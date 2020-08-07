#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Event;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Event
{
	public class EventCommands : BaseCommands<EventEmailDetail>
	{
		public static EventEmailDetail GetEventEmailDetail(int eventId, long parentId)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@EventId", eventId),
				new Parameter("@ParentId", parentId)
			};

			return SqlSerializer.Default.DeserializeSingleRecord<EventEmailDetail>(StoredProceduresConstant.GetEmailDetailsForEvent, parameters.ToArray(), false, true);
		}
	}
}
