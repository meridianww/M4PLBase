/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 MvcApplication
//Purpose:                                      Provides all the global events for  application
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient;
using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Collections.Generic;

namespace M4PL.Web
{
    public class MvcApplication : HttpApplication
    {
        private static bool _runThrough;
        private static readonly object LockObject = new object();
        protected void Application_Start()
        {
            DashboardConfig.RegisterService(RouteTable.Routes);
            DevExpress.XtraReports.Web.WebDocumentViewer.Native.WebDocumentViewerBootstrapper.SessionState = System.Web.SessionState.SessionStateBehavior.Disabled;
            DevExpress.XtraReports.Web.QueryBuilder.Native.QueryBuilderBootstrapper.SessionState = System.Web.SessionState.SessionStateBehavior.Disabled;
            DevExpress.XtraReports.Web.ReportDesigner.Native.ReportDesignerBootstrapper.SessionState = System.Web.SessionState.SessionStateBehavior.Disabled;
            AutofacConfig.RegisterDependencies();
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            ModelBinders.Binders.DefaultBinder = new DevExpressEditorsBinder();
            DevExpress.Web.ASPxWebControl.CallbackError += Application_Error;
            //Uncomment below line want to handle new report wizard and don't want to use database save and load
            // DevExpress.XtraReports.Web.Extensions.ReportStorageWebExtension.RegisterExtensionGlobal(new GlobalReportStorageWebExtension());
        }

        public override void Init()
        {
            base.Init();
            // setup stuff & searches & etc
            lock (LockObject)
            {
                if (!_runThrough)
                    CoreCache.Initialize("EN"); //1 For Language EN
            }

            // set run through
            _runThrough = true;
        }

        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = !string.IsNullOrWhiteSpace(Convert.ToString(HttpContext.Current.Session[WebApplicationConstants.UserTheme])) ? Convert.ToString(HttpContext.Current.Session[WebApplicationConstants.UserTheme]) : "Office2010Black";
        }

        protected void Application_PreSendRequestHeaders(object sender, EventArgs e)
        {
            (sender as HttpApplication).Context.Response.AddHeader("X-UA-Compatible", "IE=11");
        }


        protected void Application_BeginRequest(Object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.SetIECompatibilityMode(11);
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();

            //To send mail
            //string body = String.Format(@"Login : '{0}' encountered the following error :
            //Exception : {1}", (Session["login"] != null ? Session["login"].ToString() : ""), (ex != null ? ex.ToString() : ""));
            //Utils.MailSender.SendMail("Web Error", body, false, ConfigurationManager.AppSettings["MailSenderFromMail"]);

            if (DevExpressHelper.IsCallback) //Devexpress callbacks have to be handled by callbackErrorRedirectUrl
                return;
            return;
            //var httpContext = ((MvcApplication)sender).Context;

            //var currentRouteData = RouteTable.Routes.GetRouteData(new HttpContextWrapper(httpContext));
            //var currentController = " ";
            //var currentAction = " ";

            //if (currentRouteData != null)
            //{
            //    if (currentRouteData.Values["controller"] != null && !String.IsNullOrEmpty(currentRouteData.Values["controller"].ToString()))
            //    {
            //        currentController = currentRouteData.Values["controller"].ToString();
            //    }

            //    if (currentRouteData.Values["action"] != null && !String.IsNullOrEmpty(currentRouteData.Values["action"].ToString()))
            //    {
            //        currentAction = currentRouteData.Values["action"].ToString();
            //    }
            //}
            //var controller = new MvcBaseController();
            //var routeData = new RouteData();
            //var action = "Index";

            //if (ex is HttpException)
            //{
            //    var httpEx = ex as HttpException;

            //    switch (httpEx.GetHttpCode())
            //    {
            //        case 404:
            //            action = "NotFound";
            //            break;

            //        default:
            //            action = "Index";
            //            break;
            //    }
            //}

            //httpContext.ClearError();
            //httpContext.Response.Clear();
            //httpContext.Response.StatusCode = ex is HttpException ? ((HttpException)ex).GetHttpCode() : 500;
            //httpContext.Response.TrySkipIisCustomErrors = true;
            //routeData.Values["controller"] = "Common";
            //routeData.Values["action"] = action;

            //controller.ViewData.Model = new HandleErrorInfo(ex, currentController, currentAction);
            //((IController)controller).Execute(new RequestContext(new HttpContextWrapper(httpContext), routeData));
        }
    }
}