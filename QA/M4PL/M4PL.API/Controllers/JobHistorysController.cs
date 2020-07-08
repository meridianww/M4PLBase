#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job history/logs service
	/// </summary>
	[RoutePrefix("api/JobHistorys")]
	public class JobHistorysController : BaseApiController<JobHistory>
	{
		private readonly IJobHistorysCommands _jobHistorysController;

		/// <summary>
		/// Job history/logs constructor with required parameter
		/// </summary>
		/// <param name="jobHistorysController"></param>
		public JobHistorysController(IJobHistorysCommands jobHistorysController)
		   : base(jobHistorysController)
		{
			_jobHistorysController = jobHistorysController;
		}
	}
}