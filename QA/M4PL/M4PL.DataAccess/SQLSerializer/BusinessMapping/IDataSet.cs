//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              4/8/2016
//Program Name:                                 IDataSet
//Purpose:                                      Used to provide classes for analysis.
//
//====================================================================================================================================================

using M4PL.DataAccess.SQLSerializer.AttributeMapping;
using System.Collections.Generic;

namespace M4PL.DataAccess.SQLSerializer.BusinessMapping
{
    /// <summary>
    ///     This interface should be implemented all dataset.
    /// </summary>
    public interface IDataSet : IServerType
    {
        #region Properties

        /// <summary>
        ///     Gets or sets select stored procedure name
        /// </summary>
        string StoredProcedureName { get; set; }

        /// <summary>
        ///     Gets or sets input parameters of stored procedure
        /// </summary>
        List<DbParameter> InputParams { get; set; }

        #endregion Properties
    }
}