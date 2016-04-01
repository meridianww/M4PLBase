using System;

namespace M4PL.DataAccess.Serializer
{
    public abstract class MappingAttribute : Attribute
    {
        public string Name { get; private set; }

        public bool IsId { get; private set; }

        public bool IsIdentity { get; private set; }

        public MappingAttribute(string name)
            : this(name, false, false)
        {
        }

        public MappingAttribute(string name, bool id = false, bool identity = false)
        {
            this.Name = name;
            this.IsId = id;
            this.IsIdentity = identity;
        }
    }
}
