//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              4/4/2016
//Program Name:                                 Home
//Purpose:                                      Providing view for Home webpage details
//
//==================================================================================================================================================== 

using M4PL_Apln;
using M4PL_Apln.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using M4PL_Apln.App_Start;
using System.Globalization;

namespace M4PL_API.Controllers
{
    [HandleResourceNotFound]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";
            //return View(NorthwindDataProvider.GetCustomers());
            //return View(GetData());
            return View(new HomeModel(NorthwindDataProvider.GetCustomers(), GetScheduleData()));
        }

        public ActionResult ChangeLang(string language)
        {
            ViewBag.Title = "Home Page";
            Session["CurrentCulture"] = CultureInfo.GetCultureInfo(language);
            M4PL_API_CommonUtils.Languages.ApplyCurrentCulture();

            return View("Index", new HomeModel(NorthwindDataProvider.GetCustomers(), GetScheduleData()));
        }

        public ActionResult Theme(string theme)
        {
            ViewBag.Title = "Home Page";
            MvcApplication.Theme = theme;
            new MvcApplication().Application_PreRequestHandlerExecute(null, new EventArgs());
            return View("Index", new HomeModel(NorthwindDataProvider.GetCustomers(), GetScheduleData()));
        }

        public ActionResult MasterDetailMasterPartial()
        {

            return PartialView("MasterDetailMasterPartial", NorthwindDataProvider.GetCustomers());
        }
        public ActionResult MasterDetailDetailPartial(int employeeID)
        {
            ViewData["CustomerID"] = employeeID;
            return PartialView("MasterDetailDetailPartial", NorthwindDataProvider.GetOrders(employeeID));
        }

        public ActionResult SchedulerPartial()
        {
            return PartialView("SchedulerPartial", GetScheduleData());
        }

        public ActionResult Report()
        {
            return View(NorthwindDataProvider.GetAllReports());
        }

        private SchedulerModel GetScheduleData()
        {
            return new SchedulerModel();
        }

        public ActionResult PivotGrid()
        {
            return View();
        }

        [ValidateInput(false)]
        public ActionResult PivotGridPartial()
        {
            return PartialView("_PivotGridPartial", NorthwindDataProvider.GetPivotData());
        }
    }

    [Serializable]
    public class SchedulerModel
    {
        public AppointmentModel[] Appointments { get; set; }
        public ResourceModel[] Resources { get; set; }

        public SchedulerModel()
        {
            this.Appointments = new[]
            {
                new AppointmentModel() { Id=1, Title="Meeting 1", Start=DateTime.Today, End = DateTime.Today.AddHours(2), Resource = 1},
                new AppointmentModel() { Id=1, Title="Meeting 2", Start=DateTime.Today, End = DateTime.Today.AddHours(3), Resource = 1},
                new AppointmentModel() { Id=2, Title="Meeting 3", Start=DateTime.Today.AddDays(3), End = DateTime.Today.AddDays(3).AddHours(1), Resource = 2},
                new AppointmentModel() { Id=2, Title="Meeting 4", Start=DateTime.Today.AddDays(3), End = DateTime.Today.AddDays(3).AddHours(3), Resource = 2}
            };
            this.Resources = new[]
            {
                new ResourceModel() { Id = 1, Title = "Manager"},
                new ResourceModel() { Id = 2, Title = "Workers"}
            };
        }
    }
    [Serializable]
    public class AppointmentModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public int Resource { get; set; }
    }
    [Serializable]
    public class ResourceModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
    }

    [Serializable]
    public class HomeModel
    {
        public IEnumerable GetCustomers { get; set; }
        public SchedulerModel SchedulerModel { get; set; }

        public HomeModel(IEnumerable getCustomers, SchedulerModel schedulerModel)
        {
            this.GetCustomers = getCustomers;
            this.SchedulerModel = schedulerModel;
        }
    }

}
