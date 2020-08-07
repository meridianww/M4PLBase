#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _command = M4PL.DataAccess.Common.EmailCommands;
using M4PL.Entities.Support;
using M4PL.Entities.Event;
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Utilities;
using System.Collections;
using System.Data;
using System.IO;

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
