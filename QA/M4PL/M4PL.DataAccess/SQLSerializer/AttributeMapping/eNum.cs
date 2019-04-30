//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 eNum
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     Types of stored procedure supported by the framework
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
        ///     FCL database
        /// </summary>
        FCL,

        /// <summary>
        ///     Mobile database
        /// </summary>
        Mobile = 12
    }
}