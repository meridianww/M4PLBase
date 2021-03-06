﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/3/2016
//Program Name:                                 Login
//Purpose:                                      Providing view for logging into the application
//
//==================================================================================================================================================== 

using M4PL.APIClient;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL_Apln.Controllers
{
    public class ErrorPageController : Controller
    {
        //
        // GET: /Error/

        public ActionResult Index()
        {
            return View();
        }


        public ActionResult Error400()
        {
            return View();
        }

        public ActionResult Error401()
        {
            return View();
        }

        public ActionResult Error500()
        {
            return View();
        }

        public ActionResult Error403()
        {
            return View();
        }
    
        public ActionResult Error404()
        {
            return View();
        }
    }
}
