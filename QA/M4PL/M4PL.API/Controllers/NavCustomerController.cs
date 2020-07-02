#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.Customer;
using M4PL.Entities.Finance.Customer;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Nav Related Operations
	/// </summary>
	[RoutePrefix("api/NavCustomer")]
	public class NavCustomerController : BaseApiController<NavCustomer>
	{
		private readonly INavCustomerCommands _navCustomerCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavCustomerController"/> class.
		/// </summary>
		public NavCustomerController(INavCustomerCommands navCustomerCommands)
			: base(navCustomerCommands)
		{
			_navCustomerCommands = navCustomerCommands;
		}

		[HttpGet]
		[Route("GetAllNavCustomer")]
		public virtual IList<NavCustomer> GetAllNavCustomer()
		{
			_navCustomerCommands.ActiveUser = ActiveUser;
			return _navCustomerCommands.GetAllNavCustomer();
		}
	}
}