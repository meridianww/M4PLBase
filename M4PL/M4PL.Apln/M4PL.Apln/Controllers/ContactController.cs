using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.Entities.DisplayModels;

namespace M4PL_Apln.Controllers
{
    public class ContactController : Controller
    {
        //
        // GET: /Contact/
		disContact objContact = new disContact();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Contact()
        {
            return View(objContact);
        }


    }
}
