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
    public class UserController : Controller
    {
        //
        // GET: /User/

        static Response<User> res = new Response<User>();

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult UsersGridPartial()
        {
            return PartialView("_UsersGridPartial", API_User.GetAllUsers().DataList);
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
            res = new Response<User>();
            res.Data = new User();
            return View(res);
        }

        //
        // POST: /User/Create

        [HttpPost]
        public ActionResult Create(User user)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // TODO: Add insert logic here
                    res = API_User.SaveUser(user);
                    if (res.Status)
                        return RedirectToAction("Index");
                    else
                    {
                        res.Data = user;
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
        // GET: /User/Edit/5

        public ActionResult Edit(int Id)
        {
            res = API_User.GetUserAccount(Id);
            return View(res);
        }

        //
        // POST: /User/Edit/5

        [HttpPost]
        public ActionResult Edit(int Id, User user)
        {
            try
            {
                // TODO: Add update logic here
                if (Id > 0 && ModelState.IsValid)
                {
                    user.SysUserID = Id;
                    res = API_User.SaveUser(user);
                    if (res.Status)
                        return RedirectToAction("Index");
                    else
                    {
                        res.Data = user;
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
        // GET: /User/Delete/5

        public ActionResult Delete(int Id)
        {
            res = API_User.RemoveUserAccount(Id);
            return RedirectToAction("Index");
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
