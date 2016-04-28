﻿using M4PL.APIClient;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.IO;
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
            res = API_MenuDriver.GetMenuDetails(Id);
            if (res.Data != null)
            {
                if (res.Data.LstIconLarge != null)
                    res.Data.MnuIconLarge = res.Data.LstIconLarge.ToArray();
                if (res.Data.LstIconMedium != null)
                    res.Data.MnuIconMedium = res.Data.LstIconMedium.ToArray();
                if (res.Data.LstIconSmall != null)
                    res.Data.MnuIconSmall = res.Data.LstIconSmall.ToArray();
                if (res.Data.LstIconVerySmall != null)
                    res.Data.MnuIconVerySmall = res.Data.LstIconVerySmall.ToArray();
            }
            return View(res);
        }

        [HttpPost]
        public ActionResult Create(Menus value, FormCollection collection)
        {
            if (ModelState.IsValid)
            {
                res = this.SaveMenu(value, collection);
                if (res.Status)
                    return RedirectToAction("Index");
                else
                {
                    res.Data = value;
                    return View(res);
                }
            }
            else
            {
                res.Data = value;
                return View(res);
            }
        }

        [HttpPost]
        public ActionResult Edit(int Id, Menus value, FormCollection collection)
        {
            if (Id > 0 && ModelState.IsValid)
            {
                value.MenuID = Id;
                res = this.SaveMenu(value, collection);
                if (res.Status)
                    return RedirectToAction("Index");
                else
                {
                    res.Data = value;
                    return View(res);
                }
            }
            else
            {
                res.Data = value;
                return View(res);
            }
        }

        public ActionResult Delete(int Id)
        {
            res = API_MenuDriver.RemoveMenu(Id);
            return RedirectToAction("Index");
        }

        [ValidateInput(false)]
        public ActionResult MenusGridPartial()
        {
            return PartialView("_MenusGridPartial", API_MenuDriver.GetAllMenus().DataList);
        }

        private Response<Menus> SaveMenu(Menus value, FormCollection collection)
        {
            value.MnuIconVerySmall = value.MnuIconSmall = value.MnuIconMedium = value.MnuIconLarge = new byte[] { };
            HttpPostedFileBase fileVerySmall = Request.Files["fuIconVerySmall"];
            HttpPostedFileBase fileSmall = Request.Files["fuIconSmall"];
            HttpPostedFileBase fileMedium = Request.Files["fuIconMedium"];
            HttpPostedFileBase fileLarge = Request.Files["fuIconLarge"];

            if (fileVerySmall != null && fileVerySmall.ContentLength > 0)
            {
                using (var binaryReader = new BinaryReader(fileVerySmall.InputStream))
                {
                    value.MnuIconVerySmall = binaryReader.ReadBytes(fileVerySmall.ContentLength);
                }
            }
            if (fileSmall != null && fileSmall.ContentLength > 0)
            {
                using (var binaryReader = new BinaryReader(fileSmall.InputStream))
                {
                    value.MnuIconSmall = binaryReader.ReadBytes(fileSmall.ContentLength);
                }
            }
            if (fileMedium != null && fileMedium.ContentLength > 0)
            {
                using (var binaryReader = new BinaryReader(fileMedium.InputStream))
                {
                    value.MnuIconMedium = binaryReader.ReadBytes(fileMedium.ContentLength);
                }
            }
            if (fileLarge != null && fileLarge.ContentLength > 0)
            {
                using (var binaryReader = new BinaryReader(fileLarge.InputStream))
                {
                    value.MnuIconLarge = binaryReader.ReadBytes(fileLarge.ContentLength);
                }
            }

            return API_MenuDriver.SaveMenu(value);
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
