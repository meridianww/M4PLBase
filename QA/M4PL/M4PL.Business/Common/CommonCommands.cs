﻿#region Copyright

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
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities.Logger;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Common.CommonCommands;

namespace M4PL.Business.Common
{
    public class CommonCommands
    {
        public static BusinessConfiguration M4PLBusinessConfiguration
        {
            get { return CoreCache.GetBusinessConfiguration("EN"); }
        }

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
        public static NavSalesOrderDimensionResponse GetSalesOrderDimensionValues(string username, string password, string serviceURL)
        {
            return Finance.SalesOrder.NavSalesOrderHelper.GetNavSalesOrderDimension(username, password, serviceURL);
        }

        public static BusinessConfiguration GetBusinessConfiguration(bool forceUpdate)
        {
            return CoreCache.GetBusinessConfiguration(ActiveUser.LangCode, forceUpdate);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavSalesOrderPostedInvoiceResponse GetCachedNavSalesOrderValues(bool forceUpdate = false)
        {
            string username = string.Empty;
            string password = string.Empty;
            string serviceURL = string.Empty;
            ////CustomerNavConfiguration currentCustomerNavConfiguration = null;
            ////if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
            ////{
            ////    currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
            ////    serviceURL = currentCustomerNavConfiguration.ServiceUrl;
            ////    username = currentCustomerNavConfiguration.ServiceUserName;
            ////    password = currentCustomerNavConfiguration.ServicePassword;
            ////}
            ////else
            ////{
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;
            ////}

            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedSalesOrderResponse(username, password, serviceURL);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavPurchaseOrderPostedInvoiceResponse GetCachedNavPurchaseOrderValues(bool forceUpdate = false)
        {
            string username = string.Empty;
            string password = string.Empty;
            string serviceURL = string.Empty;
            ////CustomerNavConfiguration currentCustomerNavConfiguration = null;
            ////if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
            ////{
            ////    currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
            ////    serviceURL = currentCustomerNavConfiguration.ServiceUrl;
            ////    username = currentCustomerNavConfiguration.ServiceUserName;
            ////    password = currentCustomerNavConfiguration.ServicePassword;
            ////}
            ////else
            ////{
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;
            ////}

            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedPurchaseOrderResponse(username, password, serviceURL);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavSalesOrderItemResponse GetCachedNavSalesOrderItemValues(bool forceUpdate = false)
        {
            string username = string.Empty;
            string password = string.Empty;
            string serviceURL = string.Empty;
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;
            
            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedSalesOrderItemResponse(username, password, serviceURL);
        }

        public static NavSalesOrderItemResponse GetCachedNavSalesOrderItemValues(string documentNumber)
        {
            string username = string.Empty;
            string password = string.Empty;
            string serviceURL = string.Empty;
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;

            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedSalesOrderItemResponse(username, password, serviceURL, documentNumber);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavPurchaseOrderItemResponse GetCachedNavPurchaseOrderItemValues(bool forceUpdate = false)
        {
            CustomerNavConfiguration currentCustomerNavConfiguration = null;
            string username;
            string password;
            string serviceURL;
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;
           
            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedPurchaseOrderItemResponse(username, password, serviceURL);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NavPurchaseOrderItemResponse GetCachedNavPurchaseOrderItemValues(string documentNumber)
        {
            string username;
            string password;
            string serviceURL;
            serviceURL = M4PLBusinessConfiguration.NavAPIUrl;
            username = M4PLBusinessConfiguration.NavAPIUserName;
            password = M4PLBusinessConfiguration.NavAPIPassword;

            return Finance.SalesOrder.NavSalesOrderHelper.GetNavPostedPurchaseOrderItemResponse(username, password, serviceURL, documentNumber);
        }

        public static IList<JobReportColumnRelation> GetJobReportColumnRelation(int reportTypeId)
        {
            return _commands.GetJobReportColumnRelation(reportTypeId);
        }

        /// <summary>
        /// Gets the list of app menu data
        /// </summary>
        /// <returns></returns>
        public static NAVOrderItemResponse GetNAVOrderItemResponse(bool forceUpdate = false)
        {
            return Finance.SalesOrder.NavSalesOrderHelper.GetNavNAVOrderItemResponse();
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
        /// Gets user Securities
        /// </summary>
        /// <returns></returns>

        public static M4PL.Entities.JobService.JobPermission GetJobPermissions(ActiveUser activeUser, List<TableReference> tableReferences)
        {
            if (activeUser.IsSysAdmin)
            {
                return new Entities.JobService.JobPermission
                {
                    Job = Permission.All,
                    Document = Permission.All,
                    Tracking = Permission.All,
                    Cargo = Permission.All,
                    Price = Permission.All,
                    Cost = Permission.All,
                    Note=Permission.All
                };
            }
            IList<UserSecurity> userSecurity = _commands.GetUserSecurities(activeUser);
            M4PL.Entities.JobService.JobPermission jobPermission = new Entities.JobService.JobPermission();

            if (userSecurity != null)
            {
                var tableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.Job.ToString());
                if (tableDetails != null)
                {
                    var jobSercurity = userSecurity.FirstOrDefault(x => x.SecMainModuleId == tableDetails.TblMainModuleId);
                    if (jobSercurity != null)
                    {
                        jobPermission.Job = (Permission)jobSercurity.SecMenuAccessLevelId;
                        jobPermission.Document = jobPermission.Tracking = jobPermission.Price = jobPermission.Cost = jobPermission.Cargo = jobPermission.Job;

                        if (jobSercurity.UserSubSecurities != null && jobSercurity.UserSubSecurities.Count > 0)
                        {
                            var gatewayTableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobGateway.ToString());
                            var documentTableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobDocReference.ToString());
                            var cargoTableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobCargo.ToString());
                            var priceTableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobBillableSheet.ToString());
                            var costTableDetails = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobCostSheet.ToString());
                            var jobNotes = tableReferences.FirstOrDefault(x => x.SysRefName == EntitiesAlias.JobNote.ToString());
                            foreach (var item in jobSercurity.UserSubSecurities)
                            {
                                if (item.RefTableName == gatewayTableDetails.SysRefName)
                                    jobPermission.Tracking = (Permission)item.SubsMenuAccessLevelId;
                                else if (item.RefTableName == documentTableDetails.SysRefName)
                                    jobPermission.Document = (Permission)item.SubsMenuAccessLevelId;
                                else if (item.RefTableName == cargoTableDetails.SysRefName)
                                    jobPermission.Cargo = (Permission)item.SubsMenuAccessLevelId;
                                else if (item.RefTableName == priceTableDetails.SysRefName)
                                    jobPermission.Price = (Permission)item.SubsMenuAccessLevelId;
                                else if (item.RefTableName == costTableDetails.SysRefName)
                                    jobPermission.Cost = (Permission)item.SubsMenuAccessLevelId;
                                else if (item.RefTableName == jobNotes.SysRefName)
                                    jobPermission.Note = (Permission)item.SubsMenuAccessLevelId;
                            }
                        }
                    }
                }
            }
            return jobPermission;
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
        public static IList<TreeListModel> GetCustomerPPPTree(ActiveUser activeUser)
        {
            return _commands.GetCustomerPPPTree(activeUser);
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

        public static IList<JobAction> GetJobAction(long jobId, string entity, bool? isScheduleAciton = null)
        {
            return _commands.GetJobAction(ActiveUser, jobId, entity, isScheduleAciton);
        }

        public static IList<JobGatewayDetails> GetJobGateway(long jobId, string jobIds = null, bool IsMultiJob = false)
        {
            return _commands.GetJobGateway(ActiveUser, jobId, jobIds, IsMultiJob);
        }

        public static bool InsertErrorLog(M4PLException m4plException)
        {
            M4PL.DataAccess.Logger.ErrorLogger.Log(m4plException.Exception, m4plException.AdditionalMessage, m4plException.ErrorRelatedTo, m4plException.LogType);
            return true;
        }
        public static StatusModel GenerateReasoneCode(List<Entities.Program.PrgShipStatusReasonCode> reasonCodeList)
        {
            return _commands.GenerateReasoneCode(reasonCodeList, ActiveUser);
        }
        public static StatusModel GenerateAppointmentCode(List<Entities.Program.PrgShipApptmtReasonCode> appointmentCodeList)
        {
            return _commands.GenerateAppointmentCode(appointmentCodeList, ActiveUser);
        }
    }
}