#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
	public class SqlSerializer
	{
		//   private SqlConnectionContext OpenConnection()
		//{
		//  SqlConnectionContext connectionContext = new SqlConnectionContext(this._connection, this._command, this._parameters);
		//  this._connection.Open();
		//  return connectionContext;
		//}

		[Flags]
		public enum ParameterFlags
		{
			Default = 0,
			IdFieldsOnly = 1,
			ExcludeIdentityFields = 2
		}

		public static string DefaultConnectionStringName = "DefaultConnection"; //M4PL ConnectionString

		[ThreadStatic]
		private static SqlSerializer _defaultThreadLocal;

		private static readonly int commandTimeoutInSecs = 180;
		private readonly SqlCommand _command;
		private readonly SqlConnection _connection;
		private Parameter[] _parameters;

		static SqlSerializer()
		{
		}

		public SqlSerializer()
		{
			if (ConfigurationManager.ConnectionStrings[DefaultConnectionStringName] == null)
				throw new InvalidOperationException(string.Format("Invalid default connection string name: {0}",
					DefaultConnectionStringName));
			_connection =
				new SqlConnection(ConfigurationManager.ConnectionStrings[DefaultConnectionStringName].ConnectionString);
			_command = _connection.CreateCommand();
		}

		public SqlSerializer(ConnectionStringSettings connectionStringSetting)
		{
			if (connectionStringSetting == null)
				throw new ArgumentNullException("connectionStringSetting");
			_connection = new SqlConnection(connectionStringSetting.ConnectionString);
			_command = _connection.CreateCommand();
		}

		public SqlSerializer(string connectionString)
		{
			_connection = new SqlConnection(connectionString);
			_command = _connection.CreateCommand();
		}

		public static SqlSerializer Default
		{
			get { return _defaultThreadLocal ?? (_defaultThreadLocal = new SqlSerializer()); }
		}

		public static SqlSerializer ByName(string name)
		{
			var connectionStringSettings = ConfigurationManager.ConnectionStrings[name];
			if (connectionStringSettings == null)
				throw new InvalidOperationException(string.Format("Invalid connection string name: {0}", name));
			return new SqlSerializer(connectionStringSettings.ConnectionString);
		}

		public static Dictionary<string, MappingInfo> GetFieldMappings<T>()
		{
			return GetFieldMappings(typeof(T));
		}

		public static Dictionary<string, MappingInfo> GetFieldMappings(Type type)
		{
			var dictionary = new Dictionary<string, MappingInfo>();
			foreach (var propertyInfo in type.GetProperties())
			{
				var propertyMappingAttribute =
					Attribute.GetCustomAttribute(propertyInfo, typeof(PropertyMappingAttribute)) as
						PropertyMappingAttribute ?? new PropertyMappingAttribute(propertyInfo.Name);
				dictionary.Add(propertyMappingAttribute.Name,
					new PropertyMappingInfo(propertyMappingAttribute, propertyInfo));
			}
			foreach (var fieldInfo in type.GetFields())
			{
				var fieldMappingAttribute =
					Attribute.GetCustomAttribute(fieldInfo, typeof(FieldMappingAttribute)) as FieldMappingAttribute ??
					new FieldMappingAttribute(fieldInfo.Name);
				dictionary.Add(fieldMappingAttribute.Name, new FieldMappingInfo(fieldMappingAttribute, fieldInfo));
			}
			return dictionary;
		}

		public void AddParameters<T>(T obj, ParameterFlags flags = ParameterFlags.Default)
		{
			foreach (var keyValuePair in GetFieldMappings<T>())
			{
				var mappingInfo = keyValuePair.Value;
				if (((flags & ParameterFlags.IdFieldsOnly) == ParameterFlags.IdFieldsOnly) &&
					mappingInfo.MappingAttribute.IsId &&
					((flags & ParameterFlags.ExcludeIdentityFields) == ParameterFlags.ExcludeIdentityFields) &&
					!mappingInfo.MappingAttribute.IsIdentity)
					_command.Parameters.AddWithValue("@" + mappingInfo.Name, mappingInfo.GetValue(obj));
			}
		}

		public void SetupCommand(string commandText, Parameter[] parameters, bool storedProcedure = false,
			int timeout = 30)
		{
			_command.CommandText = commandText;
			_command.CommandType = storedProcedure ? CommandType.StoredProcedure : CommandType.Text;
			_command.CommandTimeout = timeout;
			_command.Parameters.Clear();
			_parameters = parameters;
			if ((parameters == null) || (parameters.Length == 0))
				return;
			foreach (var parameter in parameters)
			{
				var sqlParameter = new SqlParameter(parameter.Name, parameter.Value ?? DBNull.Value);
				sqlParameter.Direction = parameter.Direction;
				if (sqlParameter.Direction.HasFlag(ParameterDirection.Output) && (parameter.Type != null))
				{
					DbType result;
					if (!Enum.TryParse(parameter.Type.Name, true, out result))
						result = DbType.Object;
					sqlParameter.DbType = result;
				}
				if (!string.IsNullOrEmpty(parameter.TableValueParameterType))
				{
					sqlParameter.SqlDbType = SqlDbType.Structured;
					sqlParameter.TypeName = parameter.TableValueParameterType;
				}
				_command.Parameters.Add(sqlParameter);
			}
		}

		[Obsolete]
		public object DeserializeSingleRecord(string commandText, bool dateTimeAsUtc, params Parameter[] parameters)
		{
			return DeserializeSingleRecord<ExpandoObject, object>(commandText, parameters, false, false);
		}

		[Obsolete]
		public T DeserializeSingleRecord<T>(string commandText, bool dateTimeAsUtc, params Parameter[] parameters)
			where T : class, new()
		{
			return DeserializeSingleRecord<T, T>(commandText, parameters, false, false);
		}

		[Obsolete]
		public TReturn DeserializeSingleRecord<TObject, TReturn>(string commandText, bool dateTimeAsUtc,
			params Parameter[] parameters) where TObject : class, new()
		{
			SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
			return DeserializeSingleRecord<TObject, TReturn>(dateTimeAsUtc);
		}

		public object DeserializeSingleRecord(bool dateTimeAsUtc = false, bool storedProcedure = false)
		{
			return DeserializeSingleRecord<ExpandoObject, object>(dateTimeAsUtc);
		}

		public object DeserializeSingleRecord(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.DeserializeSingleRecord<ExpandoObject, object>(commandText1, parameters, num1 != 0,
				num2 != 0);
		}

		public object DeserializeSingleRecord(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			return DeserializeSingleRecord<ExpandoObject, object>(commandText, parameters, dateTimeAsUtc,
				storedProcedure);
		}

		public T DeserializeSingleRecord<T>(bool dateTimeAsUtc = false) where T : class, new()
		{
			return DeserializeSingleRecord<T, T>(dateTimeAsUtc);
		}

		public T DeserializeSingleRecord<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false,
			bool storedProcedure = false) where T : class, new()
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.DeserializeSingleRecord<T, T>(commandText1, parameters, num1 != 0, num2 != 0);
		}

		public T DeserializeSingleRecord<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false,
			bool storedProcedure = false) where T : class, new()
		{
			return DeserializeSingleRecord<T, T>(commandText, parameters, dateTimeAsUtc, storedProcedure);
		}

		public TReturn DeserializeSingleRecord<TObject, TReturn>(string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false, bool storedProcedure = false) where TObject : class, new()
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			return DeserializeSingleRecord<TObject, TReturn>(dateTimeAsUtc);
		}

		public TReturn DeserializeSingleRecord<TObject, TReturn>(bool dateTimeAsUtc = false)
			where TObject : class, new()
		{
			var @return = default(TReturn);
			using (OpenConnection())
			{
				var sqlDataReader = _command.ExecuteReader(CommandBehavior.SingleRow);
				if (sqlDataReader.Read())
					@return = Deserialize<TObject, TReturn>(sqlDataReader, false);
				sqlDataReader.Close();
			}
			return @return;
		}

		[Obsolete]
		public List<object> DeserializeMultiRecords(string commandText, bool dateTimeAsUtc,
			params Parameter[] parameters)
		{
			return DeserializeMultiRecords<ExpandoObject, object>(commandText, dateTimeAsUtc, parameters);
		}

		[Obsolete]
		public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(string commandText, bool dateTimeAsUtc,
			params Parameter[] parameters) where TObject : class, new()
		{
			SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
			return DeserializeMultiRecords<TObject, TReturn>(false);
		}

		public object DeserializeMultiRecords(bool dateTimeAsUtc = false)
		{
			return DeserializeMultiRecords<ExpandoObject, object>(dateTimeAsUtc);
		}

		public List<object> DeserializeMultiRecords(string commandText, Parameter parameter = null,
			bool dateTimeAsUtc = false, bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.DeserializeMultiRecords<ExpandoObject, object>(commandText1, parameters, num1 != 0,
				num2 != 0);
		}

		public List<object> DeserializeMultiRecords(string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false, bool storedProcedure = false)
		{
			return DeserializeMultiRecords<ExpandoObject, object>(commandText, parameters, dateTimeAsUtc,
				storedProcedure);
		}

		public List<T> DeserializeMultiRecords<T>(bool dateTimeAsUtc = false) where T : class, new()
		{
			return DeserializeMultiRecords<T, T>(dateTimeAsUtc);
		}

		public List<T> DeserializeMultiRecords<T>(string commandText, Parameter parameter = null,
			bool dateTimeAsUtc = false, bool storedProcedure = false) where T : class, new()
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.DeserializeMultiRecords<T, T>(commandText1, parameters, num1 != 0, num2 != 0);
		}

		public List<T> DeserializeMultiRecords<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false,
			bool storedProcedure = false) where T : class, new()
		{
			return DeserializeMultiRecords<T, T>(commandText, parameters, dateTimeAsUtc, storedProcedure);
		}

		public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false, bool storedProcedure = false) where TObject : class, new()
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			var result = DeserializeMultiRecords<TObject, TReturn>(dateTimeAsUtc);
			if (_command != null && _command.Parameters.Contains(StoredProceduresConstant.TotalCountLastParam) && _command.Parameters[StoredProceduresConstant.TotalCountLastParam].Direction == ParameterDirection.Output
				&& parameters[parameters.Length - 1].Name.Equals(StoredProceduresConstant.TotalCountLastParam, StringComparison.OrdinalIgnoreCase)
				&& parameters[parameters.Length - 1].Direction == ParameterDirection.Output)
			{
				parameters[parameters.Length - 1].Value = _command.Parameters[StoredProceduresConstant.TotalCountLastParam].Value;
			}
			return result;
		}

		public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(bool dateTimeAsUtc = false)
			where TObject : class, new()
		{
			var list = new List<TReturn>();
			using (OpenConnection())
			{
				var sqlDataReader = _command.ExecuteReader();
				while (sqlDataReader.Read())
					list.Add(Deserialize<TObject, TReturn>(sqlDataReader, dateTimeAsUtc));
				sqlDataReader.Close();
			}
			return list;
		}

		public DataTable DeserializeDataTable<T>(List<T> items)
		{
			var dataTable = new DataTable(typeof(T).Name);

			//Get all the properties
			var Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
			foreach (var prop in Props)
				dataTable.Columns.Add(prop.Name);
			foreach (var item in items)
			{
				var values = new object[Props.Length];
				for (var i = 0; i < Props.Length; i++)
					values[i] = Props[i].GetValue(item, null);
				dataTable.Rows.Add(values);
			}
			//put a breakpoint here and check datatable
			return dataTable;
		}

		public DataTable DeserializeDataTable(string commandText, params Parameter[] parameters)
		{
			SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
			return DeserializeDataTable();
		}

		public DataTable DeserializeDataTable()
		{
			var dataTable = new DataTable();
			using (OpenConnection())
			{
				new SqlDataAdapter(_command).Fill(dataTable);
			}
			return dataTable;
		}

		public DataSet DeserializeDataSet(string commandText, params Parameter[] parameters)
		{
			SetupCommand(commandText, parameters, true, commandTimeoutInSecs);
			return DeserializeDataSet();
		}

		public DataSet DeserializeDataSet()
		{
			var dataSet = new DataSet();
			using (OpenConnection())
			{
				new SqlDataAdapter(_command).Fill(dataSet);
			}
			return dataSet;
		}

		[Obsolete]
		public void DeserializeMultiSets(SetCollection sets, string commandText, bool dateTimeAsUtc,
			params Parameter[] parameters)
		{
			SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
			DeserializeMultiSets(sets, dateTimeAsUtc);
		}

		public void DeserializeMultiSets(SetCollection sets, string commandText, Parameter parameter = null,
			bool dateTimeAsUtc = false, bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var sets1 = sets;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			sqlSerializer.DeserializeMultiSets(sets1, commandText1, parameters, num1 != 0, num2 != 0);
		}

		public void DeserializeMultiSets(SetCollection sets, string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false, bool storedProcedure = false)
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			DeserializeMultiSets(sets, dateTimeAsUtc);
		}

		public void DeserializeMultiSets(SetCollection sets, bool dateTimeAsUtc = false)
		{
			if ((sets == null) || (sets.Count == 0))
				throw new ArgumentNullException("sets", "Empty collection of sets");

			var index = 0;
			using (OpenConnection())
			{
				var sqlDataReader = _command.ExecuteReader();
				do
				{
					var setType = sets.GetSetType(index);
					var list = sets[index];
					if (setType == typeof(ExpandoObject))
						while (sqlDataReader.Read())
							list.Add((dynamic)Deserialize<ExpandoObject, object>(sqlDataReader, dateTimeAsUtc));
					else
						while (sqlDataReader.Read())
							list.Add(Deserialize(sqlDataReader, setType, dateTimeAsUtc));
					++index;
				} while ((sets.Count > index) && sqlDataReader.NextResult());
				sqlDataReader.Close();
			}
		}

		private static TReturn Deserialize<TObject, TReturn>(IDataRecord reader, bool dateTimeAsUtc = false)
			where TObject : class, new()
		{
			return (TReturn)Deserialize(reader, typeof(TObject), dateTimeAsUtc);
		}

		private static object Deserialize(IDataRecord reader, Type type, bool dateTimeAsUtc = false)
		{
			if (type == typeof(ExpandoObject))
			{
				var expandoObject = new ExpandoObject();
				IDictionary<string, object> dictionary = expandoObject;
				for (var i = 0; i < reader.FieldCount; ++i)
					dictionary.Add(reader.GetName(i), reader[i]);
				return expandoObject;
			}
			if (reader.GetFieldType(0) == type)
				return reader.GetValue(0);
			var instance = Activator.CreateInstance(type);
			var fieldMappings = GetFieldMappings(type);
			for (var i = 0; i < reader.FieldCount; ++i)
				if (fieldMappings.ContainsKey(reader.GetName(i)))
				{
					var mappingInfo = fieldMappings[reader.GetName(i)];
					var obj = reader[i];
					if ((obj != null) && (obj != DBNull.Value))
					{
						if (obj is DateTime)
							if (dateTimeAsUtc)
								obj = DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
						try
						{
							mappingInfo.SetValue(instance, obj);
						}
						catch (Exception ex)
						{
							throw new ArgumentException(string.Format("Failed to map Type: {0}", type), mappingInfo.Name,
								ex);
						}
					}
				}
			return instance;
		}

		public T ExecuteScalar<T>(string commandText, params Parameter[] parameters)
		{
			SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
			return ExecuteScalar<T>(false);
		}

		public T ExecuteScalar<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.ExecuteScalar<T>(commandText1, parameters, num1 != 0, num2 != 0);
		}

		public T ExecuteScalar<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			return ExecuteScalar<T>(false);
		}

		public T ExecuteScalar<T>(bool dateTimeAsUtc = false)
		{
			object obj;
			using (OpenConnection())
			{
				obj = _command.ExecuteScalar();
			}
			if ((obj == null) || (obj == DBNull.Value))
				return default(T);
			if (obj is DateTime && dateTimeAsUtc)
				obj = DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
			return (T)obj;
		}

		public List<T> ExecuteScalarList<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num1 = dateTimeAsUtc ? 1 : 0;
			var num2 = storedProcedure ? 1 : 0;
			return sqlSerializer.ExecuteScalarList<T>(commandText1, parameters, num1 != 0, num2 != 0);
		}

		public List<T> ExecuteScalarList<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false,
			bool storedProcedure = false)
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			return ExecuteScalarList<T>(dateTimeAsUtc);
		}

		public List<T> ExecuteScalarList<T>(bool dateTimeAsUtc = false)
		{
			var list = new List<T>();
			using (OpenConnection())
			{
				var sqlDataReader = _command.ExecuteReader();
				while ((sqlDataReader.FieldCount > 0) && sqlDataReader.Read())
				{
					var obj = sqlDataReader[0] ?? null;
					if (obj is DateTime && dateTimeAsUtc)
						obj = DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
					list.Add((T)obj);
				}
				sqlDataReader.Close();
			}
			return list;
		}

		public void Execute()
		{
			ExecuteRowCount();
		}

		public void Execute(string commandText, params Parameter[] parameters)
		{
			Execute(commandText, parameters, false);
		}

		public void Execute(string commandText, Parameter parameter, bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1]
				{
					parameter
				};
			var num = storedProcedure ? 1 : 0;
			sqlSerializer.Execute(commandText1, parameters, num != 0);
		}

		public void Execute(string commandText, Parameter[] parameters, bool storedProcedure = false)
		{
			ExecuteRowCount(commandText, parameters, storedProcedure);
		}

		public int ExecuteRowCount(string commandText, Parameter parameter, bool storedProcedure = false)
		{
			var sqlSerializer = this;
			var commandText1 = commandText;
			Parameter[] parameters;
			if (parameter == null)
				parameters = null;
			else
				parameters = new Parameter[1] { parameter };
			var num = storedProcedure ? 1 : 0;
			return sqlSerializer.ExecuteRowCount(commandText1, parameters, num != 0);
		}

		public int ExecuteRowCount(string commandText, Parameter[] parameters, bool storedProcedure = false)
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			return ExecuteRowCount();
		}

		public int ExecuteRowCount()
		{
			using (OpenConnection())
			{
				return _command.ExecuteNonQuery();
			}
		}

		private SqlConnectionContext OpenConnection()
		{
			var connectionContext = new SqlConnectionContext(_connection, _command, _parameters);
			_connection.Open();
			return connectionContext;
		}

		#region ColumnAliasOrValidation settings

		public IList<T> DeserializeMultiRecordsPivot<T>(string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false,
			bool storedProcedure = false) where T : class, new()
		{
			return DeserializeMultiRecordsPivot<T, T>(commandText, parameters, dateTimeAsUtc, storedProcedure);
		}

		public List<TReturn> DeserializeMultiRecordsPivot<TObject, TReturn>(string commandText, Parameter[] parameters,
			bool dateTimeAsUtc = false, bool storedProcedure = false)
			where TObject : class, new()
		{
			SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
			return DeserializeMultiRecordsPivot<TObject, TReturn>(dateTimeAsUtc);
		}

		public List<TReturn> DeserializeMultiRecordsPivot<TObject, TReturn>(bool dateTimeAsUtc = false)
			where TObject : class, new()
		{
			var list = new List<TReturn>();
			using (OpenConnection())
			{
				var sqlDataReader = _command.ExecuteReader();
				while (sqlDataReader.Read())
					DeserializeMultiRecordsPivot<TObject, TReturn>(sqlDataReader, list, dateTimeAsUtc);
				sqlDataReader.Close();
			}
			return list;
		}

		private static void DeserializeMultiRecordsPivot<TObject, TReturn>(IDataRecord reader, List<TReturn> list,
			bool dateTimeAsUtc = false)
			where TObject : class, new()
		{
			DeserializeMultiRecordsPivot(reader, list, typeof(TObject), dateTimeAsUtc);
		}

		private static void DeserializeMultiRecordsPivot<TReturn>(IDataRecord reader, List<TReturn> list, Type type,
			bool dateTimeAsUtc = false)
		{
			var fieldMappings = GetColumnAliasesFieldMappings(type);
			for (var i = 0; i < reader.FieldCount; ++i) // starting from ColumnName
				if (!string.IsNullOrEmpty(reader.GetValue(i).ToString()) &&
					fieldMappings.ContainsKey(reader.GetValue(i).ToString().ToLower()))
				{
					var mappingInfo = fieldMappings[reader.GetValue(i).ToString().ToLower()];
					for (var j = 0; j < reader.FieldCount - i - 1; ++j)
					{
						var obj = reader[j + i + 1];
						try
						{
							if (list.Count < reader.FieldCount - i - 1)
							{
								var instance = Activator.CreateInstance(type);
								list.Add((TReturn)instance);
								var setValue = reader.GetName(i + j + 1);
								// fieldMappings[Entities.SystemMessagesConstant.PivotDataSettingName.ToLower()].SetValue(instance, setValue);
								fieldMappings[mappingInfo.Name.ToLower()].SetValue(instance, setValue);
								mappingInfo.SetValue(instance, obj.ToString());
							}
							else
							{
								mappingInfo.SetValue(list[j], obj.ToString());
							}
						}
						catch (Exception ex)
						{
							throw new ArgumentException(string.Format("Failed to map Type: {0}", type),
								mappingInfo.Name,
								ex);
						}
					}
					break;
				}
		}

		public static Dictionary<string, MappingInfo> GetColumnAliasesFieldMappings(Type type)
		{
			var dictionary = new Dictionary<string, MappingInfo>();
			foreach (var propertyInfo in type.GetProperties())
			{
				var propertyMappingAttribute =
					Attribute.GetCustomAttribute(propertyInfo, typeof(PropertyMappingAttribute)) as
						PropertyMappingAttribute ?? new PropertyMappingAttribute(propertyInfo.Name);
				dictionary.Add(propertyMappingAttribute.Name.ToLower(),
					new PropertyMappingInfo(propertyMappingAttribute, propertyInfo));
			}
			foreach (var fieldInfo in type.GetFields())
			{
				var fieldMappingAttribute =
					Attribute.GetCustomAttribute(fieldInfo, typeof(FieldMappingAttribute)) as FieldMappingAttribute ??
					new FieldMappingAttribute(fieldInfo.Name);
				dictionary.Add(fieldMappingAttribute.Name.ToLower(),
					new FieldMappingInfo(fieldMappingAttribute, fieldInfo));
			}
			return dictionary;
		}

		#endregion ColumnAliasOrValidation settings
	}
}