#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrder;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Purchase Order Nav Related Operations
	/// </summary>
	[RoutePrefix("api/NavPurchaseOrder")]
	public class NavPurchaseOrderController : BaseApiController<NavPurchaseOrder>
	{
		private readonly INavPurchaseOrderCommands _navPurchaseOrderCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavPurchaseOrderController"/> class.
		/// </summary>
		public NavPurchaseOrderController(INavPurchaseOrderCommands navPurchaseOrderCommands)
			: base(navPurchaseOrderCommands)
		{
			_navPurchaseOrderCommands = navPurchaseOrderCommands;
		}
	}
}