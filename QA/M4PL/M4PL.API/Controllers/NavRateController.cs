#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Finance.NavRate;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller for Nav Rate
	/// </summary>
	[CustomAuthorize]
	[RoutePrefix("api/NavRate")]
	public class NavRateController : ApiController
	{
		private readonly INavRateCommands _navRateCommands;

		/// <summary>
		/// Function to get navRateCommands details
		/// </summary>
		/// <param name="navRateCommands"></param>
		public NavRateController(INavRateCommands navRateCommands)
		{
			_navRateCommands = navRateCommands;
		}
		/// <summary>
		/// Generates Program's Price Cost Code
		/// </summary>
		/// <param name="navRateList"></param>
		/// <returns></returns>
		[HttpPost]
		[Route("GenerateProgramPriceCostCode"), ResponseType(typeof(StatusModel))]
		public StatusModel GenerateProgramPriceCostCode(List<Entities.Finance.Customer.NavRate> navRateList)
		{
			_navRateCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _navRateCommands.GenerateProgramPriceCostCode(navRateList);
		}
	}
}