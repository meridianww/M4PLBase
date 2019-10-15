/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavSalesOrder
//Purpose:                                      Contains Actions to render view on Nav Sales Order over the Pages in the system
//====================================================================================================================================================*/
using M4PL.APIClient.Finance;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavSalesOrderController : BaseController<NavSalesOrderView>
	{
		protected INavSalesOrderCommands _navSalesOrderCommands;

		/// <summary>
		/// Nav Sales Order Controller Constructor
		/// </summary>
		/// <param name="navSalesOrderCommands">navSalesOrderCommands</param>
		/// <param name="commonCommands">commonCommands</param>
		public NavSalesOrderController(INavSalesOrderCommands navSalesOrderCommands, ICommonCommands commonCommands)
                : base(navSalesOrderCommands)
        {
			_commonCommands = commonCommands;
			_navSalesOrderCommands = navSalesOrderCommands;

		}

		public ActionResult SyncOrderDetailsInNAV()
		{
			var route = SessionProvider.ActiveUser.CurrentRoute;
			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.CreateSalesOrder);
			if (!string.IsNullOrEmpty(route.CurrentSONumber))
			{
				displayMessage.Description = string.Format("There is already a Sales Order '{0}' present for this job", route.CurrentSONumber);
			}
			else
			{
				NavSalesOrderView navSalesOrderView = _currentEntityCommands.Get(route.RecordId);
				if (navSalesOrderView != null && !string.IsNullOrEmpty(navSalesOrderView.No))
				{
					displayMessage.Description = string.Format("Sales order generated sucessfully, sales order number is: {0}", navSalesOrderView.No);
				}
				else
				{
					displayMessage.Description = "Sales Order is not Created In Nav.";
				}
			}

			return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
		}
	}
}