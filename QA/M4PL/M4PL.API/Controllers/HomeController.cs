/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Home
//Purpose:                                      Loads the default page index
//====================================================================================================================================================*/

using System.Web.Mvc;

namespace M4PL.API.Controllers
{
    public class HomeController : Controller
    {
        /// <summary>
        ///     loads the default page index
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            return View();
        }
    }
}