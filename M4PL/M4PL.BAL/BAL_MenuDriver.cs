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

        public static List<disMenus> GetAllMenus(int Module = 0)
        {
            return DAL_MenuDriver.GetAllMenus(Module);
        }

        public static List<disSecurityByRole> GetAllSecurityRoles()
        {
            return DAL_MenuDriver.GetAllSecurityRoles();
        }

        public static int SaveMenu(Menus value)
        {
            return DAL_MenuDriver.SaveMenu(value);
        }

        public static int RemoveMenu(int MenuID)
        {
            return DAL_MenuDriver.RemoveMenu(MenuID);
        }

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
