using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.Entities;
using DevExpress.Web.Mvc;
using M4PL.APIClient;
using System.IO;

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

        [HttpPost]
        public ActionResult Create(Contact obj, FormCollection collection)
        {
            try
            {
                HttpPostedFileBase file = Request.Files["ImageData"];
                if (file != null && file.ContentLength > 0)
                {
                    obj.Image = new byte[] { };
                    using (var binaryReader = new BinaryReader(file.InputStream))
                    {
                        obj.Image = binaryReader.ReadBytes(file.ContentLength);
                    }
                }
                if (API_Contact.SaveContact(obj) > 0)
                    return RedirectToAction("Index");
                else
                    return View(obj);
            }
            catch
            {
                return View(obj);
            }
        }

        [ValidateInput(false)]
        public ActionResult ContactsGridPartial()
        {
            return PartialView("_ContactsGridPartial", API_Contact.GetAllContacts());
        }

        public ActionResult ContactsComboBoxPartial()
        {
            return PartialView("_ContactsComboBoxPartial", API_Contact.GetAllContacts());
        }

        public ActionResult Create()
        {
            return View();
        }

        public ActionResult Delete(int Id)
        {
            if (API_Contact.RemoveContact(Id) > 0)
                return RedirectToAction("Index");
            else
                return null;
        }

    }
}
