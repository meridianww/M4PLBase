//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 FCLDataException
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public class FCLDataException : Exception
    {
        public FCLDataException(string errorCode, string message, Exception innerException)
            : base(message, innerException)
        {
            ErrorCode = errorCode;
        }

        public string ErrorCode { get; private set; }
    }
}