#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities;
using M4PL.Entities.Event;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Event
{
	public class EventCommands : BaseCommands<EventEmailDetail>, IEventCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public EmailDetail Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<EmailDetail> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public EmailDetail Patch(EmailDetail entity)
		{
			throw new NotImplementedException();
		}

		public EmailDetail Post(EmailDetail entity)
		{
			throw new NotImplementedException();
		}

		public EmailDetail Put(EmailDetail entity)
		{
			throw new NotImplementedException();
		}
	}
}