//------------------------------------------------------------------------------ 
// <copyright file="SqlFrameworkCommandBuilder.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using M4PL.DataAccess.Models;
using M4PL.DataAccess.Models.Mapping;
using Microsoft.SqlServer.Server;

namespace M4PL.DataAccess.Factory.Accessors
{
    /// <summary>
    ///		This class is used to build sql queries and SQL command objecPropanator.
    /// </summary>
    public class SqlFrameworkCommandBuilder
    {
        #region Member variables

        /// <summary>
        ///     Hash table for column mapping
        /// </summary>
        private static Hashtable sqlMap = new Hashtable();

        /// <summary>
        ///     Delete query
        /// </summary>
        private string deleteSql = null;

        /// <summary>
        ///     Insert query
        /// </summary>
        private string insertSql = null;

        /// <summary>
        ///     Select query
        /// </summary>
        private string selectSql = null;

        /// <summary>
        ///     Select query with lock
        /// </summary>
        private string selectWithLockSql = null;

        /// <summary>
        ///     update query
        /// </summary>
        private string updateSql = null;

        /// <summary>
        ///     Model parameter mapping
        /// </summary>
        private ModelDataMap map = null;

        /// <summary>
        ///     Type of imodel object
        /// </summary>
        private Type type = null;

        #endregion

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
            this.map = modelDataMap;
            this.type = modelType;
        }

        #endregion

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
            SqlFrameworkCommandBuilder b = (SqlFrameworkCommandBuilder)sqlMap[modelType];
            if (b == null)
            {
                b = new SqlFrameworkCommandBuilder(modelDataMap, modelType);
                sqlMap[modelType] = b;
            }

