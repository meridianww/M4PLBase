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

        Contact obj = new Contact();

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Contact contact, FormCollection collection)
        {
            try
            {
                HttpPostedFileBase file = Request.Files["ImageData"];
                if (file != null && file.ContentLength > 0)
                {
                    contact.Image = new byte[] { };
                    using (var binaryReader = new BinaryReader(file.InputStream))
                    {
                        contact.Image = binaryReader.ReadBytes(file.ContentLength);
                    }
                }
                if (API_Contact.SaveContact(contact) > 0)
                    return RedirectToAction("Index");
                else
                    return View(contact);
            }
            catch
            {
                return View(contact);
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
            return View(obj);
        }

        public ActionResult Delete(int Id)
        {
            if (API_Contact.RemoveContact(Id) > 0)
                return RedirectToAction("Index");
            else
                return null;
        }

        public ActionResult Edit(int Id)
        {
            obj = API_Contact.GetContactDetails(Id);
            if (obj != null)
            {
                obj.Image = obj.LstImages.ToArray();
            }
            return View(obj);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Edit(int Id, Contact contact, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here
                if (Id > 0 && ModelState.IsValid)
                {
                    contact.ContactID = Id;
                    HttpPostedFileBase file = Request.Files["ImageData"];
                    if (file != null && file.ContentLength > 0)
                    {
                        contact.Image = new byte[] { };
                        using (var binaryReader = new BinaryReader(file.InputStream))
                        {
                            contact.Image = binaryReader.ReadBytes(file.ContentLength);
                        }
                    }
                    if (API_Contact.SaveContact(contact) > 0)
                        return RedirectToAction("Index");
                    else
                        return View(contact);
                }
                else
                    return View(contact);
            }
            catch
            {
                return View();
            }
        }

    }
}
