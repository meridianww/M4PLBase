﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 CustDashboardController
//Purpose:                                      Contains Actions to render view on Customer's CustDashboard
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Controllers;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web.Areas.Customer.Controllers
{
	public class CustDashboardController : MvcBaseController
	{
		protected DashboardResult<AppDashboardView> _dashboardResult
			= new DashboardResult<AppDashboardView>();// { DashboardSourceModel = new DevExpress.DashboardWeb.Mvc.DashboardSourceModel() };

		public CustDashboardController(ICommonCommands commonCommands)
		{
			_commonCommands = commonCommands;
		}

		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			if (SessionProvider == null || SessionProvider.ActiveUser == null)
				filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", MvcConstants.ActionIndex }, { "area", string.Empty } });
			else
			{
				_commonCommands.ActiveUser = SessionProvider.ActiveUser;

				if (SessionProvider.UserColumnSetting == null || string.IsNullOrEmpty(SessionProvider.UserColumnSetting.ColTableName)
					|| !SessionProvider.UserColumnSetting.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.AppDashboard.ToString()))
				{
					SessionProvider.UserColumnSetting = _commonCommands.GetUserColumnSettings(EntitiesAlias.AppDashboard);
				}

				if (SessionProvider.ActiveUser != null && !filterContext.ActionDescriptor.ActionName.Equals("GetLastCallDateTime"))
					SessionProvider.ActiveUser.LastAccessDateTime = System.DateTime.Now;
			}
			base.OnActionExecuting(filterContext);
		}

		public ActionResult Dashboard(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			route.SetParent(EntitiesAlias.Customer, _commonCommands.Tables[EntitiesAlias.Customer].TblMainModuleId);
			route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
			_dashboardResult.SetupDashboardResult(_commonCommands, route, SessionProvider);
			if (_dashboardResult.DashboardRoute.RecordId > 0)
				return PartialView(MvcConstants.ViewDashboard, _dashboardResult);
			return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoDashboard));
		}

		public ActionResult DashboardViewer(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			route.SetParent(EntitiesAlias.CustDashboard, _commonCommands.Tables[EntitiesAlias.Customer].TblMainModuleId);
			_dashboardResult.DashboardRoute = new MvcRoute(route, MvcConstants.ActionDashboardViewer);
			//_dashboardResult.DashboardSourceModel.DashboardId = route.RecordId.ToString();
			//_dashboardResult.DashboardSourceModel.DashboardLoading = (sender, e) =>
			//{
			//    if (route.RecordId.ToString().EqualsOrdIgnoreCase(e.DashboardId))
			//    {
			//        _commonCommands.ActiveUser = SessionProvider.ActiveUser;
			//        var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.DshTemplate.ToString());
			//        var dbDashboard = _commonCommands.GetByteArrayByIdAndEntity(byteArray);
			//        if (dbDashboard != null && dbDashboard.Bytes != null && dbDashboard.Bytes.Length > 50)
			//            using (System.IO.MemoryStream ms = new System.IO.MemoryStream(dbDashboard.Bytes))
			//            using (System.IO.StreamReader streamReader = new System.IO.StreamReader(ms))
			//                e.DashboardXml = streamReader.ReadToEnd();
			//    }
			//};
			return PartialView(MvcConstants.ViewDashboardViewer, _dashboardResult);
		}

		public override ActionResult RibbonMenu(string strRoute)
		{
			if (_commonCommands == null)
			{
				_commonCommands = new CommonCommands();
				_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			}
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			route.OwnerCbPanel = WebApplicationConstants.RibbonCbPanel;

			var ribbonMenus = _commonCommands.GetRibbonMenus().ToList();

			if (WebGlobalVariables.ModuleMenus.Count == 0)
				WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

			var mainModuleRibbons = (from mnu in WebGlobalVariables.ModuleMenus
									 join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
									 where mnu.MnuBreakDownStructure.StartsWith("01")
									 select mnu.SetRibbonMenu()).ToList();

			SessionProvider.UserSecurities.ToList().ForEach(sec => mainModuleRibbons.GetNotAccessibleMenus(sec).ForEach(nmnu => mainModuleRibbons.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));

			//Comment this line if want to show on ribbon if it has no operations to perform
			mainModuleRibbons.RemoveAll(mnu => mnu.Children.Count == 0);

			ribbonMenus.AddRange(mainModuleRibbons);
			ViewData[MvcConstants.LastActiveTabRoute] = route;
			ribbonMenus.ForEach(r => r.RibbonRoute(route, ribbonMenus.IndexOf(r), new MvcRoute { Entity = EntitiesAlias.CustDashboard, Area = EntitiesAlias.Customer.ToString() }, _commonCommands, SessionProvider));
			return PartialView(MvcConstants.ViewRibbonMenu, ribbonMenus);
		}
	}
}