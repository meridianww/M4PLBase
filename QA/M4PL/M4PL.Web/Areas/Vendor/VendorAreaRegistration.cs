/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorAreaRegistration
//Purpose:                                      Contains route related to VendorArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor
{
    public class VendorAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Vendor";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Vendor_default",
                "Vendor/{controller}/{action}/{id}",
                new { action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
            );
        }
    }
}