#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

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