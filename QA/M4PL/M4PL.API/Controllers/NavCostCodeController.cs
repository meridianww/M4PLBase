/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              31/07/2019
===================================================================================================================*/

using M4PL.Business.Finance;
using M4PL.Entities.Finance;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Nav Related Operations
	/// </summary>
	[RoutePrefix("api/NavCostCode")]
	public class NavCostCodeController : BaseApiController<NavCostCode>
	{
		private readonly INavCostCodeCommands _navCostCodeCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavCostCodeController"/> class.
		/// </summary>
		public NavCostCodeController(INavCostCodeCommands navCostCodeCommands)
            : base(navCostCodeCommands)
        {
			_navCostCodeCommands = navCostCodeCommands;
		}
	}
}
