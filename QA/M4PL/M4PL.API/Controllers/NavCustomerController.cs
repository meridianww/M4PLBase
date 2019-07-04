/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              19/06/2019
===================================================================================================================*/
using M4PL.Business.Administration;
using M4PL.Entities.Administration;
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
	}
}