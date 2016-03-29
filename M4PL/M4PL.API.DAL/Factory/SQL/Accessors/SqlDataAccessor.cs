//------------------------------------------------------------------------------ 
// <copyright file="SqlDataAccessor.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Text;
using System.Threading;
using M4PL.DataAccess.Factory.Converter;
using M4PL.DataAccess.Models;
using M4PL.DataAccess.Models.Mapping;

namespace M4PL.DataAccess.Factory.Accessors
{
    /// <summary>
    ///		This class implement methods defined in idata accessor interface.
    ///		It builds sql commands and sql queries using sql command builder class.
    /// </summary>
    public class SqlDataAccessor : IDataAccessor
    {
        #region Member Varibles

        /// <summary>
        ///     Connection object for database connection
        /// </summary>
        private IDbConnection connection;

        /// <summary>
        ///     Type of model
        /// </summary>
        private Type modelType;

        /// <summary>
        ///     Hash table for model mapping
        /// </summary>
        private ModelDataMap modelDataMap;

        /// <summary>
        ///     Transaction for database integrity
        /// </summary>
        private IDbTransaction transaction;

        /// <summary>
        ///     Command builder for creating sql commands
        /// </summary>
        private SqlFrameworkCommandBuilder commandBuilder;

        #endregion

        #region Constructor

        /// <summary>
        ///		Constructor set connection, transaction and generates model 
        ///		data map from model type input
        /// </summary>
        /// <param name="conn">
        ///		Connection object
        /// </param>
        /// <param name="modelType">
        ///		GlobalTranz.Framework.Common.Models type
        /// </param>
        /// <param name="transaction">
        ///		SQL transaction object.
        /// </param>
        public SqlDataAccessor(IDbConnection conn, Type modelType, IDbTransaction transaction)
        {
            this.connection = conn;
            this.modelType = modelType;
            this.transaction = transaction;
            this.modelDataMap = ModelDataMap.GetDataMap(modelType);
            this.commandBuilder = SqlFrameworkCommandBuilder.GetSqlStringBuilder(this.modelDataMap, modelType);
        }

        /// <summary>
        ///     Create SqlDataAccessor Instance, It sets connection and transaction values.
        /// </summary>
        /// <param name="connection">
        ///     Connection object which implements System.Data.IDbCOnnection Interface.
        /// </param>
        /// <param name="transaction">
        ///     Transaction instance which implements System.Data.IDbTransaction Interface.
        /// </param>
        public SqlDataAccessor(IDbConnection connection, IDbTransaction transaction)
        {
            this.connection = connection;
            this.transaction = transaction;
        }

        #endregion

        #region SQL Methods

        /// <summary>
        ///		Retrieves data from database using specified key value and fill to model
        /// </summary>
        /// <param name="key">
        ///		primary key value of record to be retrieved.
        /// </param>
        /// <returns>
        ///		A GlobalTranz.Framework.Common.Models.IModel object
        /// </returns>
        public IModel Select(object key)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            // create select statement and assign to the command object
            command.CommandText = this.commandBuilder.GetSelectSql();

            // create a parameter for primary key.
            SqlParameter parameter = new SqlParameter();
            parameter.ParameterName = "@key";
            parameter.Value = key;
            command.Parameters.Add(parameter);

            SqlDataReader dataReader = command.ExecuteReader();

            try
            {
                while (dataReader.Read())
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    return converter.ConvertDataReaderToModel(dataReader);
                }
            }
            finally
            {
                dataReader.Close();
            }

