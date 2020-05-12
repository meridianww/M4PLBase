/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              19/06/2019
===================================================================================================================*/
using System.Web.Mvc;
using M4PL.Business.Finance.Vendor;
using M4PL.Entities.Finance.Vendor;
using System.Collections.Generic;

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