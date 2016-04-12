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

        public static List<Menus> GetAllMenus(int Module = 0)
        {
            return DAL_MenuDriver.GetAllMenus(Module);
        }

        public static List<disSecurityByRole> GetAllSecurityRoles()
        {
            return DAL_MenuDriver.GetAllSecurityRoles();
        }
    }
}
