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
    public class MenuDriverController : Controller
    {
        //
        // GET: /MenuDriver/

        static Response<Menus> res = new Response<Menus>();

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult Create()
        {
            res = new Response<Menus>();
            res.Data = new Menus();
            return View(res);
        }

        public ActionResult Edit(int Id)
        {
            res = new Response<Menus>();
            res.Data = new Menus();
            res.Data.MenuID = Id;
            return View(res);
        }

        [HttpPost]
        public ActionResult Create(Menus value, FormCollection collection)
        {
            res = new Response<Menus>();
            res.Data = value;
            return View(value);
        }

        [HttpPost]
        public ActionResult Edit(int Id, Menus value, FormCollection collection)
        {
            res = new Response<Menus>();
            res.Data = value;
            res.Data.MenuID = Id;
            return View(value);
        }

        [ValidateInput(false)]
        public ActionResult MenusGridPartial()
        {
            return PartialView("_MenusGridPartial", API_MenuDriver.GetAllMenus().DataList);
        }

        #region Old Code of Menu Driver

        //public ActionResult CreateRole()
        //{
        //    return View();
        //}

        //public ActionResult CreateMenu()
        //{
        //    return View();
        //}

        //[HttpPost]
        //public ActionResult CreateRole(Roles obj)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            if (API_MenuDriver.AddRole(obj) > 0)
        //                return RedirectToAction("Index");
        //            else
        //                return View(obj);
        //        }
        //        else
        //            return View(obj);
        //    }
        //    catch
        //    {
        //        return View(obj);
        //    }
        //}

        //[HttpPost]
        //public ActionResult CreateMenu(SecurityByRole obj)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            if (API_MenuDriver.AddSecurityByRole(obj) > 0)
        //                return RedirectToAction("Index");
        //            else
        //                return View(obj);
        //        }
        //        else
        //            return View(obj);
        //    }
        //    catch
        //    {
        //        return View(obj);
        //    }
        //}

        //[ValidateInput(false)]
        //public ActionResult RolesGridPartial()
        //{
        //    return PartialView("_RolesGridPartial", API_MenuDriver.GetAllRoles());
        //}

        //[ValidateInput(false)]
        //public ActionResult SecurityRolesPartial()
        //{
        //    return PartialView("_SecurityRolesPartial", API_MenuDriver.GetAllSecurityRoles());
        //}

        #endregion

    }
}
