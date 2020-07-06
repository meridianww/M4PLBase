#region Copyright

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
//Date Programmed:                              18/02/2020
//Program Name:                                 JobEDIXcbl
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// JobXcblInfosController
	/// </summary>
	[RoutePrefix("api/JobXcblInfos")]
	public class JobXcblInfosController : BaseApiController<JobXcblInfo>
	{
		private readonly IJobXcblInfoCommands _jobXcblInfoCommands;

		/// <summary>
		/// Function to get Job's Cargo details
		/// </summary>
		/// <param name="jobXcblInfoCommands">jobXcblInfoCommands</param>
		public JobXcblInfosController(IJobXcblInfoCommands jobXcblInfoCommands)
			: base(jobXcblInfoCommands)
		{
			_jobXcblInfoCommands = jobXcblInfoCommands;
		}

        /// <summary>
        /// It will compare the changes with job current values and XBCL values recieved from customer and detected changes eligible for mannual approve will be returned.
        /// </summary>
        /// <param name="jobId">jobId</param>
        /// <param name="gatewayId">gateway Id</param>
        /// <returns>List of changes for mannual review</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("GetJobXcblInfo"), ResponseType(typeof(JobXcblInfo))]
		public JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _jobXcblInfoCommands.GetJobXcblInfo(jobId, gatewayId);
		}

        /// <summary>
        /// It will approve the xcbl changes for supplied job id and gateway id. Then it will update the changes the Job. 
        /// </summary>
        /// <param name="jobId">job Id</param>
        /// <param name="gatewayId">gateway id</param>
        /// <returns>Returns true if the changes approved successfully else false.</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("AcceptJobXcblInfo"), ResponseType(typeof(bool))]
		public bool AcceptJobXcblInfo(long jobId, long gatewayId)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _jobXcblInfoCommands.AcceptJobXcblInfo(jobId, gatewayId);
		}

        /// <summary>
        /// It will reject the xcbl changes for supplied gateway id. It will NOT update any changes the Job. 
        /// </summary>
        /// <param name="gatewayId"></param>
        /// <returns></returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("RejectJobXcblInfo"), ResponseType(typeof(bool))]
		public bool RejectJobXcblInfo(long gatewayId)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _jobXcblInfoCommands.RejectJobXcblInfo(gatewayId);
		}
	}
}