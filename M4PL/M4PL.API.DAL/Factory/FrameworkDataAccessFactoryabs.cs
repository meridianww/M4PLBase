using System;
using System.Collections.Generic;
using System.Data;


using Manthan.Depo.Common.Constants.DataAcecess;
using Manthan.Depo.Framework.DataAccess.Factory.Accessors;

namespace Manthan.Depo.Framework.DataAccess.Factory
{
    /// <summary>
    /// Creates a singleton instance of database and provides all accessor interfaces 
    /// to access different entities.
    /// </summary>
    public abstract class FrameworkDataAccessFactory
    {
        #region Abstract Methods

        #region Common

        /// <summary>
        /// Abstract method to create connection with database
        /// </summary>
        /// <returns>
        /// Object of Connection class
        /// </returns>
        public abstract IDbConnection CreateConnection();

        /// <summary>
        ///     Abstract method to create data accesor.
        /// </summary>
        /// <param name="connection">
        ///     Connection object which implements System.Data.IDbCOnnection Interface.
        /// </param>
        /// <returns>
        ///     Returns data accessor instance which implemtns
        /// </returns>
        public abstract IDataAccessor CreateAccessor(IDbConnection connection);

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
        public abstract IDataAccessor CreateAccessor(IDbConnection c, Type modelType);

        /// <summary>
        ///		Abstract method to create object of SqlDataAccessor
        /// </summary>
        /// <param name="c">
        ///		Object of connection class
        /// </param>
        /// <param name="t">
        ///		Type of model object
        /// </param>
        ///<param name="trans">
        ///		Transaction Object
        /// </param>
        /// <returns>
        ///		Data accessor object
        /// </returns>
        public abstract IDataAccessor CreateAccessor(IDbConnection c, Type t, IDbTransaction trans);

        #endregion

        #region Custom Accessor

        public abstract ICustomAccessor CreateCustomAccessor<iS>(IDbConnection connection);


        #endregion

        #endregion Abstract Methods


    }
}
