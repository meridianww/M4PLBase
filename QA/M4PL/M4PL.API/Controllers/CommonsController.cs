﻿#region Copyright

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

        [HttpGet]
        [CustomQueryable]
        [Route("Tables")]
        public IQueryable<TableReference> GetTables(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetTables(forceUpdate).AsQueryable();
        }

		[HttpGet]
        [CustomQueryable]
        [Route("RibbonMenus")]
        public IQueryable<RibbonMenu> GetRibbonMenus(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRibbonMenus(forceUpdate).AsQueryable();
        }

		[HttpGet]
		[Route("BusinessConfiguration")]
		public BusinessConfiguration GetBusinessConfiguration(bool forceUpdate = false)
		{
			_command.ActiveUser = ActiveUser;
			return _command.GetBusinessConfiguration(forceUpdate);
		}

		[HttpGet]
        [CustomQueryable]
        [Route("IdRefLangNames")]
        public IQueryable<IdRefLangName> GetIdRefLangNames(int lookupId, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetIdRefLangNames(lookupId, forceUpdate).AsQueryable();
        }

        [HttpGet]
        [CustomQueryable]
        [Route("Operations")]
        public IQueryable<Operation> GetOperations(LookupEnums lookup, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOperations(lookup, forceUpdate).AsQueryable();
        }

        [HttpGet]
        [CustomQueryable]
        [Route("PageAndTabNames")]
        public IQueryable<PageInfo> GetPageInfos(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPageInfos(entity, forceUpdate).AsQueryable();
        }

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

        [HttpGet]
        [CustomQueryable]
        [Route("ColumnSettings")]
        public IQueryable<ColumnSetting> ColumnSettings(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetColumnSettingsByEntityAlias(entity, forceUpdate).AsQueryable();
        }

		[HttpGet]
        [CustomQueryable]
        [Route("GridColumnSettings")]
        public IQueryable<ColumnSetting> GridColumnSettings(EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetGridColumnSettingsByEntityAlias(entity, forceUpdate, isGridSetting).AsQueryable();
        }

		[HttpGet]
		[CustomQueryable]
		[Route("GetJobReportColumnRelation")]
		public IQueryable<JobReportColumnRelation> GetJobReportColumnRelation(int reportTypeId)
		{
			_command.ActiveUser = ActiveUser;
			return _command.GetJobReportColumnRelation(reportTypeId).AsQueryable();
		}

		[HttpGet]
        [CustomQueryable]
        [Route("ValidationRegExps")]
        public IQueryable<ValidationRegEx> GetValidationRegExpsByEntityAlias(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetValidationRegExpsByEntityAlias(entity, forceUpdate).AsQueryable();
        }

        [HttpGet]
        [CustomQueryable]
        [Route("MasterTables")]
        public object GetMasterTableObject(EntitiesAlias entity, bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetMasterTableObject(entity, forceUpdate);
        }

        [HttpGet]
        [CustomQueryable]
        [Route("ConditionalOperators")]
        public IQueryable<ConditionalOperator> GetConditionalOperators(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetConditionalOperators(forceUpdate).AsQueryable();
        }

        [HttpGet]
        [Route("SysSettings")]
        public SysSetting GetSystemSettings(bool forceUpdate = false)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetSystemSettings(forceUpdate);
        }

        #endregion Cached Results

        [HttpPost]
        [Route("IsUniqueField")]
        public bool GetIsFieldUnique(UniqueValidation uniqueValidation)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetIsFieldUnique(uniqueValidation);
        }

        [HttpGet]
        [Route("IsValidJobSiteCode")]
        public string IsValidJobSiteCode(string jobSiteCode, long programId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.IsValidJobSiteCode(jobSiteCode, programId);
        }

        [HttpGet]
        [Route("GetVendorIdforSiteCode")]
        public long GetVendorIdforSiteCode(string jobSiteCode, long programId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetVendorIdforSiteCode(jobSiteCode, programId);
        }

        [HttpPost]
        [Route("UpdSysAccAndConBridgeRole")]
        public bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdSysAccAndConBridgeRole(systemAccount);
        }

        [HttpGet]
        [Route("UserColumnSettings")]
        public UserColumnSettings UserColumnSettings(EntitiesAlias entity)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserColumnSettings(entity);
        }

        [HttpGet]
        [Route("UserSysSettings")]
        public SysSetting GetUserSysSettings()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserSysSettings();
        }

        [HttpGet]
        [CustomQueryable]
        [Route("ModuleMenus")]
        public IQueryable<LeftMenu> GetModuleMenus()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetModuleMenus().AsQueryable();
        }

        [HttpPost]
        [CustomQueryable]
        [Route("PagedSelectedFields")]
        public object GetPagedSelectedFieldsByTable(DropDownInfo dropDownDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPagedSelectedFieldsByTable(dropDownDataInfo);
        }

        [HttpPost]
        [CustomQueryable]
        [Route("GetProgramDescendants")]
        public object GetProgramDescendants(DropDownInfo dropDownDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetProgramDescendants(dropDownDataInfo);
        }

        [HttpPost]
        [CustomQueryable]
        [Route("UserSecurities")]
        public IQueryable<UserSecurity> GetUserSecurities(ActiveUser activeUser)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserSecurities(activeUser).AsQueryable();
        }

        [HttpPost]
        [CustomQueryable]
        [Route("RefRoleSecurities")]
        public IQueryable<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRefRoleSecurities(activeUser).AsQueryable();
        }

        [HttpPost]
        [CustomQueryable]
        [Route("InsAndUpdChooseColumn")]
        public UserColumnSettings InsAndUpdChooseColumn(UserColumnSettings userColumnSettings)
        {
            _command.ActiveUser = ActiveUser;
            return _command.InsAndUpdChooseColumn(userColumnSettings);
        }

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

        [HttpGet]
        [CustomQueryable]
        [Route("RefLookup")]
        public IQueryable<LookupReference> GetRefLookup(EntitiesAlias entitiesAlias)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetRefLookup(entitiesAlias).AsQueryable();
        }

        [HttpGet]
        [Route("CheckRecordUsed")]
        public bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity)
        {
            _command.ActiveUser = ActiveUser;
            return _command.CheckRecordUsed(allRecordIds, entity);
        }

        [HttpPost]
        [Route("ByteArrayByIdAndEntity")]
        public ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetByteArrayByIdAndEntity(byteArray);
        }

        [HttpGet]
        [Route("AddorEditPreferedLocations")]
        public IList<PreferredLocation> AddorEditPreferedLocations(string locations, int contTypeId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.AddorEditPreferedLocations(locations, contTypeId);
        }

        [HttpGet]
        [Route("GetPreferedLocations")]
        public IList<PreferredLocation> GetPreferedLocations(int contTypeId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetPreferedLocations(contTypeId);
        }

        [HttpGet]
        [Route("GetUserContactType")]
        public int GetUserContactType()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserContactType();
        }

        [HttpGet]
        [Route("ContactById")]
        public Entities.Contact.Contact GetContactById(long recordId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetContactById(recordId);
        }

        [HttpGet]
        [Route("ContactAddressByCompany")]
        public Entities.Contact.Contact GetContactAddressByCompany(long companyId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetContactAddressByCompany(companyId);
        }

        [HttpPost]
        [CustomQueryable]
        [Route("ContactCardAddOrEdit")]
        public Entities.Contact.Contact ContactCardAddOrEdit(Entities.Contact.Contact contact)
        {
            _command.ActiveUser = ActiveUser;
            return _command.ContactCardAddOrEdit(contact);
        }

        [HttpPost]
        [Route("LastItemNumber")]
        public int GetLastItemNumber(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetLastItemNumber(pagedDataInfo);
        }

        [HttpPost]
        [Route("ResetItemNumber")]
        public bool ResetItemNumber(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.ResetItemNumber(pagedDataInfo);
        }

        [HttpGet]
        [Route("CustPPPTree")]
        public virtual IQueryable<TreeListModel> GetCustPPPTree(long? custId, long? parentId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetCustPPPTree(ActiveUser, ActiveUser.OrganizationId, custId, parentId).AsQueryable(); ;
        }

        [HttpGet]
        [Route("UpdateLineNumberForJobCostSheet")]
        public virtual bool UpdateLineNumberForJobCostSheet(long? jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdateLineNumberForJobCostSheet(ActiveUser, ActiveUser.OrganizationId, jobId); ;
        }

        [HttpGet]
        [Route("UpdateLineNumberForJobBillableSheet")]
        public virtual bool UpdateLineNumberForJobBillableSheet(long? jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.UpdateLineNumberForJobBillableSheet(ActiveUser, ActiveUser.OrganizationId, jobId); ;
        }

        [HttpPost]
        [CustomQueryable]
        [Route("ErrorLog")]
        public Entities.ErrorLog GetOrInsErrorLog(Entities.ErrorLog errorLog)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrInsErrorLog(errorLog);
        }

        [HttpPost]
        [CustomQueryable]
        [Route("TableAssociations")]
        public IQueryable<DeleteInfo> GetTableAssociations(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetTableAssociations(pagedDataInfo).AsQueryable();
        }

        [HttpGet]
        [CustomQueryable]
        [Route("UserDashboards")]
        public IQueryable<AppDashboard> GetUserDashboards(int mainModuleId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetUserDashboards(mainModuleId).AsQueryable();
        }

        [HttpGet]
        [Route("NextBreakDownStructure")]
        public string GetNextBreakDownStructure(bool ribbon)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetNextBreakDownStructure(ribbon);
        }

        [HttpGet]
        [Route("JobIsCompleted")]
        public bool GetJobIsCompleted(long jobId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetJobIsCompleted(jobId);
        }

        [HttpGet]
        [Route("{id}")]
        public Entities.Organization.OrgRefRole GetOrgRefRole(long id)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrgRefRole(id);
        }

        [HttpGet]
        [CustomQueryable]
        [Route("OrganizationRoleDetail")]
        public IQueryable<Role> GetOrganizationRoleDetails()
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetOrganizationRoleDetails().AsQueryable();
        }

        [HttpPost]
        [Route("UserSystemSettings")]
        public void UpdateUserSystemSettings(SysSetting userSystemSettings)
        {
            _command.ActiveUser = ActiveUser;
            _command.UpdateUserSystemSettings(userSystemSettings);
        }

        [HttpPost]
        [CustomQueryable]
        [Route("GetDeleteInfoModules")]
        public IQueryable<SysRefModel> GetDeleteInfoModules(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDeleteInfoModules(pagedDataInfo).AsQueryable();
        }

        [HttpPost]
        [CustomQueryable]
        [Route("GetDeleteInfoRecords")]
        public dynamic GetDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDeleteInfoRecords(pagedDataInfo);
        }

        [HttpPost]
        [Route("RemoveDeleteInfoRecords")]
        public void RemoveDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            _command.ActiveUser = ActiveUser;
            _command.RemoveDeleteInfoRecords(pagedDataInfo);
        }

        [HttpGet]
        [Route("GetDashboardAccess")]
        public UserSecurity GetDashboardAccess(string tableName, long dashboardId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetDashboardAccess(tableName, dashboardId);
        }

        [HttpGet]
        [Route("GetMaxMinRecordsByEntity")]
        public CommonIds GetMaxMinRecordsByEntity(string entity, long RecordID, long ID)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetMaxMinRecordsByEntity(entity, RecordID, ActiveUser.OrganizationId, ID);
        }

        [HttpGet]
        [Route("GetGatewayTypeByJobID")]
        public JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetGatewayTypeByJobID(jobGatewayateId);
        }

        [HttpGet]
        [Route("GetCompCorpAddress")]
        public CompanyCorpAddress GetCompCorpAddress(int compId)
        {
            _command.ActiveUser = ActiveUser;
            return _command.GetCompCorpAddress(compId);
        }

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
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GetJobGateway")]
        public IQueryable<JobGatewayDetails> GetJobGateway(long jobId)
        {
            _command.ActiveUser = Models.ApiContext.ActiveUser;
            return _command.GetJobGateway(jobId).AsQueryable();
        }

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