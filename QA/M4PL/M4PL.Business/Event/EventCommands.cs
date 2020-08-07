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

namespace M4PL.Business.Event
{
	public class EventCommands : BaseCommands<EventEmailDetail>, IEventCommands
	{
		public void CreateEventMailNotificationForCargoException(int eventId, long parentId, string contractNumber)
		{
			var emailData = DataAccess.Event.EventCommands.GetEventEmailDetail(eventId, parentId);
			if (emailData != null)
			{
				EmailDetail emailDetail = new EmailDetail()
				{
					FromAddress = emailData.FromMail,
					Body = emailData.Body,
					CCAddress = emailData.CcAddress,
					EmailPriority = 1,
					IsBodyHtml = true,
					Subject = string.Format(emailData.Subject, contractNumber),
					ToAddress = emailData.ToAddress
				};

				_command.InsertEmailDetail(emailDetail);
			}
		}

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
