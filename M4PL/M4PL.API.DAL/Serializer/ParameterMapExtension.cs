using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Serializer
{
    public static class ParameterMapExtension
    {
        public static IList<Parameter> ToParameterList(this ParameterMap map)
        {
            if (map == null)
                throw new ArgumentNullException("map");
            else
                return (IList<Parameter>)Enumerable.ToList<Parameter>(Enumerable.Select<KeyValuePair<string, object>, Parameter>((IEnumerable<KeyValuePair<string, object>>)map, (Func<KeyValuePair<string, object>, Parameter>)(kvp => new Parameter(kvp.Key, kvp.Value))));
        }
    }
}
