#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.PriceCode;
using M4PL.Entities.Finance.PriceCode;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Nav Related Operations
	/// </summary>
	[RoutePrefix("api/NavPriceCode")]
	public class NavPriceCodeController : BaseApiController<NavPriceCode>
	{
		private readonly INavPriceCodeCommands _navPriceCodeCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavPriceCodeController"/> class.
		/// </summary>
		public NavPriceCodeController(INavPriceCodeCommands navPriceCodeCommands)
			: base(navPriceCodeCommands)
		{
			_navPriceCodeCommands = navPriceCodeCommands;
		}

		[HttpGet]
		[Route("GetAllPriceCode")]
		public virtual IList<NavPriceCode> GetAllPriceCode()
		{
			_navPriceCodeCommands.ActiveUser = ActiveUser;
			return _navPriceCodeCommands.GetAllPriceCode();
		}
	}
}