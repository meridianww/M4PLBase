using M4PL.Entities;
using M4PL_API_CommonUtils.APICalls;
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
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Organization/Edit/5

        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Organization/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Organization/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
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
