﻿using M4PL.APIClient;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    public class OrganizationController : Controller
    {
        //
        // GET: /Organization/
        Organization obj = new Organization();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult OrganizationGridPartial()
        {
            return PartialView("_OrganizationGridPartial", API_Organization.GetAllOrganizations());
        }

        public ActionResult OrganizationComboBoxPartial()
        {
            return PartialView("_OrganizationComboBoxPartial", API_Organization.GetAllOrganizations());
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
            return View(obj);
        }

        //
        // POST: /Organization/Create

        [HttpPost]
        public ActionResult Create(Organization Org)
        {
            try
            {
                if (API_Organization.SaveOrganization(Org) > 0)
                    return RedirectToAction("Index");
                else
                    return View(Org);
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Organization/Edit/5
        public ActionResult Edit(int Id)
        {
            obj = API_Organization.GetOrganizationDetails(Id);
            return View(obj);
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
                    if (API_Organization.SaveOrganization(Org) > 0)
                        return RedirectToAction("Index");
                    else
                        return View(Org);
                }
                else
                    return View(Org);
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Organization/Delete/5

        public ActionResult Delete(int Id)
        {
            if (API_Organization.RemoveOrganization(Id) > 0)
                return RedirectToAction("Index");
            else
                return null;
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
    }
}
