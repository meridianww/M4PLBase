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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 JobGateways
//Purpose:                                      End point to interact with Job Gateways module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Contact;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job Gateway Services
	/// </summary>
	[RoutePrefix("api/JobGateways")]
	public class JobGatewaysController : BaseApiController<JobGateway>
	{
		private readonly IJobGatewayCommands _jobGatewayCommands;

		/// <summary>
		/// Constructor of Job gateway details
		/// </summary>
		/// <param name="jobGatewayCommands"></param>
		public JobGatewaysController(IJobGatewayCommands jobGatewayCommands)
			: base(jobGatewayCommands)
		{
			_jobGatewayCommands = jobGatewayCommands;
		}

		/// <summary>
		/// GET to the Job Gateway based on jobid
		/// </summary>
		/// <param name="id"></param>
		/// <param name="parentId"></param>
		/// <param name="entityFor"></param>
		/// <param name="is3PlAction"></param>
		/// <returns>Return the job gateway detail.</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("GatewayWithParent"), ResponseType(typeof(JobGateway))]
		public JobGateway GetGatewayWithParent(long id, long parentId, string entityFor, bool is3PlAction, string gatewayCode = null)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.GetGatewayWithParent(id, parentId, entityFor, is3PlAction, gatewayCode);
		}

		/// <summary>
		/// GET to Completed job gateway based on job id
		/// </summary>
		/// <param name="id"></param>
		/// <param name="parentId"></param>
		/// <returns>Returns the job latested completed gateway.</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("GatewayComplete"), ResponseType(typeof(JobGatewayComplete))]
		public Entities.Support.JobGatewayComplete GetJobGatewayComplete(long id, long parentId)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.GetJobGatewayComplete(id, parentId);
		}

		/// <summary>
		/// PUT to partial update of job gateway to make complete with required property need to update followed to business rules
		/// </summary>
		/// <param name="jobGateway"></param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpPut]
		[Route("GatewayComplete")]
		public Entities.Support.JobGatewayComplete GetJobGatewayComplete(Entities.Support.JobGatewayComplete jobGateway)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.PutJobGatewayComplete(jobGateway);
		}

		//[CustomAuthorize]
		//[HttpGet]
		//[Route("JobAction")]
		//public IQueryable<JobAction> GetJobAction(long jobId)
		//{
		//    _jobGatewayCommands.ActiveUser = ActiveUser;
		//    return _jobGatewayCommands.GetJobAction(jobId).AsQueryable();
		//}

		/// <summary>
		/// PUT to partial updates for job action
		/// </summary>
		/// <param name="jobGateway"></param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpPut]
		[Route("JobAction")]
		public JobGateway PutJobAction(JobGateway jobGateway)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.PutJobAction(jobGateway);
		}

		/// <summary>
		/// New put with user sys settings
		/// </summary>
		/// <param name="jobGateway"></param>
		/// <returns></returns>
		[HttpPost]
		[Route("SettingPost")]
		public JobGateway SettingPost(JobGateway jobGateway)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.PostWithSettings(UpdateActiveUserSettings(), jobGateway);
		}

		/// <summary>
		/// New put with user sys settings
		/// </summary>
		/// <param name="jobGateway"></param>
		/// <returns></returns>
		[HttpPut]
		[Route("SettingPut")]
		public JobGateway SettingPut(JobGateway jobGateway)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.PutWithSettings(UpdateActiveUserSettings(), jobGateway);
		}

		/// <summary>
		/// job action code by title
		/// </summary>
		/// <param name="id"></param>
		/// <param name="gwyTitle"></param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("JobActionCodeByTitle")]
		public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.JobActionCodeByTitle(jobId, gwyTitle);
		}

		/// <summary>
		/// job gateways by jobid
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("GetJobGateway")]
		public IQueryable<JobGatewayDetails> GetJobGateway(long jobId)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.GetJobGateway(jobId).AsQueryable();
		}

		/// <summary>
		/// Function to update the Contact card details
		/// </summary>
		/// <param name="contact"></param>
		[HttpPost]
		[Route("ContactCardAddOrEdit")]
		public Contact PostContactCard(Contact contact)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.PostContactCard(contact);
		}

		/// <summary>
		/// Upload POD gateway based on job id
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns>Returns true/false based on operation success</returns>
		[HttpGet]
		[Route("UploadPODGateway")]
		public bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId)
		{
			_jobGatewayCommands.ActiveUser = ActiveUser;
			return _jobGatewayCommands.InsJobGatewayPODIfPODDocExistsByJobId(jobId);
		}
	}
}