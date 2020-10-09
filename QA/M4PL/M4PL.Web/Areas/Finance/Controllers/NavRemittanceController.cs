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
//Programmer:                                   Kamal
//Date Programmed:                              06/23/2020
//Program Name:                                 NavRemittance
//Purpose:                                      Contains Actions to render view on Nav Remittance over the Pages in the system
//====================================================================================================================================================*/


using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.ViewModels.NavRemittance;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavRemittanceController : BaseController<NavRemittanceView>
    {
        public INavRemittanceCommands _navRemittanceCommands;
        public NavRemittanceController(ICommonCommands commonCommands, INavRemittanceCommands navRemittanceCommands)
            : base(navRemittanceCommands)
        {
            _commonCommands = commonCommands;
            _navRemittanceCommands = navRemittanceCommands;
        }
        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.Action = MvcConstants.ActionForm;
            route.IsPopup = true;
            _formResult.CallBackRoute = route;
            _formResult.SessionProvider = SessionProvider;
            _formResult.ColumnSettings = _commonCommands.GetColumnSettings(Entities.EntitiesAlias.NavRemittance, false);
            _formResult.Permission = Entities.Permission.All;
            return PartialView(_formResult);
        }

        public ActionResult IsInvoiceAvailable(string checkNo)
        {
            if (string.IsNullOrEmpty(checkNo)) return Json(false, JsonRequestBehavior.AllowGet);
            try
            {
                var result = _navRemittanceCommands.GetPostedInvoicesByCheckNumber(checkNo);
                if (result != null && !string.IsNullOrEmpty(result.DocumentName) && result.DocumentContent != null)
                {
                    TempData["OrderInvoice"] = result;
                    return Json(true, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
            }
            return Json(false, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DownloadInvoice()
        {
            if (TempData["OrderInvoice"] == null) return null;
            try
            {
                var result = (Entities.Document.DocumentData)TempData["OrderInvoice"];
                if (result != null && !string.IsNullOrEmpty(result.DocumentName) && result.DocumentContent != null)
                    return File(result.DocumentContent, result.ContentType, result.DocumentName);
                return View();
            }
            catch (Exception ex)
            {
                return View();
            }
        }
    }
}