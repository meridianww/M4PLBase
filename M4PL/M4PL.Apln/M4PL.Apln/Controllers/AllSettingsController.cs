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

    }
}
