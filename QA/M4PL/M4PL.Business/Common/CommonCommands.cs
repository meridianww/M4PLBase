#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 CommonCommands
// Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Common.CommonCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Common.CommonCommands;

namespace M4PL.Business.Common
{
    public class CommonCommands
    {
        public static ActiveUser ActiveUser { get; set; }

        #region Cached Results

        /// <summary>
        /// Gets the list of tables
        /// </summary>
        /// <returns></returns>
        public static IList<TableReference> GetTables(bool forceUpdate = false)
        {
            return CoreCache.GetTables(forceUpdate);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static IList<RibbonMenu> GetRibbonMenus(bool forceUpdate = false)
        {
            return CoreCache.GetRibbonMenus(ActiveUser.LangCode, forceUpdate);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavSalesOrderDimensionResponse GetSalesOrderDimensionValues(bool forceUpdate = false)
        {
            string lan = string.Empty;
            if (ActiveUser == null)
                lan = "EN";
            else
                lan = ActiveUser.LangCode;
            return CoreCache.GetNavSalesOrderDimensionValues(lan, forceUpdate);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NAVOrderItemResponse GetNAVOrderItemResponse(bool forceUpdate = false)
        {
            return CoreCache.GetNAVOrderItemResponse(ActiveUser.LangCode, forceUpdate);
        }

        /// <summary>
        /// Gets list of reference language names
        /// </summary>
        /// <param name="lookupId"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> GetIdRefLangNames(int lookupId, bool forceUpdate = false)
        {
            return CoreCache.GetIdRefLangNames(ActiveUser.LangCode, lookupId, forceUpdate);
        }

        /// <summary>
        /// gets list of operations
        /// </summary>
        /// <param name="lookup"></param>
        /// <returns></returns>

        public static IList<Operation> GetOperations(LookupEnums lookup, bool forceUpdate = false)
        {
            return CoreCache.GetOperations(ActiveUser.LangCode, lookup, forceUpdate);
        }

        /// <summary>
        /// Gets list of page information
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        public static IList<PageInfo> GetPageInfos(EntitiesAlias entity, bool forceUpdate = false)
        {
            return CoreCache.GetPageInfos(ActiveUser.LangCode, entity, forceUpdate);
        }

        /// <summary>
        /// Gets Display message based on the message code
        /// </summary>
        /// <param name="messageType"></param>
        /// <param name="messageCode"></param>
        /// <returns></returns>

        public static DisplayMessage GetDisplayMessageByCode(MessageTypeEnum messageType, string messageCode, bool forceUpdate = false)
        {
            return CoreCache.GetDisplayMessageByCode(ActiveUser.LangCode, messageCode, forceUpdate);
        }

        /// <summary>
        /// Gets list of coulmn settings based on the entity name
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        public static IList<ColumnSetting> GetColumnSettingsByEntityAlias(EntitiesAlias entity, bool forceUpdate)
        {
            return CoreCache.GetColumnSettingsByEntityAlias(ActiveUser.LangCode, entity, forceUpdate);
        }

        /// <summary>
        /// Gets list of grid coulmn settings based on the entity name
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        public static IList<ColumnSetting> GetGridColumnSettingsByEntityAlias(EntitiesAlias entity, bool forceUpdate, bool isGridSetting)
        {
            return CoreCache.GetGridColumnSettingsByEntityAlias(ActiveUser.LangCode, entity, forceUpdate, isGridSetting);
        }

        /// <summary>
        /// Gets column validtions based on the table name
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        public static IList<ValidationRegEx> GetValidationRegExpsByEntityAlias(EntitiesAlias entity, bool forceUpdate = false)
        {
            return CoreCache.GetValidationRegExpsByEntityAlias(ActiveUser.LangCode, entity, forceUpdate);
        }

        public static object GetMasterTableObject(EntitiesAlias entity, bool forceUpdate = false)
        {
            return CoreCache.GetMasterTableObject(ActiveUser.LangCode, entity, forceUpdate);
        }

        public static IList<ConditionalOperator> GetConditionalOperators(bool forceUpdate = false)
        {
            return CoreCache.GetConditionalOperators(ActiveUser.LangCode, forceUpdate);
        }

        /// <summary>
        /// Get System Settings from cache
        /// </summary>
        /// <param name="forceUpdate"></param>
        /// <returns></returns>
        public static SysSetting GetSystemSettings(bool forceUpdate = false)
        {
            return CoreCache.GetSystemSettings(ActiveUser.LangCode, forceUpdate);
        }

        public static SysSetting GetSystemSettings(string langCode, bool forceUpdate = false)
        {
            return CoreCache.GetSystemSettings(langCode, forceUpdate);
        }

        /// <summary>
        /// Gets user coulmn settings based on the entity name
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        #endregion Cached Results

        public static UserColumnSettings GetUserColumnSettings(EntitiesAlias entity)
        {
            return _commands.GetUserColumnSettings(ActiveUser.UserId, entity);
        }

        public static bool GetIsFieldUnique(UniqueValidation uniqueValidation)
        {
            return _commands.GetIsFieldUnique(uniqueValidation, ActiveUser);
        }

        public static string IsValidJobSiteCode(string jobSiteCode, long programId)
        {
            return _commands.IsValidJobSiteCode(jobSiteCode, programId, ActiveUser);
        }
        public static long GetVendorIdforSiteCode(string jobSiteCode, long programId)
        {
            return _commands.GetVendorIdforSiteCode(jobSiteCode, programId, ActiveUser);
        }
        public static bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount)
        {
            return _commands.UpdSysAccAndConBridgeRole(systemAccount, ActiveUser);
        }

        /// <summary>
        /// Gets user Securities
        /// </summary>
        /// <returns></returns>

        public static IList<UserSecurity> GetUserSecurities(ActiveUser activeUser)
        {
            return _commands.GetUserSecurities(activeUser);
        }

        /// <summary>
        /// Gets ref role Securities
        /// </summary>
        /// <returns></returns>

        public static IList<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser)
        {
            return _commands.GetRefRoleSecurities(activeUser);
        }

        public static SysSetting GetUserSysSettings()
        {
            return _commands.GetUserSysSettings(ActiveUser);
        }

        public static UserColumnSettings InsAndUpdChooseColumn(UserColumnSettings userColumnSettings)
        {
            return _commands.InsAndUpdChooseColumn(ActiveUser, userColumnSettings);
        }

        public static IList<LeftMenu> GetModuleMenus()
        {
            return _commands.GetModuleMenus(ActiveUser);
        }

        public static object GetPagedSelectedFieldsByTable(DropDownInfo dropDownDataInfo)
        {
            return _commands.GetPagedSelectedFieldsByTable(ActiveUser, dropDownDataInfo);
        }

        public static object GetProgramDescendants(DropDownInfo dropDownDataInfo)
        {
            return _commands.GetProgramDescendants(ActiveUser, dropDownDataInfo);
        }
        public static int SaveBytes(ByteArray byteArray)
        {
            return _commands.SaveBytes(byteArray, ActiveUser);
        }

        public static IList<PreferredLocation> AddorEditPreferedLocations(string locations, int contTypeId)
        {
            return _commands.AddorEditPreferedLocations(locations, contTypeId, ActiveUser);
        }

        public static IList<PreferredLocation> GetPreferedLocations(int contTypeId)
        {
            return _commands.GetPreferedLocations(ActiveUser, contTypeId);
        }


        public static int GetUserContactType()
        {
            return _commands.GetUserContactType(ActiveUser);
        }

        public static IList<LookupReference> GetRefLookup(EntitiesAlias entitiesAlias)
        {
            return _commands.GetRefLookup(ActiveUser, entitiesAlias);
        }

        public static bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity)
        {
            return _commands.CheckRecordUsed(allRecordIds, entity);
        }

