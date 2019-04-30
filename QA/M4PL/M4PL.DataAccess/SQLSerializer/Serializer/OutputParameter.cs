//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 OutputParameter
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System.Data;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public class OutputParameter<T> : Parameter
    {
        public OutputParameter(string name)
            : base(name, default(T), ParameterDirection.Output, typeof(T))
        {
        }

        public OutputParameter(string name, T value)
            : base(name, value, ParameterDirection.InputOutput, typeof(T))
        {
        }
    }
}