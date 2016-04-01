using System;
using System.Data;

namespace M4PL.DataAccess.Serializer
{
    public class Parameter
    {
        public string Name;
        public object Value;
        public string TableValueParameterType;
        public ParameterDirection Direction;
        internal Type Type;

        public Parameter(string name, object value)
            : this(name, value, ParameterDirection.Input, value == null ? (Type)null : value.GetType())
        {
        }

        public Parameter(string name, object value, Type type)
            : this(name, value, ParameterDirection.Input, type)
        {
        }

        public Parameter(string name, DataTable value, string tableValueParmeterType)
            : this(name, (object)value)
        {
            this.TableValueParameterType = tableValueParmeterType;
        }

        internal Parameter(string name, object value, ParameterDirection direction, Type type)
        {
            this.Name = name;
            this.Value = value;
            this.Direction = direction;
            this.Type = type;
        }

        public override string ToString()
        {
            return this.Name + (object)"=" + (string)(this.Value ?? (object)string.Empty) + " [" + (string)(object)this.Direction + "]";
        }
    }
}

