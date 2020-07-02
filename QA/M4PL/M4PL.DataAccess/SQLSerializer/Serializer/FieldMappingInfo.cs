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