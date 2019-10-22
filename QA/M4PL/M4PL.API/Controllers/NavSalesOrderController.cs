/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              31/07/2019
===================================================================================================================*/

using M4PL.Business.Finance;
using M4PL.Entities.Finance.SalesOrder;
using System.Web.Http;


namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Sales Order Nav Related Operations
	/// </summary>
	[RoutePrefix("api/NavSalesOrder")]
	public class NavSalesOrderController : BaseApiController<NavSalesOrder>
	{
		private readonly INavSalesOrderCommands _navSalesOrderCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavSalesOrderController"/> class.
		/// </summary>
		public NavSalesOrderController(INavSalesOrderCommands navSalesOrderCommands)
            : base(navSalesOrderCommands)
        {
			_navSalesOrderCommands = navSalesOrderCommands;
		}
	}
}