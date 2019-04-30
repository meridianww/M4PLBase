//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 EnumDisplayNameAttribute
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

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