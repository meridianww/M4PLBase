using System;

namespace M4PL.DataAccess.Serializer
{
    [AttributeUsage(AttributeTargets.Property)]
    public class PropertyMappingAttribute : MappingAttribute
    {
        public PropertyMappingAttribute(string name)
            : base(name, false, false)
        {
        }

        public PropertyMappingAttribute(string name, bool id = false, bool identity = false)
            : base(name, id, identity)
        {
        }
    }
}
