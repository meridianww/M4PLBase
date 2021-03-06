﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Email;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Endpoints to serve Email Service (IT Email alerts)
	/// </summary>
	[CustomAuthorize]
	[RoutePrefix("api/EmailService")]
	public class EmailServiceController : ApiController
	{
		private readonly IEmailCommands _emailCommands;

		public EmailServiceController(IEmailCommands emailCommands)
		{
			_emailCommands = emailCommands;
		}

		/// <summary>
		/// Get the Details of Emails and SMTP server which are in Queue
		/// </summary>
		/// <param name="emailCount">emailCount</param>
		/// <param name="toHours">toHours</param>
		/// <param name="fromHours">fromHours</param>
		/// <returns>SMTPEmailDetail</returns>
		[HttpGet]
		[Route("GetSMTPEmailDetail"), ResponseType(typeof(SMTPEmailDetail))]
		public SMTPEmailDetail GetSMTPEmailDetail(int emailCount, int toHours, int fromHours)
		{
			_emailCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _emailCommands.GetSMTPEmailDetail(emailCount, toHours, fromHours);
		}

		/// <summary>
		/// Updates Email status and Retry Attempts on EmailDetail for the supplied id
		/// </summary>
		/// <param name="id">Supplied Id of EmailDetail</param>
		/// <param name="emailStatus">Email Status</param>
		/// <param name="retryAttampts">Retry Attempts</param>
		/// <returns></returns>
		[HttpGet]
		[Route("UpdateEmailStatus")]
		public bool UpdateEmailStatus(int id, short emailStatus, short retryAttampts)
		{
			_emailCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _emailCommands.UpdateEmailStatus(id, emailStatus, retryAttampts);
		}

		/// <summary>
		/// Sends xCBL IT Email Notification for scenario(Event Id) supplied e.g. 5 for xCBL Invalid Requests 
		/// </summary>
		/// <param name="scenarioTypeId">Event Id</param>
		/// <returns></returns>
		[HttpGet]
		[Route("xCBLEmailNotification")]
		public bool xCBLEmailNotification(int scenarioTypeId)
		{
			_emailCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _emailCommands.xCBLEmailNotification(scenarioTypeId);
		}

		/// <summary>
		/// Sends EDI IT Email Notification for scenario(Event Id) supplied e.g. 9 for EDI- No EDI Received (Daily)
		/// </summary>
		/// <param name="scenarioTypeId">Event Id</param>
		/// <returns></returns>
		[HttpGet]
		[Route("EDIEmailNotification")]
		public bool EDIEmailNotification(int scenarioTypeId)
        {
			_emailCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _emailCommands.EDIEmailNotification(scenarioTypeId);
		}
	}
}