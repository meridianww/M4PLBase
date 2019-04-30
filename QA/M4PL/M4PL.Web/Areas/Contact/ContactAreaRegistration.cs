/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ContactAreaRegistration
//Purpose:                                      Contains route related to ContactArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Contact
{
    public class ContactAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Contact";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Contact_default",
                "Contact/{controller}/{action}/{id}",
                new { action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
            );
        }
    }
}