//------------------------------------------------------------------------------ 
// <copyright file="ISQLTableType.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System.Collections.Generic;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     Interface for implementing tablue valued data type functionality of MS SQL Server 2012.
    ///     
    ///     Created By: Subin K.J                   Created Date:06/10/2013
    ///     Modified By:                            Modified Date: 
    ///     Comments: 
    ///     Modified By:
    /// </summary>
    public interface ISQLTableType
    {
        #region Properties

        /// <summary>
        ///     Gets or sets table valued input parameter, dataset table name 
        ///     will be the key, and name of user defined tabledata type in 
        ///     SQL server will be the value.
        /// </summary>
        Dictionary<string, DbParameter> TableValuedParameters
        {
            get;
            set;
        }

        #endregion
    }
}
