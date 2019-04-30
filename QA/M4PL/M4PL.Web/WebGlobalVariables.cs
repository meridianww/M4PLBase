/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 WebGlobalVariables
//Purpose:                                      Provides Global static variables to be used throughout the application
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Web;

namespace M4PL.Web
{
    public static class WebGlobalVariables
    {
        public static IList<LeftMenu> ModuleMenus
        {
            get
            {
                if (HttpContext.Current.Application["ModuleMenus"] == null || !(HttpContext.Current.Application["ModuleMenus"] is List<LeftMenu>))
                    HttpContext.Current.Application["ModuleMenus"] = new List<LeftMenu>();
                return HttpContext.Current.Application["ModuleMenus"] as List<LeftMenu>;
            }
            set
            {
                HttpContext.Current.Application["ModuleMenus"] = value;
            }
        }

        public static List<string> Themes = new List<string>();
    }
}