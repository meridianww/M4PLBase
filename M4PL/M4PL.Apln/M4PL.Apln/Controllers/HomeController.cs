
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

    }
}
