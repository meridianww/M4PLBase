#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.AttributeMapping;
using Microsoft.SqlServer.Server;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace M4PL.DataAccess.SQLSerializer.Factory.SQL.Accessors
{
	/// <summary>
	///     This class is used to build sql queries and SQL command objecPropanator.
	/// </summary>
	public class SqlFrameworkCommandBuilder
	{
		#region Constructor

		/// <summary>
		///     Constructor, create new instance of SqlFrameworkCommandBuilder
		/// </summary>
		/// <param name="modelDataMap">
		///     Model parameter map
		/// </param>
		/// <param name="modelType">
		///     Type of imodel object
		/// </param>
		private SqlFrameworkCommandBuilder(ModelDataMap modelDataMap, Type modelType)
		{
			map = modelDataMap;
			type = modelType;
		}

		#endregion Constructor

		#region Static Methods

		/// <summary>
		///     Create select sql statement
		/// </summary>
		/// <param name="modelDataMap">
		///     Model data map object
		/// </param>
		/// <param name="modelType">
		///     Type of model
		/// </param>
		/// <returns>
		///     Command builder object with sql query.
		/// </returns>
		public static SqlFrameworkCommandBuilder GetSqlStringBuilder(
			ModelDataMap modelDataMap,
			Type modelType)
		{
			var b = (SqlFrameworkCommandBuilder)sqlMap[modelType];
			if (b == null)
			{
				b = new SqlFrameworkCommandBuilder(modelDataMap, modelType);
				sqlMap[modelType] = b;
			}

			return b;
		}

		#endregion Static Methods

		#region Member variables

		/// <summary>
		///     Hash table for column mapping
		/// </summary>
		private static readonly Hashtable sqlMap = new Hashtable();

		/// <summary>
		///     Delete query
		/// </summary>
		private string deleteSql;

		/// <summary>
		///     Insert query
		/// </summary>
		private string insertSql;

		/// <summary>
		///     Select query
		/// </summary>
		private string selectSql;

		/// <summary>
		///     Select query with lock
		/// </summary>
		private string selectWithLockSql;

		/// <summary>
		///     update query
		/// </summary>
		private string updateSql;

		/// <summary>
		///     Model parameter mapping
		/// </summary>
		private readonly ModelDataMap map;

		/// <summary>
		///     Type of imodel object
		/// </summary>
		private Type type;

		#endregion Member variables

		#region Command

		/// <summary>
		///     Retrieves data using stored procedure specified in the model
		/// </summary>
		/// <param name="key">
		///     Primary key value
		/// </param>
		/// <returns>
		///     SQL command object
		/// </returns>
		public SqlCommand GetSelectCommand(object key)
		{
			var command = new SqlCommand();

			var commandText = ((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.SELECT]).ProcedureName;

			command.CommandText = commandText;
			command.CommandType = CommandType.StoredProcedure;

			var p = new SqlParameter();
			p.ParameterName = string.Concat("@", map.KeyColumn);
			p.Value = key;
			command.Parameters.Add(p);

			return command;
		}

		/// <summary>
		///     Retrieves data using stored procedure specified in the model
		/// </summary>
		/// <param name="model">
		///     Model object with input parameter values.
		/// </param>
		/// <returns>
		///     SQL command object
		/// </returns>
		public SqlCommand GetSelectMultipleCommand(IModel model)
		{
			var command = new SqlCommand();
			var parameterSortedList = new SortedList();

			var commandText =
				((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.SELECT_MULTIPLE]).ProcedureName;
			command.CommandText = commandText;
			command.CommandType = CommandType.StoredProcedure;

			foreach (ArrayList al in map.Parameters.Values)
			{
				var parameters = (ModelParameterMap[])al.ToArray(
					typeof(ModelParameterMap));
				if ((parameters != null) && (parameters.Length > 0))
					for (var i = 0; i < parameters.Length; i++)
					{
						var mp = parameters[i];
						if (mp.ParameterAction == DBProcedureType.SELECT_MULTIPLE)
						{
							var p = new SqlParameter();

							var parameterName = string.Concat("@", mp.ParameterName);
							p.ParameterName = parameterName;
							p.DbType = mp.DatabaseType;
							p.SourceColumn = parameterName;

							var parameterValue = mp.Property.GetValue(model, null);
							if (parameterValue == null)
								p.Value = DBNull.Value;
							else
								p.Value = parameterValue;

							int index;
							if (mp.ParameterIndex == 0)
								index = parameterSortedList.Count + 1;
							else
								index = mp.ParameterIndex;

							parameterSortedList.Add(index, p);
						}
					}
			}

			if (parameterSortedList.Count > 0)
				foreach (DictionaryEntry parameter in parameterSortedList)
				{
					var index = (int)parameter.Key;
					var currentParam = (SqlParameter)parameter.Value;

					command.Parameters.Add(currentParam);
				}

			return command;
		}

		/// <summary>
		///     Retrieves data using stored procedure specified in the model
		/// </summary>
		/// <param name="model">
		///     Model object with input parameter values.
		/// </param>
		/// <returns>
		///     SQL command object
		/// </returns>
		public SqlCommand GetSelectCommand(IModel model)
		{
			var command = new SqlCommand();
			var parameterSortedList = new SortedList();

			var commandText = ((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.SELECT]).ProcedureName;
			command.CommandText = commandText;
			command.CommandType = CommandType.StoredProcedure;

			foreach (ArrayList al in map.Parameters.Values)
			{
				var parameters = (ModelParameterMap[])al.ToArray(
					typeof(ModelParameterMap));
				if ((parameters != null) && (parameters.Length > 0))
					for (var i = 0; i < parameters.Length; i++)
					{
						var mp = parameters[i];
						if (mp.ParameterAction == DBProcedureType.SELECT)
						{
							var p = new SqlParameter();

							var parameterName = string.Concat("@", mp.ParameterName);
							p.ParameterName = parameterName;
							p.DbType = mp.DatabaseType;
							p.SourceColumn = parameterName;

							var parameterValue = mp.Property.GetValue(model, null);
							if (parameterValue == null)
								p.Value = DBNull.Value;
							else
								p.Value = parameterValue;

							int index;
							if (mp.ParameterIndex == 0)
								index = parameterSortedList.Count + 1;
							else
								index = mp.ParameterIndex;

							parameterSortedList.Add(index, p);
						}
					}
			}

			if (parameterSortedList.Count > 0)
				foreach (DictionaryEntry parameter in parameterSortedList)
				{
					var index = (int)parameter.Key;
					var currentParam = (SqlParameter)parameter.Value;

					command.Parameters.Add(currentParam);
				}

			return command;
		}

		/// <summary>
		///     Creates SQL command object with parameters for insert operation
		/// </summary>
		/// <param name="model">
		///     Imodel object
		/// </param>
		/// <returns>
		///     An SqlCommand object with command text and all parameters.
		/// </returns>
		public SqlCommand GetInsertCommand(IModel model)
		{
			var asaCommand = new SqlCommand();
			var parameterSortedList = new SortedList();

			var insertProcedureName =
				((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.INSERT]).ProcedureName;

			if (insertProcedureName != null)
			{
				asaCommand.CommandText = insertProcedureName;
				asaCommand.CommandType = CommandType.StoredProcedure;
				foreach (ArrayList al in map.Parameters.Values)
				{
					var parameters = (ModelParameterMap[])al.ToArray(
						typeof(ModelParameterMap));
					if ((parameters != null) && (parameters.Length > 0))
						for (var i = 0; i < parameters.Length; i++)
						{
							var mp = parameters[i];
							if (mp.ParameterAction == DBProcedureType.INSERT)
							{
								var p = new SqlParameter();

								var parameterName = string.Concat("@", mp.ParameterName);
								p.ParameterName = parameterName;
								p.DbType = mp.DatabaseType;
								p.SourceColumn = parameterName;

								var parameterValue = mp.Property.GetValue(model, null);
								if (parameterValue == null)
									p.Value = DBNull.Value;
								else
									p.Value = parameterValue;

								int index;
								if (mp.ParameterIndex == 0)
									index = parameterSortedList.Count + 1;
								else
									index = mp.ParameterIndex;

								parameterSortedList.Add(index, p);
							}
						}
				}
			}

			if (parameterSortedList.Count > 0)
				foreach (DictionaryEntry parameter in parameterSortedList)
				{
					var index = (int)parameter.Key;
					var currentParam = (SqlParameter)parameter.Value;

					asaCommand.Parameters.Add(currentParam);
				}

			return asaCommand;
		}

		/// <summary>
		///     Creates SQL command object with parameters for insert operation
		/// </summary>
		/// <typeparam name="T">
		///     Any type which implements Framework.Common.Models.IModel interface.
		/// </typeparam>
		/// <param name="modelCollection">
		///     A collection of model items to be bulk inserted.
		/// </param>
		/// <returns>
		///     An SqlCommand object with command text and all parameters.
		/// </returns>
		public SqlCommand GetInsertTableValuedCommand<T>(List<T> modelCollection) where T : IModel
		{
			var asaCommand = new SqlCommand();
			var parameterSortedList = new SortedList();
			var s = map.TableName;

			var procedureMap = (StoredProcedureMappingAttribute)
				map.Procedures[DBProcedureType.INSERT_MULTIPLE];

			var insertProcedureName = procedureMap.ProcedureName;

			if (insertProcedureName != null)
			{
				asaCommand.CommandText = insertProcedureName;
				asaCommand.CommandType = CommandType.StoredProcedure;

				var dataRecords = CreateSqlDataRecordCollection(modelCollection);
				var tableValuedType = procedureMap.TableValuedParameterType;
				var tableValuedParameterName = procedureMap.TableValuedParameterName;

				var parameter = asaCommand.Parameters.AddWithValue(
					tableValuedParameterName, dataRecords);

				parameter.SqlDbType = SqlDbType.Structured;
				parameter.TypeName = tableValuedType;
			}

			return asaCommand;
		}

		/// <summary>
		///     Create sql data record collection for bulk insert.
		///     It creates meta data from insert procedure mapping  customattribute
		/// </summary>
		/// <typeparam name="T">
		///     Any type which implements Framework.Common.Models.IModel interface.
		/// </typeparam>
		/// <param name="modelCollection">
		///     A collection of model items to be bulk inserted.
		/// </param>
		/// <returns>
		///     A collection of SqlDataRecord object for bulk insert.
		/// </returns>
		public List<SqlDataRecord> CreateSqlDataRecordCollection<T>(List<T> modelCollection) where T : IModel
		{
			List<SqlDataRecord> recordCollection = null;
			var modelInsertParameters = new ModelParameterMap[map.Parameters.Count];
			var metaDataCollection = new SqlMetaData[map.Parameters.Count];

			foreach (ArrayList parameterMap in map.Parameters.Values)
			{
				var parameters = (ModelParameterMap[])parameterMap.ToArray(typeof(ModelParameterMap));
				if ((parameters != null) && (parameters.Length > 0))
					for (var i = 0; i < parameters.Length; i++)
					{
						var mp = parameters[i];
						if (mp.ParameterAction == DBProcedureType.INSERT)
						{
							// create meta data for insert parameter.
							var metaData = CreateSQLMetaData(mp.ParameterName, mp.DatabaseType);
							metaDataCollection[mp.ParameterIndex - 1] = metaData;
							modelInsertParameters[mp.ParameterIndex - 1] = mp;
						}
					}
			}

			var metaDataList = new List<SqlMetaData>();

			for (var counter = 0; counter < metaDataCollection.Length; counter++)
				if (metaDataCollection[counter] != null)
					metaDataList.Add(metaDataCollection[counter]);

			// create one sql data record object for each model in the collection
			// and add that object to list
			recordCollection = new List<SqlDataRecord>();
			foreach (IModel model in modelCollection)
			{
				var dataRecord = new SqlDataRecord(metaDataList.ToArray());

				// assign value for each property in the data record.
				for (var index = 0; index < modelInsertParameters.Length; index++)
					if (modelInsertParameters[index] != null)
					{
						var mp = modelInsertParameters[index];

						// this.SetDataRecordValue(dataRecord, mp.DatabaseType, mp.Property.GetValue(model, null), index);
						dataRecord.SetValue(index, mp.Property.GetValue(model, null));
					}

				recordCollection.Add(dataRecord);
			}

			return recordCollection;
		}

		/// <summary>
		///     Creates SQL command object with parameters for update operation
		/// </summary>
		/// <param name="model">
		///     Imodel object
		/// </param>
		/// <returns>
		///     An SqlCommand object with command text and all parameters.
		/// </returns>
		public SqlCommand GetUpdateCommand(IModel model)
		{
			var asaCommand = new SqlCommand();
			var parameterSortedList = new SortedList();

			var updateProcedureName =
				((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.UPDATE]).ProcedureName;

			if (updateProcedureName != null)
			{
				asaCommand.CommandText = updateProcedureName;
				asaCommand.CommandType = CommandType.StoredProcedure;

				foreach (ArrayList al in map.Parameters.Values)
				{
					var parameters = (ModelParameterMap[])al.ToArray(
						typeof(ModelParameterMap));
					if ((parameters != null) && (parameters.Length > 0))
						for (var i = 0; i < parameters.Length; i++)
						{
							var mp = parameters[i];
							if (mp.ParameterAction == DBProcedureType.UPDATE)
							{
								var p = new SqlParameter();

								var parameterName = string.Concat("@", mp.ParameterName);
								p.ParameterName = parameterName;
								p.DbType = mp.DatabaseType;
								p.SourceColumn = parameterName;

								var parameterValue = mp.Property.GetValue(model, null);
								if (parameterValue == null)
									p.Value = DBNull.Value;
								else
									p.Value = parameterValue;

								int index;
								if (mp.ParameterIndex == 0)
									index = parameterSortedList.Count + 1;
								else
									index = mp.ParameterIndex;

								parameterSortedList.Add(index, p);
							}
						}
				}
			}

			if (parameterSortedList.Count > 0)
				foreach (DictionaryEntry parameter in parameterSortedList)
				{
					var index = (int)parameter.Key;
					var currentParam = (SqlParameter)parameter.Value;

					asaCommand.Parameters.Add(currentParam);
				}

			return asaCommand;
		}

		/// <summary>
		///     Creates SQL command for delete
		/// </summary>
		/// <param name="keyValue">
		///     Primary key value
		/// </param>
		/// <returns>
		///     An SqlCommand object with delete text
		/// </returns>
		public SqlCommand GetDeleteCommand(object keyValue)
		{
			var asaCommand = new SqlCommand();

			// retrieves delete stored procedure name from model map.
			var deleteProcedureName =
				((StoredProcedureMappingAttribute)map.Procedures[DBProcedureType.DELETE]).ProcedureName;

			asaCommand.CommandText = deleteProcedureName;
			asaCommand.CommandType = CommandType.StoredProcedure;

			var p = new SqlParameter();
			p.ParameterName = string.Concat("@", map.KeyColumn);
			p.Value = keyValue;
			asaCommand.Parameters.Add(p);

			return asaCommand;
		}

		#endregion Command

		#region SQL

		/// <summary>
		///     Create delete sql
		/// </summary>
		/// <returns>
		///     Delete SQL statement
		/// </returns>
		public string GetDeleteSql()
		{
			if (deleteSql == null)
			{
				var sb = new StringBuilder();
				sb.Append("Delete from ");
				sb.Append(map.TableName);
				sb.Append(" WHERE ");
				sb.Append(map.KeyColumn);
				sb.Append(" = @key");
				deleteSql = sb.ToString();
			}

			return deleteSql;
		}

		/// <summary>
		///     Create delete statement without where clause
		/// </summary>
		/// <returns>
		///     Delete sql statement.
		/// </returns>
		public string GetDeleteSqlWithoutWhere()
		{
			if (deleteSql == null)
			{
				var sb = new StringBuilder();
				sb.Append("Delete from [");
				sb.Append(map.TableName);
				sb.Append("]");
				deleteSql = sb.ToString();
			}

			return deleteSql;
		}

		/// <summary>
		///     Create select sql statement
		/// </summary>
		/// <returns>
		///     Select sql statement
		/// </returns>
		public string GetSelectSql()
		{
			if (selectSql == null)
			{
				var sb = new StringBuilder();
				sb.Append("select ");
				sb = GenerateColumnList(map, sb, true);
				sb.Append(" from [");
				sb.Append(map.ViewName);
				sb.Append("] where ");
				sb.Append(map.KeyColumn);
				sb.Append(" = @key ");

				selectSql = sb.ToString();
			}

			return selectSql;
		}

		/// <summary>
		///     Create select sql statement with row lock and hold lock
		/// </summary>
		/// <returns>
		///     Select sql statement
		/// </returns>
		public string GetSelectWithLockSql()
		{
			if (selectWithLockSql == null)
			{
				var sb = new StringBuilder();

				sb.Append("select ");
				sb = GenerateColumnList(map, sb, true);
				sb.Append(" from [");
				sb.Append(map.ViewName);
				sb.Append("] WITH(HOLDLOCK,ROWLOCK)");
				sb.Append(" where ");
				sb.Append(map.KeyColumn);
				sb.Append(" = @key");

				selectWithLockSql = sb.ToString();
			}

			return selectWithLockSql;
		}

		/// <summary>
		///     Create insert sql statement
		/// </summary>
		/// <returns>
		///     Insert sql statement
		/// </returns>
		public string GetInsertSql()
		{
			if (insertSql == null)
			{
				var sb = new StringBuilder();

				// sb.Append("Insert into [");
				sb.Append("Insert into ");
				sb.Append(map.TableName);

				// sb.Append("] ( ");
				sb.Append(" ( ");
				sb = GenerateColumnList(map, sb, false);
				sb.Append(") Values (");

				// SqlCommand cmd = (SqlCommand)connection.CreateCommand();
				foreach (ModelColumnMap col in map.Columns.Values)
					if (!col.IsViewOnly)
					{
						sb.Append("@");
						sb.Append(col.ColumnName);
						sb.Append(", ");
					}

				sb.Append(");");
				sb = StripCommaFromSQL(sb);
				sb.Append(" Select SCOPE_IDENTITY(); ");

				insertSql = sb.ToString();
			}

			return insertSql;
		}

		/// <summary>
		///     Create update sql statement
		/// </summary>
		/// <returns>
		///     update sql statement
		/// </returns>
		public string GetUpdateSql()
		{
			if (updateSql == null)
			{
				var sb = new StringBuilder();
				sb.Append("update ");
				sb.Append(map.TableName);
				sb.Append(" set ");

				foreach (ModelColumnMap col in map.Columns.Values)
					if (!col.IsViewOnly)
					{
						sb.Append(col.ColumnName);
						sb.Append(" = @");
						sb.Append(col.ColumnName);
						sb.Append(", ");
					}

				sb.Append(" where ");
				sb.Append(map.KeyColumn);
				sb.Append(" = @key");
				sb = StripCommaFromSQL(sb);
				updateSql = sb.ToString();
			}

			return updateSql;
		}

		#endregion SQL

		#region Private Methods

		/// <summary>
		///     Convert DBtype to corresponding sql db type.
		/// </summary>
		/// <param name="databaseType">
		///     DBtype to be converted.
		/// </param>
		/// <returns>
		///     Sql db type.
		/// </returns>
		private SqlDbType ConvertDBTypetoSqlDbType(DbType databaseType)
		{
			SqlDbType sqlDbType;
			switch (databaseType)
			{
				case DbType.String:
					sqlDbType = SqlDbType.VarChar;
					break;

				case DbType.Int32:
					sqlDbType = SqlDbType.Int;
					break;

				case DbType.DateTime:
					sqlDbType = SqlDbType.DateTime;
					break;

				case DbType.Boolean:
					sqlDbType = SqlDbType.Bit;
					break;

				default:
					sqlDbType = SqlDbType.NVarChar;
					break;
			}

			return sqlDbType;
		}

		/// <summary>
		///     Create sql meta data for sql data record
		/// </summary>
		/// <param name="parameterName">
		///     Sql Parameter name
		/// </param>
		/// <param name="databaseType">
		///     Parameter data type
		/// </param>
		/// <returns>
		///     Sql Meta data object.
		/// </returns>
		private SqlMetaData CreateSQLMetaData(string parameterName, DbType databaseType)
		{
			SqlMetaData metaData;

			switch (databaseType)
			{
				case DbType.String:
					metaData = new SqlMetaData(parameterName, SqlDbType.VarChar, 1000);
					break;

				case DbType.Int64:
					metaData = new SqlMetaData(parameterName, SqlDbType.BigInt);
					break;

				case DbType.Int32:
					metaData = new SqlMetaData(parameterName, SqlDbType.Int);
					break;

				case DbType.DateTime:
					metaData = new SqlMetaData(parameterName, SqlDbType.DateTime);
					break;

				case DbType.Boolean:
					metaData = new SqlMetaData(parameterName, SqlDbType.Bit);
					break;

				default:
					metaData = new SqlMetaData(parameterName, SqlDbType.NVarChar, 1000);
					break;
			}

			return metaData;
		}

		/// <summary>
		///     Generate column list for the query
		/// </summary>
		/// <param name="mapping">
		///     Mapping details.
		/// </param>
		/// <param name="sb">
		///     String builder object
		/// </param>
		/// <param name="selectStatement">
		///     Select sql statement
		/// </param>
		/// <returns>
		///     String bulder object with select sql
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

		/// <summary>
		///     Strip comma from sql
		/// </summary>
		/// <param name="sb">
		///     String builder object with sql
		/// </param>
		/// <returns>
		///     Sql statement.
		/// </returns>
		private StringBuilder StripCommaFromSQL(StringBuilder sb)
		{
			var strSQL = sb.ToString();
			var index = strSQL.LastIndexOf(",");
			if (index >= 0)
				strSQL = strSQL.Remove(index, 1);

			var sqlStatement = new StringBuilder(strSQL);
			return sqlStatement;
		}

		/// <summary>
		///     Set property value to sql record.
		/// </summary>
		/// <param name="dataRecord">
		///     Instance of sql data record.
		/// </param>
		/// <param name="databaseType">
		///     Type of database column.
		/// </param>
		/// <param name="propValue">
		///     Value to be inserted.
		/// </param>
		/// <param name="ordinal">
		///     The zero based ordinal of the data record column.
		/// </param>
		private void SetDataRecordValue(SqlDataRecord dataRecord, DbType databaseType, object propValue, int ordinal)
		{
			switch (databaseType)
			{
				case DbType.String:
					dataRecord.SetString(ordinal, propValue.ToString());
					break;

				case DbType.Int32:
					dataRecord.SetInt32(ordinal, Convert.ToInt32(propValue));
					break;

				case DbType.DateTime:
					dataRecord.SetDateTime(ordinal, Convert.ToDateTime(propValue));
					break;

				case DbType.Boolean:
					dataRecord.SetBoolean(ordinal, Convert.ToBoolean(propValue));
					break;

				default:
					dataRecord.SetString(ordinal, propValue.ToString());
					break;
			}
		}

		#endregion Private Methods
	}
}