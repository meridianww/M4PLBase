#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Factory.Common;
using M4PL.DataAccess.SQLSerializer.Factory.Interfaces;
using M4PL.DataAccess.SQLSerializer.Factory.SQL.Accessors;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace M4PL.DataAccess.SQLSerializer.Factory.SQL
{
	/// <summary>
	///     This class implements framework data accessor methods for MS SQL Server database.
	///     It creates database connections and various accessor classes
	/// </summary>
	public class SqlFrameworkDataAccessFactory : IFrameworkDataAccessFactory
	{
		#region Member varibles

		/// <summary>
		///     variable for connection string
		/// </summary>
		private readonly string connectionURL;

		#endregion Member varibles

		#region Common

		/// <summary>
		///     Construct a sql framework data access factory object and initialize connection string
		/// </summary>
		/// <param name="connectionString">
		///     Connection string for create database connection
		/// </param>
		public SqlFrameworkDataAccessFactory(string connectionString)
		{
			connectionURL = connectionString;
		}

		/// <summary>
		///     Construct a sql framework data access factory object and initialize connection string
		/// </summary>
		public SqlFrameworkDataAccessFactory()
		{
			connectionURL = DataSource.Instance.GetConnectionString();
			Debug.Assert(connectionURL != null, "Checks whether connection string is null or not");
		}

		/// <summary>
		///     Create new database connection
		/// </summary>
		/// <returns>
		///     Idbconnection object
		/// </returns>
		public IDbConnection CreateConnection()
		{
			var sqlConnection = new SqlConnection();
			sqlConnection.ConnectionString = connectionURL;
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
			var connection = new SqlConnection(connectionString);
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
		///     Create new general data accessor
		/// </summary>
		/// <param name="conn">
		///     Connection object
		/// </param>
		/// <param name="t">
		///     type of model object
		/// </param>
		/// <returns>
		///     IData accessors object
		/// </returns>
		public IDataAccessor CreateAccessor(IDbConnection conn, Type t)
		{
			return CreateAccessor(conn, t, null);
		}

		/// <summary>
		///     Create new general data accessor
		/// </summary>
		/// <param name="conn">
		///     Connection object
		/// </param>
		/// <param name="t">
		///     Type of IModel object.
		/// </param>
		/// <param name="trans">
		///     Transaction object
		/// </param>
		/// <returns>
		///     IData accessors object
		/// </returns>
		public IDataAccessor CreateAccessor(IDbConnection conn, Type t, IDbTransaction trans)
		{
			IDataAccessor accessor = new SqlDataAccessor(conn, t, trans);
			return accessor;
			//return null;
		}

		#endregion Common

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

		#endregion Custom Accessor
	}
}