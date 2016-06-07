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
    public class MessageTypesController : Controller
    {
        //
        // GET: /AllSettings/

        static Response<disMessages> res = new Response<disMessages>();

        public ActionResult Index()
        {
            return View(res);
        }

        public ActionResult Create()
        {
            res = new Response<disMessages>();
            res.Data = new disMessages();
            return View(res);
        }

        public ActionResult _MessageTypesDetailsFormPartial()
        {
            return View();
        }

        public ActionResult _MessageTypesChangedAndEnteredFormPartial()
        {
            return View();

        }

    }
}
