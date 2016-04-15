using M4PL.APIClient;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    public class UserController : Controller
    {
        //
        // GET: /User/

        User obj = new User();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult UsersGridPartial()
        {
            return PartialView("_UsersGridPartial", API_User.GetAllUsers());
        }

        //
        // GET: /User/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /User/Create

        public ActionResult Create()
        {
            return View(obj);
        }

        //
        // POST: /User/Create
        
        [HttpPost]
        public ActionResult Create(M4PL.Entities.User user)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // TODO: Add insert logic here
                    if (API_User.AddUser(user) > 0)
                        return RedirectToAction("Index");
                    else
                        return View(obj);
                }
                else
                    return View(obj);
            }
            catch
            {
                return View(obj);
            }
        }

        //
        // GET: /User/Edit/5

        public ActionResult Edit(int SysUserID)
        {
            return View();
        }

        //
        // POST: /User/Edit/5

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
        // GET: /User/Delete/5

        public ActionResult Delete(int Id)
        {
            if (API_User.RemoveUserAccount(Id) > 0)
                return RedirectToAction("Index");
            else
                return null;
        }

        //
        // POST: /User/Delete/5

        [HttpPost]
        public ActionResult Delete(int Id, FormCollection collection)
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


        //public JsonResult GetAllUserAccounts(List<User> lstUsers)
        //{
        //    return Json(lstUsers, JsonRequestBehavior.AllowGet);
        //} 

    }
}
