using Microsoft.CSharp.RuntimeBinder;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace M4PL.DataAccess.Serializer
{
    public class SqlSerializer
    {
        public static string DefaultConnectionStringName = "M4PLConnection";//M4PL ConnectionString
        [ThreadStatic]
        private static SqlSerializer _defaultThreadLocal;
        private readonly SqlConnection _connection;
        private readonly SqlCommand _command;
        private Parameter[] _parameters;
        private static int commandTimeoutInSecs = 90;

        public static SqlSerializer Default
        {
            get
            {
                return SqlSerializer._defaultThreadLocal ?? (SqlSerializer._defaultThreadLocal = new SqlSerializer());
            }
        }

        static SqlSerializer()
        {
        }

        public SqlSerializer()
        {
            if (ConfigurationManager.ConnectionStrings[SqlSerializer.DefaultConnectionStringName] == null)
                throw new InvalidOperationException(string.Format("Invalid default connection string name: {0}", (object)SqlSerializer.DefaultConnectionStringName));
            this._connection = new SqlConnection(ConfigurationManager.ConnectionStrings[SqlSerializer.DefaultConnectionStringName].ConnectionString);
            this._command = this._connection.CreateCommand();
        }

        public SqlSerializer(ConnectionStringSettings connectionStringSetting)
        {
            if (connectionStringSetting == null)
                throw new ArgumentNullException("connectionStringSetting");
            this._connection = new SqlConnection(connectionStringSetting.ConnectionString);
            this._command = this._connection.CreateCommand();
        }

        public SqlSerializer(string connectionString)
        {
            this._connection = new SqlConnection(connectionString);
            this._command = this._connection.CreateCommand();
        }

        public static SqlSerializer ByName(string name)
        {
            ConnectionStringSettings connectionStringSettings = ConfigurationManager.ConnectionStrings[name];
            if (connectionStringSettings == null)
                throw new InvalidOperationException(string.Format("Invalid connection string name: {0}", (object)name));
            else
                return new SqlSerializer(connectionStringSettings.ConnectionString);
        }

        public static Dictionary<string, MappingInfo> GetFieldMappings<T>()
        {
            return SqlSerializer.GetFieldMappings(typeof(T));
        }

        public static Dictionary<string, MappingInfo> GetFieldMappings(Type type)
        {
            Dictionary<string, MappingInfo> dictionary = new Dictionary<string, MappingInfo>();
            foreach (PropertyInfo propertyInfo in type.GetProperties())
            {
                PropertyMappingAttribute propertyMappingAttribute = Attribute.GetCustomAttribute((MemberInfo)propertyInfo, typeof(PropertyMappingAttribute)) as PropertyMappingAttribute ?? new PropertyMappingAttribute(propertyInfo.Name);
                dictionary.Add(propertyMappingAttribute.Name, (MappingInfo)new PropertyMappingInfo(propertyMappingAttribute, propertyInfo));
            }
            foreach (FieldInfo fieldInfo in type.GetFields())
            {
                FieldMappingAttribute fieldMappingAttribute = Attribute.GetCustomAttribute((MemberInfo)fieldInfo, typeof(FieldMappingAttribute)) as FieldMappingAttribute ?? new FieldMappingAttribute(fieldInfo.Name);
                dictionary.Add(fieldMappingAttribute.Name, (MappingInfo)new FieldMappingInfo(fieldMappingAttribute, fieldInfo));
            }
            return dictionary;
        }

        public void AddParameters<T>(T obj, SqlSerializer.ParameterFlags flags = SqlSerializer.ParameterFlags.Default)
        {
            foreach (KeyValuePair<string, MappingInfo> keyValuePair in SqlSerializer.GetFieldMappings<T>())
            {
                MappingInfo mappingInfo = keyValuePair.Value;
                if ((flags & SqlSerializer.ParameterFlags.IdFieldsOnly) == SqlSerializer.ParameterFlags.IdFieldsOnly && mappingInfo.MappingAttribute.IsId && ((flags & SqlSerializer.ParameterFlags.ExcludeIdentityFields) == SqlSerializer.ParameterFlags.ExcludeIdentityFields && !mappingInfo.MappingAttribute.IsIdentity))
                    this._command.Parameters.AddWithValue("@" + mappingInfo.Name, mappingInfo.GetValue((object)obj));
            }
        }

        public void SetupCommand(string commandText, Parameter[] parameters, bool storedProcedure = false, int timeout = 30)
        {
            this._command.CommandText = commandText;
            this._command.CommandType = storedProcedure ? CommandType.StoredProcedure : CommandType.Text;
            this._command.CommandTimeout = timeout;
            this._command.Parameters.Clear();
            this._parameters = parameters;
			if (parameters == null || parameters.Length == 0)
                return;
            foreach (Parameter parameter in parameters)
            {
                SqlParameter sqlParameter = new SqlParameter(parameter.Name, parameter.Value ?? (object)DBNull.Value);
                sqlParameter.Direction = parameter.Direction;
                if (sqlParameter.Direction.HasFlag((Enum)ParameterDirection.Output) && parameter.Type != (Type)null)
                {
                    DbType result;
                    if (!Enum.TryParse<DbType>(parameter.Type.Name, true, out result))
                        result = DbType.Object;
                    sqlParameter.DbType = result;
                }
                if (!string.IsNullOrEmpty(parameter.TableValueParameterType))
                {
                    sqlParameter.SqlDbType = SqlDbType.Structured;
                    sqlParameter.TypeName = parameter.TableValueParameterType;
                }
                this._command.Parameters.Add(sqlParameter);
            }
        }

        [Obsolete]
        public object DeserializeSingleRecord(string commandText, bool dateTimeAsUtc, params Parameter[] parameters)
        {
            return this.DeserializeSingleRecord<ExpandoObject, object>(commandText, parameters, false, false);
        }

        [Obsolete]
        public T DeserializeSingleRecord<T>(string commandText, bool dateTimeAsUtc, params Parameter[] parameters) where T : class, new()
        {
            return this.DeserializeSingleRecord<T, T>(commandText, parameters, false, false);
        }

        [Obsolete]
        public TReturn DeserializeSingleRecord<TObject, TReturn>(string commandText, bool dateTimeAsUtc, params Parameter[] parameters) where TObject : class, new()
        {
            this.SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
            return this.DeserializeSingleRecord<TObject, TReturn>(dateTimeAsUtc);
        }

        public object DeserializeSingleRecord(bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            return this.DeserializeSingleRecord<ExpandoObject, object>(dateTimeAsUtc);
        }

        public object DeserializeSingleRecord(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.DeserializeSingleRecord<ExpandoObject, object>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public object DeserializeSingleRecord(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            return this.DeserializeSingleRecord<ExpandoObject, object>(commandText, parameters, dateTimeAsUtc, storedProcedure);
        }

        public T DeserializeSingleRecord<T>(bool dateTimeAsUtc = false) where T : class, new()
        {
            return this.DeserializeSingleRecord<T, T>(dateTimeAsUtc);
        }

        public T DeserializeSingleRecord<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false) where T : class, new()
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.DeserializeSingleRecord<T, T>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public T DeserializeSingleRecord<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false) where T : class, new()
        {
            return this.DeserializeSingleRecord<T, T>(commandText, parameters, dateTimeAsUtc, storedProcedure);
        }

        public TReturn DeserializeSingleRecord<TObject, TReturn>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false) where TObject : class, new()
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            return this.DeserializeSingleRecord<TObject, TReturn>(dateTimeAsUtc);
        }

        public TReturn DeserializeSingleRecord<TObject, TReturn>(bool dateTimeAsUtc = false) where TObject : class, new()
        {
            TReturn @return = default(TReturn);
            using (this.OpenConnection())
            {
                SqlDataReader sqlDataReader = this._command.ExecuteReader(CommandBehavior.SingleRow);
                if (sqlDataReader.Read())
                    @return = SqlSerializer.Deserialize<TObject, TReturn>((IDataRecord)sqlDataReader, false);
                sqlDataReader.Close();
            }
            return @return;
        }

        [Obsolete]
        public List<object> DeserializeMultiRecords(string commandText, bool dateTimeAsUtc, params Parameter[] parameters)
        {
            return this.DeserializeMultiRecords<ExpandoObject, object>(commandText, dateTimeAsUtc, parameters);
        }

        [Obsolete]
        public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(string commandText, bool dateTimeAsUtc, params Parameter[] parameters) where TObject : class, new()
        {
            this.SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
            return this.DeserializeMultiRecords<TObject, TReturn>(false);
        }

        public object DeserializeMultiRecords(bool dateTimeAsUtc = false)
        {
            return (object)this.DeserializeMultiRecords<ExpandoObject, object>(dateTimeAsUtc);
        }

        public List<object> DeserializeMultiRecords(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.DeserializeMultiRecords<ExpandoObject, object>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public List<object> DeserializeMultiRecords(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            return this.DeserializeMultiRecords<ExpandoObject, object>(commandText, parameters, dateTimeAsUtc, storedProcedure);
        }

        public List<T> DeserializeMultiRecords<T>(bool dateTimeAsUtc = false) where T : class, new()
        {
            return this.DeserializeMultiRecords<T, T>(dateTimeAsUtc);
        }

        public List<T> DeserializeMultiRecords<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false) where T : class, new()
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.DeserializeMultiRecords<T, T>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public List<T> DeserializeMultiRecords<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false) where T : class, new()
        {
            return this.DeserializeMultiRecords<T, T>(commandText, parameters, dateTimeAsUtc, storedProcedure);
        }

        public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false) where TObject : class, new()
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            return this.DeserializeMultiRecords<TObject, TReturn>(dateTimeAsUtc);
        }

        public List<TReturn> DeserializeMultiRecords<TObject, TReturn>(bool dateTimeAsUtc = false) where TObject : class, new()
        {
            List<TReturn> list = new List<TReturn>();
            using (this.OpenConnection())
            {
                SqlDataReader sqlDataReader = this._command.ExecuteReader();
                while (sqlDataReader.Read())
                    list.Add(SqlSerializer.Deserialize<TObject, TReturn>((IDataRecord)sqlDataReader, dateTimeAsUtc));
                sqlDataReader.Close();
            }
            return list;
        }

        public DataTable DeserializeDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        public DataTable DeserializeDataTable(string commandText, params Parameter[] parameters)
        {
            this.SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
            return this.DeserializeDataTable();
        }

        public DataTable DeserializeDataTable()
        {
            DataTable dataTable = new DataTable();
            using (this.OpenConnection())
                new SqlDataAdapter(this._command).Fill(dataTable);
            return dataTable;
        }

        public DataSet DeserializeDataSet(string commandText, params Parameter[] parameters)
        {
            this.SetupCommand(commandText, parameters, true, commandTimeoutInSecs);
            return this.DeserializeDataSet();
        }

        public DataSet DeserializeDataSet()
        {
            DataSet dataSet = new DataSet();
            using (this.OpenConnection())
                new SqlDataAdapter(this._command).Fill(dataSet);
            return dataSet;
        }

        [Obsolete]
        public void DeserializeMultiSets(SetCollection sets, string commandText, bool dateTimeAsUtc, params Parameter[] parameters)
        {
            this.SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
            this.DeserializeMultiSets(sets, dateTimeAsUtc);
        }

        public void DeserializeMultiSets(SetCollection sets, string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            SetCollection sets1 = sets;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            sqlSerializer.DeserializeMultiSets(sets1, commandText1, parameters, num1 != 0, num2 != 0);
        }

        public void DeserializeMultiSets(SetCollection sets, string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            this.DeserializeMultiSets(sets, dateTimeAsUtc);
        }

        public void DeserializeMultiSets(SetCollection sets, bool dateTimeAsUtc = false)
        {
            if (sets == null || sets.Count == 0)
                throw new ArgumentNullException("sets", "Empty collection of sets");

            int index = 0;
            using (this.OpenConnection())
            {
                SqlDataReader sqlDataReader = this._command.ExecuteReader();
                do
                {
                    Type setType = sets.GetSetType(index);
                    IList list = sets[index];
                    if (setType == typeof(ExpandoObject))
                    {
                        while (sqlDataReader.Read())
                        {

                            list.Add((dynamic)Deserialize<ExpandoObject, object>(sqlDataReader, dateTimeAsUtc));

                        }
                    }
                    else
                    {
                        while (sqlDataReader.Read())
                            list.Add(Deserialize((IDataRecord)sqlDataReader, setType, dateTimeAsUtc));
                    }
                    ++index;
                }
                while (sets.Count > index && sqlDataReader.NextResult());
                sqlDataReader.Close();
            }
        }

        private static TReturn Deserialize<TObject, TReturn>(IDataRecord reader, bool dateTimeAsUtc = false) where TObject : class, new()
        {
            return (TReturn)SqlSerializer.Deserialize(reader, typeof(TObject), dateTimeAsUtc);
        }

        private static object Deserialize(IDataRecord reader, Type type, bool dateTimeAsUtc = false)
        {
            if (type == typeof(ExpandoObject))
            {
                ExpandoObject expandoObject = new ExpandoObject();
                IDictionary<string, object> dictionary = (IDictionary<string, object>)expandoObject;
                for (int i = 0; i < reader.FieldCount; ++i)
                    dictionary.Add(reader.GetName(i), reader[i]);
                return (object)expandoObject;
            }
            else
            {
                if (reader.GetFieldType(0) == type)
                    return reader.GetValue(0);
                object instance = Activator.CreateInstance(type);
                Dictionary<string, MappingInfo> fieldMappings = SqlSerializer.GetFieldMappings(type);
                for (int i = 0; i < reader.FieldCount; ++i)
                {
                    if (fieldMappings.ContainsKey(reader.GetName(i)))
                    {
                        MappingInfo mappingInfo = fieldMappings[reader.GetName(i)];
                        object obj = reader[i];
                        if (obj != null && obj != DBNull.Value)
                        {
                            if (obj is DateTime)
                            {
                                if (dateTimeAsUtc)
                                    obj = (object)DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
                            }
                            try
                            {
                                mappingInfo.SetValue(instance, obj);
                            }
                            catch (Exception ex)
                            {
                                throw new ArgumentException(string.Format("Failed to map Type: {0}", (object)type), mappingInfo.Name, ex);
                            }
                        }
                    }
                }
                return instance;
            }
        }

        public T ExecuteScalar<T>(string commandText, params Parameter[] parameters)
        {
            this.SetupCommand(commandText, parameters, false, commandTimeoutInSecs);
            return this.ExecuteScalar<T>(false);
        }

        public T ExecuteScalar<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.ExecuteScalar<T>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public T ExecuteScalar<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            return this.ExecuteScalar<T>(false);
        }

        public T ExecuteScalar<T>(bool dateTimeAsUtc = false)
        {
            object obj;
            using (this.OpenConnection())
                obj = this._command.ExecuteScalar();
            if (obj == null || obj == DBNull.Value)
                return default(T);
            if (obj is DateTime && dateTimeAsUtc)
                obj = (object)DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
            return (T)obj;
        }

        public List<T> ExecuteScalarList<T>(string commandText, Parameter parameter = null, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num1 = dateTimeAsUtc ? 1 : 0;
            int num2 = storedProcedure ? 1 : 0;
            return sqlSerializer.ExecuteScalarList<T>(commandText1, parameters, num1 != 0, num2 != 0);
        }

        public List<T> ExecuteScalarList<T>(string commandText, Parameter[] parameters, bool dateTimeAsUtc = false, bool storedProcedure = false)
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            return this.ExecuteScalarList<T>(dateTimeAsUtc);
        }

        public List<T> ExecuteScalarList<T>(bool dateTimeAsUtc = false)
        {
            List<T> list = new List<T>();
            using (this.OpenConnection())
            {
                SqlDataReader sqlDataReader = this._command.ExecuteReader();
                while (sqlDataReader.FieldCount > 0 && sqlDataReader.Read())
                {
                    object obj = sqlDataReader[0];
                    if (obj is DateTime && dateTimeAsUtc)
                        obj = (object)DateTime.SpecifyKind((DateTime)obj, DateTimeKind.Utc);
                    list.Add((T)obj);
                }
                sqlDataReader.Close();
            }
            return list;
        }

        public void Execute()
        {
            this.ExecuteRowCount();
        }

        public void Execute(string commandText, params Parameter[] parameters)
        {
            this.Execute(commandText, parameters, false);
        }

        public void Execute(string commandText, Parameter parameter, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1]
        {
          parameter
        };
            int num = storedProcedure ? 1 : 0;
            sqlSerializer.Execute(commandText1, parameters, num != 0);
        }

        public void Execute(string commandText, Parameter[] parameters, bool storedProcedure = false)
        {
            this.ExecuteRowCount(commandText, parameters, storedProcedure);
        }

        public int ExecuteRowCount(string commandText, Parameter parameter, bool storedProcedure = false)
        {
            SqlSerializer sqlSerializer = this;
            string commandText1 = commandText;
            Parameter[] parameters;
            if (parameter == null)
                parameters = (Parameter[])null;
            else
                parameters = new Parameter[1] { parameter };
            int num = storedProcedure ? 1 : 0;
            return sqlSerializer.ExecuteRowCount(commandText1, parameters, num != 0);
        }

        public int ExecuteRowCount(string commandText, Parameter[] parameters, bool storedProcedure = false)
        {
            this.SetupCommand(commandText, parameters, storedProcedure, commandTimeoutInSecs);
            return this.ExecuteRowCount();
        }

        public int ExecuteRowCount()
        {
            using (this.OpenConnection())
                return this._command.ExecuteNonQuery();
        }

        private SqlConnectionContext OpenConnection()
        {
            SqlConnectionContext connectionContext = new SqlConnectionContext(this._connection, this._command, this._parameters);
            this._connection.Open();
            return connectionContext;
        }

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
            ExcludeIdentityFields = 2,
        }
    }
}
