#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;

namespace M4PL.DataAccess.SQLSerializer.Serializer
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