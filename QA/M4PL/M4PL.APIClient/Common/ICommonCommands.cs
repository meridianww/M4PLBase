#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ICommonCommands
// Purpose:                                      Set of rules for CommonCommands
//=============================================================================================================

using M4PL.APIClient.ViewModels.Attachment;
using M4PL.APIClient.ViewModels.Contact;
using M4PL.APIClient.ViewModels.Document;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Common
{
	public interface ICommonCommands
	{
		ActiveUser ActiveUser { get; set; }

		IDictionary<EntitiesAlias, TableReference> Tables { get; }

		#region Cached Results

		/// <summary>
		/// Route to call Ribbon Menus
		/// </summary>
		/// <returns></returns>

		IList<RibbonMenu> GetRibbonMenus(bool forceUpdate = false);

		/// <summary>
		/// Route to call RefLanguagesNames
		/// </summary>
		/// <param name="lookupId"></param>
		/// <returns></returns>
		IList<IdRefLangName> GetIdRefLangNames(int lookupId, bool forceUpdate = false);

		/// <summary>
		/// Route to call Operation
		/// </summary>
		/// <param name="operationType"></param>
		/// <returns></returns>
		Operation GetOperation(OperationTypeEnum operationType, bool forceUpdate = false);

		/// <summary>
		/// Route to call Page IClass1.csnformation
		/// </summary>
		/// <param name="entity"></param>
		/// <returns></returns>
		IList<PageInfo> GetPageInfos(EntitiesAlias entity, bool forceUpdate = false);

		/// <summary>
		/// Route to call Display Message based on Message Code
		/// </summary>
		/// <param name="messageType"></param>
		/// <param name="messageCode"></param>
		/// <returns></returns>
		DisplayMessage GetDisplayMessageByCode(MessageTypeEnum messageType, string messageCode, bool forceUpdate = false);

		/// <summary>
		/// Route to GetCompanyAddress
		/// </summary>
		/// <param name="compId"></param>
		/// <returns>CompanyCorpAddress</returns>
		CompanyCorpAddress GetCompCorpAddress(int compId);

		/// <summary>
		/// Route to call Page Information
		/// </summary>
		/// <param name="entity"></param>
		/// <returns></returns>
		object GetMasterTableObject(EntitiesAlias entity, bool forceUpdate = false);

		IList<ConditionalOperator> GetConditionalOperators(bool forceUpdate = false);

		IList<ViewModels.ColumnSetting> GetColumnSettings(EntitiesAlias entity, bool forceUpdate = false);

		IList<ViewModels.ColumnSetting> GetGridColumnSettings(EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false);

		IList<ValidationRegEx> GetValidationRegExpsByEntityAlias(EntitiesAlias entity, bool forceUpdate = false);

		void ReloadCacheForAllEntites();

		SysSetting GetSystemSetting(bool forceUpdate = false, ActiveUser activeUser = null);

		#endregion Cached Results

		int GetLookupIdByName(string lookupName);

		List<EnumKeyValue> GetContactType(string lookupName);

		/// <summary>
		/// Route to call Main Modules Menus
		/// </summary>
		/// <returns></returns>

		IList<LeftMenu> GetModuleMenus();

		/// <summary>
		/// Route to call User Securities
		/// </summary>
		/// <returns></returns>
		IList<UserSecurity> GetUserSecurities(ActiveUser activeUser);

		/// <summary>
		/// Route to call Ref role  Securities
		/// </summary>
		/// <returns></returns>
		IList<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser);

		UserColumnSettings GetUserColumnSettings(EntitiesAlias entity);

		SysSetting GetUserSysSettings(ActiveUser activeUser = null);

		bool GetIsFieldUnique(UniqueValidation uniqueValidation);

		string IsValidJobSiteCode(string jobSiteCode, long programId);

		long GetVendorIdforSiteCode(string jobSiteCode, long programId);

		bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount);

		UserColumnSettings InsAndUpdChooseColumn(UserColumnSettings userColumnSettings);

		int SaveBytes(ByteArray byteArray, byte[] bytes);

		IList<LookupReference> GetRefLookup(EntitiesAlias entitiesAlias);

		bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity);

		object GetPagedSelectedFieldsByTable(DropDownInfo dropDownDataInfo, ActiveUser activeUser = null);

		object GetProgramDescendants(DropDownInfo dropDownDataInfo);

		ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray);

		ContactView GetContactById(long recordId);

		ContactView GetContactAddressByCompany(long companyId);

		ContactView ContactCardAddOrEdit(ContactView contactView, string routeSuffix = "");

		int GetLastItemNumber(PagedDataInfo pagedDataInfo, string fieldName);

		bool ResetItemNumber(PagedDataInfo pagedDataInfo, string fieldName, string whereCondition, List<long> ids);

		int GetPageNumber(EntitiesAlias entityAlias);

		IList<TreeListModel> GetCustPPPTree(long? custId, long? parentId);

		ErrorLog GetOrInsErrorLog(ErrorLog errorLog);

		IList<AppDashboard> GetUserDashboards(int mainModuleId);

		string GetNextBreakDownStrusture(bool ribbon);

		bool GetIsJobCompleted(long jobid);

		IList<Role> GetOrganizationRoleDetails();

		void UpdateUserSystemSettings(SysSetting userSystemSettings, ActiveUser activeUser = null);

		IList<PreferredLocation> AddorEditPreferedLocations(string locations, int ContTypeId);

		IList<PreferredLocation> GetPreferedLocations(ActiveUser activeUser);

		int GetUserContactType(ActiveUser activeUser = null);

		IList<SysRefModel> GetDeleteInfoModules(PagedDataInfo pagedDataInfo);

		dynamic GetDeleteInfoRecords(PagedDataInfo pagedDataInfo);

		void RemoveDeleteInfoRecords(PagedDataInfo pagedDataInfo);

		UserSecurity GetDashboardAccess(string tableName, long dashboardId);

		CommonIds GetMaxMinRecordsByEntity(string entity, long recordID, long ID);

		bool UpdateLineNumberForJobCostSheet(PagedDataInfo pagedDataInfo);

		bool UpdateLineNumberForJobBillableSheet(PagedDataInfo pagedDataInfo);

		JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId);

		DocumentDataView DownloadAll(string jobId);

		DocumentDataView DownloadBOL(string jobId);

		DocumentDataView DownloadTracking(string jobId);

		DocumentDataView GetPriceCodeReportByJobId(string jobId);

		DocumentDataView GetCostCodeReportByJobId(string jobId);

		DocumentDataView DownloadPOD(string jobId);

		DocumentStatusView GetDocumentStatusByJobId(string jobId);

		DocumentStatusView IsPriceCodeDataPresentForJob(string jobId);

		DocumentStatusView IsCostCodeDataPresentForJob(string jobId);

		IList<JobAction> GetJobAction(long jobId, string entity = null, bool? isScheduleAciton = null);
	}
}