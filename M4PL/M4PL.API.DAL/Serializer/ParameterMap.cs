using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Serializer
{
    public class ParameterMap : Dictionary<string, object>
    {
        public IList<Parameter> Parameters
        {
            get
            {
                return ParameterMapExtension.ToParameterList(this);
            }
        }

        public static implicit operator Parameter[](ParameterMap map)
        {
            if (map == null)
                return (Parameter[])null;
            else
                return Enumerable.ToArray<Parameter>((IEnumerable<Parameter>)ParameterMapExtension.ToParameterList(map));
        }
    }
}
