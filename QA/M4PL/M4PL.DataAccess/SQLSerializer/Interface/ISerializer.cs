//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ISerializer
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;

namespace M4PL.DataAccess.SQLSerializer.Interface
{
    /// <summary>
    /// </summary>
    public interface ISerializer
    {
        #region Serializer

        /// <summary>
        ///     Get Sql serializer for
        /// </summary>
        SqlSerializer DAL { get; }

        #endregion Serializer
    }
}