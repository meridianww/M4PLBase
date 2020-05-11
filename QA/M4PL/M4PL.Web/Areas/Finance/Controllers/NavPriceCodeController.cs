/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavPriceCode
//Purpose:                                      Contains Actions to render view on Nav Price Code over the Pages in the system
//====================================================================================================================================================*/

using M4PL.APIClient.Finance;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavPriceCodeController : BaseController<NavPriceCodeView>
    {
        protected INavPriceCodeCommands _navPriceCodeCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Nav Price Code details and renders to the page
        /// </summary>
        /// <param name="navPriceCodeCommands">navPriceCodeCommands</param>
        /// <param name="commonCommands"></param>
        public NavPriceCodeController(INavPriceCodeCommands navPriceCodeCommands, ICommonCommands commonCommands)
                : base(navPriceCodeCommands)
        {
            _commonCommands = commonCommands;
            _navPriceCodeCommands = navPriceCodeCommands;

        }

        public ActionResult SyncPurchasePricesDataFromNav()
        {
            IList<NavPriceCodeView> navpriceCodeViewList = _currentEntityCommands.GetAllData();
            var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavPriceCode);
            var route = SessionProvider.ActiveUser.LastRoute;
            if (navpriceCodeViewList == null)
			{
				displayMessage.Description = "No record found from Dynamic Nav to sync data for price code.";
			}

			return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
        }
    }
}

