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
    public class SystemMessagesController : Controller
    {
        //
        // GET: /AllSettings/

        static Response<SystemMessages> res = new Response<SystemMessages>();
        static Response<disMessages> res1 = new Response<disMessages>();

        public ActionResult SystemMessagesGridPartial()
        {
            res1.DataList = API_SystemMessages.GetAllSystemMessages().DataList;
            if (Session[SessionNames.SystemMessagesLayout] != null)
                API_RefOptions.SaveGridLayout(new GridLayout("SystemMessages", 0, (string)Session[SessionNames.SystemMessagesLayout]));
            else
                Session[SessionNames.SystemMessagesLayout] = API_RefOptions.GetSavedGridLayout("SystemMessages", 0).ToString();
            return PartialView("_SystemMessagesGridPartial", res1);
        }

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult Create()
        {
            res = new Response<SystemMessages>();
            res = API_SystemMessages.GetSystemMessageDetails(0);
            return View(res);
        }

        public ActionResult Edit(int Id)
        {
            res = API_SystemMessages.GetSystemMessageDetails(Id);
            return View(res);
        }

    }
}
