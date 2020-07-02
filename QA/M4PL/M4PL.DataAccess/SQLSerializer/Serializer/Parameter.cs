#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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