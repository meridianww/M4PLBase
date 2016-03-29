using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL_Apln.Models;

namespace M4PL_Apln.Controllers
{
    public class ContactController : Controller
    {
        //
        // GET: /Contact/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Contact()
        {
            Contact contact = new Contact();
            return View(contact);
        }

    }
}
