//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              15/4/2016
//Program Name:                                 Menu Driver
//Purpose:                                      Acts as intermediary for data exchange between the presentation layer and the Data Access Layer for Menu Driver
//
//==================================================================================================================================================== 

using M4PL.Entities;
using M4PL_API_DAL.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_MenuDriver
    {
        public static List<Roles> GetAllRoles()
        {
            return DAL_MenuDriver.GetAllRoles();
        }

        public static int SaveRole(Roles obj)
        {
            return DAL_MenuDriver.SaveRole(obj);
        }

        public static int RemoveRole(int RoleID)
        {
            return DAL_MenuDriver.RemoveRole(RoleID);
        }

        public static Roles GetRoleDetails(int RoleID)
        {
            return DAL_MenuDriver.GetRoleDetails(RoleID);
        }

        public static int SaveSecurityByRole(SecurityByRole obj)
        {
            return DAL_MenuDriver.SaveSecurityByRole(obj);
        }

        /// <summary>
        /// Function to get the list of all menus
        /// </summary>
        /// <param name="Module"></param>
        /// <returns></returns>
        public static List<disMenus> GetAllMenus(int Module = 0, int UserId = 0)
        {
            return DAL_MenuDriver.GetAllMenus(Module, UserId);
        }

        public static List<disSecurityByRole> GetAllSecurityRoles()
        {
            return DAL_MenuDriver.GetAllSecurityRoles();
        }

        /// <summary>
        /// Function to Save menu details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveMenu(Menus value)
        {
            return DAL_MenuDriver.SaveMenu(value);
        }

        /// <summary>
        /// Function to delete menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public static int RemoveMenu(int MenuID)
        {
            return DAL_MenuDriver.RemoveMenu(MenuID);
        }

        /// <summary>
        /// Function to get the details of selected menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public static Menus GetMenuDetails(int MenuID)
        {
            var res = DAL_MenuDriver.GetMenuDetails(MenuID);
            if (res != null)
            {
                if (res.MnuIconLarge != null)
                {
                    res.LstIconLarge = res.MnuIconLarge.ToList();
                    res.MnuIconLarge = null;
                }
                if (res.MnuIconMedium != null)
                {
                    res.LstIconMedium = res.MnuIconMedium.ToList();
                    res.MnuIconMedium = null;
                }
                if (res.MnuIconSmall != null)
                {
                    res.LstIconSmall = res.MnuIconSmall.ToList();
                    res.MnuIconSmall = null;
                }
                if (res.MnuIconVerySmall != null)
                {
                    res.LstIconVerySmall = res.MnuIconVerySmall.ToList();
                    res.MnuIconVerySmall = null;
                }
            }
            return res;
        }
    }
}