            return null;
        }

        /// <summary>
        ///		Retrieves data from database using specified key value and fill to model
        /// </summary>
        /// <param name="key">
        ///		primary key value of record to be retrieved.
        /// </param>
        /// <returns>
        ///		A GlobalTranz.Framework.Common.Models.IModel object
        /// </returns>
        public IModel SelectWithLock(object key)
        {
            SqlDataReader dataReader = null;

            SqlCommand command = new SqlCommand();
            string selectWithLockSql = this.commandBuilder.GetSelectWithLockSql();
            command.CommandText = selectWithLockSql;

            SqlParameter p = new SqlParameter();
            p.ParameterName = "@key";
            p.Value = key;

            command.Parameters.Add(p);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            dataReader = command.ExecuteReader();
            try
            {
                while (dataReader.Read())
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    return converter.ConvertDataReaderToModel(dataReader);
                }
            }
            finally
            {
                dataReader.Close();
            }

            return null;
        }

        /// <summary>
        ///		Returns Imodel array with sorted records for given sort field 
        ///		and with given filter columns and values 
        /// </summary>
        /// <param name="fieldNames">
        ///		Field names to filter on
        /// </param>
        /// <param name="fieldValues">
        ///		filter for field values
        /// </param>
        /// <param name="sortField">
        ///		Sort on field name
        /// </param>
        /// <param name="ascending">
        ///		true for sort ascending
        /// </param>
        /// <returns>
        ///		sorted Imodel array
        ///	</returns>
        public IModel[] SelectSorted(
            string[] fieldNames,
            object[] fieldValues,
            string sortField,
            bool ascending)
        {
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            IModel[] models = null;

            command = (SqlCommand)this.CreateSelectCommandForMultipleResultsSorted(
                this.modelDataMap, fieldNames, fieldValues, sortField, ascending);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            dataReader = command.ExecuteReader();
            try
            {
                DataReaderConverter converter = new DataReaderConverter(this.modelType);
                models = converter.ConvertDatReaderToModels(dataReader);
            }
            finally
            {
                dataReader.Close();
            }

            return models;
        }

        /// <summary>
        ///		Returns Imodel array with sorted records for given sort field 
        ///		and with given filter columns and values 
        /// </summary>
        /// <param name="fieldNames">
        ///		Field names to filter on
        /// </param>
        /// <param name="fieldValues">
        ///		filter for field values
        /// </param>
        /// <param name="sortField">
        ///		Sort on field name
        /// </param>
        /// <param name="ascending">
        ///		true for sort ascending
        /// </param>
        /// <returns>
        ///		sorted Imodel array
        ///	</returns>
        public IModel[] SelectSorted(
            string[] fieldNames,
            object[] fieldValues,
            string[] sortField,
            bool ascending)
        {
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            IModel[] models = null;

            command = (SqlCommand)this.CreateSelectCommandForMultipleResultsSorted(
                this.modelDataMap, fieldNames, fieldValues, sortField, ascending);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            dataReader = command.ExecuteReader();
            try
            {
                DataReaderConverter converter = new DataReaderConverter(this.modelType);
                models = converter.ConvertDatReaderToModels(dataReader);
            }
            finally
            {
                dataReader.Close();
            }

            return models;
        }

        /// <summary>
        ///		Selects mutiple records based on fileter columns and their values
        /// </summary>
        /// <param name="fieldNames">
        ///		filter on filed names
        /// </param>
        /// <param name="fieldValues">
        ///		filter for field values
        /// </param>
        /// <returns>
        ///		Imodel array
        ///	</returns>
        public IModel[] SelectMultiple(string[] fieldNames, object[] fieldValues)
        {
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            IModel[] models = null;

            command = (SqlCommand)this.CreateSelectCommandForMultipleResults(
                this.modelDataMap, fieldNames, fieldValues);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            try
            {
                dataReader = command.ExecuteReader();
                DataReaderConverter converter = new DataReaderConverter(this.modelType);
                models = converter.ConvertDatReaderToModels(dataReader);
            }
            catch (Exception ex)
            {
                string str = ex.Message;
            }
            finally
            {
                dataReader.Close();
            }

            return models;
        }

        /// <summary>
        ///		Selects multiple records based on filter columns and their values
        /// </summary>
        /// <typeparam name="T">
        ///     Any model object that implements Imodel interface.
        /// </typeparam>
        /// <param name="fieldNames">
        ///		filter on filed names
        /// </param>
        /// <param name="fieldValues">
        ///		filter for field values
        /// </param>
        /// <returns>
        ///		Collection of IModel objects
        ///	</returns>
        public List<T> SelectMultiple<T>(string[] fieldNames, object[] fieldValues) where T : IModel
        {
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            List<T> models = null;

            command = (SqlCommand)this.CreateSelectCommandForMultipleResults(
                this.modelDataMap, fieldNames, fieldValues);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            try
            {
                dataReader = command.ExecuteReader();
                DataReaderConverter converter = new DataReaderConverter(this.modelType);
                models = converter.ConvertDataReaderToModels<T>(dataReader);
            }
            finally
            {
                dataReader.Close();
            }

            return models;
        }

        /// <summary>
        ///		Update a database record using given imodel object,
        /// </summary>
        /// <param name="model">
        ///		A CarrierRate.GlobalTranz.Framework.Common.Models.IModel object to be updated
        /// </param>
        /// <returns>
        ///		A CarrierRate.GlobalTranz.Framework.Common.Models.IModel object
        /// </returns>
        public IModel Update(IModel model)
        {
            ModelColumnMap c = null;
            DataReaderConverter converter;
            converter = new DataReaderConverter(this.modelDataMap);

            // set the createdDate if it exists
            c = (ModelColumnMap)this.modelDataMap.Columns["modifiedDate"];
            if (c != null)
            {
                converter.SetFieldValue(model, c, DateTime.Now);
            }

            // set the createdBy if it exists
            c = (ModelColumnMap)this.modelDataMap.Columns["modifiedBy"];
            if (c != null)
            {
                string userName = Thread.CurrentPrincipal.Identity.Name;
                converter.SetFieldValue(model, c, userName);
            }

            SqlCommand command = (SqlCommand)this.connection.CreateCommand();
            command.CommandText = this.commandBuilder.GetUpdateSql();

            foreach (ModelColumnMap col in this.modelDataMap.Columns.Values)
            {
                if (!col.IsViewOnly)
                {
                    string paramName = "@" + col.ColumnName;
                    command.Parameters.Add(this.CreateParameter(paramName, col, model));
                }
            }

            SqlParameter param = new SqlParameter();
            param.ParameterName = "@key";

            string keyName = null;
            if (this.modelDataMap.KeyField != null)
            {
                keyName = this.modelDataMap.KeyField.Name;
            }
            else if (this.modelDataMap.KeyProperty != null)
            {
                keyName = this.modelDataMap.KeyProperty.Name;
            }

            ModelColumnMap keyCol;
            keyCol = (ModelColumnMap)this.modelDataMap.Columns[keyName];
            command.Parameters.Add(this.CreateParameter("@key", keyCol, model));

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            int rowsAffected = command.ExecuteNonQuery();

            if (rowsAffected > 0)
            {
                return model;
            }

            return null;
        }

        /// <summary>
        ///		Delete the record specified in the key value
        /// </summary>
        /// <param name="key">
        ///		primary key record to be deleted
        /// </param>
        public void Delete(object key)
        {
            SqlCommand command = (SqlCommand)this.connection.CreateCommand();
            command.CommandText = this.commandBuilder.GetDeleteSql();

            SqlParameter p = new SqlParameter();

            p.ParameterName = "@key";
            p.Value = key;

            command.Parameters.Add(p);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            command.ExecuteNonQuery();
        }

        /// <summary>
        ///		Delete records based on delete conditions specified
        /// </summary>
        /// <param name="fieldNames">
        ///		Filter field names
        /// </param>
        /// <param name="fieldValues">
        ///		Filter values.
        /// </param>
        public void DeleteWithCondition(string[] fieldNames, string[] fieldValues)
        {
            SqlCommand command = (SqlCommand)this.connection.CreateCommand();

            StringBuilder sb = new StringBuilder();
            sb.Append(this.commandBuilder.GetDeleteSqlWithoutWhere());

            if (fieldNames != null)
            {
                sb.Append(" Where ");

                for (int i = 0; i < fieldNames.Length; i++)
                {
                    ModelColumnMap columnMap = (ModelColumnMap)this.modelDataMap.Columns[fieldNames[i]]; // mapping
                    sb.Append(columnMap.ColumnName);
                    sb.Append(" = @");
                    sb.Append(fieldNames[i]);
                    if (fieldNames.Length > 1 && i != fieldNames.Length - 1)
                    {
                        sb.Append(" AND ");
                    }

                    SqlParameter p = new SqlParameter();
                    if (!columnMap.IsDatabaseTypeNull)
                    {
                        p.DbType = columnMap.DatabaseType;
                    }

                    if (columnMap.Field != null)
                    {
                        p.ParameterName = "@" + columnMap.FieldName;
                    }
                    else if (columnMap.Property != null)
                    {
                        p.ParameterName = "@" + columnMap.PropertyName;
                    }

                    object val = fieldValues[i];
                    p.Value = val;
                    command.Parameters.Add(p);
                }
            }

            command.CommandText = sb.ToString();

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            command.ExecuteNonQuery();
        }

        /// <summary>
        ///		Insert a new record to database using given imodel object.
        /// </summary>
        /// <param name="model">
        ///		A IModel object to be saved.
        /// </param>
        /// <returns>
        ///		A IModel object
        /// </returns>
        public IModel Insert(IModel model)
        {
            SqlDataReader reader = null;
            IModel newModel = null;
            ModelColumnMap c = null;

            DataReaderConverter converter;
            converter = new DataReaderConverter(this.modelDataMap);

            // set the createdDate if it exists
            c = (ModelColumnMap)this.modelDataMap.Columns["createdDate"];
            if (c != null)
            {
                converter.SetFieldValue(model, c, DateTime.Now);
            }

            // set the createdBy if it exists
            c = (ModelColumnMap)this.modelDataMap.Columns["createdBy"];
            if (c != null)
            {
                string userName = Thread.CurrentPrincipal.Identity.Name;
                converter.SetFieldValue(model, c, userName);
            }

            SqlCommand command = (SqlCommand)this.connection.CreateCommand();
            command.CommandText = this.commandBuilder.GetInsertSql();

            foreach (ModelColumnMap col in this.modelDataMap.Columns.Values)
            {
                if (!col.IsViewOnly)
                {
                    SqlParameter p = new SqlParameter();

                    p.ParameterName = "@" + col.ColumnName;
                    if (col.Field != null)
                    {
                        p.SourceColumn = col.FieldName;
                    }
                    else if (col.Property != null)
                    {
                        p.SourceColumn = col.PropertyName;
                    }

                    if (!col.IsDatabaseTypeNull)
                    {
                        p.DbType = col.DatabaseType;
                    }

                    object val = null;
                    if (col.Field != null)
                    {
                        val = col.Field.GetValue(model);
                    }
                    else if (col.Property != null)
                    {
                        val = col.Property.GetValue(model, null);
                    }

                    if (val == null)
                    {
                        val = DBNull.Value;
                    }

                    p.Value = val;
                    command.Parameters.Add(p);
                }
            }

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            try
            {
                reader = command.ExecuteReader();

                while (reader.Read())
                {
                    FieldInfo keyField = this.modelDataMap.KeyField;
                    if (keyField != null)
                    {
                        object id = reader[0];
                        converter.SetFieldValue(model, keyField, id);
                        newModel = model;
                    }
                    else if (this.modelDataMap.KeyProperty != null)
                    {
                        object id = reader[0];
                        converter.SetFieldValue(model, this.modelDataMap.KeyProperty, id);
                        newModel = model;
                    }
                    else
                    {
                        newModel = model;
                    }
                }
            }
            finally
            {
                reader.Close();
            }

            return newModel;
        }

        #endregion

        #region Stored Procedure methods

        /// <summary>
        ///		Insert a new row to database using stored procedure
        /// </summary>
        /// <param name="model">
        ///		An Imodel object with data to be saved
        /// </param>
        /// <returns>
        ///		Returns I model object with new key
        /// </returns>
        public IModel InsertProcedure(IModel model)
        {
            SqlDataReader reader = null;
            IModel newModel = null;
            DataReaderConverter converter;
            converter = new DataReaderConverter(this.modelDataMap);

            // creates new command object with stored procedure parameters
            SqlCommand command = this.commandBuilder.GetInsertCommand(model);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            // Execute stored procedure
            reader = command.ExecuteReader();

            try
            {
                while (reader.Read())
                {
                    // set newly generated primary key to model
                    if (this.modelDataMap.KeyProperty != null)
                    {
                        object id = reader[0];
                        converter.SetFieldValue(model, this.modelDataMap.KeyProperty, id);
                        newModel = model;
                    }
                    else
                    {
                        newModel = model;
                    }
                }
            }
            finally
            {
                reader.Close();
            }

            return newModel;
        }


        /// <summary>
        ///     Bulk insert collection of record to the database using sql server table valued parameter.
        /// </summary>
        /// <typeparam name="T">
        ///     Any type which implements Framework.Common.Models.IModel interface.
        /// </typeparam>
        /// <param name="modelCollection">
        ///     A collection objects which implements imodel for bulk insert.
        /// </param>
        /// <returns>
        ///     A boolean value indicating insert opertation is successful or not.
        /// </returns>
        public ModelDataMap InsertTableValuedProcedure<T>(List<T> modelCollection) where T : IModel
        {
            return this.modelDataMap;

            //// creates new command object with table valued parameter.
            //SqlCommand command = this.commandBuilder.GetInsertTableValuedCommand<T>(modelCollection);           
            //command.Connection = (SqlConnection)this.connection;
            //command.Transaction = (SqlTransaction)this.transaction;

            //// Execute stored procedure
            //SqlDataReader reader = command.ExecuteReader();
            //bool isSuccess = false;
            //try
            //{
            //    DataReaderConverter converter;
            //    converter = new DataReaderConverter(this.modelDataMap);
            //    int ordinal = 0;
            //    while (reader.Read())
            //    {
            //        // set newly generated primary key to model
            //        if (this.modelDataMap.KeyProperty != null)
            //        {
            //            // read primary key value from the reader and set to the object.
            //            object primaryKey = reader[0];
            //            converter.SetFieldValue(modelCollection[ordinal], this.modelDataMap.KeyProperty, primaryKey);
            //        }

            //        ordinal = ordinal + 1;
            //    }

            //    isSuccess = true;
            //}
            //finally
            //{
            //    reader.Close();
            //}

            //return isSuccess;
        }
        /// <summary>
        ///		Insert a new row to database using stored procedure
        /// </summary>
        /// <param name="model">
        ///		An Imodel object with data to be saved
        /// </param>
        /// <returns>
        ///		Returns I model object with new key
        /// </returns>
        public IModel UpdateProcedure(IModel model)
        {
            DataReaderConverter converter;
            converter = new DataReaderConverter(this.modelDataMap);

            // creates new command object with stored procedure parameters
            SqlCommand command = this.commandBuilder.GetUpdateCommand(model);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            // Execute stored procedure
            int returnValue = command.ExecuteNonQuery();
            return model;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>	
        /// <param name="key">
        ///     Primary key value.
        /// </param>
        /// <returns>
        ///		Imodel object
        /// </returns>
        public IModel SelectProcedure(object key)
        {
            SqlDataReader dataReader = null;

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectCommand(key);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            // executes select stored procedure
            dataReader = command.ExecuteReader();

            try
            {
                while (dataReader.Read())
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    return converter.ConvertDataReaderToModel(dataReader);
                }
            }
            finally
            {
                dataReader.Close();
            }

            return null;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>	
        /// <param name="model">
        ///     Model object with parameter values.
        /// </param>
        /// <returns>
        ///		Imodel object
        /// </returns>
        public IModel SelectProcedure(IModel model)
        {
            SqlDataReader dataReader = null;

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectCommand(model);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            // executes select stored procedure
            dataReader = command.ExecuteReader();

            try
            {
                while (dataReader.Read())
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    return converter.ConvertDataReaderToModel(dataReader);
                }
            }
            finally
            {
                dataReader.Close();
            }

            return null;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>	
        /// <param name="model">
        ///     Model object with value for input parameters
        /// </param>
        /// <returns>
        ///		Imodel object
        /// </returns>
        public IModel[] SelectMultipleFromProcedure(IModel model)
        {
            SqlDataReader dataReader = null;
            IModel[] models;

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectMultipleCommand(model);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            // executes select stored procedure
            using (dataReader = command.ExecuteReader())
            {
                try
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    models = converter.ConvertDatReaderToModels(dataReader);
                }
                finally
                {
                    dataReader.Close();
                }
            }

            return models;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>	
        /// <typeparam name="T">
        ///     Any object that implements IModel interface
        /// </typeparam>
        /// <param name="model">
        ///     IModel object with values for stored procedure input parameters
        /// </param>
        /// <returns>
        ///		Imodel object
        /// </returns>
        public List<T> SelectMultipleFromProcedure<T>(IModel model) where T : IModel
        {
            SqlDataReader dataReader = null;
            List<T> models;

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectMultipleCommand(model);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            //checking the connection state and making it in Open State
            if (connection.State.ToString() == "Closed")
            {
                connection.Open();
            }

            // executes select stored procedure
            using (dataReader = command.ExecuteReader())
            {
                try
                {
                    DataReaderConverter converter = new DataReaderConverter(this.modelType);
                    models = converter.ConvertDataReaderToModels<T>(dataReader);
                }
                finally
                {
                    dataReader.Close();
                    if (connection.State.ToString() == "Open")
                    {
                        connection.Close();
                    }
                }
            }

            return models;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>	
        /// <param name="key">
        ///     Value of primary key
        /// </param>
        /// <returns>
        ///		DataSet object
        /// </returns>
        public DataSet SelectDataSetProcedure(object key)
        {
            DataSet result = new DataSet();

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectCommand(key);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            SqlDataAdapter sqlDataAdapter = null;
            using (sqlDataAdapter = new SqlDataAdapter(command))
            {
                sqlDataAdapter.Fill(result);
            }

            return result;
        }

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>
        /// <param name="model">
        ///     IModel object with values for stored procedure input parameters
        /// </param>
        /// <returns>
        ///		A System.Data.DataSet object containing result of command execution
        /// </returns>
        public DataSet SelectMultipleDataSetFromProcedure(IModel model)
        {
            DataSet result = new DataSet();

            // creates new as command object using stored procedure
            SqlCommand command = this.commandBuilder.GetSelectMultipleCommand(model);

            command.Transaction = (SqlTransaction)this.transaction;
            command.Connection = (SqlConnection)this.connection;

            SqlDataAdapter sqlDataAdapter = null;
            using (sqlDataAdapter = new SqlDataAdapter(command))
            {
                sqlDataAdapter.Fill(result);
            }

            return result;
        }

        /// <summary>
        ///		Insert a new row to database using stored procedure
        /// </summary>
        /// <param name="keyValue">
        ///		Primary key value of record to be deleted.
        /// </param>
        /// <returns>
        ///		Returns I model object with new key
        /// </returns>
        public bool DeleteProcedure(object keyValue)
        {
            DataReaderConverter converter;
            converter = new DataReaderConverter(this.modelDataMap);

            // creates new command object with stored procedure parameters
            SqlCommand command = this.commandBuilder.GetDeleteCommand(keyValue);

            command.Connection = (SqlConnection)this.connection;
            command.Transaction = (SqlTransaction)this.transaction;

            // Execute stored procedure
            int rowsAffected = command.ExecuteNonQuery();

            if (rowsAffected > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        #region Private Methods

        /// <summary>
        ///		Creates stored procedure parameter
        /// </summary>
        /// <param name="name">
        ///		Parameter name
        /// </param>
        /// <param name="col">
        ///		Model column map
        /// </param>
        /// <param name="model">
        ///		I model object
        /// </param>
        /// <returns>
        ///		Asa parameter
        /// </returns>
        private IDataParameter CreateParameter(string name, ModelColumnMap col, IModel model)
        {
            IDataParameter p = new SqlParameter();
            p.ParameterName = name;
            if (col.Field != null)
            {
                p.SourceColumn = col.FieldName;
            }
            else if (col.Property != null)
            {
                p.SourceColumn = col.PropertyName;
            }

            if (!col.IsDatabaseTypeNull)
            {
                p.DbType = col.DatabaseType;
            }

            object val = null;
            if (col.Field != null)
            {
                val = col.Field.GetValue(model);
            }
            else if (col.Property != null)
            {
                val = col.Property.GetValue(model, null);
            }

            if (val == null)
            {
                val = DBNull.Value;
            }

            p.Value = val;
            return p;
        }

        /// <summary>
        ///     Create select command for multiple result set
        /// </summary>
        /// <param name="mapping">
        ///     Model data map for attribute mapping
        /// </param>
        /// <param name="fieldNames">
        ///     Name of the field names for where clause
        /// </param>
        /// <param name="fieldValues">
        ///     values of the field for where clause
        /// </param>       
        /// <param name="sortField">
        ///     Name of the sort filed
        /// </param>
        /// <param name="ascending">
        ///     Sort order
        /// </param>
        /// <returns>
        ///     Command object with all parameters
        /// </returns>
        private IDbCommand CreateSelectCommandForMultipleResultsSorted(
            ModelDataMap mapping,
            string[] fieldNames,
            object[] fieldValues,
            string sortField,
            bool ascending)
        {
            SqlCommand cmd = new SqlCommand();
            StringBuilder sb = new StringBuilder();
            sb.Append("select ");
            sb = this.GenerateColumnList(mapping, sb, true);
            sb.Append(" from [");
            sb.Append(mapping.ViewName);
            sb.Append("] ");
            if (fieldNames != null)
            {
                sb.Append(" where ");

                for (int i = 0; i < fieldNames.Length; i++)
                {
                    ModelColumnMap columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
                    sb.Append(columnMap.ColumnName);
                    sb.Append(" = @");
                    sb.Append(fieldNames[i]);
                    if (fieldNames.Length > 1 && i != fieldNames.Length - 1)
                    {
                        sb.Append(" AND ");
                    }

                    SqlParameter p = new SqlParameter();
                    if (!columnMap.IsDatabaseTypeNull)
                    {
                        p.DbType = columnMap.DatabaseType;
                    }

                    // p.SourceColumn = columnMap.FieldName;
                    if (columnMap.Field != null)
                    {
                        p.ParameterName = "@" + columnMap.FieldName;
                    }
                    else if (columnMap.Property != null)
                    {
                        p.ParameterName = "@" + columnMap.PropertyName;
                    }

                    object val = fieldValues[i];
                    p.Value = val;
                    cmd.Parameters.Add(p);
                }
            }

            sb.Append(" order by ");
            sb.Append(sortField);
            if (!ascending)
            {
                sb.Append(" desc");
            }

            cmd.CommandText = sb.ToString();
            return cmd;
        }

        /// <summary>
        ///     Create select command for multiple result set
        /// </summary>
        /// <param name="mapping">
        ///     Model data map for attribute mapping
        /// </param>
        /// <param name="fieldNames">
        ///     Name of the field names for where clause
        /// </param>
        /// <param name="fieldValues">
        ///     values of the field for where clause
        /// </param>       
        /// <param name="sortFields">
        ///     Name of the sort filed
        /// </param>
        /// <param name="ascending">
        ///     Sort order
        /// </param>
        /// <returns>
        ///     Command object with all parameters
        /// </returns>
        private IDbCommand CreateSelectCommandForMultipleResultsSorted(
            ModelDataMap mapping,
            string[] fieldNames,
            object[] fieldValues,
            string[] sortFields,
            bool ascending)
        {
            SqlCommand cmd = new SqlCommand();
            StringBuilder sb = new StringBuilder();
            sb.Append("select ");
            sb = this.GenerateColumnList(mapping, sb, true);
            sb.Append(" from [");
            sb.Append(mapping.ViewName);
            sb.Append("] ");
            if (fieldNames != null)
            {
                sb.Append(" where ");

                for (int i = 0; i < fieldNames.Length; i++)
                {
                    ModelColumnMap columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
                    sb.Append(columnMap.ColumnName);
                    sb.Append(" = @");
                    sb.Append(fieldNames[i]);
                    if (fieldNames.Length > 1 && i != fieldNames.Length - 1)
                    {
                        sb.Append(" AND ");
                    }

                    SqlParameter p = new SqlParameter();
                    if (!columnMap.IsDatabaseTypeNull)
                    {
                        p.DbType = columnMap.DatabaseType;
                    }

                    // p.SourceColumn = columnMap.FieldName;
                    if (columnMap.Field != null)
                    {
                        p.ParameterName = "@" + columnMap.FieldName;
                    }
                    else if (columnMap.Property != null)
                    {
                        p.ParameterName = "@" + columnMap.PropertyName;
                    }

                    object val = fieldValues[i];
                    p.Value = val;
                    cmd.Parameters.Add(p);
                }
            }

            sb.Append(" order by ");
            for (int i = 0; i < sortFields.GetLength(0); i++)
            {
                if (i < sortFields.GetUpperBound(0))
                {
                    sb.Append(sortFields[i]);
                    if (!ascending)
                    {
                        sb.Append(" desc");
                    }

                    sb.Append(",");
                }
                else
                {
                    sb.Append(sortFields[i]);
                    if (!ascending)
                    {
                        sb.Append(" desc");
                    }
                }
            }

            cmd.CommandText = sb.ToString();
            return cmd;
        }

        /// <summary>
        ///     Create select command for multiple result set
        /// </summary>
        /// <param name="mapping">
        ///     Model data map for attribute mapping
        /// </param>
        /// <param name="fieldNames">
        ///     Name of the field names for where clause
        /// </param>
        /// <param name="fieldValues">
        ///     values of the field for where clause
        /// </param>              
        /// <returns>
        ///     Command object with all parameters
        /// </returns>
        private IDbCommand CreateSelectCommandForMultipleResults(
            ModelDataMap mapping,
            string[] fieldNames,
            object[] fieldValues)
        {
            SqlCommand cmd = new SqlCommand();
            StringBuilder sb = new StringBuilder();
            sb.Append("select ");
            sb = this.GenerateColumnList(mapping, sb, true);
            sb.Append(" from ");
            sb.Append(mapping.ViewName);
            sb.Append(" ");
            if (fieldNames != null)
            {
                sb.Append(" where ");

                for (int i = 0; i < fieldNames.Length; i++)
                {
                    ModelColumnMap columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
                    sb.Append(columnMap.ColumnName);
                    sb.Append(" = @");
                    sb.Append(fieldNames[i]);
                    if (fieldNames.Length > 1 && i != fieldNames.Length - 1)
                    {
                        sb.Append(" AND ");
                    }

                    SqlParameter p = new SqlParameter();
                    if (!columnMap.IsDatabaseTypeNull)
                    {
                        p.DbType = columnMap.DatabaseType;
                    }

                    // p.SourceColumn = columnMap.FieldName;
                    if (columnMap.Field != null)
                    {
                        p.ParameterName = "@" + columnMap.FieldName;
                    }
                    else if (columnMap.Property != null)
                    {
                        p.ParameterName = "@" + columnMap.PropertyName;
                    }

                    object val = fieldValues[i];
                    p.Value = val;
                    cmd.Parameters.Add(p);
                }
            }

            cmd.CommandText = sb.ToString();
            return cmd;
        }

        /// <summary>
        ///     Generate column list for select query
        /// </summary>
        /// <param name="mapping">
        ///     Model column mapping details
        /// </param>
        /// <param name="sb">
        ///     String builder object for the query
        /// </param>
        /// <param name="selectStatement">
        ///     Select statement
        /// </param>
        /// <returns>
        ///     string builder object with column list
        /// </returns>
        private StringBuilder GenerateColumnList(ModelDataMap mapping, StringBuilder sb, bool selectStatement)
        {
            bool changed = false;
            foreach (ModelColumnMap col in mapping.Columns.Values)
            {
                if (selectStatement || (!col.IsViewOnly))
                {
                    // add the column if this is a select statement or if the column
                    // is not a read only column.
                    sb.Append(col.ColumnName);
                    sb.Append(", ");
                    changed = true;
                }
            }

            if (changed)
            {
                // remove the comma and space from the end of the string
                sb.Remove(sb.Length - 2, 2);
            }

            return sb;
        }

        #endregion

        #endregion
    }
}