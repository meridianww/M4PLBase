//------------------------------------------------------------------------------ 
// <copyright file="eNum.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     Types of stored procedure supported by the framework
    ///     
    ///     Created By : Amit verma             Modified By : Name
    ///     Create Date : 07/02/2010            Modified Date : mm/dd/yyyy
    ///     ----------------------------------------------------------
    ///     Change Comment
    ///     ----------------------------------------------------------
    /// </summary>
    public enum DBProcedureType
    {
        /// <summary>
        ///     Select procedure using primary key
        /// </summary>
        SELECT,

        /// <summary>
        ///     Select procedure with multiple result
        /// </summary>
        SELECT_MULTIPLE,

        /// <summary>
        ///     Insert procedure
        /// </summary>
        INSERT,

        /// <summary>
        ///     Insert procedure name, It inserts multiple rows 
        ///     using table valued parameter.
        /// </summary>
        INSERT_MULTIPLE,

        /// <summary>
        ///     Update procedure
        /// </summary>
        UPDATE,

        /// <summary>
        ///     Delete procedure
        /// </summary>
        DELETE
    }

    /// <summary>
    ///     Different types of server used in the application, like truck load, DHL etc
    /// </summary>
    public enum ServerTypes
    {
        
        /// <summary>
        /// FCL database
        /// </summary>
        FCL,      

        /// <summary>
        /// Mobile database
        /// </summary>        
        Mobile = 12
    }

}
