using System.Reflection;

namespace M4PL.DataAccess.Serializer
{
    internal class FieldMappingInfo : MappingInfo
    {
        public FieldMappingAttribute FieldMappingAttribute { get; private set; }

        public FieldInfo FieldInfo { get; private set; }

        public override MappingAttribute MappingAttribute
        {
            get
            {
                return (MappingAttribute)this.FieldMappingAttribute;
            }
        }

        public override string Name
        {
            get
            {
                return this.FieldInfo.Name;
            }
        }

        public FieldMappingInfo(FieldMappingAttribute fieldMappingAttribute, FieldInfo fieldInfo)
        {
            this.FieldMappingAttribute = fieldMappingAttribute;
            this.FieldInfo = fieldInfo;
        }

        public override object GetValue(object obj)
        {
            return this.FieldInfo.GetValue(obj);
        }

        public override void SetValue(object obj, object value)
        {
            this.FieldInfo.SetValue(obj, value);
        }
    }
}
