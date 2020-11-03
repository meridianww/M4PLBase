#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Event;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _command = M4PL.DataAccess.Common.EmailCommands;

namespace M4PL.Business.Email
{
	public class EmailCommands : BaseCommands<EmailDetail>, IEmailCommands
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

		public SMTPEmailDetail GetSMTPEmailDetail(int emailCount, int toHours, int fromHours)
		{
			return _command.GetSMTPEmailDetail(emailCount, toHours, fromHours);
		}

		public bool UpdateEmailStatus(int id, short emailStatus, short retryAttampts)
		{
			return _command.UpdateEmailStatus(id, emailStatus, retryAttampts);
		}

		public bool xCBLEmailNotification(int scenarioTypeId)
		{
			string emailBody = EventBodyHelper.GetxCBLExceptionMailBody(scenarioTypeId);
			if (!string.IsNullOrEmpty(emailBody))
			{
				EventBodyHelper.CreateEventMailNotificationForxCBLException(scenarioTypeId, emailBody);
				DataAccess.Event.EventCommands.InsertEmailProcessingLog(scenarioTypeId);
				return true;
			}

			return false;
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