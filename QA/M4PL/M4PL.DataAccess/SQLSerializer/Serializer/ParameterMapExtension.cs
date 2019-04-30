//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ParameterMapExtension
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public static class ParameterMapExtension
    {
        public static IList<Parameter> ToParameterList(this ParameterMap map)
        {
            if (map == null)
                throw new ArgumentNullException("map");
            return map.Select(kvp => new Parameter(kvp.Key, kvp.Value)).ToList();
        }
    }
}