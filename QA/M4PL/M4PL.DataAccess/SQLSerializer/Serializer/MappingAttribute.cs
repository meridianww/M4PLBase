//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 MappingAttribute
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

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