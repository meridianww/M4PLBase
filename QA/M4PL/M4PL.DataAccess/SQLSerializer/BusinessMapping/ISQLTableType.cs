#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Collections.Generic;

namespace M4PL.DataAccess.SQLSerializer.BusinessMapping
{
    /// <summary>
    ///     Interface for implementing tablue valued data type functionality of MS SQL Server 2012.
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
        Dictionary<string, DbParameter> TableValuedParameters { get; set; }

        #endregion Properties
    }
}