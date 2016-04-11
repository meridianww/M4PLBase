using M4PL.APIClient;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    public class MenuDriverController : Controller
    {
        //
        // GET: /MenuDriver/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CreateRole()
        {
            return View();
        }

        public ActionResult CreateMenu()
        {
            return View();
        }

        [HttpPost]
        public ActionResult CreateRole(Roles obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (API_MenuDriver.AddRole(obj) > 0)
                        return RedirectToAction("Index");
                    else
                        return View(obj);
                }
                else
                    return View(obj);
            }
            catch
            {
                return View(obj);
            }
        }

        [ValidateInput(false)]
        public ActionResult RolesGridPartial()
        {
            return PartialView("_RolesGridPartial", API_MenuDriver.GetAllRoles());
        }

    }
}
