/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              31/07/2019
===================================================================================================================*/

using M4PL.Business.Finance;
using M4PL.Business.Finance.PriceCode;
using M4PL.Entities.Finance.PriceCode;
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
	}
}
