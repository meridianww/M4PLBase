/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 DashboardConfig
Purpose:                                      Contains the Configuration related to Dashboard
==========================================================================================================*/
using DevExpress.DashboardWeb;
using DevExpress.DashboardWeb.Mvc;
using M4PL.APIClient.Common;
using M4PL.Web.Providers;
using System.Web.Routing;

namespace M4PL.Web
{
    public class DashboardConfig
    {
        static DashboardConfigurator appDashboardConfigurator;
        static DashboardConfigurator orgAppDashboardConfigurator;
        static DashboardConfigurator custAppDashboardConfigurator;
        static DashboardConfigurator vendAppDashboardConfigurator;

        static DashboardConfigurator programAppDashboardConfigurator;
        static DashboardConfigurator jobAppDashboardConfigurator;
        static DashboardConfigurator contactAppDashboardConfigurator;


        public static DashboardConfigurator AppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (appDashboardConfigurator == null)
            {
                appDashboardConfigurator = new DashboardConfigurator();
                appDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return appDashboardConfigurator;
        }

        public static DashboardConfigurator OrgAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (orgAppDashboardConfigurator == null)
            {
                orgAppDashboardConfigurator = new DashboardConfigurator();
                orgAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return orgAppDashboardConfigurator;
        }

        public static DashboardConfigurator CustAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (custAppDashboardConfigurator == null)
            {
                custAppDashboardConfigurator = new DashboardConfigurator();
                custAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return custAppDashboardConfigurator;
        }

        public static DashboardConfigurator VendAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (vendAppDashboardConfigurator == null)
            {
                vendAppDashboardConfigurator = new DashboardConfigurator();
                vendAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return vendAppDashboardConfigurator;
        }


        public static DashboardConfigurator ProgramAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (programAppDashboardConfigurator == null)
            {
                programAppDashboardConfigurator = new DashboardConfigurator();
                programAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return programAppDashboardConfigurator;
        }

        public static DashboardConfigurator JobAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (jobAppDashboardConfigurator == null)
            {
                jobAppDashboardConfigurator = new DashboardConfigurator();
                jobAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return jobAppDashboardConfigurator;
        }

        public static DashboardConfigurator ContactAppDashboardConfigurator(ICommonCommands commonCommands, int moduleId = 0)
        {
            if (contactAppDashboardConfigurator == null)
            {
                contactAppDashboardConfigurator = new DashboardConfigurator();
                contactAppDashboardConfigurator.SetDashboardStorage(new CustomDashboardStorage(commonCommands, moduleId));
            }
            return contactAppDashboardConfigurator;
        }


        public static void RegisterService(RouteCollection routes)
        {
            routes.MapDashboardRoute("Administration", "AppDashboard", new string[] { "M4PL.Web.Areas.Administration.Controllers" }, "Administration");
            routes.MapDashboardRoute("Contact", "AppDashboard", new string[] { "M4PL.Web.Areas.Contact.Controllers" }, "Contact");
            routes.MapDashboardRoute("Customer", "AppDashboard", new string[] { "M4PL.Web.Areas.Customer.Controllers", "Customer" });
            routes.MapDashboardRoute("Job", "AppDashboard", new string[] { "M4PL.Web.Areas.Job.Controllers" }, "Job");
            routes.MapDashboardRoute("Organization", "AppDashboard", new string[] { "M4PL.Web.Areas.Organization.Controllers" }, "Organization");
            routes.MapDashboardRoute("Program", "AppDashboard", new string[] { "M4PL.Web.Areas.Program.Controllers" }, "Program");
            routes.MapDashboardRoute("Vendor", "AppDashboard", new string[] { "M4PL.Web.Areas.Vendor.Controllers" }, "Vendor");
        }
    }
}