#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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