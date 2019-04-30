//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              4/8/2016
//Program Name:                                 ISQLTableType
//Purpose:                                      Represents the definition of a table structure.Used to declare table-valued parameters for stored procedures or functions, or to declare table variables .
//
//====================================================================================================================================================

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