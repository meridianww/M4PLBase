//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 FieldMappingAttribute
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    [AttributeUsage(AttributeTargets.Field)]
    public class FieldMappingAttribute : MappingAttribute
    {
        public FieldMappingAttribute(string name)
            : base(name, false, false)
        {
        }

        public FieldMappingAttribute(string name, bool id = false, bool identity = false)
            : base(name, id, identity)
        {
        }
    }
}