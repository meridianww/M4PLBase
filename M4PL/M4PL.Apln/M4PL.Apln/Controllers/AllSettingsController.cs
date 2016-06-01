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
using M4PL_Apln.App_Start;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    [HandleResourceNotFound]
    public class AllSettingsController : Controller
    {
        //
        // GET: /AllSettings/

        static Response<ColumnsAlias> res = new Response<ColumnsAlias>();

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult SetGridProperties<T>(Response<T> res)
        {
            res.ShowFilterRow = (!res.ShowFilterRow);
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetAllColumns(string pageName, bool IsRestoreDefaults = false)
        {
            return Json(API_ChooseColumns.GetAllColumns(pageName, IsRestoreDefaults).Data, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SaveChosenColumns(ChooseColumns value)
        {
            return Json(API_ChooseColumns.SaveChoosedColumns(value).Status);
        }

        public ActionResult SaveAliasColumn()
        {
            return View(res);
        }

        [ValidateInput(false)]
        public ActionResult BatchEditingUpdateModel(MVCxGridViewBatchUpdateValues<ColumnsAlias, string> updateValues)
        {
            List<ColumnsAlias> lstColumnsAlias = new List<ColumnsAlias>();
            if (updateValues.Update.Count() > 0)
            {
                foreach (var obj in updateValues.Update)
                {
                    if (updateValues.IsValid(obj))
                        lstColumnsAlias.Add(obj);
                }
                var res1 = API_RefOptions.SaveAliasColumn(new SaveColumnsAlias((Request.Params["ColPageName"] != null && Convert.ToString(Request.Params["ColPageName"]).Length > 0) ? Convert.ToString(Request.Params["ColPageName"]) : "Contact", lstColumnsAlias));
                res = new Response<ColumnsAlias>
                (
                    new ColumnsAlias(),
                    API_RefOptions.GetAllColumnAliases((Request.Params["ColPageName"] != null && Convert.ToString(Request.Params["ColPageName"]).Length > 0) ? Convert.ToString(Request.Params["ColPageName"]) : "Contact").DataList,
                    res1.Status,
                    res1.MessageType,
                    res1.Message
                );
            }
            return RedirectToAction("SaveAliasColumn");
        }

        [HttpPost]
        public ActionResult SaveAliasColumns(Response<ColumnsAlias> res1)
        {
            try
            {
                return RedirectToAction("SaveAliasColumn", res);
                //if (ModelState.IsValid)
                //{
                //    //var res = API_RefOptions.SaveAliasColumn(obj);
                //    if (res.Status)
                //        return RedirectToAction("SaveAliasColumn");
                //    else
                //    {
                //        return View(res);
                //    }
                //}
                //else
                //{
                //    return View(res);
                //}
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

        public ActionResult AliasColumnsGridPartial()
        {
            res.DataList = API_RefOptions.GetAllColumnAliases((Request.Params["ColPageName"] != null && Convert.ToString(Request.Params["ColPageName"]).Length > 0) ? Convert.ToString(Request.Params["ColPageName"]) : "Contact").DataList;
            if (Session[SessionNames.ContactLayout] != null)
                API_RefOptions.SaveGridLayout(new GridLayout("SaveAliasColumn", 0, (string)Session[SessionNames.ColumnAliasLayout]));
            else
                Session[SessionNames.ColumnAliasLayout] = API_RefOptions.GetSavedGridLayout("SaveAliasColumn", 0).ToString();
            return PartialView("_AliasColumnsGridPartial", res);
        }

        public JsonResult NextPrevious(string pageName, long id, short options = 0)
        {
            var res = Convert.ToInt64(API_RefOptions.GetNextPrevValue(pageName, id, options));
            id = (res > 0) ? res : id;
            return Json(id, JsonRequestBehavior.AllowGet);
        }

    }
}
