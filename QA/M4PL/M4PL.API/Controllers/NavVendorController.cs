#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.Vendor;
using M4PL.Entities.Finance.Vendor;
using System.Collections.Generic;
using System.Web.Mvc;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Nav Vendor Related Operations
	/// </summary>
	[RoutePrefix("api/NavVendor")]
	public class NavVendorController : BaseApiController<NavVendor>
	{
		private readonly INavVendorCommands _navVendorCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavVendorController"/> class.
		/// </summary>
		public NavVendorController(INavVendorCommands navVendorCommands)
				: base(navVendorCommands)
		{
			_navVendorCommands = navVendorCommands;
		}

		[HttpGet]
		[Route("GetAllNavVendor")]
		public virtual IList<NavVendor> GetAllNavVendor()
		{
			_navVendorCommands.ActiveUser = ActiveUser;
			return _navVendorCommands.GetAllNavVendor();
		}
	}
}