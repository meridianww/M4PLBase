#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    internal class PropertyMappingInfo : MappingInfo
    {
        public PropertyMappingInfo(PropertyMappingAttribute propertyMappingAttribute, PropertyInfo propertyInfo)
        {
            PropertyMappingAttribute = propertyMappingAttribute;
            PropertyInfo = propertyInfo;
        }

        public PropertyMappingAttribute PropertyMappingAttribute { get; private set; }

        public PropertyInfo PropertyInfo { get; private set; }

        public override MappingAttribute MappingAttribute
        {
            get { return PropertyMappingAttribute; }
        }

        public override string Name
        {
            get { return PropertyInfo.Name; }
        }

        public override object GetValue(object obj)
        {
            return PropertyInfo.GetValue(obj, BindingFlags.GetProperty, null, null, null);
        }

        public override void SetValue(object obj, object value)
        {
            PropertyInfo.SetValue(obj, value, BindingFlags.SetProperty, null, null, null);
        }
    }
}