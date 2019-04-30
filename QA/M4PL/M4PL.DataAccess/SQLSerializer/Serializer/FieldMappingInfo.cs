//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 FieldMappingInfo
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    internal class FieldMappingInfo : MappingInfo
    {
        public FieldMappingInfo(FieldMappingAttribute fieldMappingAttribute, FieldInfo fieldInfo)
        {
            FieldMappingAttribute = fieldMappingAttribute;
            FieldInfo = fieldInfo;
        }

        public FieldMappingAttribute FieldMappingAttribute { get; private set; }

        public FieldInfo FieldInfo { get; private set; }

        public override MappingAttribute MappingAttribute
        {
            get { return FieldMappingAttribute; }
        }

        public override string Name
        {
            get { return FieldInfo.Name; }
        }

        public override object GetValue(object obj)
        {
            return FieldInfo.GetValue(obj);
        }

        public override void SetValue(object obj, object value)
        {
            FieldInfo.SetValue(obj, value);
        }
    }
}