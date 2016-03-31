using System.Globalization;
using System.Reflection;

namespace M4PL.DataAccess.Serializer
{
    internal class PropertyMappingInfo : MappingInfo
    {
        public PropertyMappingAttribute PropertyMappingAttribute { get; private set; }

        public PropertyInfo PropertyInfo { get; private set; }

        public override MappingAttribute MappingAttribute
        {
            get
            {
                return (MappingAttribute)this.PropertyMappingAttribute;
            }
        }

        public override string Name
        {
            get
            {
                return this.PropertyInfo.Name;
            }
        }

        public PropertyMappingInfo(PropertyMappingAttribute propertyMappingAttribute, PropertyInfo propertyInfo)
        {
            this.PropertyMappingAttribute = propertyMappingAttribute;
            this.PropertyInfo = propertyInfo;
        }

        public override object GetValue(object obj)
        {
            return this.PropertyInfo.GetValue(obj, BindingFlags.GetProperty, (Binder)null, (object[])null, (CultureInfo)null);
        }

        public override void SetValue(object obj, object value)
        {
            this.PropertyInfo.SetValue(obj, value, BindingFlags.SetProperty, (Binder)null, (object[])null, (CultureInfo)null);
        }
    }
}
