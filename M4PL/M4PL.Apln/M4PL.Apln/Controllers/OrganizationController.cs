using M4PL.APIClient;
using M4PL.Entities;
using M4PL_API_CommonUtils;
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
        static Response<Organization> res = new Response<Organization>();

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult OrganizationGridPartial()
        {
            return PartialView("_OrganizationGridPartial", API_Organization.GetAllOrganizations().DataList);
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
            res.Data = new Organization();
            return View(res);
        }

        //
        // POST: /Organization/Create

        [HttpPost]
        public ActionResult Create(Organization Org)
        {
            try
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
    }
}
