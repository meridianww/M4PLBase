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
//Program Name:                                 JobCargos
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobCargos")]
	public class JobCargosController : BaseApiController<JobCargo>
	{
		private readonly IJobCargoCommands _jobCargoCommands;

		/// <summary>
		/// Function to get Job's Cargo details
		/// </summary>
		/// <param name="jobCargoCommands"></param>
		public JobCargosController(IJobCargoCommands jobCargoCommands)
			: base(jobCargoCommands)
		{
			_jobCargoCommands = jobCargoCommands;
		}

		/// <summary>
		/// Create Cargo Exception For a Particular Job Cargo
		/// </summary>
		/// <param name="jobCargoException">jobCargoException</param>
		/// <param name="cargoId">cargoId</param>
		/// <returns>StatusModel</returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("CreateCargoException")]
		public StatusModel CreateCargoException(JobCargoException jobCargoException, long cargoId)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _jobCargoCommands.CreateCargoException(jobCargoException, cargoId);
		}
	}
}