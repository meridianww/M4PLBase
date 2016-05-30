//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              11/4/2016
//Program Name:                                 Contact
//Purpose:                                      Providing view to see Contact webpages for different operations
//
//==================================================================================================================================================== 

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.Entities;
using DevExpress.Web.Mvc;
using M4PL.APIClient;
using System.IO;
using M4PL_API_CommonUtils;

namespace M4PL_Apln.Controllers
{
    public class ContactController : Controller
    {
        //
        // GET: /Contact/

        static Response<Contact> res = new Response<Contact>();

        public ActionResult Index()
        {
            return View(res);
        }

        [HttpPost]
        public ActionResult Create(Contact contact, FormCollection collection)
        {
            try
            {
                HttpPostedFileBase file = Request.Files["ImageData"];
                contact.ConImage = new byte[] { };
                if (file != null && file.ContentLength > 0)
                {
                    using (var binaryReader = new BinaryReader(file.InputStream))
                    {
                        contact.ConImage = binaryReader.ReadBytes(file.ContentLength);
                    }
                }

                res = API_Contact.SaveContact(contact);

                if (res.Status)
                    return RedirectToAction("Index");
                else
                {
                    res.Data = contact;
                    return View(res);
                }
            }
            catch
            {
                res.Data = contact;
                return View(res);
            }
        }
    


        [ValidateInput(false)]
        public ActionResult ContactsGridPartial()
        {
            res.DataList = API_Contact.GetAllContacts().DataList;
            if (Session[SessionNames.ContactLayout] != null)
                API_RefOptions.SaveGridLayout(new GridLayout("Contact", 0, (string)Session[SessionNames.ContactLayout]));
            else
                Session[SessionNames.ContactLayout] = API_RefOptions.GetSavedGridLayout("Contact", 0).ToString();
            return PartialView("_ContactsGridPartial", res);
        }

        public ActionResult ContactsComboBoxPartial()
        {
            return PartialView("_ContactsComboBoxPartial", API_Contact.GetAllContacts().DataList);
        }

        public ActionResult Create()
        {
            res = new Response<Contact>();
            res.Data = new Contact();
            return View(res);
        }

        public ActionResult Delete(int Id)
        {
            res = API_Contact.RemoveContact(Id);
            return RedirectToAction("Index");
        }

        public ActionResult Edit(int Id)
        {
            res = API_Contact.GetContactDetails(Id);
            if (res.Data != null && res.Data.LstImages != null)
            {
                res.Data.ConImage = res.Data.LstImages.ToArray();
            }
            return View(res);
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
                    contact.ConImage = new byte[] { };
                    HttpPostedFileBase file = Request.Files["ImageData"];
                    if (file != null && file.ContentLength > 0)
                    {
                        using (var binaryReader = new BinaryReader(file.InputStream))
                        {
                            contact.ConImage = binaryReader.ReadBytes(file.ContentLength);
                        }
                    }
                    else
                    {
                        if (res.Data != null && res.Data.LstImages != null)
                        {
                            contact.ConImage = res.Data.LstImages.ToArray();
                        }
                    }

                    res = API_Contact.SaveContact(contact);

                    if (res.Status)
                        return RedirectToAction("Index");
                    else
                    {
                        res.Data = contact;
                        return View(res);
                    }
                }
                else
                {
                    res.Data = contact;
                    return View(res);
                }
            }
            catch
            {
                res.Data = contact;
                return View(res);
            }
        }

        public JsonResult SetGridProperties()
        {
            res.ShowFilterRow = (!res.ShowFilterRow);
            return Json(true, JsonRequestBehavior.AllowGet);
        }

    }
}
