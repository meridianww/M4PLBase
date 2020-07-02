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
    public abstract class MappingAttribute : Attribute
    {
        public MappingAttribute(string name)
            : this(name, false, false)
        {
        }

        public MappingAttribute(string name, bool id = false, bool identity = false)
        {
            Name = name;
            IsId = id;
            IsIdentity = identity;
        }

        public string Name { get; private set; }

        public bool IsId { get; private set; }

        public bool IsIdentity { get; private set; }
    }
}