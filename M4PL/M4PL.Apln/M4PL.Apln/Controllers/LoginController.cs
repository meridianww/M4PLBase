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

        User user = new User();

        public ActionResult Index()
        {
            return View("Index", user);
        }

    }
}
