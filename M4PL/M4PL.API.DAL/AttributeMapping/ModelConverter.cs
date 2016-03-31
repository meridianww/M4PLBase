//------------------------------------------------------------------------------ 
// <copyright file="ModelConverter.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Collections;
using System.Data;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     ModelConverter is used to convert different models to data table in dataset. and from data tables to models.
    /// </summary>
    public class ModelConverter
    {
        #region Member Variables

        /// <summary>
        ///     Details of column mapping
        /// </summary>
        private ModelDataMap mapping;

        #endregion

        #region Constructor

        /// <summary>
        ///		Create instance of ModelConverter
        /// </summary>
        /// <param name="modelType">
        ///		Model Type
        ///	</param>
        public ModelConverter(Type modelType)
        {
            this.mapping = ModelDataMap.GetDataMap(modelType);
        }

        #endregion

        #region Methods

        /// <summary>
        ///		Fills the dataset with table with  schema as defined 
        ///		by model type passed to constructor
        /// </summary>
        /// <param name="ds">
        ///		Dataset to contain table
        ///	</param>
        /// <returns>   
        ///		A System.Data.DataTable object
        ///	</returns>
        public DataTable CreateDataTable(DataSet ds)
        {
            DataTable table = ds.Tables[this.mapping.TableName];
            if (table == null)
            {
                table = ds.Tables.Add(this.mapping.TableName);
            }

            DataColumn column;
            string keyColumn = this.mapping.KeyColumn;
            string columnName;
            foreach (ModelColumnMap colMap in this.mapping.Columns.Values)
            {
                columnName = colMap.ColumnName;
                column = table.Columns[columnName];
                if (column == null)
                {
                    // If the column does not exist, add it.
                    table.Columns.Add(columnName, colMap.FieldType);
                    if (columnName.Equals(keyColumn))
                    {
                        // Set up the primary key column.
                        column.AllowDBNull = false;
                        column.Unique = true;
                        column.AutoIncrement = true;
                        column.AutoIncrementSeed = -1;
                        column.AutoIncrementStep = -1;
                    }
                }
            }

            return table;
        }

        /// <summary>
        ///		Inserts data from model array  to data table for that model entity
        /// </summary>
        /// <param name="models">
        ///		model objects array
        ///	</param>
        /// <param name="ds">
        ///		dataset to fill with models
        ///	</param>
        /// <returns>
        ///		data table
        ///	</returns>
        public DataTable InsertAsDataTable(IModel[] models, DataSet ds)
        {
            if (models.Length == 0)
            {
                return null;
            }

            Type modelType = models[0].GetType();
            DataTable table = this.CreateDataTable(ds);

            foreach (IModel model in models)
            {
                this.InsertAsDataRow(model, table);
            }

            return table;
        }

        /// <summary>
        ///		adds model data to a new row in data table for that model entity
        /// </summary>
        /// <param name="model">
        ///		model object
        ///	</param>
        /// <param name="table">
        ///		data table takes model data
        ///	</param>
        /// <returns>
        ///		returns data row with data
        ///	</returns>
        public DataRow InsertAsDataRow(IModel model, DataTable table)
        {
            DataRow row = table.NewRow();
            foreach (ModelColumnMap colMap in this.mapping.Columns.Values)
            {
                row[colMap.ColumnName] = colMap.Field.GetValue(model);
            }

            table.Rows.Add(row);
            return row;
        }

        /// <summary>
        ///		Creates a model from data row values
        /// </summary>
        /// <param name="row">
        ///		data row keeping specific entity data
        ///	</param>
        /// <returns>
        ///		GlobalTranz.Framework.Common.Models.IModel object.
        /// </returns>
        public IModel CreateFromDataRow(DataRow row)
        {
            object val;
            IModel model = (IModel)this.mapping.Constructor.Invoke(null);
            foreach (ModelColumnMap colMap in this.mapping.Columns.Values)
            {
                val = row[colMap.ColumnName];
                if (val == DBNull.Value)
                {
                    val = null;
                }

                if (colMap.Field.FieldType.IsEnum)
                {
                    val = System.Enum.ToObject(colMap.FieldType, val);
                }

                colMap.Field.SetValue(model, val);
            }

            return model;
        }

        /// <summary>
        ///		Creates an Imodel array from Data table for that model entity 
        /// </summary>
        /// <param name="table">
        ///		data table for model entity
        ///	</param>
        /// <returns>
        ///		array of entity model
        ///	</returns>
        public IModel[] CreateFromDataTable(DataTable table)
        {
            IModel[] models = new IModel[table.Rows.Count];
            int end = table.Rows.Count;
            for (int i = 0; i < end; ++i)
            {
                models[i] = this.CreateFromDataRow(table.Rows[i]);
            }

            return models;
        }

        /// <summary>
        ///		Merges changes made in the model to the database.
        /// </summary>
        /// <param name="models">
        ///		Array of i model objects
        /// </param>
        /// <param name="ds">
        ///		A system.Data.DataSet object that contains data to be merged.
        /// </param>
        public void MergeChangesIntoDataSet(IModel[] models, DataSet ds)
        {
            DataTable table = ds.Tables[this.mapping.TableName];
            int rowCount = table.Rows.Count;

            for (int i = rowCount - 1; i >= 0; --i)
            {
                if (table.Rows[i].RowState != DataRowState.Unchanged)
                {
                    table.Rows.RemoveAt(i);
                }
            }

            table.AcceptChanges();
        }

        /// <summary>
        ///		Get the changes made in the  dataset.
        /// </summary>
        /// <param name="ds">
        ///		A System.Data.DataSet that contains data.
        /// </param>
        /// <returns>
        ///		An array of GlobalTranz.Framework.Common.Models.IModel objecPropanator.	
        /// </returns>
        public IModel[] GetChangesFromDataSet(DataSet ds)
        {
            ArrayList list = new ArrayList();
            DataRowCollection rows = ds.Tables[this.mapping.TableName].Rows;

            foreach (DataRow row in rows)
            {
                if (row.RowState != DataRowState.Unchanged)
                {
                    list.Add(this.CreateFromDataRow(row));
                }
            }

            return (IModel[])list.ToArray(this.mapping.ModelType);
        }

        #endregion
    }
}
