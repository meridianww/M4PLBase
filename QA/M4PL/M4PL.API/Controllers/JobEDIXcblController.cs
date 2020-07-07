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
	/// Job EDI xCBL Services
	/// </summary>
	[RoutePrefix("api/JobEDIXcbl")]
	public class JobEDIXcblController : BaseApiController<JobEDIXcbl>
	{
		private readonly IJobEDIXcblCommands _jobEDIXcblCommands;

		/// <summary>
		/// Constructor to get Job's Cargo details
		/// </summary>
		/// <param name="jobEDIXcblCommands">jobEDIXcblCommands</param>
		public JobEDIXcblController(IJobEDIXcblCommands jobEDIXcblCommands)
			: base(jobEDIXcblCommands)
		{
			_jobEDIXcblCommands = jobEDIXcblCommands;
		}

		/// <summary>
		/// POST too Add Electonic transaction for job
		/// </summary>
		/// <param name="jobEDIXcbl"></param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("ElectronicTransaction"), ResponseType(typeof(long))]
		public long JobAddElectronicTransaction(JobEDIXcbl jobEDIXcbl)
		{
			BaseCommands.ActiveUser = ActiveUser;
			JobEDIXcbl updatedJobEDIXcbl = _jobEDIXcblCommands.Post(jobEDIXcbl);

			return updatedJobEDIXcbl != null ? updatedJobEDIXcbl.Id : 0;
		}

		/// <summary>
		/// PUT to update Electonic transaction data for job EDI xCBL
		/// </summary>
		/// <param name="jobEDIXcbl"></param>
		/// <returns>Returns the job EDI xCBL Id.</returns>
		[CustomAuthorize]
		[HttpPut]
		[Route("ElectronicTransaction"), ResponseType(typeof(long))]
		public long JobUpdateElectronicTransaction(JobEDIXcbl jobEDIXcbl)
		{
			BaseCommands.ActiveUser = ActiveUser;
			JobEDIXcbl updatedJobEDIXcbl = _jobEDIXcblCommands.Put(jobEDIXcbl);

			return updatedJobEDIXcbl != null ? updatedJobEDIXcbl.Id : 0;
		}
	}
}