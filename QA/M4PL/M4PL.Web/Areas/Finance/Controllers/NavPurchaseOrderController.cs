#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavPurchaseOrder
//Purpose:                                      Contains Actions to render view on Nav Purchase Order over the Pages in the system
//====================================================================================================================================================*/
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavPurchaseOrderController : BaseController<NavPurchaseOrderView>
    {
        protected INavPurchaseOrderCommands _navPurchaseOrderCommands;

        /// <summary>
        /// Nav Purchase Order Controller Constructor
        /// </summary>
        /// <param name="navPurchaseOrderCommands">navPurchaseOrderCommands</param>
        /// <param name="commonCommands">commonCommands</param>
        public NavPurchaseOrderController(INavPurchaseOrderCommands navPurchaseOrderCommands, ICommonCommands commonCommands)
                : base(navPurchaseOrderCommands)
        {
            _commonCommands = commonCommands;
            _navPurchaseOrderCommands = navPurchaseOrderCommands;

        }

        public ActionResult SyncPurchaseOrderDetailsInNAV()
        {
            var route = SessionProvider.ActiveUser.CurrentRoute;
            NavPurchaseOrderView navPurchaseOrderView = _currentEntityCommands.Get(route.RecordId);
            var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.CreatePurchaseOrder);
            if (navPurchaseOrderView != null && !string.IsNullOrEmpty(navPurchaseOrderView.No))
            {
                displayMessage.Description = string.Format("{0}, {1}", displayMessage.Description, navPurchaseOrderView.No);
            }
            else
            {
                displayMessage.Description = "Purchase Order is not Created In Nav.";
            }

            return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
        }
    }
}