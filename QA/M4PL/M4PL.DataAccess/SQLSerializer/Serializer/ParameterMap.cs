//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ParameterMap
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public class ParameterMap : Dictionary<string, object>
    {
        public IList<Parameter> Parameters
        {
            get { return this.ToParameterList(); }
        }

        public static implicit operator Parameter[](ParameterMap map)
        {
            if (map == null)
                return null;
            return map.ToParameterList().ToArray();
        }
    }
}