            return b;
        }

        #endregion

        #region Command

        /// <summary>
        ///		Retrieves data using stored procedure specified in the model
        /// </summary>
        /// <param name="key">
        ///		Primary key value
        /// </param>
        /// <returns>
        ///		SQL command object
        /// </returns>
        public SqlCommand GetSelectCommand(object key)
        {
            SqlCommand command = new SqlCommand();

            string commandText = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.SELECT]).ProcedureName;

            command.CommandText = commandText;
            command.CommandType = CommandType.StoredProcedure;

            SqlParameter p = new SqlParameter();
            p.ParameterName = string.Concat("@", this.map.KeyColumn);
            p.Value = key;
            command.Parameters.Add(p);

            return command;
        }

        /// <summary>
        ///		Retrieves data using stored procedure specified in the model
        /// </summary>
        /// <param name="model">
        ///		Model object with input parameter values.
        /// </param>
        /// <returns>
        ///		SQL command object
        /// </returns>
        public SqlCommand GetSelectMultipleCommand(IModel model)
        {
            SqlCommand command = new SqlCommand();
            SortedList parameterSortedList = new SortedList();

            string commandText = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.SELECT_MULTIPLE]).ProcedureName;
            command.CommandText = commandText;
            command.CommandType = CommandType.StoredProcedure;

            foreach (ArrayList al in this.map.Parameters.Values)
            {
                ModelParameterMap[] parameters = (ModelParameterMap[])al.ToArray(
                typeof(ModelParameterMap));
                if (parameters != null && parameters.Length > 0)
                {
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        ModelParameterMap mp = (ModelParameterMap)parameters[i];
                        if (mp.ParameterAction == DBProcedureType.SELECT_MULTIPLE)
                        {
                            SqlParameter p = new SqlParameter();

                            string parameterName = string.Concat("@", mp.ParameterName);
                            p.ParameterName = parameterName;
                            p.DbType = mp.DatabaseType;
                            p.SourceColumn = parameterName;

                            object parameterValue = mp.Property.GetValue(model, null);
                            if (parameterValue == null)
                            {
                                p.Value = DBNull.Value;
                            }
                            else
                            {
                                p.Value = parameterValue;
                            }

                            int index;
                            if (mp.ParameterIndex == 0)
                            {
                                index = parameterSortedList.Count + 1;
                            }
                            else
                            {
                                index = mp.ParameterIndex;
                            }

                            parameterSortedList.Add(index, p);
                        }
                    }
                }
            }

            if (parameterSortedList.Count > 0)
            {
                foreach (DictionaryEntry parameter in parameterSortedList)
                {
                    int index = (int)parameter.Key;
                    SqlParameter currentParam = (SqlParameter)parameter.Value;

                    command.Parameters.Add(currentParam);
                }
            }

            return command;
        }

        /// <summary>
        ///		Retrieves data using stored procedure specified in the model
        /// </summary>
        /// <param name="model">
        ///		Model object with input parameter values.
        /// </param>
        /// <returns>
        ///		SQL command object
        /// </returns>
        public SqlCommand GetSelectCommand(IModel model)
        {
            SqlCommand command = new SqlCommand();
            SortedList parameterSortedList = new SortedList();

            string commandText = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.SELECT]).ProcedureName;
            command.CommandText = commandText;
            command.CommandType = CommandType.StoredProcedure;

            foreach (ArrayList al in this.map.Parameters.Values)
            {
                ModelParameterMap[] parameters = (ModelParameterMap[])al.ToArray(
                typeof(ModelParameterMap));
                if (parameters != null && parameters.Length > 0)
                {
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        ModelParameterMap mp = (ModelParameterMap)parameters[i];
                        if (mp.ParameterAction == DBProcedureType.SELECT)
                        {
                            SqlParameter p = new SqlParameter();

                            string parameterName = string.Concat("@", mp.ParameterName);
                            p.ParameterName = parameterName;
                            p.DbType = mp.DatabaseType;
                            p.SourceColumn = parameterName;

                            object parameterValue = mp.Property.GetValue(model, null);
                            if (parameterValue == null)
                            {
                                p.Value = DBNull.Value;
                            }
                            else
                            {
                                p.Value = parameterValue;
                            }

                            int index;
                            if (mp.ParameterIndex == 0)
                            {
                                index = parameterSortedList.Count + 1;
                            }
                            else
                            {
                                index = mp.ParameterIndex;
                            }

                            parameterSortedList.Add(index, p);
                        }
                    }
                }
            }

            if (parameterSortedList.Count > 0)
            {
                foreach (DictionaryEntry parameter in parameterSortedList)
                {
                    int index = (int)parameter.Key;
                    SqlParameter currentParam = (SqlParameter)parameter.Value;

                    command.Parameters.Add(currentParam);
                }
            }

            return command;
        }

        /// <summary>
        ///		Creates SQL command object with parameters for insert operation
        /// </summary>
        /// <param name="model">
        ///		Imodel object
        /// </param>
        /// <returns>
        ///		An SqlCommand object with command text and all parameters.
        /// </returns>
        public SqlCommand GetInsertCommand(IModel model)
        {
            SqlCommand asaCommand = new SqlCommand();
            SortedList parameterSortedList = new SortedList();

            string insertProcedureName = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.INSERT]).ProcedureName;

            if (insertProcedureName != null)
            {
                asaCommand.CommandText = insertProcedureName;
                asaCommand.CommandType = CommandType.StoredProcedure;
                foreach (ArrayList al in this.map.Parameters.Values)
                {
                    ModelParameterMap[] parameters = (ModelParameterMap[])al.ToArray(
                    typeof(ModelParameterMap));
                    if (parameters != null && parameters.Length > 0)
                    {
                        for (int i = 0; i < parameters.Length; i++)
                        {
                            ModelParameterMap mp = (ModelParameterMap)parameters[i];
                            if (mp.ParameterAction == DBProcedureType.INSERT)
                            {
                                SqlParameter p = new SqlParameter();

                                string parameterName = string.Concat("@", mp.ParameterName);
                                p.ParameterName = parameterName;
                                p.DbType = mp.DatabaseType;
                                p.SourceColumn = parameterName;

                                object parameterValue = mp.Property.GetValue(model, null);
                                if (parameterValue == null)
                                {
                                    p.Value = DBNull.Value;
                                }
                                else
                                {
                                    p.Value = parameterValue;
                                }

                                int index;
                                if (mp.ParameterIndex == 0)
                                {
                                    index = parameterSortedList.Count + 1;
                                }
                                else
                                {
                                    index = mp.ParameterIndex;
                                }

                                parameterSortedList.Add(index, p);
                            }
                        }
                    }
                }
            }

            if (parameterSortedList.Count > 0)
            {
                foreach (DictionaryEntry parameter in parameterSortedList)
                {
                    int index = (int)parameter.Key;
                    SqlParameter currentParam = (SqlParameter)parameter.Value;

                    asaCommand.Parameters.Add(currentParam);
                }
            }

            return asaCommand;
        }

        /// <summary>
        ///		Creates SQL command object with parameters for insert operation
        /// </summary>       
        /// <typeparam name="T">
        ///     Any type which implements Framework.Common.Models.IModel interface.
        /// </typeparam>
        /// <param name="modelCollection">
        ///     A collection of model items to be bulk inserted.
        /// </param>
        /// <returns>
        ///		An SqlCommand object with command text and all parameters.
        /// </returns>
        public SqlCommand GetInsertTableValuedCommand<T>(List<T> modelCollection) where T : IModel
        {
            SqlCommand asaCommand = new SqlCommand();
            SortedList parameterSortedList = new SortedList();
            string s = map.TableName.ToString();


            StoredProcedureMappingAttribute procedureMap = (StoredProcedureMappingAttribute)
                this.map.Procedures[DBProcedureType.INSERT_MULTIPLE];

            string insertProcedureName = procedureMap.ProcedureName;

            if (insertProcedureName != null)
            {
                asaCommand.CommandText = insertProcedureName;
                asaCommand.CommandType = CommandType.StoredProcedure;

                List<SqlDataRecord> dataRecords = this.CreateSqlDataRecordCollection<T>(modelCollection);
                string tableValuedType = procedureMap.TableValuedParameterType;
                string tableValuedParameterName = procedureMap.TableValuedParameterName;

                SqlParameter parameter = asaCommand.Parameters.AddWithValue(
                        tableValuedParameterName, dataRecords);

                parameter.SqlDbType = SqlDbType.Structured;
                parameter.TypeName = tableValuedType;
            }

            return asaCommand;
        }

        /// <summary>
        ///		Create sql data record collection for bulk insert. 
        ///		It creates meta data from insert procedure mapping  customattribute
        /// </summary> 
        /// <typeparam name="T">
        ///     Any type which implements Framework.Common.Models.IModel interface.
        /// </typeparam>
        /// <param name="modelCollection">
        ///     A collection of model items to be bulk inserted.
        /// </param>
        /// <returns>
        ///		A collection of SqlDataRecord object for bulk insert.
        /// </returns>
        public List<SqlDataRecord> CreateSqlDataRecordCollection<T>(List<T> modelCollection) where T : IModel
        {
            List<SqlDataRecord> recordCollection = null;
            ModelParameterMap[] modelInsertParameters = new ModelParameterMap[this.map.Parameters.Count];
            SqlMetaData[] metaDataCollection = new SqlMetaData[this.map.Parameters.Count];

            foreach (ArrayList parameterMap in this.map.Parameters.Values)
            {
                ModelParameterMap[] parameters = (ModelParameterMap[])parameterMap.ToArray(typeof(ModelParameterMap));
                if (parameters != null && parameters.Length > 0)
                {
                    for (int i = 0; i < parameters.Length; i++)
                    {
                        ModelParameterMap mp = parameters[i];
                        if (mp.ParameterAction == DBProcedureType.INSERT)
                        {
                            // create meta data for insert parameter.
                            SqlMetaData metaData = this.CreateSQLMetaData(mp.ParameterName, mp.DatabaseType);
                            metaDataCollection[mp.ParameterIndex - 1] = metaData;
                            modelInsertParameters[mp.ParameterIndex - 1] = mp;
                        }
                    }
                }
            }

            List<SqlMetaData> metaDataList = new List<SqlMetaData>();

            for (int counter = 0; counter < metaDataCollection.Length; counter++)
            {
                if (metaDataCollection[counter] != null)
                {
                    metaDataList.Add(metaDataCollection[counter]);
                }
            }

            // create one sql data record object for each model in the collection
            // and add that object to list
            recordCollection = new List<SqlDataRecord>();
            foreach (IModel model in modelCollection)
            {
                SqlDataRecord dataRecord = new SqlDataRecord(metaDataList.ToArray());

                // assign value for each property in the data record.
                for (int index = 0; index < modelInsertParameters.Length; index++)
                {
                    if (modelInsertParameters[index] != null)
                    {
                        ModelParameterMap mp = modelInsertParameters[index];

                        // this.SetDataRecordValue(dataRecord, mp.DatabaseType, mp.Property.GetValue(model, null), index);
                        dataRecord.SetValue(index, mp.Property.GetValue(model, null));
                    }
                }

                recordCollection.Add(dataRecord);
            }

            return recordCollection;
        }

        /// <summary>
        ///		Creates SQL command object with parameters for update operation
        /// </summary>
        /// <param name="model">
        ///		Imodel object
        /// </param>
        /// <returns>
        ///		An SqlCommand object with command text and all parameters.
        /// </returns>
        public SqlCommand GetUpdateCommand(IModel model)
        {
            SqlCommand asaCommand = new SqlCommand();
            SortedList parameterSortedList = new SortedList();

            string updateProcedureName = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.UPDATE]).ProcedureName;

            if (updateProcedureName != null)
            {
                asaCommand.CommandText = updateProcedureName;
                asaCommand.CommandType = CommandType.StoredProcedure;

                foreach (ArrayList al in this.map.Parameters.Values)
                {
                    ModelParameterMap[] parameters = (ModelParameterMap[])al.ToArray(
                    typeof(ModelParameterMap));
                    if (parameters != null && parameters.Length > 0)
                    {
                        for (int i = 0; i < parameters.Length; i++)
                        {
                            ModelParameterMap mp = (ModelParameterMap)parameters[i];
                            if (mp.ParameterAction == DBProcedureType.UPDATE)
                            {
                                SqlParameter p = new SqlParameter();

                                string parameterName = string.Concat("@", mp.ParameterName);
                                p.ParameterName = parameterName;
                                p.DbType = mp.DatabaseType;
                                p.SourceColumn = parameterName;

                                object parameterValue = mp.Property.GetValue(model, null);
                                if (parameterValue == null)
                                {
                                    p.Value = DBNull.Value;
                                }
                                else
                                {
                                    p.Value = parameterValue;
                                }

                                int index;
                                if (mp.ParameterIndex == 0)
                                {
                                    index = parameterSortedList.Count + 1;
                                }
                                else
                                {
                                    index = mp.ParameterIndex;
                                }

                                parameterSortedList.Add(index, p);
                            }
                        }
                    }
                }
            }

            if (parameterSortedList.Count > 0)
            {
                foreach (DictionaryEntry parameter in parameterSortedList)
                {
                    int index = (int)parameter.Key;
                    SqlParameter currentParam = (SqlParameter)parameter.Value;

                    asaCommand.Parameters.Add(currentParam);
                }
            }

            return asaCommand;
        }

        /// <summary>
        ///		Creates SQL command for delete
        /// </summary>
        /// <param name="keyValue">
        ///		Primary key value
        /// </param>
        /// <returns>
        ///		An SqlCommand object with delete text 
        /// </returns>
        public SqlCommand GetDeleteCommand(object keyValue)
        {
            SqlCommand asaCommand = new SqlCommand();

            // retrieves delete stored procedure name from model map.
            string deleteProcedureName = ((StoredProcedureMappingAttribute)this.map.Procedures[DBProcedureType.DELETE]).ProcedureName;

            asaCommand.CommandText = deleteProcedureName;
            asaCommand.CommandType = CommandType.StoredProcedure;

            SqlParameter p = new SqlParameter();
            p.ParameterName = string.Concat("@", this.map.KeyColumn);
            p.Value = keyValue;
            asaCommand.Parameters.Add(p);

            return asaCommand;
        }

        #endregion

        #region SQL

        /// <summary>
        ///     Create delete sql
        /// </summary>
        /// <returns>
        ///     Delete SQL statement
        /// </returns>
        public string GetDeleteSql()
        {
            if (this.deleteSql == null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("Delete from ");
                sb.Append(this.map.TableName);
                sb.Append(" WHERE ");
                sb.Append(this.map.KeyColumn);
                sb.Append(" = @key");
                this.deleteSql = sb.ToString();
            }

            return this.deleteSql;
        }

        /// <summary>
        ///     Create delete statement without where clause
        /// </summary>
        /// <returns>
        ///     Delete sql statement.
        /// </returns>
        public string GetDeleteSqlWithoutWhere()
        {
            if (this.deleteSql == null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("Delete from [");
                sb.Append(this.map.TableName);
                sb.Append("]");
                this.deleteSql = sb.ToString();
            }

            return this.deleteSql;
        }

        /// <summary>
        ///     Create select sql statement
        /// </summary>
        /// <returns>
        ///     Select sql statement
        /// </returns>
        public string GetSelectSql()
        {
            if (this.selectSql == null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("select ");
                sb = this.GenerateColumnList(this.map, sb, true);
                sb.Append(" from [");
                sb.Append(this.map.ViewName);
                sb.Append("] where ");
                sb.Append(this.map.KeyColumn);
                sb.Append(" = @key ");

                this.selectSql = sb.ToString();
            }

            return this.selectSql;
        }

        /// <summary>
        ///     Create select sql statement with row lock and hold lock
        /// </summary>
        /// <returns>
        ///     Select sql statement
        /// </returns>
        public string GetSelectWithLockSql()
        {
            if (this.selectWithLockSql == null)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("select ");
                sb = this.GenerateColumnList(this.map, sb, true);
                sb.Append(" from [");
                sb.Append(this.map.ViewName);
                sb.Append("] WITH(HOLDLOCK,ROWLOCK)");
                sb.Append(" where ");
                sb.Append(this.map.KeyColumn);
                sb.Append(" = @key");

                this.selectWithLockSql = sb.ToString();
            }

            return this.selectWithLockSql;
        }

        /// <summary>
        ///     Create insert sql statement
        /// </summary>
        /// <returns>
        ///     Insert sql statement
        /// </returns>
        public string GetInsertSql()
        {
            if (this.insertSql == null)
            {
                StringBuilder sb = new StringBuilder();

                // sb.Append("Insert into [");
                sb.Append("Insert into ");
                sb.Append(this.map.TableName);

                // sb.Append("] ( ");
                sb.Append(" ( ");
                sb = this.GenerateColumnList(this.map, sb, false);
                sb.Append(") Values (");

                // SqlCommand cmd = (SqlCommand)connection.CreateCommand();
                foreach (ModelColumnMap col in this.map.Columns.Values)
                {
                    if (!col.IsViewOnly)
                    {
                        sb.Append("@");
                        sb.Append(col.ColumnName);
                        sb.Append(", ");
                    }
                }

                sb.Append(");");
                sb = this.StripCommaFromSQL(sb);
                sb.Append(" Select SCOPE_IDENTITY(); ");

                this.insertSql = sb.ToString();
            }

            return this.insertSql;
        }

        /// <summary>
        ///     Create update sql statement
        /// </summary>
        /// <returns>
        ///     update sql statement
        /// </returns>
        public string GetUpdateSql()
        {
            if (this.updateSql == null)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("update ");
                sb.Append(this.map.TableName);
                sb.Append(" set ");

                foreach (ModelColumnMap col in this.map.Columns.Values)
                {
                    if (!col.IsViewOnly)
                    {
                        sb.Append(col.ColumnName);
                        sb.Append(" = @");
                        sb.Append(col.ColumnName);
                        sb.Append(", ");
                    }
                }

                sb.Append(" where ");
                sb.Append(this.map.KeyColumn);
                sb.Append(" = @key");
                sb = this.StripCommaFromSQL(sb);
                this.updateSql = sb.ToString();
            }

            return this.updateSql;
        }

        #endregion

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
            string strSQL = sb.ToString();
            int index = strSQL.LastIndexOf(",");
            if (index >= 0)
            {
                strSQL = strSQL.Remove(index, 1);
            }

            StringBuilder sqlStatement = new StringBuilder(strSQL);
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

        #endregion
    }
}
