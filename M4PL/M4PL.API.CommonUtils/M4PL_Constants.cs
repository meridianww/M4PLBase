using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_CommonUtils
{
    public class M4PL_Constants
    {
        public static string M4PL_API = Convert.ToString(ConfigurationManager.AppSettings["API_URL"]);
    }

    /// <summary>
    ///     A class contains constants declaration for Stored procedure names and input output parameters
    /// </summary>
    public class StoredProcedureNames
    {
        public const string InsertContact = "dbo.spInsertContact";
        public const string UpdateContact = "dbo.spUpdateContact";
        public const string GetAllContacts = "dbo.spGetAllContacts";
        public const string GetContactDetails = "dbo.spGetContactDetails";
        public const string RemoveContact = "dbo.spRemoveContact";

        public const string RemoveUserAccount = "dbo.spRemoveUserAccount";
        public const string SaveUserAccount = "dbo.spSaveUserAccount";
        public const string GetUserAccount = "dbo.spGetUserAccountDetails";
        public const string GetAllUserAccounts = "dbo.spGetAllUserAccounts";

        public const string GetAllOrganizations = "dbo.spGetAllOrganizations";
        public const string GetOrganizationDetails = "dbo.spGetOrganizationDetails";
        public const string RemoveOrganization = "dbo.spRemoveOrganization";
        public const string SaveOrganization = "dbo.spSaveOrganization";
        public const string GetOrgSortOrder = "dbo.spGetOrgSortOrder";

        public const string GetRefOptions = "dbo.spGetRefOptions";
        public const string GetAllMenus = "dbo.spGetAllMenus";

        /* Menu Driver */
        public const string GetAllRoles = "dbo.spGetAllRoles";
        public const string GetRoleDetails = "dbo.spGetRoleDetails";
        public const string RemoveRole = "dbo.spRemoveRole";
        public const string SaveRole = "dbo.spSaveRole";
        public const string SaveSecurityByRole = "dbo.spSaveSecurityByRole";
        public const string GetAllSecurityRoles = "dbo.GetAllSecurityRoles";

    }
}
