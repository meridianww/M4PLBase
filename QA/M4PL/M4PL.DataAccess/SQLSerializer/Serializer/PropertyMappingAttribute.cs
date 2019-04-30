//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 PropertyMappingAttribute
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

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