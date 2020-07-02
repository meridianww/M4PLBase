#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.AttributeMapping;
using M4PL.DataAccess.SQLSerializer.Factory.Converters;
using M4PL.DataAccess.SQLSerializer.Factory.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Threading;

namespace M4PL.DataAccess.SQLSerializer.Factory.SQL.Accessors
{
	/// <summary>
	///     This class implement methods defined in idata accessor interface.
	///     It builds sql commands and sql queries using sql command builder class.
	/// </summary>
	public class SqlDataAccessor : IDataAccessor
	{
		#region Member Varibles

		/// <summary>
		///     Connection object for database connection
		/// </summary>
		private readonly IDbConnection connection;

		/// <summary>
		///     Type of model
		/// </summary>
		private readonly Type modelType;

		/// <summary>
		///     Hash table for model mapping
		/// </summary>
		private readonly ModelDataMap modelDataMap;

		/// <summary>
		///     Transaction for database integrity
		/// </summary>
		private readonly IDbTransaction transaction;

		/// <summary>
		///     Command builder for creating sql commands
		/// </summary>
		private readonly SqlFrameworkCommandBuilder commandBuilder;

		#endregion Member Varibles

		#region Constructor

		/// <summary>
		///     Constructor set connection, transaction and generates model
		///     data map from model type input
		/// </summary>
		/// <param name="conn">
		///     Connection object
		/// </param>
		/// <param name="modelType">
		///     GlobalTranz.Framework.Common.Models type
		/// </param>
		/// <param name="transaction">
		///     SQL transaction object.
		/// </param>
		public SqlDataAccessor(IDbConnection conn, Type modelType, IDbTransaction transaction)
		{
			connection = conn;
			this.modelType = modelType;
			this.transaction = transaction;
			modelDataMap = ModelDataMap.GetDataMap(modelType);
			commandBuilder = SqlFrameworkCommandBuilder.GetSqlStringBuilder(modelDataMap, modelType);
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

		#endregion Constructor

		#region SQL Methods

		/// <summary>
		///     Retrieves data from database using specified key value and fill to model
		/// </summary>
		/// <param name="key">
		///     primary key value of record to be retrieved.
		/// </param>
		/// <returns>
		///     A GlobalTranz.Framework.Common.Models.IModel object
		/// </returns>
		public IModel Select(object key)
		{
			var command = new SqlCommand();
			command.CommandType = CommandType.Text;
			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			// create select statement and assign to the command object
			command.CommandText = commandBuilder.GetSelectSql();

			// create a parameter for primary key.
			var parameter = new SqlParameter();
			parameter.ParameterName = "@key";
			parameter.Value = key;
			command.Parameters.Add(parameter);

			var dataReader = command.ExecuteReader();

			try
			{
				while (dataReader.Read())
				{
					var converter = new DataReaderConverter(modelType);
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
		///     Retrieves data from database using specified key value and fill to model
		/// </summary>
		/// <param name="key">
		///     primary key value of record to be retrieved.
		/// </param>
		/// <returns>
		///     A GlobalTranz.Framework.Common.Models.IModel object
		/// </returns>
		public IModel SelectWithLock(object key)
		{
			SqlDataReader dataReader = null;

			var command = new SqlCommand();
			var selectWithLockSql = commandBuilder.GetSelectWithLockSql();
			command.CommandText = selectWithLockSql;

			var p = new SqlParameter();
			p.ParameterName = "@key";
			p.Value = key;

			command.Parameters.Add(p);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			dataReader = command.ExecuteReader();
			try
			{
				while (dataReader.Read())
				{
					var converter = new DataReaderConverter(modelType);
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
		///     Returns Imodel array with sorted records for given sort field
		///     and with given filter columns and values
		/// </summary>
		/// <param name="fieldNames">
		///     Field names to filter on
		/// </param>
		/// <param name="fieldValues">
		///     filter for field values
		/// </param>
		/// <param name="sortField">
		///     Sort on field name
		/// </param>
		/// <param name="ascending">
		///     true for sort ascending
		/// </param>
		/// <returns>
		///     sorted Imodel array
		/// </returns>
		public IModel[] SelectSorted(
			string[] fieldNames,
			object[] fieldValues,
			string sortField,
			bool ascending)
		{
			SqlCommand command = null;
			SqlDataReader dataReader = null;
			IModel[] models = null;

			command = (SqlCommand)CreateSelectCommandForMultipleResultsSorted(
				modelDataMap, fieldNames, fieldValues, sortField, ascending);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			dataReader = command.ExecuteReader();
			try
			{
				var converter = new DataReaderConverter(modelType);
				models = converter.ConvertDatReaderToModels(dataReader);
			}
			finally
			{
				dataReader.Close();
			}

			return models;
		}

		/// <summary>
		///     Returns Imodel array with sorted records for given sort field
		///     and with given filter columns and values
		/// </summary>
		/// <param name="fieldNames">
		///     Field names to filter on
		/// </param>
		/// <param name="fieldValues">
		///     filter for field values
		/// </param>
		/// <param name="sortField">
		///     Sort on field name
		/// </param>
		/// <param name="ascending">
		///     true for sort ascending
		/// </param>
		/// <returns>
		///     sorted Imodel array
		/// </returns>
		public IModel[] SelectSorted(
			string[] fieldNames,
			object[] fieldValues,
			string[] sortField,
			bool ascending)
		{
			SqlCommand command = null;
			SqlDataReader dataReader = null;
			IModel[] models = null;

			command = (SqlCommand)CreateSelectCommandForMultipleResultsSorted(
				modelDataMap, fieldNames, fieldValues, sortField, ascending);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			dataReader = command.ExecuteReader();
			try
			{
				var converter = new DataReaderConverter(modelType);
				models = converter.ConvertDatReaderToModels(dataReader);
			}
			finally
			{
				dataReader.Close();
			}

			return models;
		}

		/// <summary>
		///     Selects mutiple records based on fileter columns and their values
		/// </summary>
		/// <param name="fieldNames">
		///     filter on filed names
		/// </param>
		/// <param name="fieldValues">
		///     filter for field values
		/// </param>
		/// <returns>
		///     Imodel array
		/// </returns>
		public IModel[] SelectMultiple(string[] fieldNames, object[] fieldValues)
		{
			SqlCommand command = null;
			SqlDataReader dataReader = null;
			IModel[] models = null;

			command = (SqlCommand)CreateSelectCommandForMultipleResults(
				modelDataMap, fieldNames, fieldValues);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			try
			{
				dataReader = command.ExecuteReader();
				var converter = new DataReaderConverter(modelType);
				models = converter.ConvertDatReaderToModels(dataReader);
			}
			catch (Exception ex)
			{
				var str = ex.Message;
			}
			finally
			{
				dataReader.Close();
			}

			return models;
		}

		/// <summary>
		///     Selects multiple records based on filter columns and their values
		/// </summary>
		/// <typeparam name="T">
		///     Any model object that implements Imodel interface.
		/// </typeparam>
		/// <param name="fieldNames">
		///     filter on filed names
		/// </param>
		/// <param name="fieldValues">
		///     filter for field values
		/// </param>
		/// <returns>
		///     Collection of IModel objects
		/// </returns>
		public List<T> SelectMultiple<T>(string[] fieldNames, object[] fieldValues) where T : IModel
		{
			SqlCommand command = null;
			SqlDataReader dataReader = null;
			List<T> models = null;

			command = (SqlCommand)CreateSelectCommandForMultipleResults(
				modelDataMap, fieldNames, fieldValues);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			try
			{
				dataReader = command.ExecuteReader();
				var converter = new DataReaderConverter(modelType);
				models = converter.ConvertDataReaderToModels<T>(dataReader);
			}
			finally
			{
				dataReader.Close();
			}

			return models;
		}

		/// <summary>
		///     Update a database record using given imodel object,
		/// </summary>
		/// <param name="model">
		///     A CarrierRate.GlobalTranz.Framework.Common.Models.IModel object to be updated
		/// </param>
		/// <returns>
		///     A CarrierRate.GlobalTranz.Framework.Common.Models.IModel object
		/// </returns>
		public IModel Update(IModel model)
		{
			ModelColumnMap c = null;
			DataReaderConverter converter;
			converter = new DataReaderConverter(modelDataMap);

			// set the createdDate if it exists
			c = (ModelColumnMap)modelDataMap.Columns["modifiedDate"];
			if (c != null)
				converter.SetFieldValue(model, c, DateTime.Now);

			// set the createdBy if it exists
			c = (ModelColumnMap)modelDataMap.Columns["modifiedBy"];
			if (c != null)
			{
				var userName = Thread.CurrentPrincipal.Identity.Name;
				converter.SetFieldValue(model, c, userName);
			}

			var command = (SqlCommand)connection.CreateCommand();
			command.CommandText = commandBuilder.GetUpdateSql();

			foreach (ModelColumnMap col in modelDataMap.Columns.Values)
				if (!col.IsViewOnly)
				{
					var paramName = "@" + col.ColumnName;
					command.Parameters.Add(CreateParameter(paramName, col, model));
				}

			var param = new SqlParameter();
			param.ParameterName = "@key";

			string keyName = null;
			if (modelDataMap.KeyField != null)
				keyName = modelDataMap.KeyField.Name;
			else if (modelDataMap.KeyProperty != null)
				keyName = modelDataMap.KeyProperty.Name;

			ModelColumnMap keyCol;
			keyCol = (ModelColumnMap)modelDataMap.Columns[keyName];
			command.Parameters.Add(CreateParameter("@key", keyCol, model));

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			var rowsAffected = command.ExecuteNonQuery();

			if (rowsAffected > 0)
				return model;

			return null;
		}

		/// <summary>
		///     Delete the record specified in the key value
		/// </summary>
		/// <param name="key">
		///     primary key record to be deleted
		/// </param>
		public void Delete(object key)
		{
			var command = (SqlCommand)connection.CreateCommand();
			command.CommandText = commandBuilder.GetDeleteSql();

			var p = new SqlParameter();

			p.ParameterName = "@key";
			p.Value = key;

			command.Parameters.Add(p);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			command.ExecuteNonQuery();
		}

		/// <summary>
		///     Delete records based on delete conditions specified
		/// </summary>
		/// <param name="fieldNames">
		///     Filter field names
		/// </param>
		/// <param name="fieldValues">
		///     Filter values.
		/// </param>
		public void DeleteWithCondition(string[] fieldNames, string[] fieldValues)
		{
			var command = (SqlCommand)connection.CreateCommand();

			var sb = new StringBuilder();
			sb.Append(commandBuilder.GetDeleteSqlWithoutWhere());

			if (fieldNames != null)
			{
				sb.Append(" Where ");

				for (var i = 0; i < fieldNames.Length; i++)
				{
					var columnMap = (ModelColumnMap)modelDataMap.Columns[fieldNames[i]]; // mapping
					sb.Append(columnMap.ColumnName);
					sb.Append(" = @");
					sb.Append(fieldNames[i]);
					if ((fieldNames.Length > 1) && (i != fieldNames.Length - 1))
						sb.Append(" AND ");

					var p = new SqlParameter();
					if (!columnMap.IsDatabaseTypeNull)
						p.DbType = columnMap.DatabaseType;

					if (columnMap.Field != null)
						p.ParameterName = "@" + columnMap.FieldName;
					else if (columnMap.Property != null)
						p.ParameterName = "@" + columnMap.PropertyName;

					object val = fieldValues[i];
					p.Value = val;
					command.Parameters.Add(p);
				}
			}

			command.CommandText = sb.ToString();

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			command.ExecuteNonQuery();
		}

		/// <summary>
		///     Insert a new record to database using given imodel object.
		/// </summary>
		/// <param name="model">
		///     A IModel object to be saved.
		/// </param>
		/// <returns>
		///     A IModel object
		/// </returns>
		public IModel Insert(IModel model)
		{
			SqlDataReader reader = null;
			IModel newModel = null;
			ModelColumnMap c = null;

			DataReaderConverter converter;
			converter = new DataReaderConverter(modelDataMap);

			// set the createdDate if it exists
			c = (ModelColumnMap)modelDataMap.Columns["createdDate"];
			if (c != null)
				converter.SetFieldValue(model, c, DateTime.Now);

			// set the createdBy if it exists
			c = (ModelColumnMap)modelDataMap.Columns["createdBy"];
			if (c != null)
			{
				var userName = Thread.CurrentPrincipal.Identity.Name;
				converter.SetFieldValue(model, c, userName);
			}

			var command = (SqlCommand)connection.CreateCommand();
			command.CommandText = commandBuilder.GetInsertSql();

			foreach (ModelColumnMap col in modelDataMap.Columns.Values)
				if (!col.IsViewOnly)
				{
					var p = new SqlParameter();

					p.ParameterName = "@" + col.ColumnName;
					if (col.Field != null)
						p.SourceColumn = col.FieldName;
					else if (col.Property != null)
						p.SourceColumn = col.PropertyName;

					if (!col.IsDatabaseTypeNull)
						p.DbType = col.DatabaseType;

					object val = null;
					if (col.Field != null)
						val = col.Field.GetValue(model);
					else if (col.Property != null)
						val = col.Property.GetValue(model, null);

					if (val == null)
						val = DBNull.Value;

					p.Value = val;
					command.Parameters.Add(p);
				}

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			try
			{
				reader = command.ExecuteReader();

				while (reader.Read())
				{
					var keyField = modelDataMap.KeyField;
					if (keyField != null)
					{
						var id = reader[0] ?? null;
						converter.SetFieldValue(model, keyField, id);
						newModel = model;
					}
					else if (modelDataMap.KeyProperty != null)
					{
						var id = reader[0] ?? null;
						converter.SetFieldValue(model, modelDataMap.KeyProperty, id);
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

		#endregion SQL Methods

		#region Stored Procedure methods

		/// <summary>
		///     Insert a new row to database using stored procedure
		/// </summary>
		/// <param name="model">
		///     An Imodel object with data to be saved
		/// </param>
		/// <returns>
		///     Returns I model object with new key
		/// </returns>
		public IModel InsertProcedure(IModel model)
		{
			SqlDataReader reader = null;
			IModel newModel = null;
			DataReaderConverter converter;
			converter = new DataReaderConverter(modelDataMap);

			// creates new command object with stored procedure parameters
			var command = commandBuilder.GetInsertCommand(model);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			// Execute stored procedure
			reader = command.ExecuteReader();

			try
			{
				while (reader.Read())
					if (modelDataMap.KeyProperty != null)
					{
						var id = reader[0] ?? null;
						converter.SetFieldValue(model, modelDataMap.KeyProperty, id);
						newModel = model;
					}
					else
					{
						newModel = model;
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
			return modelDataMap;

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
		///     Insert a new row to database using stored procedure
		/// </summary>
		/// <param name="model">
		///     An Imodel object with data to be saved
		/// </param>
		/// <returns>
		///     Returns I model object with new key
		/// </returns>
		public IModel UpdateProcedure(IModel model)
		{
			DataReaderConverter converter;
			converter = new DataReaderConverter(modelDataMap);

			// creates new command object with stored procedure parameters
			var command = commandBuilder.GetUpdateCommand(model);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			// Execute stored procedure
			var returnValue = command.ExecuteNonQuery();
			return model;
		}

		/// <summary>
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <param name="key">
		///     Primary key value.
		/// </param>
		/// <returns>
		///     Imodel object
		/// </returns>
		public IModel SelectProcedure(object key)
		{
			SqlDataReader dataReader = null;

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectCommand(key);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			// executes select stored procedure
			dataReader = command.ExecuteReader();

			try
			{
				while (dataReader.Read())
				{
					var converter = new DataReaderConverter(modelType);
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
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <param name="model">
		///     Model object with parameter values.
		/// </param>
		/// <returns>
		///     Imodel object
		/// </returns>
		public IModel SelectProcedure(IModel model)
		{
			SqlDataReader dataReader = null;

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectCommand(model);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			// executes select stored procedure
			dataReader = command.ExecuteReader();

			try
			{
				while (dataReader.Read())
				{
					var converter = new DataReaderConverter(modelType);
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
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <param name="model">
		///     Model object with value for input parameters
		/// </param>
		/// <returns>
		///     Imodel object
		/// </returns>
		public IModel[] SelectMultipleFromProcedure(IModel model)
		{
			SqlDataReader dataReader = null;
			IModel[] models;

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectMultipleCommand(model);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			// executes select stored procedure
			using (dataReader = command.ExecuteReader())
			{
				try
				{
					var converter = new DataReaderConverter(modelType);
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
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <typeparam name="T">
		///     Any object that implements IModel interface
		/// </typeparam>
		/// <param name="model">
		///     IModel object with values for stored procedure input parameters
		/// </param>
		/// <returns>
		///     Imodel object
		/// </returns>
		public List<T> SelectMultipleFromProcedure<T>(IModel model) where T : IModel
		{
			SqlDataReader dataReader = null;
			List<T> models;

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectMultipleCommand(model);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			//checking the connection state and making it in Open State
			if (connection.State.ToString() == "Closed")
				connection.Open();

			// executes select stored procedure
			using (dataReader = command.ExecuteReader())
			{
				try
				{
					var converter = new DataReaderConverter(modelType);
					models = converter.ConvertDataReaderToModels<T>(dataReader);
				}
				finally
				{
					dataReader.Close();
					if (connection.State.ToString() == "Open")
						connection.Close();
				}
			}

			return models;
		}

		/// <summary>
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <param name="key">
		///     Value of primary key
		/// </param>
		/// <returns>
		///     DataSet object
		/// </returns>
		public DataSet SelectDataSetProcedure(object key)
		{
			var result = new DataSet();

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectCommand(key);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			SqlDataAdapter sqlDataAdapter = null;
			using (sqlDataAdapter = new SqlDataAdapter(command))
			{
				sqlDataAdapter.Fill(result);
			}

			return result;
		}

		/// <summary>
		///     Generates select command from model and execute that stored procedure
		/// </summary>
		/// <param name="model">
		///     IModel object with values for stored procedure input parameters
		/// </param>
		/// <returns>
		///     A System.Data.DataSet object containing result of command execution
		/// </returns>
		public DataSet SelectMultipleDataSetFromProcedure(IModel model)
		{
			var result = new DataSet();

			// creates new as command object using stored procedure
			var command = commandBuilder.GetSelectMultipleCommand(model);

			command.Transaction = (SqlTransaction)transaction;
			command.Connection = (SqlConnection)connection;

			SqlDataAdapter sqlDataAdapter = null;
			using (sqlDataAdapter = new SqlDataAdapter(command))
			{
				sqlDataAdapter.Fill(result);
			}

			return result;
		}

		/// <summary>
		///     Insert a new row to database using stored procedure
		/// </summary>
		/// <param name="keyValue">
		///     Primary key value of record to be deleted.
		/// </param>
		/// <returns>
		///     Returns I model object with new key
		/// </returns>
		public bool DeleteProcedure(object keyValue)
		{
			DataReaderConverter converter;
			converter = new DataReaderConverter(modelDataMap);

			// creates new command object with stored procedure parameters
			var command = commandBuilder.GetDeleteCommand(keyValue);

			command.Connection = (SqlConnection)connection;
			command.Transaction = (SqlTransaction)transaction;

			// Execute stored procedure
			var rowsAffected = command.ExecuteNonQuery();

			if (rowsAffected > 0)
				return true;
			return false;
		}

		#region Private Methods

		/// <summary>
		///     Creates stored procedure parameter
		/// </summary>
		/// <param name="name">
		///     Parameter name
		/// </param>
		/// <param name="col">
		///     Model column map
		/// </param>
		/// <param name="model">
		///     I model object
		/// </param>
		/// <returns>
		///     Asa parameter
		/// </returns>
		private IDataParameter CreateParameter(string name, ModelColumnMap col, IModel model)
		{
			IDataParameter p = new SqlParameter();
			p.ParameterName = name;
			if (col.Field != null)
				p.SourceColumn = col.FieldName;
			else if (col.Property != null)
				p.SourceColumn = col.PropertyName;

			if (!col.IsDatabaseTypeNull)
				p.DbType = col.DatabaseType;

			object val = null;
			if (col.Field != null)
				val = col.Field.GetValue(model);
			else if (col.Property != null)
				val = col.Property.GetValue(model, null);

			if (val == null)
				val = DBNull.Value;

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
			var cmd = new SqlCommand();
			var sb = new StringBuilder();
			sb.Append("select ");
			sb = GenerateColumnList(mapping, sb, true);
			sb.Append(" from [");
			sb.Append(mapping.ViewName);
			sb.Append("] ");
			if (fieldNames != null)
			{
				sb.Append(" where ");

				for (var i = 0; i < fieldNames.Length; i++)
				{
					var columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
					sb.Append(columnMap.ColumnName);
					sb.Append(" = @");
					sb.Append(fieldNames[i]);
					if ((fieldNames.Length > 1) && (i != fieldNames.Length - 1))
						sb.Append(" AND ");

					var p = new SqlParameter();
					if (!columnMap.IsDatabaseTypeNull)
						p.DbType = columnMap.DatabaseType;

					// p.SourceColumn = columnMap.FieldName;
					if (columnMap.Field != null)
						p.ParameterName = "@" + columnMap.FieldName;
					else if (columnMap.Property != null)
						p.ParameterName = "@" + columnMap.PropertyName;

					var val = fieldValues[i];
					p.Value = val;
					cmd.Parameters.Add(p);
				}
			}

			sb.Append(" order by ");
			sb.Append(sortField);
			if (!ascending)
				sb.Append(" desc");

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
			var cmd = new SqlCommand();
			var sb = new StringBuilder();
			sb.Append("select ");
			sb = GenerateColumnList(mapping, sb, true);
			sb.Append(" from [");
			sb.Append(mapping.ViewName);
			sb.Append("] ");
			if (fieldNames != null)
			{
				sb.Append(" where ");

				for (var i = 0; i < fieldNames.Length; i++)
				{
					var columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
					sb.Append(columnMap.ColumnName);
					sb.Append(" = @");
					sb.Append(fieldNames[i]);
					if ((fieldNames.Length > 1) && (i != fieldNames.Length - 1))
						sb.Append(" AND ");

					var p = new SqlParameter();
					if (!columnMap.IsDatabaseTypeNull)
						p.DbType = columnMap.DatabaseType;

					// p.SourceColumn = columnMap.FieldName;
					if (columnMap.Field != null)
						p.ParameterName = "@" + columnMap.FieldName;
					else if (columnMap.Property != null)
						p.ParameterName = "@" + columnMap.PropertyName;

					var val = fieldValues[i];
					p.Value = val;
					cmd.Parameters.Add(p);
				}
			}

			sb.Append(" order by ");
			for (var i = 0; i < sortFields.GetLength(0); i++)
				if (i < sortFields.GetUpperBound(0))
				{
					sb.Append(sortFields[i]);
					if (!ascending)
						sb.Append(" desc");

					sb.Append(",");
				}
				else
				{
					sb.Append(sortFields[i]);
					if (!ascending)
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
		/// <returns>
		///     Command object with all parameters
		/// </returns>
		private IDbCommand CreateSelectCommandForMultipleResults(
			ModelDataMap mapping,
			string[] fieldNames,
			object[] fieldValues)
		{
			var cmd = new SqlCommand();
			var sb = new StringBuilder();
			sb.Append("select ");
			sb = GenerateColumnList(mapping, sb, true);
			sb.Append(" from ");
			sb.Append(mapping.ViewName);
			sb.Append(" ");
			if (fieldNames != null)
			{
				sb.Append(" where ");

				for (var i = 0; i < fieldNames.Length; i++)
				{
					var columnMap = (ModelColumnMap)mapping.Columns[fieldNames[i]];
					sb.Append(columnMap.ColumnName);
					sb.Append(" = @");
					sb.Append(fieldNames[i]);
					if ((fieldNames.Length > 1) && (i != fieldNames.Length - 1))
						sb.Append(" AND ");

					var p = new SqlParameter();
					if (!columnMap.IsDatabaseTypeNull)
						p.DbType = columnMap.DatabaseType;

					// p.SourceColumn = columnMap.FieldName;
					if (columnMap.Field != null)
						p.ParameterName = "@" + columnMap.FieldName;
					else if (columnMap.Property != null)
						p.ParameterName = "@" + columnMap.PropertyName;

					var val = fieldValues[i];
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
			var changed = false;
			foreach (ModelColumnMap col in mapping.Columns.Values)
				if (selectStatement || !col.IsViewOnly)
				{
					// add the column if this is a select statement or if the column
					// is not a read only column.
					sb.Append(col.ColumnName);
					sb.Append(", ");
					changed = true;
				}

			if (changed)
				sb.Remove(sb.Length - 2, 2);

			return sb;
		}

		#endregion Private Methods

		#endregion Stored Procedure methods
	}
}