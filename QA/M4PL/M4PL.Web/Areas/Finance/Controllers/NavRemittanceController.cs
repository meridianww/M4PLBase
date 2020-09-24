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
            //strRoute = string.IsNullOrEmpty(strRoute) && SessionProvider.NavRemittanceData != null ?
            //    ((IList<NavRemittanceView>)SessionProvider.NavRemittanceData).FirstOrDefault().StrRoute : strRoute;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.Action = MvcConstants.ActionForm;
            route.IsPopup = true;
            //if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            //    SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            //_formResult.SessionProvider = SessionProvider;
            //var recordData = (IList<NavRemittanceView>)SessionProvider.NavRemittanceData;
            //if (recordData == null || (recordData != null && recordData.Count == 0))
            //{
            //    IList<NavRemittanceView> NavRemittanceList = _navRemittanceCommands.GetAllNavRemittance();
            //    if (NavRemittanceList != null && NavRemittanceList.Count > 0)
            //    {
            //        foreach (var navRemittanceView in NavRemittanceList)
            //        {
            //            navRemittanceView.StrRoute = strRoute;
            //        }
            //    }
            //    SessionProvider.NavRemittanceData = NavRemittanceList;
            //    recordData = (IList<NavRemittanceView>)SessionProvider.NavRemittanceData;
            //}

            return PartialView(_formResult);
        }
    }
}