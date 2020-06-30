#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 WebGlobalVariables
//Purpose:                                      Provides Global static variables to be used throughout the application
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using System;
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

        public static int IsBundlingEnable = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["IsBundlingEnable"]);
    }
}