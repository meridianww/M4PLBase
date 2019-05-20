/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 BaseDashboardController
//Purpose:                                      Contains Actions related to navigation, dataview and Formview
//====================================================================================================================================================*/
using DevExpress.DashboardWeb;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web.Areas
{
    public class BaseDashboardController : DevExpress.DashboardWeb.Mvc.DashboardController
    {
        protected DashboardResult<AppDashboardView> _dashboardResult = new DashboardResult<AppDashboardView>();

        protected ICommonCommands _commonCommands;
        protected IAppDashboardCommands _appDashboardCommands;
        protected Dictionary<string, Dictionary<string, object>> RowHashes { get; set; }
        public SessionProvider SessionProvider
        {
            get { return SessionProvider.Instance; }
        }

        public BaseDashboardController(DashboardConfigurator dashboardConfigurator)
            : base(dashboardConfigurator)
        {
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (SessionProvider == null || SessionProvider.ActiveUser == null)
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", MvcConstants.ActionIndex }, { "area", string.Empty } });
            else
            {
                if (SessionProvider.ActiveUser != null && !filterContext.ActionDescriptor.ActionName.Equals("GetLastCallDateTime"))
                    SessionProvider.ActiveUser.LastAccessDateTime = DateTime.Now;

                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
                _appDashboardCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            base.OnActionExecuting(filterContext);
        }



        #region Base Methods copied from Base and MvcBase Controller



        protected MvcRoute GetDefaultRoute()
        {
            if (SessionProvider.ActiveUser.LastRoute != null && SessionProvider.MvcPageAction.Count == 0)
                return SessionProvider.ActiveUser.LastRoute;

            SessionProvider.MvcPageAction.Clear();

            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            if (WebGlobalVariables.ModuleMenus.Count == 0)
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

            var leftMenus = (from mnu in WebGlobalVariables.ModuleMenus
                             join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
                             where mnu.MnuBreakDownStructure.StartsWith("02")
                             select mnu).ToList();
            SessionProvider.UserSecurities.ToList().ForEach(sec => leftMenus.GetNotAccessibleMenus(sec).ForEach(nmnu => leftMenus.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));
            //Comment this line if want to show on left menu if it has no operations to perform
            leftMenus.RemoveAll(mnu => mnu.Children.Count == 0);

            var defaultMenu = (from mnu in leftMenus
                               where mnu.MnuModuleId == SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysMainModuleId).ToInt()
                               select mnu).LastOrDefault().Children.FirstOrDefault(m => !string.IsNullOrEmpty(m.MnuTableName)); // because first might be ribbon and select where table/Controller name is not empty or null

            if (defaultMenu == null || string.IsNullOrEmpty(defaultMenu.MnuExecuteProgram) || !Enum.IsDefined(typeof(EntitiesAlias), defaultMenu.MnuTableName))
                defaultMenu = leftMenus.FirstOrDefault().Children.FirstOrDefault(m => !string.IsNullOrEmpty(m.MnuTableName));

            defaultMenu.Route = new MvcRoute
            {
                Entity = defaultMenu.MnuTableName.ToEnum<EntitiesAlias>(),
                Action = defaultMenu.MnuExecuteProgram,
                Area = !string.IsNullOrEmpty(defaultMenu.MnuTableName) && _commonCommands.Tables.ContainsKey(defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()) ? _commonCommands.Tables[defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()].MainModuleName : string.Empty,
                EntityName = !string.IsNullOrEmpty(defaultMenu.MnuTableName) && _commonCommands.Tables.ContainsKey(defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()) ? _commonCommands.Tables[defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()].TblLangName : string.Empty,
            };

            defaultMenu.Route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            ViewData[MvcConstants.DefaultRoute] = defaultMenu.Route;
            return defaultMenu.Route;
        }

        public ActionResult CallbackPanelPartial(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute) ?? GetDefaultRoute();

            //start- Not Found logic

            var controllerFullName = string.Format("M4PL.Web.Areas.{0}.Controllers.{1}Controller", route.Area, route.Entity.ToString());
            var cont = Assembly.GetExecutingAssembly().GetType(controllerFullName);
            if (!route.Action.EqualsOrdIgnoreCase("Dashboard") && !string.IsNullOrEmpty(route.Area) && (cont == null || cont.GetMethod(route.Action) == null))
            {
                var errorLog = new ErrorLog
                {
                    ErrRelatedTo = WebApplicationConstants.NotFoundError,
                    ErrInnerException = "Controller or action not found", // should be from database
                    ErrMessage = "Controller or action not found", // should be from database
                    ErrSource = route.Entity.ToString(),
                    ErrStackTrace = WebApplicationConstants.NotFoundError,
                    ErrAdditionalMessage = JsonConvert.SerializeObject(route)
                };
                  var mvcPageAction = SessionProvider.MvcPageAction;
                mvcPageAction.Add(_commonCommands.GetOrInsErrorLog(errorLog).Id, MvcConstants.ActionNotFound);
                SessionProvider.MvcPageAction = mvcPageAction;
                route = new MvcRoute(EntitiesAlias.Common, SessionProvider.MvcPageAction.FirstOrDefault().Value, string.Empty);
                route.RecordId = SessionProvider.MvcPageAction.FirstOrDefault().Key;
            }
            SessionProvider.MvcPageAction.Clear();
            //End
            SessionProvider.ActiveUser.LastRoute = route;
            if (DevExpress.Web.Mvc.DevExpressHelper.IsCallback)
                System.Threading.Thread.Sleep(100);
            return PartialView(MvcConstants.CallBackPanelPartial, route);
        }

        public ActionResult InnerCallbackPanelPartial(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.Action.Equals(MvcConstants.ActionRibbonMenu) && route.Entity == EntitiesAlias.Common)
            {
                var arbValue = route.OwnerCbPanel;
                route = new MvcRoute(GetDefaultRoute());
                route.OwnerCbPanel = arbValue;
            }
            if (DevExpress.Web.Mvc.DevExpressHelper.IsCallback)
                System.Threading.Thread.Sleep(100);
            return PartialView(MvcConstants.ViewInnerCallBackPanelPartial, route);
        }

        #endregion Base Methods copied from Base and MvcBase Controller

        public int GetorSetUserGridPageSize(int? pageSize = null)
        {
            var sysPageSize = SessionProvider.UserSettings.Settings.GetSettingByEntityAndName(_commonCommands.GetSystemSetting().Settings, EntitiesAlias.System, WebApplicationConstants.SysPageSize).ToInt();
            if (pageSize == null)
                return sysPageSize;
            else
            {
                if (pageSize != sysPageSize)
                {
                    SessionProvider.UserSettings.Settings.SetSettingByEnitityAndName(EntitiesAlias.System, WebApplicationConstants.SysPageSize, pageSize.Value.ToString());
                    _commonCommands.UpdateUserSystemSettings(SessionProvider.UserSettings);
                }
                return pageSize.Value;
            }
        }
    }
}