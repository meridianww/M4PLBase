using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_CommonUtils
{
    public enum MessageTypes
    {
        Success = 1,
        Failure = 2,
        Exception = 3,
        Duplicate = 4,
        ForeignKeyIssue = 5
    };

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
        public const string SaveMenu = "dbo.spSaveMenu";
        public const string RemoveMenu = "dbo.spRemoveMenu";
        public const string GetMenuDetails = "dbo.spGetMenuDetails";

        /* Choose Columns */
        public const string GetAllColumns = "dbo.spGetAllColumns";
        public const string SaveChoosedColumns = "dbo.spSaveChoosedColumns";
    }

    /// <summary>
    ///     A class contains constants declaration for Display messages for operations performed in modules
    /// </summary>
    public class DisplayMessages
    {
        #region Contact

        public const string RemoveContact_Success = "Contact deleted successfully";
        public const string RemoveContact_Failure = "Contact can't be deleted.";
        public const string RemoveContact_ForeignKeyIssue = "You can't delete this contact; Remove all the references first to delete this contact.";

        public const string SaveContact_Duplicate = "This contact is already exist.";
        public const string SaveContact_Success = "Contact saved successfully.";
        public const string SaveContact_Failure = "Contact can't be saved.";

        #endregion

        #region Users

        public const string SaveUser_Success = "User saved successfully.";
        public const string SaveUser_Failure = "User can't be saved.";
        public const string SaveUser_Duplicate = "This user is already exist.";

        public const string RemoveUser_Success = "User deleted successfully.";
        public const string RemoveUser_Failure = "User can't be deleted.";
        public const string RemoveUser_ForeignKeyIssue = "You can't delete this user; Remove all the references first to delete this user.";

        #endregion

        #region Organizations

        public const string RemoveOrganization_Success = "Organization deleted successfully.";
        public const string RemoveOrganization_Failure = "Organization can't be deleted.";
        public const string RemoveOrganization_ForeignKeyIssue = "You can't delete this organization; Remove all the references first to delete this organization.";

        public const string SaveOrganization_Success = "Organization saved successfully.";
        public const string SaveOrganization_Failure = "Organization can't be saved.";
        public const string SaveOrganization_Duplicate = "This organization is already exist.";

        #endregion

        #region Menu Driver

        public const string SaveMenus_Success = "Menu saved successfully.";
        public const string SaveMenus_Failure = "Menu can't be saved.";
        public const string SaveMenus_Duplicate = "This menu is already exist.";

        public const string RemoveMenus_Success = "Menu deleted successfully.";
        public const string RemoveMenus_Failure = "Menu can't be deleted.";
        public const string RemoveMenus_ForeignKeyIssue = "You can't delete this menu; Remove all the references first to delete this menu.";

        #endregion

        #region Choosed Columns

        public const string SaveChoosedColumns_Success = "Choosed Columns saved successfully.";
        public const string SaveChoosedColumns_Failure = "Choosed Columns can't be saved.";
        public const string SaveChoosedColumns_Duplicate = "These Choosed Columns are already exist.";

        #endregion

    }
}
