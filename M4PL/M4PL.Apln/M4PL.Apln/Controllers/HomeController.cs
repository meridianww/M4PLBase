
using M4PL_Apln.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_API.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";
            return View(NorthwindDataProvider.GetCustomers());
            //return View(GetData());
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
            return PartialView("SchedulerPartial", GetData());
        }

        public ActionResult Report()
        {
            return View(NorthwindDataProvider.GetAllReports());
        }

        private object GetData()
        {
            var model = new SchedulerModel
            {
                Appointments = new[]
                {
                    new AppointmentModel() { Id=1, Title="Meeting 1", Start=DateTime.Today, End = DateTime.Today.AddHours(2), Resource = 1},
                    new AppointmentModel() { Id=1, Title="Meeting 2", Start=DateTime.Today, End = DateTime.Today.AddHours(3), Resource = 1}
                },
                Resources = new[]
                {
                    new ResourceModel() { Id = 1, Title = "Manager"}
                }
            };

            return model;
        }

    }

    [Serializable]
    public class SchedulerModel
    {
        public AppointmentModel[] Appointments { get; set; }
        public ResourceModel[] Resources { get; set; }
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
}
