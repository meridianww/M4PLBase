//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 MappingInfo
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public abstract class MappingInfo
    {
        public abstract MappingAttribute MappingAttribute { get; }

        public abstract string Name { get; }

        public abstract object GetValue(object obj);

        public abstract void SetValue(object obj, object value);
    }
}