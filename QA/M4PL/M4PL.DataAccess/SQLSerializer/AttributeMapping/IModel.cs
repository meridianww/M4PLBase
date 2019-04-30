//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 IModel
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     This interface should be implemented by all models.
    ///     It does not specify any methods that need to be implemented.
    ///     Its sole purpose is to give all model implementations a common type.
    /// </summary>
    public interface IModel : IServerType
    {
        /// <summary>
        ///     Gets a value indicating whether current object
        ///     is a new object or existing object.
        /// </summary>
        bool IsNew { get; }
    }
}