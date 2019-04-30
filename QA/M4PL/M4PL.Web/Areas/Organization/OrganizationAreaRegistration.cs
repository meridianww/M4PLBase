/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationAreaRegistration
//Purpose:                                      Contains route related to OrganizationArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization
{
    public class OrganizationAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Organization";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Organization_default",
                "Organization/{controller}/{action}/{id}",
                new { action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
            );
        }
    }
}