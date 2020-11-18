#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Web.Optimization;

namespace M4PL.Web
{
	public class BundleConfig
	{
		// For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
		public static void RegisterBundles(BundleCollection bundles)
		{
			bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
				"~/Scripts/jquery-{version}.js"));

			bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
				"~/Scripts/jquery.validate*"));

			bundles.Add(new ScriptBundle("~/bundles/unobtrusive").Include(
			  "~/Scripts/jquery.unobtrusive-ajax*"));

			// Use the development version of Modernizr to develop with and learn from. Then, when you're
			// ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
			bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
				"~/Scripts/modernizr-*"));

			bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
				"~/Scripts/bootstrap.js",
				"~/Scripts/respond.js"));

			bundles.Add(new ScriptBundle("~/bundles/M4PLWindow").Include(
				"~/M4PLScripts/Common.js",
				 "~/M4PLScripts/DevExControl.js",
				 "~/Scripts/moment.js",
				"~/M4PLScripts/Window.js",
				 "~/M4PLScripts/Job.js"
				));

			//bundles.Add(new ScriptBundle("~/bundles/M4PLPopupWindow").Include(
			//	"~/M4PLScripts/Common.js",
			//	 "~/M4PLScripts/DevExControl.js",
			//	  "~/Scripts/moment.js"
			//	));

			bundles.Add(new StyleBundle("~/Content/css").Include(
				"~/Content/bootstrap.css",
				"~/Content/site.css"));

			//// Clear all items from the ignore list to allow minified CSS and JavaScript files in debug mode
			bundles.IgnoreList.Clear();

			// Add back the default ignore list rules sans the ones which affect minified files and debug mode
			bundles.IgnoreList.Ignore("*.intellisense.js");
			bundles.IgnoreList.Ignore("*-vsdoc.js");
			bundles.IgnoreList.Ignore("*.debug.js", OptimizationMode.WhenEnabled);

			//// To test optimizations
			// BundleTable.EnableOptimizations = true;
		}
	}
}