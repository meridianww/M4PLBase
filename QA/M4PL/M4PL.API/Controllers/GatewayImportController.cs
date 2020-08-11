#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Finance.Gateway;
using M4PL.Business.Finance.NavRate;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[CustomAuthorize]
	[RoutePrefix("api/GatewayImport")]
	public class GatewayImportController : ApiController
	{
		private readonly IGatewayCommands _gatewayCommands;

		/// <summary>
		/// Function to get gatewayCommands details
		/// </summary>
		/// <param name="gatewayCommands">gatewayCommands</param>
		public GatewayImportController(IGatewayCommands gatewayCommands)
		{
			_gatewayCommands = gatewayCommands;
		}

		[HttpPost]
		[Route("GenerateProgramGateway"), ResponseType(typeof(StatusModel))]
		public StatusModel GenerateProgramGateway(List<Entities.Finance.Customer.Gateway> gatewayList)
		{
			_gatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _gatewayCommands.GenerateProgramGateway(gatewayList);
		}
	}
}