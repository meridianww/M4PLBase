using System;


namespace M4PL.DataAccess.Serializer
{
    [AttributeUsage(AttributeTargets.Field)]
    public class FieldMappingAttribute : MappingAttribute
    {
        public FieldMappingAttribute(string name)
            : base(name, false, false)
        {
        }

        public FieldMappingAttribute(string name, bool id = false, bool identity = false)
            : base(name, id, identity)
        {
        }
    }
}
