//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/4/2016
//Program Name:                                 Organization
//Purpose:                                      Providing view to list Organization
//
//==================================================================================================================================================== 

using M4PL.APIClient;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using M4PL_Apln.App_Start;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    [HandleResourceNotFound]
    public class OrganizationController : Controller
    {
        //
        // GET: /Organization/
        static Response<Organization> res = new Response<Organization>();
        public static Contact orgContact { get { return API_Contact.GetContactDetails(0).Data; } }

        void SetOrganizationContact()
        {
            if (res.Data.OrgContact != null)
                res.Data.OrgContact = new OrgContact();
            if (orgContact != null)
            {
                res.Data.OrgContact.LblContactID = orgContact.LblContactID;
                res.Data.OrgContact.LblConTitle = orgContact.LblConTitle;
                res.Data.OrgContact.LblConFirstName = orgContact.LblConFirstName;
                res.Data.OrgContact.LblConMiddleName = orgContact.LblConMiddleName;
                res.Data.OrgContact.LblConLastName = orgContact.LblConLastName;
                res.Data.OrgContact.LblConEmailAddress = orgContact.LblConEmailAddress;
                res.Data.OrgContact.LblConEmailAddress2 = orgContact.LblConEmailAddress2;
                res.Data.OrgContact.LblConBusinessPhone = orgContact.LblConBusinessPhone;
                res.Data.OrgContact.LblConMobilePhone = orgContact.LblConMobilePhone;
                res.Data.OrgContact.LblConHomePhone = orgContact.LblConHomePhone;
                res.Data.OrgContact.LblConFaxNumber = orgContact.LblConFaxNumber;
            }
        }

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult OrganizationGridPartial()
        {
            res.DataList = API_Organization.GetAllOrganizations().DataList;
            if (Session[SessionNames.OrgLayout] != null)
                API_RefOptions.SaveGridLayout(new GridLayout("Organization", 0, (string)Session[SessionNames.OrgLayout]));
            else
                Session[SessionNames.OrgLayout] = API_RefOptions.GetSavedGridLayout("Organization", 0).ToString();
            return PartialView("_OrganizationGridPartial", res);
        }

        public ActionResult OrganizationComboBoxPartial()
        {
            return PartialView("_OrganizationComboBoxPartial", API_Organization.GetAllOrganizations().DataList);
        }

        //
        // GET: /Organization/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Organization/Create

        public ActionResult Create()
        {
            res = new Response<Organization>();
            res = API_Organization.GetOrganizationDetails(0);
            this.SetOrganizationContact();
            return View(res);
        }

        //
        // POST: /Organization/Create

        [HttpPost]
        public ActionResult Create(Organization Org)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    res = API_Organization.SaveOrganization(Org);
                    if (res.Status)
                        return RedirectToAction("Index");
                    else
                    {
                        res.Data = Org;
                        return View(res);
                    }
                }
                else
                {
                    res.Data = Org;
                    return View(res);
                }
            }
            catch
            {
                return View(res);
            }
        }

        //
        // GET: /Organization/Edit/5
        public ActionResult Edit(int Id)
        {
            res = API_Organization.GetOrganizationDetails(Id);
            this.SetOrganizationContact();
            return View(res);
        }

        //
        // POST: /Organization/Edit/5
        [HttpPost]
        public ActionResult Edit(int Id, Organization Org)
        {
            try
            {
                // TODO: Add update logic here
                if (Id > 0 && ModelState.IsValid)
                {
                    Org.OrganizationID = Id;
                    res = API_Organization.SaveOrganization(Org);
                    if (res.Status)
                        return RedirectToAction("Index");
                    else
                    {
                        res.Data = Org;
                        return View(res);
                    }
                }
                else
                    return View(res);
            }
            catch
            {
                return View(res);
            }
        }

        //
        // GET: /Organization/Delete/5

        public ActionResult Delete(int Id)
        {
            res = API_Organization.RemoveOrganization(Id);
            return RedirectToAction("Index");
        }

        //
        // POST: /Organization/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        public ActionResult OrganizationContactFormPartial(int ContactID = 0)
        {
            var data = API_Contact.GetContactDetails(ContactID).Data;
            res.Data.OrgContact = new OrgContact();
            if (data != null)
            {
                res.Data.OrgContact.BusinessPhone = data.ConBusinessPhone;
                res.Data.OrgContact.ContactID = data.ContactID;
                res.Data.OrgContact.Email = data.ConEmailAddress;
                res.Data.OrgContact.Email2 = data.ConEmailAddress2;
                res.Data.OrgContact.Fax = data.ConFaxNumber;
                res.Data.OrgContact.FirstName = data.ConFirstName;
                res.Data.OrgContact.HomePhone = data.ConHomePhone;
                res.Data.OrgContact.LastName = data.ConLastName;
                res.Data.OrgContact.MiddleName = data.ConMiddleName;
                res.Data.OrgContact.MobilePhone = data.ConMobilePhone;
                res.Data.OrgContact.Title = data.ConTitle;
            }
            return Json(res.Data.OrgContact, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SetGridProperties()
        {
            res.ShowFilterRow = (!res.ShowFilterRow);
            return Json(true, JsonRequestBehavior.AllowGet);
        }
    }
}
