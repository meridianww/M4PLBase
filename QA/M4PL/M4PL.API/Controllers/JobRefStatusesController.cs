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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 JobRefStatuses
//Purpose:                                      End point to interact with Job RefStatuses module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job ref status service
	/// </summary>
	[RoutePrefix("api/JobRefStatuses")]
	public class JobRefStatusesController : BaseApiController<JobRefStatus>
	{
		private readonly IJobRefStatusCommands _jobRefStatusCommands;

		/// <summary>
		/// Job ref status constructor with required parameter
		/// </summary>
		/// <param name="jobRefStatusCommands">Required parameter jobRefStatusCommands to initialize the required objects</param>
		public JobRefStatusesController(IJobRefStatusCommands jobRefStatusCommands)
			: base(jobRefStatusCommands)
		{
			_jobRefStatusCommands = jobRefStatusCommands;
		}
	}
}