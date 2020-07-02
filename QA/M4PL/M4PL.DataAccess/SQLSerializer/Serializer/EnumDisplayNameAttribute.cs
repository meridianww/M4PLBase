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
    [AttributeUsage(AttributeTargets.Field)]
    public class EnumDisplayNameAttribute : Attribute
    {
        private readonly string _displayName;

        public EnumDisplayNameAttribute(string displayName)
        {
            _displayName = displayName;
        }

        public string DisplayName
        {
            get { return _displayName ?? string.Empty; }
        }
    }
}