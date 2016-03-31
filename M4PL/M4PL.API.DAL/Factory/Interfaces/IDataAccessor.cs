//------------------------------------------------------------------------------ 
// <copyright file="SampleDataset.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System.Collections.Generic;
using System.Data;
using M4PL.DataAccess.Models;
using M4PL.DataAccess.Models.Mapping;

namespace M4PL.DataAccess.Factory.Accessors
{
    /// <summary>
    ///		This is an interface for common database operations. It defines methods 
    ///		for all common database operations like select, insert, update and delete.
    ///	</summary>	 
    public interface IDataAccessor
    {
        #region Get

        #region SQL

        /// <summary>
        ///		Selects data from database on basis of primary key of given model object
        /// </summary>
        /// <param name="key">
        ///		key of the imodel object
        ///	</param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel Select(object key);

        /// <summary>
        ///		Selects data from database on basis of primary key of given model
        ///		object with database record lock
        /// </summary>
        /// <param name="key">
        ///		key of the imodel object
        ///	</param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel SelectWithLock(object key);

        /// <summary>
        ///		Selects data from database and filters data on the basis 
        ///		of field names and field values given
        /// </summary>
        /// <param name="fieldNames">
        ///     An array that contains database column names for creating fitter columns
        /// </param>
        /// <param name="fieldValues">
        ///		An array that contains values for filter columns
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel[] SelectMultiple(string[] fieldNames, object[] fieldValues);

        /// <summary>
        ///     Selects data from database and filters data on the basis of field names and field values given
        /// </summary>
        /// <typeparam name="T">
        ///     Any model object that implements I model interface.
        /// </typeparam>
        /// <param name="fieldNames">
        ///     An array that contains values for filter columns
        /// </param>
        /// <param name="fieldValues">
        ///     An array that contains database column names for creating fitter columns    
        /// </param>
        /// <returns>
        ///     GlobalTranz.Framework.Common.Models.IModel object
        /// </returns>
        List<T> SelectMultiple<T>(string[] fieldNames, object[] fieldValues) where T : IModel;

        /// <summary>
        ///		Selects sorted data based on sort filed from database 
        ///		and filters data on the basis of field names and field values given
        /// </summary>
        /// <param name="fieldNames">
        ///		An array that contains database column names for creating fitter columns
        /// </param>
        /// <param name="fieldValues">
        ///		An array that contains values for filter columns
        /// </param>
        /// <param name="sortField">
        ///		The field name used for sort
        /// </param>
        /// <param name="ascending">
        ///		Sort Order.
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel[] SelectSorted(string[] fieldNames, object[] fieldValues, string sortField, bool ascending);

        /// <summary>
        ///		Selects sorted data based on sort filed from database 
        ///		and filters data on the basis of field names and field values given		///
        /// </summary>
        /// <param name="fieldNames">
        ///		An array that contains database column names for creating fitter columns
        /// </param>
        /// <param name="fieldValues">
        ///		An array that contains values for filter columns
        /// </param>
        /// <param name="sortFields">
        ///		An array that contains field names used for sort
        /// </param>
        /// <param name="ascending">
        ///		Sort Order.
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel[] SelectSorted(
            string[] fieldNames,
            object[] fieldValues,
            string[] sortFields,
            bool ascending);

        #endregion

        #region Procedure

        /// <summary>
        ///		Selects data from database on basis of primary key of given model object
        /// </summary>
        /// <param name="key">
        ///		key of the imodel object
        ///	</param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel SelectProcedure(object key);

        /// <summary>
        ///		Selects data from database on basis of primary key of given model object
        /// </summary>
        /// <param name="model">
        ///		Model object with parameter values.
        ///	</param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel SelectProcedure(IModel model);

        /// <summary>
        ///		Selects data from database and filters data on the basis of field names and field values given
        /// </summary>
        /// <param name="model">
        ///		An IModel object to be saved.
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel[] SelectMultipleFromProcedure(IModel model);

        /// <summary>
        ///		Selects data from database and filters data on the basis of field names and field values given
        /// </summary>
        /// <typeparam name="T">
        ///     Any model object that implements I model interface.
        /// </typeparam>
        /// <param name="model">
        ///		An IModel object to be saved.
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        List<T> SelectMultipleFromProcedure<T>(IModel model) where T : IModel;

        /// <summary>
        ///		Selects data from database and filters data on the basis of field names and field values given
        /// </summary>
        /// <param name="model">
        ///		An IModel object containing filter parameters
        /// </param>		
        /// <returns>
        ///		A System.Data.DataSet object containing result of command execution
        /// </returns>
        DataSet SelectMultipleDataSetFromProcedure(IModel model);

        /// <summary>
        ///		Generates select command from model and execute that stored procedure
        /// </summary>
        /// <param name="key">
        ///     primary key of the table
        /// </param>
        /// <returns>
        ///		DataSet object
        /// </returns>
        DataSet SelectDataSetProcedure(object key);

        #endregion

        #endregion

        #region Delete

        /// <summary>
        ///		Delete data from database based on the key 
        /// </summary>
        /// <param name="key">
        ///		key of the imodel object, that contains key of record to be deleted
        /// </param>
        void Delete(object key);

        /// <summary>
        ///		Deletes a row from database using stored procedure
        /// </summary>
        /// <param name="keyValue">
        ///		Primary key value of record to be deleted.
        /// </param>
        /// <returns>
        ///		Returns true if successful deletion
        /// </returns>
        bool DeleteProcedure(object keyValue);

        /// <summary>
        ///		Delete data from database based on given parameters
        /// </summary>
        /// <param name="fieldNames">
        ///		A string array that contains field names
        /// </param>
        /// <param name="fieldValues">
        ///		A string array that contains field values.
        /// </param>
        void DeleteWithCondition(string[] fieldNames, string[] fieldValues);

        #endregion

        #region Insert

        /// <summary>
        ///		Create a new record in database based on given imodel object
        /// </summary>
        /// <param name="model">
        ///		An IModel object to be saved.
        ///	</param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel Insert(IModel model);

        /// <summary>
        ///		Create a new record in database using stored procedure specified in the given model
        /// </summary>
        /// <param name="model">
        ///		An IModel object to be saved.
        /// </param>
        /// <returns>
        ///		An IModel object
        /// </returns>
        IModel InsertProcedure(IModel model);

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
        ModelDataMap InsertTableValuedProcedure<T>(List<T> modelCollection) where T : IModel;
        //bool InsertTableValuedProcedure<T>(List<T> modelCollection) where T : IModel;

        #endregion

        #region Update

        /// <summary>
        ///		Updates given imodel object
        /// </summary>
        /// <param name="model">
        ///		An Models.IModel object to be saved.
        ///	</param>
        /// <returns>
        ///		An Models.IModel object
        /// </returns>
        IModel Update(IModel model);

        /// <summary>
        ///		Insert a new row to database using stored procedure
        /// </summary>
        /// <param name="model">
        ///		An Imodel object with data to be saved
        /// </param>
        /// <returns>
        ///		Returns Models object with new key
        /// </returns>
        IModel UpdateProcedure(IModel model);

        #endregion
    }
}
