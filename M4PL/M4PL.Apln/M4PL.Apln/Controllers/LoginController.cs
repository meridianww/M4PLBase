using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.Entities;
using System.Web.Security;

namespace M4PL_Apln.Controllers
{
    public class LoginController : Controller
    {
        //
        // GET: /Login/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult UserLogin()
        {
            User user = new User();
            return View("Login",user);
        }

        [HttpPost]
        public bool SetFormAuthentication(User user)
        {
            if (user.IsValidUser)
            {
                FormsAuthentication.SetAuthCookie(user.Email, true);
                //return RedirectToAction("Index", "Home");
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
