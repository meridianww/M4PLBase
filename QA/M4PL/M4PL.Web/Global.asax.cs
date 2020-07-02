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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 MvcApplication
//Purpose:                                      Provides all the global events for  application
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient;
using M4PL.Utilities;
using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

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
			DevExpress.Web.ASPxWebControl.BackwardCompatibility.DataControlAllowReadUnexposedColumnsFromClientApiDefaultValue = false;
			//Uncomment below line want to handle new report wizard and don't want to use database save and load
			// DevExpress.XtraReports.Web.Extensions.ReportStorageWebExtension.RegisterExtensionGlobal(new GlobalReportStorageWebExtension());
			DevExpress.DashboardWeb.DashboardInMemoryStorage storage = new DevExpress.DashboardWeb.DashboardInMemoryStorage();
			DevExpress.DashboardWeb.DashboardConfigurator.Default.SetDashboardStorage(storage);
			storage.RegisterDashboard("dashboard1", System.Xml.Linq.XDocument.Load(System.Web.Hosting.HostingEnvironment.MapPath(@"~\Providers\DashboardXml.xml")));
			var initialize = SingleInstance.GetInstance;
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
			DevExpress.Web.ASPxWebControl.GlobalTheme = HttpContext.Current.Session != null && !string.IsNullOrWhiteSpace(Convert.ToString(HttpContext.Current.Session[WebApplicationConstants.UserTheme])) ? Convert.ToString(HttpContext.Current.Session[WebApplicationConstants.UserTheme]) : "Office2010Black";
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

			var exception = HttpContext.Current.Server.GetLastError();

			if (DevExpressHelper.IsCallback) //Devexpress callbacks have to be handled by callbackErrorRedirectUrl
			{
				Session["Application_Error"] = exception?.Message;
				DevExpress.Web.ASPxWebControl.SetCallbackErrorMessage(exception?.Message);
				Server.ClearError();
				return;
			}
			return;
		}
	}
}