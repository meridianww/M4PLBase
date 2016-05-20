//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              10/5/2016
//Program Name:                                 AllSettings
//Purpose:                                      Choose Columns for all pages
//
//==================================================================================================================================================== 

using DevExpress.Web.Mvc;
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
    public class AllSettingsController : Controller
    {
        //
        // GET: /AllSettings/

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult SetGridProperties<T>(Response<T> res)
        {
            res.ShowFilterRow = (!res.ShowFilterRow);
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetAllColumns(string pageName)
        {
            return Json(API_ChooseColumns.GetAllColumns(pageName).Data, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SaveChosenColumns(ChooseColumns value)
        {
            return Json(API_ChooseColumns.SaveChoosedColumns(value).Status);
        }

        static Response<ColumnsAlias> res = new Response<ColumnsAlias>();
        public ActionResult SaveAliasColumn()
        {
            string pageName = (Request.Params["ColPageName"] != null && Convert.ToString(Request.Params["ColPageName"]).Length > 0) ? Convert.ToString(Request.Params["ColPageName"]) : "Contact";
            res.DataList = API_RefOptions.GetAllColumnAliases(pageName).DataList;
            return View("SaveAliasColumn", res);
        }

        [ValidateInput(false)]
        public ActionResult BatchEditingUpdateModel(MVCxGridViewBatchUpdateValues<ColumnsAlias, string> updateValues)
        {
            foreach (var product in updateValues.Update)
            {
                if (updateValues.IsValid(product))
                {

                }
            }
            return this.SaveAliasColumn();
        }

        [HttpPost]
        public ActionResult SaveAliasColumns(ColumnsAlias obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    //var res = API_RefOptions.SaveAliasColumn(obj);
                    if (res.Status)
                        return RedirectToAction("SaveAliasColumn");
                    else
                    {
                        return View(res);
                    }
                }
                else
                {
                    return View(res);
                }
            }
            catch
            {
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
