//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 PropertyMappingInfo
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

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