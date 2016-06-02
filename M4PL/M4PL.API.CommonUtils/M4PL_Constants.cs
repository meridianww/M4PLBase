using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace M4PL_API_CommonUtils
{
    public class M4PL_Constants
    {
        public static string M4PL_API = Convert.ToString(ConfigurationManager.AppSettings["API_URL"]);
        public const string M4PL_EmptyImageUrl = "http://www.intelligentmedia.com/Press/notavailable.gif";
    }

    /// <summary>
    ///     A class contains constants declaration for Stored procedure names and input output parameters
    /// </summary>
    public class StoredProcedureNames
    {
        public const string InsertContact = "dbo.InsertContact";
        public const string UpdateContact = "dbo.UpdateContact";
        public const string GetAllContacts = "dbo.GetAllContacts";
        public const string GetContactDetails = "dbo.GetContactDetails";
        public const string RemoveContact = "dbo.RemoveContact";

        public const string RemoveUserAccount = "dbo.RemoveUserAccount";
        public const string SaveUserAccount = "dbo.SaveUserAccount";
        public const string GetUserAccount = "dbo.GetUserAccountDetails";
        public const string GetAllUserAccounts = "dbo.GetAllUserAccounts";

        public const string GetAllOrganizations = "dbo.GetAllOrganizations";
        public const string GetOrganizationDetails = "dbo.GetOrganizationDetails";
        public const string RemoveOrganization = "dbo.RemoveOrganization";
        public const string SaveOrganization = "dbo.SaveOrganization";
        public const string GetOrgSortOrder = "dbo.GetOrgSortOrder";

        public const string GetRefOptions = "dbo.GetRefOptions";
        public const string GetAllMenus = "dbo.GetAllMenus";

        /* Menu Driver */
        public const string GetAllRoles = "dbo.GetAllRoles";
        public const string GetRoleDetails = "dbo.GetRoleDetails";
        public const string RemoveRole = "dbo.RemoveRole";
        public const string SaveRole = "dbo.SaveRole";
        public const string SaveSecurityByRole = "dbo.SaveSecurityByRole";
        public const string GetAllSecurityRoles = "dbo.GetAllSecurityRoles";
        public const string SaveMenu = "dbo.SaveMenu";
        public const string RemoveMenu = "dbo.RemoveMenu";
        public const string GetMenuDetails = "dbo.GetMenuDetails";

        /* Choose Columns */
        public const string GetAllColumns = "dbo.GetAllColumns";
        public const string SaveChoosedColumns = "dbo.SaveChoosedColumns";

        //Saving the Grid Layout
        public const string SaveGridLayout = "dbo.SaveGridLayout";
        public const string GetSavedGridLayout = "dbo.GetSavedGridLayout";

        //Column Alias
        public const string SaveColumnsAlias = "dbo.SaveColumnsAlias";
        public const string GetAllColumnAliases = "dbo.GetAllColumnAliases";

        //Error Log
        public const string InsertErrorLog = "dbo.ErrorLog_InsertErrorDetails";
        public const string LogDBErrors = "dbo.ErrorLog_LogDBErrors";

        public const string GetNextPrevValue = "dbo.GetNextPrevValue";

        //Message Templates
        public const string GetSysMessagesTemplates = "dbo.GetSysMessagesTemplates";

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

        #region Choose Columns

        public const string SaveChooseColumns_Success = "Choosed Columns saved successfully.";
        public const string SaveChooseColumns_Failure = "Choosed Columns can't be saved.";
        public const string SaveChooseColumns_Duplicate = "These Choosed Columns are already exist.";

        #endregion

        #region Choose Columns

        public const string SaveColumnsAlias_Success = "Columns Aliases saved successfully.";
        public const string SaveColumnsAlias_Failure = "Columns Aliases can't be saved.";
        public const string SaveColumnsAlias_Duplicate = "These Columns Aliases are already exist.";

        #endregion

    }

    /// <summary>
    /// A class contains constants declaration for Session Names for storing data in modules
    /// </summary>
    public class SessionNames
    {
        public const string UserID = "UserID";
        public const string ContactLayout = "ContactLayout";
        public const string UserLayout = "UserLayout";
        public const string OrgLayout = "OrgLayout";
        public const string MenuLayout = "MenuLayout";
        public const string ColumnAliasLayout = "ColumnAliasLayout";
    }

    public class Languages
    {
        public static List<SelectListItem> GetLanguages()
        {
            return new List<SelectListItem>() {
                new SelectListItem() { Text = "English", Value = "en", Selected = true },
                new SelectListItem() { Text = "French", Value = "fr" },
                new SelectListItem() { Text = "Deutsch", Value = "de" },
                new SelectListItem() { Text = "Spanish", Value = "es" }
            };
        }

        public static void ApplyCurrentCulture()
        {
            if (HttpContext.Current.Session["CurrentCulture"] != null)
            {
                CultureInfo ci = (CultureInfo)HttpContext.Current.Session["CurrentCulture"];
                Thread.CurrentThread.CurrentUICulture = ci;                
                Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(ci.Name);                
            }
        }
    }
}
