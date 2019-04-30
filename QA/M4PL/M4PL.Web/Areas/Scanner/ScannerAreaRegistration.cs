/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScannerAreaRegistration
//Purpose:                                      Contains route related to ScannerArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Scanner
{
    public class ScannerAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Scanner";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Scanner_default",
                "Scanner/{controller}/{action}/{id}",
                new { action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
            );
        }
    }
}