        public static ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray)
        {
            return _commands.GetByteArrayByIdAndEntity(byteArray);
        }

        public static Entities.Contact.Contact GetContactById(long recordId)
        {
            return _commands.GetContactById(recordId, ActiveUser);
        }

        public static Entities.Contact.Contact GetContactAddressByCompany(long companyId)
        {
            Entities.Contact.Contact contact = new Entities.Contact.Contact();
            Entities.CompanyAddress.CompanyAddress companyAddress = _commands.GetContactAddressByCompany(companyId, ActiveUser);
            if (companyAddress != null)
            {
                contact.ConBusinessAddress1 = companyAddress.Address1;
                contact.ConBusinessAddress2 = companyAddress.Address2;
                contact.ConBusinessCity = companyAddress.City;
                contact.ConBusinessStateId = companyAddress.StateId;
                contact.ConBusinessStateIdName = companyAddress.StateIdName;
                contact.ConBusinessZipPostal = companyAddress.ZipPostal;
                contact.ConBusinessCountryId = companyAddress.CountryId;
                contact.ConBusinessCountryIdName = companyAddress.CountryIdName;
            }

            return contact;
        }

        public static Entities.Contact.Contact ContactCardAddOrEdit(Entities.Contact.Contact contact)
        {
            return _commands.ContactCardAddOrEdit(contact, ActiveUser);
        }

