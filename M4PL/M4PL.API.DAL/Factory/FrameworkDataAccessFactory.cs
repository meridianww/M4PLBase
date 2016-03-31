//------------------------------------------------------------------------------
// <copyright file="SampleDataset.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System;
using System.Data;

using M4PL.DataAccess.Factory.Accessors;

namespace M4PL.DataAccess.Factory
{
    /// <summary>
    /// Creates a singleton instance of database and provides all accessor interfaces
    /// to access different entities.
    /// </summary>
    public interface IFrameworkDataAccessFactory
    {
        #region Abstract Methods

        #region Common

        /// <summary>
        ///     Abstract method to create connection with database
        /// </summary>
        /// <returns>
        ///     Object of Connection class
        /// </returns>
        IDbConnection CreateConnection();

        /// <summary>
        ///     Create connection with database using given connection string.
        /// </summary>
        /// <param name="connectionString">
        ///     Connection string for connection object
        /// </param>
        /// <returns>
        ///     Object of Connection class
        /// </returns>
        IDbConnection CreateConnection(string connectionString);

        /// <summary>
        ///     Abstract method to create data accessors.
        /// </summary>
        /// <param name="connection">
        ///     Connection object which implements System.Data.IDbCOnnection Interface.
        /// </param>
        /// <returns>
        ///     Returns data accessor instance which implement's
        /// </returns>
        IDataAccessor CreateAccessor(IDbConnection connection);

        /// <summary>
        ///		Abstract method to create object of SqlDataAccessor
        /// </summary>
        /// <param name="c">
        ///		Object of connection class
        /// </param>
        /// <param name="modelType">
        ///		Type of model object
        /// </param>
        /// <returns>
        ///		Data accessor object
        /// </returns>
        IDataAccessor CreateAccessor(IDbConnection c, Type modelType);

        /// <summary>
        ///		Abstract method to create object of SqlDataAccessor
        /// </summary>
        /// <param name="c">
        ///		Object of connection class
        /// </param>
        /// <param name="t">
        ///		Type of model object
        /// </param>
        /// <param name="trans">
        ///		Transaction Object
        /// </param>
        /// <returns>
        ///		Data accessor object
        /// </returns>
        IDataAccessor CreateAccessor(IDbConnection c, Type t, IDbTransaction trans);

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
        T CreateCustomAccessor<T>(IDbConnection connection) where T : ICustomAccessor;

        /// <summary>
        ///     Create accessors for custom activities, It is a genetic method.
        /// </summary>
        /// <typeparam name="T">
        ///     Type of custom accessor, type should implement ICustom accessor interface.
        /// </typeparam>
        /// <param name="transaction">
        ///     Transaction object for database operations
        /// </param>
        /// <returns>
        ///     Accessor specified in generic type
        /// </returns>
        T CreateCustomAccessor<T>(IDbTransaction transaction) where T : ICustomAccessor;

        #endregion

        #endregion Abstract Methods
    }
}
