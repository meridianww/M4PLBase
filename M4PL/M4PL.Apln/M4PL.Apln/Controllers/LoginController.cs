using M4PL.APIClient;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    public class LoginController : Controller
    {
        //
        // GET: /Login/

        Login user = new Login();

        public ActionResult Index()
        {
            return View("Index", user);
        }

        [HttpPost]
        public ActionResult Login(Login obj)
        {
            if (ModelState.IsValid)
            {
                if (API_Login.GetLogin(obj.Email, obj.Password))
                    return RedirectToAction("Index", "Home");
                else
                    return View("Index", user);

            }
            return View("Index", user);
        }

    }
}
