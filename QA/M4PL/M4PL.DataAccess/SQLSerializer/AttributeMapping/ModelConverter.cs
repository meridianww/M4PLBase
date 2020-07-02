#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;
using System.Collections;
using System.Data;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
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
        private readonly ModelDataMap mapping;

        #endregion Member Variables

        #region Constructor

        /// <summary>
        ///     Create instance of ModelConverter
        /// </summary>
        /// <param name="modelType">
        ///     Model Type
        /// </param>
        public ModelConverter(Type modelType)
        {
            mapping = ModelDataMap.GetDataMap(modelType);
        }

        #endregion Constructor

        #region Methods

        /// <summary>
        ///     Fills the dataset with table with  schema as defined
        ///     by model type passed to constructor
        /// </summary>
        /// <param name="ds">
        ///     Dataset to contain table
        /// </param>
        /// <returns>
        ///     A System.Data.DataTable object
        /// </returns>
        public DataTable CreateDataTable(DataSet ds)
        {
            var table = ds.Tables[mapping.TableName];
            if (table == null)
                table = ds.Tables.Add(mapping.TableName);

            DataColumn column;
            var keyColumn = mapping.KeyColumn;
            string columnName;
            foreach (ModelColumnMap colMap in mapping.Columns.Values)
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
        ///     Inserts data from model array  to data table for that model entity
        /// </summary>
        /// <param name="models">
        ///     model objects array
        /// </param>
        /// <param name="ds">
        ///     dataset to fill with models
        /// </param>
        /// <returns>
        ///     data table
        /// </returns>
        public DataTable InsertAsDataTable(IModel[] models, DataSet ds)
        {
            if (models.Length == 0)
                return null;

            var modelType = models[0] != null ? models[0].GetType() : null;
            var table = CreateDataTable(ds);

            foreach (var model in models)
                InsertAsDataRow(model, table);

            return table;
        }

        /// <summary>
        ///     adds model data to a new row in data table for that model entity
        /// </summary>
        /// <param name="model">
        ///     model object
        /// </param>
        /// <param name="table">
        ///     data table takes model data
        /// </param>
        /// <returns>
        ///     returns data row with data
        /// </returns>
        public DataRow InsertAsDataRow(IModel model, DataTable table)
        {
            var row = table.NewRow();
            foreach (ModelColumnMap colMap in mapping.Columns.Values)
                row[colMap.ColumnName] = colMap.Field.GetValue(model);

            table.Rows.Add(row);
            return row;
        }

        /// <summary>
        ///     Creates a model from data row values
        /// </summary>
        /// <param name="row">
        ///     data row keeping specific entity data
        /// </param>
        /// <returns>
        ///     GlobalTranz.Framework.Common.Models.IModel object.
        /// </returns>
        public IModel CreateFromDataRow(DataRow row)
        {
            object val;
            var model = (IModel)mapping.Constructor.Invoke(null);
            foreach (ModelColumnMap colMap in mapping.Columns.Values)
            {
                val = row[colMap.ColumnName];
                if (val == DBNull.Value)
                    val = null;

                if (colMap.Field.FieldType.IsEnum)
                    val = Enum.ToObject(colMap.FieldType, val);

                colMap.Field.SetValue(model, val);
            }

            return model;
        }

        /// <summary>
        ///     Creates an Imodel array from Data table for that model entity
        /// </summary>
        /// <param name="table">
        ///     data table for model entity
        /// </param>
        /// <returns>
        ///     array of entity model
        /// </returns>
        public IModel[] CreateFromDataTable(DataTable table)
        {
            var models = new IModel[table.Rows.Count];
            var end = table.Rows.Count;
            for (var i = 0; i < end; ++i)
                models[i] = CreateFromDataRow(table.Rows[i]);

            return models;
        }

        /// <summary>
        ///     Merges changes made in the model to the database.
        /// </summary>
        /// <param name="models">
        ///     Array of i model objects
        /// </param>
        /// <param name="ds">
        ///     A system.Data.DataSet object that contains data to be merged.
        /// </param>
        public void MergeChangesIntoDataSet(IModel[] models, DataSet ds)
        {
            var table = ds.Tables[mapping.TableName];
            var rowCount = table.Rows.Count;

            for (var i = rowCount - 1; i >= 0; --i)
                if (table.Rows[i].RowState != DataRowState.Unchanged)
                    table.Rows.RemoveAt(i);

            table.AcceptChanges();
        }

        /// <summary>
        ///     Get the changes made in the  dataset.
        /// </summary>
        /// <param name="ds">
        ///     A System.Data.DataSet that contains data.
        /// </param>
        /// <returns>
        ///     An array of GlobalTranz.Framework.Common.Models.IModel objecPropanator.
        /// </returns>
        public IModel[] GetChangesFromDataSet(DataSet ds)
        {
            var list = new ArrayList();
            var rows = ds.Tables[mapping.TableName].Rows;

            foreach (DataRow row in rows)
                if (row.RowState != DataRowState.Unchanged)
                    list.Add(CreateFromDataRow(row));

            return (IModel[])list.ToArray(mapping.ModelType);
        }

        #endregion Methods
    }
}