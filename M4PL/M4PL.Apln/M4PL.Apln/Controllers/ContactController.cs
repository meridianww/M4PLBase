using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.Entities;
using M4PL_API_CommonUtils.APICalls;
using DevExpress.Web.Mvc;

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

        [ValidateInput(false)]
        public ActionResult ContactsGridPartial()
        {
            return PartialView("_ContactsGridPartial", API_Contact.GetAllContacts());
        }

    }
}
