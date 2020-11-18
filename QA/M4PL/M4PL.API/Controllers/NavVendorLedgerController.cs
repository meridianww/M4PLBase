#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.API.Filters;
using System.Collections.Generic;
using System.Web.Http;
using M4PL.Business.Finance.VendorLedger;
using M4PL.Entities.Finance.VendorLedger;
using M4PL.Entities.Finance.PurchaseOrder;

namespace M4PL.API.Controllers
{
	[CustomAuthorize]
	[RoutePrefix("api/NavVendorLedger")]
	public class NavVendorLedgerController : ApiController
	{
		private readonly INavVendorLedgerCommands _navVendorLedgerCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavVendorLedgerController"/> class.
		/// </summary>
		public NavVendorLedgerController(INavVendorLedgerCommands navVendorLedgerCommands)
		{
			_navVendorLedgerCommands = navVendorLedgerCommands;
		}

		[HttpGet]
		[Route("GetPostedInvoicesByCheckNumber")]
		public virtual List<CheckPostedInvoice> GetPostedInvoicesByCheckNumber(string checkNumber)
		{
			_navVendorLedgerCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _navVendorLedgerCommands.GetVendorCheckedInvoice(checkNumber);
		}
	}
}