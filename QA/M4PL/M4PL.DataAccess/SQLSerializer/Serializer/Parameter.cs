//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 Parameter
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;
using System.Data;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public class Parameter
    {
        public ParameterDirection Direction;
        public string Name;
        public string TableValueParameterType;
        internal Type Type;
        public object Value;

        public Parameter(string name, object value)
            : this(name, value, ParameterDirection.Input, value == null ? null : value.GetType())
        {
        }

        public Parameter(string name, object value, Type type)
            : this(name, value, ParameterDirection.Input, type)
        {
        }

        public Parameter(string name, DataTable value, string tableValueParmeterType)
            : this(name, value)
        {
            TableValueParameterType = tableValueParmeterType;
        }

        internal Parameter(string name, object value, ParameterDirection direction, Type type)
        {
            Name = name;
            Value = value;
            Direction = direction;
            Type = type;
        }

        public override string ToString()
        {
            return Name + (object)"=" + (string)(Value ?? string.Empty) + " [" + (string)(object)Direction + "]";
        }
    }
}