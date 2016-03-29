using System.Data;

namespace M4PL.DataAccess.Serializer
{
    public class OutputParameter<T> : Parameter
    {
        public OutputParameter(string name)
            : base(name, (object)default(T), ParameterDirection.Output, typeof(T))
        {
        }

        public OutputParameter(string name, T value)
            : base(name, (object)value, ParameterDirection.InputOutput, typeof(T))
        {
        }
    }
}
