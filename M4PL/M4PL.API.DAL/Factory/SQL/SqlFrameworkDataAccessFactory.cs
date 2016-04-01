//------------------------------------------------------------------------------ 
// <copyright file="SqlFrameworkDataAccessFactory.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

using M4PL.DataAccess.Factory.Accessors;
using M4PL.DataAccess.Factory.Common;

namespace M4PL.DataAccess.Factory
{
    /// <summary>
    ///		This class implements framework data accessor methods for MS SQL Server database.
    ///		It creates database connections and various accessor classes
    /// </summary>
    public class SqlFrameworkDataAccessFactory : IFrameworkDataAccessFactory
    {
        #region Member varibles

        /// <summary>
        ///     variable for connection string
        /// </summary>
        private string connectionURL = null;

        #endregion

        #region Common

        /// <summary>
        ///		Construct a sql framework data access factory object and initialize connection string 
        /// </summary>
        /// <param name="connectionString">
        ///		Connection string for create database connection
        /// </param>
        public SqlFrameworkDataAccessFactory(string connectionString)
        {
            this.connectionURL = connectionString;
        }

        /// <summary>
        ///		Construct a sql framework data access factory object and initialize connection string 
        /// </summary>		
        public SqlFrameworkDataAccessFactory()
        {
            this.connectionURL = DataSource.Instance.GetConnectionString();
            Debug.Assert(this.connectionURL != null, "Checks whether connection string is null or not");
        }

        /// <summary>
        ///		Create new database connection
        /// </summary>
        /// <returns>
        ///     Idbconnection object
        /// </returns>
        public IDbConnection CreateConnection()
        {
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = this.connectionURL;
            return sqlConnection;
        }

        /// <summary>
        ///     Create connection with database using given connection string
        /// </summary>
        /// <param name="connectionString">
        ///     Connection string for connection object
        /// </param>
        /// <returns>
        ///     Object of Connection class
        /// </returns>
        public IDbConnection CreateConnection(string connectionString)
        {
            SqlConnection connection = new SqlConnection(connectionString);
            return connection;
        }

        /// <summary>
        ///     Abstract method to create data accessor.
        /// </summary>
        /// <param name="connection">
        ///     Connection object which implements System.Data.IDbCOnnection Interface.
        /// </param>
        /// <returns>
        ///     Returns data accessor instance which implements IDataAccessor instance.
        /// </returns>
        public IDataAccessor CreateAccessor(IDbConnection connection)
        {
            return new SqlDataAccessor(connection, null);
            //return null;
        }

        /// <summary>
        ///		Create new general data accessor
        /// </summary>
        /// <param name="conn">
        ///		Connection object
        /// </param>
        /// <param name="t">
        ///		type of model object
        /// </param>
        /// <returns>
        ///		IData accessors object
        /// </returns>
        public IDataAccessor CreateAccessor(IDbConnection conn, Type t)
        {
            return this.CreateAccessor(conn, t, null);
        }

        /// <summary>
        ///		Create new general data accessor
        /// </summary>
        /// <param name="conn">
        ///		Connection object
        /// </param>
        /// <param name="t">
        ///		Type of IModel object.
        /// </param>
        /// <param name="trans">
        ///		Transaction object
        /// </param>
        /// <returns>
        ///		IData accessors object
        /// </returns>
        public IDataAccessor CreateAccessor(IDbConnection conn, Type t, IDbTransaction trans)
        {
            IDataAccessor accessor = new SqlDataAccessor(conn, t, trans);
            return accessor;
            //return null;
        }

        #endregion

        #region Custom Accessor

        /// <summary>
        ///     Create accessors for custom activities, It is a genetic method.
        /// </summary>
        /// <typeparam name="T">
        ///     Type of custom accessor, type should implement ICustom accessor interface.
        /// </typeparam>
        /// <param name="connection">
        ///     Connection object for database operations
        /// </param>
        /// <returns>
        ///     Accessor specified in generic type
        /// </returns>
        public virtual T CreateCustomAccessor<T>(IDbConnection connection) where T : ICustomAccessor
        {
            throw new NotSupportedException("This method should implement in child class");
        }

        /// <summary>
        ///     Create accessors for custom activities, It is a genetic method.
        /// </summary>
        /// <typeparam name="T">
        ///     Type of custom accessor, type should implement ICustom accessor interface.
        /// </typeparam>
        /// <param name="transaction">
        ///     transaction object for database operations
        /// </param>
        /// <returns>
        ///     Accessor specified in generic type
        /// </returns>
        public virtual T CreateCustomAccessor<T>(IDbTransaction transaction) where T : ICustomAccessor
        {
            throw new NotSupportedException("This method should implement in child class");
        }

        #endregion
    }
}