        public static int GetLastItemNumber(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetLastItemNumber(pagedDataInfo);
        }

        public static bool ResetItemNumber(PagedDataInfo pagedDataInfo)
        {
            return _commands.ResetItemNumber(ActiveUser, pagedDataInfo);
        }

        public static IList<TreeListModel> GetCustPPPTree(ActiveUser activeUser, long orgId, long? custId, long? parentId)
        {
            return _commands.GetCustPPPTree(activeUser, orgId, custId, parentId);
        }

        public static ErrorLog GetOrInsErrorLog(ErrorLog errorLog)
        {
            return _commands.GetOrInsErrorLog(ActiveUser, errorLog);
        }

        public static IList<DeleteInfo> GetTableAssociations(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetTableAssociations(ActiveUser, pagedDataInfo);
        }


        public static IList<AppDashboard> GetUserDashboards(int mainModuleId)
        {
            return _commands.GetUserDashboards(ActiveUser, mainModuleId);
        }

        public static string SwitchOrganization(ActiveUser activeUser, long orgId)
        {
            return _commands.SwitchOrganization(ActiveUser, orgId);
        }

        public static string GetNextBreakDownStructure(bool ribbon)
        {
            return _commands.GetNextBreakDownStructure(ActiveUser, ribbon);
        }

        public static bool GetJobIsCompleted(long jobId)
        {
            return _commands.GetJobIsCompleted(jobId);
        }

        public static Entities.Organization.OrgRefRole GetOrgRefRole(long id)
        {
            return M4PL.DataAccess.Organization.OrgRefRoleCommands.Get(ActiveUser, id);
        }

        public static IList<Role> GetOrganizationRoleDetails()
        {
            return _commands.GetOrganizationRoleDetails(ActiveUser);
        }

        public static void UpdateUserSystemSettings(SysSetting userSystemSettings)
        {
            _commands.UpdateUserSystemSettings(ActiveUser, userSystemSettings);
        }

        public static bool UpdateLineNumberForJobCostSheet(ActiveUser activeUser, long organizationId, long? jobId)
        {
            return _commands.UpdateLineNumberForJobCostSheet(ActiveUser, jobId);
        }

        public static bool UpdateLineNumberForJobBillableSheet(ActiveUser activeUser, long organizationId, long? jobId)
        {
            return _commands.UpdateLineNumberForJobBillableSheet(ActiveUser, jobId);
        }

        public static IList<SysRefModel> GetDeleteInfoModules(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetDeleteInfoModules(ActiveUser, pagedDataInfo);
        }

        public static dynamic GetDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetDeleteInfoRecords(ActiveUser, pagedDataInfo);
        }

        public static void RemoveDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            _commands.RemoveDeleteInfoRecords(ActiveUser, pagedDataInfo);
        }

        public static UserSecurity GetUserPageOptnLevelAndPermission(long userId, long orgId, long roleId, EntitiesAlias entity)
        {
            return _commands.GetUserPageOptnLevelAndPermission(userId, orgId, roleId, entity, ActiveUser);
        }

        public static UserSecurity GetDashboardAccess(string tableName, long dashboardId)
        {
            return _commands.GetDashboardAccess(ActiveUser, tableName, dashboardId);
        }
        public static CommonIds GetMaxMinRecordsByEntity(string Entity, long RecordID, long OrganizationId, long ID)
        {
            return _commands.GetMaxMinRecordsByEntity(Entity, RecordID, OrganizationId, ID);
        }
        public static JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId)
        {
            return _commands.GetGatewayTypeByJobID(jobGatewayateId);
        }

        public static CompanyCorpAddress GetCompCorpAddress(int compId)
        {
            return _commands.GetCompCorpAddress(compId);
        }

        public static IList<JobAction> GetJobAction(long jobId)
        {
            return _commands.GetJobAction(ActiveUser, jobId);
        }
    }
}