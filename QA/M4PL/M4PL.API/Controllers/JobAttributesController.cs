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
//Program Name:                                 JobAttribute
//Purpose:                                      End point to interact with JobAttribute module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobAttributes
    /// </summary>
	[RoutePrefix("api/JobAttributes")]
	public class JobAttributesController : BaseApiController<JobAttribute>
	{
		private readonly IJobAttributeCommands _jobAttributeCommands;

		/// <summary>
		/// Function to get Job's attribute details
		/// </summary>
		/// <param name="jobAttributeCommands"></param>
		public JobAttributesController(IJobAttributeCommands jobAttributeCommands)
			: base(jobAttributeCommands)
		{
			_jobAttributeCommands = jobAttributeCommands;
		}
	}
}