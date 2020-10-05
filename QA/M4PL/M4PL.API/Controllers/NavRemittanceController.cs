#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;
using M4PL.Entities.Document;
using M4PL.Business.Finance.Remittance;

namespace M4PL.API.Controllers
{
	[CustomAuthorize]
	[RoutePrefix("api/NavRemittance")]
	public class NavRemittanceController : ApiController
	{
		private readonly INavRemittanceCommands _navRemittanceCommands;

		/// <summary>
		/// Function to get NavRemittanceController details
		/// </summary>
		/// <param name="navRemittanceCommands"></param>
		public NavRemittanceController(INavRemittanceCommands navRemittanceCommands)
		{
			_navRemittanceCommands = navRemittanceCommands;
		}

		[HttpGet]
		[Route("GetPostedInvoicesByCheckNumber")]
		public DocumentData GetPostedInvoiceByCheckNumber(string checkNumber)
		{
			_navRemittanceCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _navRemittanceCommands.GetPostedInvoiceByCheckNumber(checkNumber);
		}
	}
}