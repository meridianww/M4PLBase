using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Serializer
{
    public abstract class MappingInfo
    {
        public abstract MappingAttribute MappingAttribute { get; }

        public abstract string Name { get; }

        public abstract object GetValue(object obj);

        public abstract void SetValue(object obj, object value);
    }
}
