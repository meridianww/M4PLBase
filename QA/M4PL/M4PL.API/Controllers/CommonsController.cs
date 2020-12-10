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
//Date Programmed:                              10/10/2017
//Program Name:                                 Commons
//Purpose:                                      End point to interact with Commons module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Handlers;
using M4PL.API.Models;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities.Logger;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using _command = M4PL.Business.Common.CommonCommands;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Commons API use purpose
    /// </summary>
    [RoutePrefix("api/Commons")]
    public class CommonsController : ApiController
    {
        /// <summary>
        /// Function to get the active user details
        /// </summary>
        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        #region Cached Results

        /// <summary>
        /// Get all table details and cached details for future purpose
        /// </summary>
        /// <param name="forceUpdate">Optional parameter to get table details if required after any update ar created the details</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("Tables")]
        public IQueryable<TableReference> GetTables(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetTables(forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get Ribbon menus details show details in ribbon
        /// </summary>
        /// <param name="forceUpdate">Optional parameter to get ribbon menus if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("RibbonMenus")]
        public IQueryable<RibbonMenu> GetRibbonMenus(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRibbonMenus(forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get Business Configuration details show details in ribbon
        /// </summary>
        /// <param name="forceUpdate">Optional parameter to get Business Configuration details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [Route("BusinessConfiguration")]
        public BusinessConfiguration GetBusinessConfiguration(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetBusinessConfiguration(forceUpdate);
        }
        /// <summary>
        /// Get system option details for any common drop down 
        /// </summary>
        /// <param name="lookupId">pass the look up id to get option details from system reference</param>
        /// <param name="forceUpdate">Optional parameter to get system option details if required forcefully to passing true value</param>
        /// <returns></returns>  

        [HttpGet]
        [CustomQueryable]
        [Route("IdRefLangNames")]
        public IQueryable<IdRefLangName> GetIdRefLangNames(int lookupId, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetIdRefLangNames(lookupId, forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get system Operations details for any common drop down 
        /// </summary>
        /// <param name="lookup">pass the look up enum to get Operations details from system reference</param>
        /// <param name="forceUpdate">Optional parameter to get system Operations details if required forcefully to passing true value</param>
        /// <returns></returns>  
        [HttpGet]
        [CustomQueryable]
        [Route("Operations")]
        public IQueryable<Operation> GetOperations(LookupEnums lookup, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOperations(lookup, forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get page info detail by EntitiesAlias
        /// </summary>
        /// <param name="entity">Pass the EntitiesAlias to get pageinfo details</param>
        /// <param name="forceUpdate">Optional parameter to get page info details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("PageAndTabNames")]
        public IQueryable<PageInfo> GetPageInfos(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPageInfos(entity, forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get dispaly message details for update result to the end user 
        /// </summary>
        /// <param name="messageType">pass meassge type enum </param>
        /// <param name="messageCode">pass meassge code</param>
        /// <param name="forceUpdate">Optional parameter to get  dispaly message details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [Route("DisplayMessage")]
        [AllowAnonymous]
        public DisplayMessage GetDisplayMessageByCode(MessageTypeEnum messageType, string messageCode, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            if (_command.ActiveUser == null || string.IsNullOrWhiteSpace(_command.ActiveUser.LangCode))
                _command.ActiveUser = new ActiveUser { LangCode = "EN" };
            return _command.GetDisplayMessageByCode(messageType, messageCode, forceUpdate);
        }

        /// <summary>
        /// Get column settings details by use EntitiesAlias for caching
        /// </summary>
        /// <param name="entity">pass EntitiesAlias </param>
        /// <param name="forceUpdate">Optional parameter to get column settings details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("ColumnSettings")]
        public IQueryable<ColumnSetting> ColumnSettings(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetColumnSettingsByEntityAlias(entity, forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get grid column settings details by use EntitiesAlias for caching eg: job ,advance report,job card, etc grid
        /// </summary>
        /// <param name="entity">pass EntitiesAlias </param>
        /// <param name="forceUpdate">Optional parameter to get grid column settings details if required forcefully to passing true value</param>
        /// <param name="isGridSetting">Optional parameter to get grid column settings details if required seeting is true</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("GridColumnSettings")]
        public IQueryable<ColumnSetting> GridColumnSettings(EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetGridColumnSettingsByEntityAlias(entity, forceUpdate, isGridSetting).AsQueryable();
        }

        /// <summary>
        /// Get diffrent cobination of columns by report type for caching
        /// </summary>
        /// <param name="reportTypeId">pass reprt type to get diffrent cobination of columns</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("GetJobReportColumnRelation")]
        public IQueryable<JobReportColumnRelation> GetJobReportColumnRelation(int reportTypeId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetJobReportColumnRelation(reportTypeId).AsQueryable();
        }

        /// <summary>
        /// Get all validation settings by entity for caching
        /// </summary>
        /// <param name="entity">pass entity alias to get validation settings</param>
        /// <param name="forceUpdate">Optional parameter to get validation settings details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("ValidationRegExps")]
        public IQueryable<ValidationRegEx> GetValidationRegExpsByEntityAlias(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetValidationRegExpsByEntityAlias(entity, forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get all master details table by entity for caching
        /// </summary>
        /// <param name="entity">Pasing the enity get master table details by entity </param>
        /// <param name="forceUpdate">Optional parameter to get Master Tables details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("MasterTables")]
        public object GetMasterTableObject(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetMasterTableObject(entity, forceUpdate);
        }

        /// <summary>
        /// Get all Conditional Operators for advance searching for caching
        /// </summary>
        /// <param name="forceUpdate">Optional parameter to get all Conditional Operators details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("ConditionalOperators")]
        public IQueryable<ConditionalOperator> GetConditionalOperators(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetConditionalOperators(forceUpdate).AsQueryable();
        }

        /// <summary>
        /// Get all system setting details for caching
        /// </summary>
        /// <param name="forceUpdate">Optional parameter to get all system setting details if required forcefully to passing true value</param>
        /// <returns></returns>
        [HttpGet]
        [Route("SysSettings")]
        public SysSetting GetSystemSettings(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetSystemSettings(forceUpdate);
        }

        #endregion Cached Results
        /// <summary>
        /// Get Field is unique or not
        /// </summary>
        /// <param name="uniqueValidation"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("IsUniqueField")]
        public bool GetIsFieldUnique(UniqueValidation uniqueValidation)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetIsFieldUnique(uniqueValidation);
        }
        /// <summary>
        ///  Get valid site code or not by jobsite code and program id
        /// </summary>
        /// <param name="jobSiteCode"> pass job site code(eg: ANDREWS SC)</param>
        /// <param name="programId">pass program id(eg: 10012)</param>
        /// <returns></returns>
        [HttpGet]
        [Route("IsValidJobSiteCode")]
        public string IsValidJobSiteCode(string jobSiteCode, long programId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.IsValidJobSiteCode(jobSiteCode, programId);
        }
        /// <summary>
        /// Get vendor id by jobsitecode and program id
        /// </summary>
        /// <param name="jobSiteCode"> pass job site code(eg: ANDREWS SC)</param>
        /// <param name="programId">pass program id(eg: 10012)</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetVendorIdforSiteCode")]
        public long GetVendorIdforSiteCode(string jobSiteCode, long programId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetVendorIdforSiteCode(jobSiteCode, programId);
        }

        /// <summary>
        /// Update syn with system account and contact bridge table
        /// </summary>
        /// <param name="systemAccount"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("UpdSysAccAndConBridgeRole")]
        public bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdSysAccAndConBridgeRole(systemAccount);
        }

        /// <summary>
        /// Get all user column setting by entity
        /// </summary>
        /// <param name="entity">pass valid enity to get all details by user provided set-up</param>
        /// <returns></returns>
        [HttpGet]
        [Route("UserColumnSettings")]
        public UserColumnSettings UserColumnSettings(EntitiesAlias entity)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserColumnSettings(entity);
        }

        /// <summary>
        /// Get all user system setings
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("UserSysSettings")]
        public SysSetting GetUserSysSettings()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserSysSettings();
        }

        /// <summary>
        /// get all menus througout all module
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("ModuleMenus")]
        public IQueryable<LeftMenu> GetModuleMenus()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetModuleMenus().AsQueryable();
        }

        /// <summary>
        /// Get all drop down value based upon dropDownDataInfo model
        /// </summary>
        /// <param name="dropDownDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("PagedSelectedFields")]
        public object GetPagedSelectedFieldsByTable(DropDownInfo dropDownDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPagedSelectedFieldsByTable(dropDownDataInfo);
        }

        /// <summary>
        /// Get program Descendants based upon dropDownDataInfo model
        /// </summary>
        /// <param name="dropDownDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("GetProgramDescendants")]
        public object GetProgramDescendants(DropDownInfo dropDownDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetProgramDescendants(dropDownDataInfo);
        }

        /// <summary>
        /// Get all user securites and sub securites by active user model
        /// </summary>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("UserSecurities")]
        public IQueryable<UserSecurity> GetUserSecurities(ActiveUser activeUser)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserSecurities(activeUser).AsQueryable();
        }

        /// <summary>
        /// Get all user securites and sub securites for mobile application 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("UserSecurity")]
        public IQueryable<UserSecurity> GetUserSecurities()
        {
            _command.ActiveUser = Common.GetActiveUser();
            return _command.GetUserSecurities(_command.ActiveUser).AsQueryable();
        }

        /// <summary>
        /// Get the permission of job
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("JobPermissions")]
        public M4PL.Entities.JobService.JobPermission GetJobPermissions()
        {
            _command.ActiveUser = Common.GetActiveUser();
            return _command.GetJobPermissions(_command.ActiveUser, GetTables(true).ToList());
        }

        /// <summary>
        /// Get ref role securities by active user model
        /// </summary>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("RefRoleSecurities")]
        public IQueryable<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRefRoleSecurities(activeUser).AsQueryable();
        }

        /// <summary>
        /// Inser or update column of specific grid by userColumnSettings model
        /// </summary>
        /// <param name="userColumnSettings"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("InsAndUpdChooseColumn")]
        public UserColumnSettings InsAndUpdChooseColumn(UserColumnSettings userColumnSettings)
        {
            _command.ActiveUser = ActiveUser;
            return _command.InsAndUpdChooseColumn(userColumnSettings);
        }

        /// <summary>
        /// Save the byte document into data base
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("SaveBytes")]
        public int SaveBytes()
        {
            var streamProvider = new MultipartMemoryStreamProvider();
            var strByteArray = HttpContext.Current.Request.Form["application/json"];
            var postedFile = HttpContext.Current.Request.Files["PostedFile"];
            if (!string.IsNullOrEmpty(strByteArray) && postedFile != null && postedFile.ContentLength > 0)
            {
                var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
                using (BinaryReader binaryReader = new BinaryReader(postedFile.InputStream))
                {
                    int bytesToRead = postedFile.ContentLength;
                    byteArray.Bytes = binaryReader.ReadBytes(bytesToRead);
                }
                return _command.SaveBytes(byteArray);
            }
            else if (!string.IsNullOrEmpty(strByteArray) && postedFile != null && (postedFile.ContentLength == 0))
            {
                var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
                byteArray.Bytes = null;
                return _command.SaveBytes(byteArray);
            }
            return 0;
        }

        /// <summary>
        /// Get the look up refrerence by entity
        /// </summary>
        /// <param name="entitiesAlias">Pass valid entity to get look up reference details</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("RefLookup")]
        public IQueryable<LookupReference> GetRefLookup(EntitiesAlias entitiesAlias)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRefLookup(entitiesAlias).AsQueryable();
        }

        /// <summary>
        /// Checking record are changed or not to show the confirmatipn to the end user
        /// </summary>
        /// <param name="allRecordIds">pass the ids details in comma separated to fetch the details of unsaved record</param>
        /// <param name="entity">pass the valid entity get details of unsaved record</param>
        /// <returns></returns>
        [HttpGet]
        [Route("CheckRecordUsed")]
        public bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity)
        {
            _command.ActiveUser = ActiveUser;
            return _command.CheckRecordUsed(allRecordIds, entity);
        }

        /// <summary>
        /// Get Byte array id and entity my byteArray model
        /// </summary>
        /// <param name="byteArray"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("ByteArrayByIdAndEntity")]
        public ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetByteArrayByIdAndEntity(byteArray);
        }

        /// <summary>
        /// Inser/Update Prefered Locations by location separeted with comma string and contact type id eg 62(employee)
        /// </summary>
        /// <param name="locations">location separeted with comma string</param>
        /// <param name="contTypeId">Contact type of employee (62)</param>
        /// <returns></returns>
        [HttpGet]
        [Route("AddorEditPreferedLocations")]
        public IList<PreferredLocation> AddorEditPreferedLocations(string locations, int contTypeId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.AddorEditPreferedLocations(locations, contTypeId);
        }
        /// <summary>
        /// Get all Prefered Locations by contact type id
        /// </summary>
        /// <param name="contTypeId">Pass the contact type to get all Prefered locations</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetPreferedLocations")]
        public IList<PreferredLocation> GetPreferedLocations(int contTypeId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPreferedLocations(contTypeId);
        }

        /// <summary>
        /// Get all user contact type
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("GetUserContactType")]
        public int GetUserContactType()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserContactType();
        }

        /// <summary>
        /// Get all contact by record id
        /// </summary>
        /// <param name="recordId"> Passing record id to get all contact</param>
        /// <returns></returns>
        [HttpGet]
        [Route("ContactById")]
        public Entities.Contact.Contact GetContactById(long recordId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetContactById(recordId);
        }

        /// <summary>
        /// Get all contact type by comany id 
        /// </summary>
        /// <param name="companyId">passing a valid company id to get all contact details by valid company id </param>
        /// <returns>List of contact</returns>
        [HttpGet]
        [Route("ContactAddressByCompany")]
        public Entities.Contact.Contact GetContactAddressByCompany(long companyId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetContactAddressByCompany(companyId);
        }

        /// <summary>
        /// Insert/update contact card by contact model
        /// </summary>
        /// <param name="contact"></param>
        /// <returns>List of contact</returns>
        [HttpPost]
        [CustomQueryable]
        [Route("ContactCardAddOrEdit")]
        public Entities.Contact.Contact ContactCardAddOrEdit(Entities.Contact.Contact contact)
        {
            _command.ActiveUser = ActiveUser;
            return _command.ContactCardAddOrEdit(contact);
        }

        /// <summary>
        /// Get last item number by pagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("LastItemNumber")]
        public int GetLastItemNumber(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetLastItemNumber(pagedDataInfo);
        }
        /// <summary>
        /// Get reset item number by pagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("ResetItemNumber")]
        public bool ResetItemNumber(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.ResetItemNumber(pagedDataInfo);
        }

        /// <summary>
        /// Get Customer,program,project,phase tree by customer id and their parent id
        /// </summary>
        /// <param name="custId">pass valid customer id</param>
        /// <param name="parentId">pass valid parent id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("CustPPPTree")]
        public virtual IQueryable<TreeListModel> GetCustPPPTree(long? custId, long? parentId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetCustPPPTree(ActiveUser, ActiveUser.OrganizationId, custId, parentId).AsQueryable(); ;
        }
        /// <summary>
        /// Get Customer,program,project,phase tree by customer id and their parent id
        /// </summary>
        /// <param name="custId">pass valid customer id</param>
        /// <param name="parentId">pass valid parent id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("CustomerPPPTree")]
        public virtual IQueryable<TreeListModel> GetCustomerPPPTree()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetCustomerPPPTree(ActiveUser).AsQueryable(); ;
        }
        /// <summary>
        /// Update the line number for job cost sheet by valid job id
        /// </summary>
        /// <param name="jobId">passing a valid job id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("UpdateLineNumberForJobCostSheet")]
        public virtual bool UpdateLineNumberForJobCostSheet(long? jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdateLineNumberForJobCostSheet(ActiveUser, ActiveUser.OrganizationId, jobId); ;
        }
        /// <summary>
        /// Update the line number for job Billable sheet by valid job id
        /// </summary>
        /// <param name="jobId">passing a valid job id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("UpdateLineNumberForJobBillableSheet")]
        public virtual bool UpdateLineNumberForJobBillableSheet(long? jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdateLineNumberForJobBillableSheet(ActiveUser, ActiveUser.OrganizationId, jobId); ;
        }
        /// <summary>
        /// Get any error log details in system by errorLog model
        /// </summary>
        /// <param name="errorLog"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("ErrorLog")]
        public Entities.ErrorLog GetOrInsErrorLog(Entities.ErrorLog errorLog)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrInsErrorLog(errorLog);
        }

        /// <summary>
        /// Get all table associations by pagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("TableAssociations")]
        public IQueryable<DeleteInfo> GetTableAssociations(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetTableAssociations(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get user dash board by main module id
        /// </summary>
        /// <param name="mainModuleId">Pass a valid main module id to get user dash board</param>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("UserDashboards")]
        public IQueryable<AppDashboard> GetUserDashboards(int mainModuleId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserDashboards(mainModuleId).AsQueryable();
        }

        /// <summary>
        /// Get Next breakdown structure for ribbon by true/false parameter
        /// </summary>
        /// <param name="ribbon">pass boolean parameter</param>
        /// <returns></returns>
        [HttpGet]
        [Route("NextBreakDownStructure")]
        public string GetNextBreakDownStructure(bool ribbon)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetNextBreakDownStructure(ribbon);
        }
        /// <summary>
        /// Get job is completed or not by job id
        /// </summary>
        /// <param name="jobId">passing the valid job id to confirmed job is competed or not</param>
        /// <returns></returns>
        [HttpGet]
        [Route("JobIsCompleted")]
        public bool GetJobIsCompleted(long jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetJobIsCompleted(jobId);
        }
        /// <summary>
        /// Get Organization reference role by a id 
        /// </summary>
        /// <param name="id">pasing valid id parameter to get all ref role data in organization</param>
        /// <returns></returns>
        [HttpGet]
        [Route("{id}")]
        public Entities.Organization.OrgRefRole GetOrgRefRole(long id)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrgRefRole(id);
        }

        /// <summary>
        /// Get all Organization Role Details 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomQueryable]
        [Route("OrganizationRoleDetail")]
        public IQueryable<Role> GetOrganizationRoleDetails()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrganizationRoleDetails().AsQueryable();
        }

        /// <summary>
        /// Update User System Settings details by SysSetting
        /// </summary>
        /// <param name="userSystemSettings"></param>
        [HttpPost]
        [Route("UserSystemSettings")]
        public void UpdateUserSystemSettings(SysSetting userSystemSettings)
        {
            _command.ActiveUser = ActiveUser;
            _command.UpdateUserSystemSettings(userSystemSettings);
        }

        /// <summary>
        /// Get all delete info modules by PagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("GetDeleteInfoModules")]
        public IQueryable<SysRefModel> GetDeleteInfoModules(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDeleteInfoModules(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get all delete info records by PagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomQueryable]
        [Route("GetDeleteInfoRecords")]
        public dynamic GetDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDeleteInfoRecords(pagedDataInfo);
        }

        /// <summary>
        /// Remove Delete Info Records by PagedDataInfo model
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        [HttpPost]
        [Route("RemoveDeleteInfoRecords")]
        public void RemoveDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            _command.RemoveDeleteInfoRecords(pagedDataInfo);
        }

        /// <summary>
        /// Get Dashboard Access by table name and dashboard id
        /// </summary>
        /// <param name="tableName">Passing a valid table name</param>
        /// <param name="dashboardId">Passing a valid dashboard id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetDashboardAccess")]
        public UserSecurity GetDashboardAccess(string tableName, long dashboardId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDashboardAccess(tableName, dashboardId);
        }

        /// <summary>
        /// Get Maximum and Minimum Record id By Entity to get next and previous record
        /// </summary>
        /// <param name="entity">Passing a valid entity</param>
        /// <param name="RecordID">Passing a valid Record</param>  
        /// <param name="ID">Passing a valid id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetMaxMinRecordsByEntity")]
        public CommonIds GetMaxMinRecordsByEntity(string entity, long RecordID, long ID)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetMaxMinRecordsByEntity(entity, RecordID, ActiveUser.OrganizationId, ID);
        }

        /// <summary>
        /// Get gateway type by a valid job gateway id
        /// </summary>
        /// <param name="jobGatewayateId">Passing a valid jobGatewayateId</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetGatewayTypeByJobID")]
        public JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetGatewayTypeByJobID(jobGatewayateId);
        }

        /// <summary>
        /// Get Company Corporate Address by company id 
        /// </summary>
        /// <param name="compId">passing a valid company id to get details</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetCompCorpAddress")]
        public CompanyCorpAddress GetCompCorpAddress(int compId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetCompCorpAddress(compId);
        }

        /// <summary>
        /// Get all job action by job id 
        /// </summary>
        /// <param name="jobId">Passing a valid job id</param>
        /// <param name="entity">Optional entity parameter</param>
        /// <param name="isScheduleAciton">Optional parameter passing is schedule or not</param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("JobAction")]
        public IQueryable<JobAction> GetJobAction(long jobId, string entity = null, bool? isScheduleAciton = null)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetJobAction(jobId, entity, isScheduleAciton).AsQueryable();
        }

        /// <summary>
        /// job gateways by jobid
        /// </summary>
        /// <param name="jobId"></param>
        /// <param name="jobIds"></param>
        /// <param name="IsMultiJob"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GetJobGateway")]
        public IQueryable<JobGatewayDetails> GetJobGateway(long jobId, string jobIds = null, bool IsMultiJob = false)
        {
            _command.ActiveUser = Models.ApiContext.ActiveUser;
            return _command.GetJobGateway(jobId, jobIds, IsMultiJob).AsQueryable();
        }

        /// <summary>
        /// Inser the error log record to database by M4PLException model
        /// </summary>
        /// <param name="m4plException"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("InsertErrorLog")]
        public bool InsertErrorLog(M4PLException m4plException)
        {
            _command.ActiveUser = Models.ApiContext.ActiveUser;
            return _command.InsertErrorLog(m4plException);
        }
    }
}