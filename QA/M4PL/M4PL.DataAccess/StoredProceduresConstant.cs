/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 StoredProcedureConstants
Purpose:                                      Contains Strored procedures of the system
=============================================================================================================*/

namespace M4PL.DataAccess
{
    /// <summary>
    ///     To hold all SP list to perform CRUD on entity
    ///     KEEP A-Z REGION PLEASE!!
    /// </summary>
    public class StoredProceduresConstant
    {
        public const string TotalCountLastParam = "@TotalCount";

		#region General SPs
		public const string GetGatewayTypeByJobID = "dbo.GetGatewayTypeByJobID";
		public const string GetMaxMinRecordByEntity = "dbo.GetMaxMinRecordByEntity";
        public const string GetDashboardAccess = "dbo.GetDashboardAccess";
        public const string GetUserPageOptnLevelAndPermission = "dbo.GetUserPageOptnLevelAndPermission";
        public const string GetOrInsErrorLog = "dbo.GetOrInsErrorLog";
        public const string GetRibbonMenus = "dbo.GetRibbonMenus";
        public const string GetTables = "dbo.GetTables";
        public const string GetOperations = "dbo.GetOperations";
        public const string GetPageAndTabNames = "dbo.GetPageAndTabNames";
        public const string GetDisplayMessagesByCode = "dbo.GetDisplayMessagesByCode";
		public const string GetDataForChangeHistory = "dbo.GetDataForChangeHistory";

		public const string GetUserSecurities = "dbo.GetUserSecurities";
        public const string GetUserSubSecurities = "dbo.GetUserSubSecurities";
        public const string GetComboBoxContacts = "dbo.GetComboBoxContacts";
        public const string GetComboBoxContact = "dbo.GetContactCombobox";
        public const string GetSelectedFieldsByTable = "dbo.GetSelectedFieldsByTable";
        public const string GetProgramDescendants = "dbo.GetProgramDescendants";
        public const string GetProgramCodesById = "dbo.GetProgramCodesById";
        public const string GetAppDashboardDropdown = "dbo.GetAppDashboardDropdown";
        public const string GetSysRefDropDown = "dbo.GetSysRefDropDown";
        public const string GetVendorDropDownByPrgId = "dbo.GetVendorDropDownByPrgId";
        public const string SaveBytes = "dbo.SaveBytes";
        public const string GetRefLookup = "dbo.GetRefLookup";
        public const string GetMenuModuleDropdown = "dbo.GetMenuModuleDropdown";
        public const string GetActrolesByProgramId = "dbo.GetActrolesByProgramId";
        public const string GetRefRolesByProgramId = "dbo.GetRefRolesByProgramId";
        public const string GetProgramRolesByProgramId = "dbo.GetProgramRolesByProgramId";
        public const string GetUserSysSetting = "dbo.GetUserSysSetting";
        public const string GetLastItemNumber = "dbo.GetLastItemNumber";
        public const string ResetItemNumber = "dbo.ResetItemNumber";
        public const string UpdSecByRoleItemNumberAfterDelete = "dbo.UpdSecByRoleItemNumberAfterDelete";
        public const string GetLookupDropDown = "dbo.GetLookupDropDown";
        public const string GetDeletedRecordLookUpIds = "dbo.GetDeletedRecordLookUpIds";
        public const string GetCustPPPTree = "dbo.GetCustPPPTree";
        public const string GetStatesDropDown = "dbo.GetStatesDropDown";
        public const string GetProgramContacts = "dbo.GetProgramContactsByProgramId";
        public const string GetVendorLocations = "dbo.GetVendorLocations";
        public const string GetEDIMappingTablesByType = "dbo.GetEDIMappingTablesByType";
        public const string GetUserDashboards = "dbo.GetUserDashboards";
        public const string SwitchOrganization = "dbo.SwitchOrganization";
        public const string GetNextModuleBDS = "dbo.GetNextModuleBDS";
        public const string GetVocReportData = "dbo.GetVocReportData";

        public const string GetIsJobCompleted = "dbo.GetIsJobCompleted";
        public const string GetOrganizationRoleDetails = "dbo.GetOrganizationRoleDetails";
        public const string UpdateUserSystemSettings = "dbo.UpdUserSystemSettings";
        public const string GetDeleteInfoModules = "dbo.GetDeleteInfoModules";
        public const string GetDeleteInfoRecords = "dbo.GetDeleteInfoRecords";

        public const string RemoveDeleteInfoRecords = "dbo.RemoveDeleteInfoRecords";
		public const string GetComboBoxCompany = "dbo.GetComboBoxCompany";
		public const string GetProgramRollupBillingJob = "dbo.GetProgramRollupBillingJob";
		public const string UpdateLineNumberForJobBillableSheet = "dbo.UpdateLineNumberForJobBillableSheet";
		public const string UpdateLineNumberForJobCostSheet = "dbo.UpdateLineNumberForJobCostSheet";
		public const string UpdateDataForChangeHistory = "dbo.UpdateDataForChangeHistory";
		#endregion General SPs

		#region Generic SPs

		public const string CheckRecordUsed = "dbo.CheckRecordUsed";
        public const string GetColumnAliasesByTableName = "dbo.GetColumnAliasesByTableName";
        public const string GetGridColumnAliasesByTableName = "dbo.GetGridColumnAliasesByTableName";
        public const string GetColumnAliasesByUserAndTbl = "dbo.GetColumnAliasesByUserAndTbl";
        public const string GetIdRefLangNames = "dbo.GetIdRefLangNames";
        public const string GetIdRefLangNamesFromTable = "dbo.GetIdRefLangNamesFromTable";
        public const string GetIsFieldUnique = "dbo.GetIsFieldUnique";
        public const string GetMasterTableObject = "dbo.GetMasterTableObject";
        public const string GetValidationRegExpsByTblName = "dbo.GetValidationRegExpsByTblName";
        public const string UpdateEntityField = "dbo.UpdateEntityField";
        public const string GetByteArrayByIdAndEntity = "dbo.GetByteArrayByIdAndEntity";
        public const string GetModuleMenus = "dbo.GetModuleMenus";
        public const string GetSystemSettings = "dbo.GetSystemSettings";

        #endregion Generic SPs

        #region Administration

        /* Column Alias */
        public const string GetColumnAliasView = "dbo.GetColumnAliasView";
        public const string GetColumnAlias = "dbo.GetColumnAlias";
        public const string InsertColumnAlias = "dbo.InsColumnAlias";
        public const string UpdateColumnAlias = "dbo.UpdColumnAlias";
        public const string GetColumnAliasesDropDown = "dbo.GetColumnAliasesDropDown";
        public const string GetEdiSummaryHeaderDropDown = "dbo.GetEdiSummaryHeaderDropDown";

        /* Menu Access Level */
        public const string GetMenuAccessLevelView = "dbo.GetMenuAccessLevelView";
        public const string GetMenuAccessLevel = "dbo.GetMenuAccessLevel";
        public const string InsertMenuAccessLevel = "dbo.InsMenuAccessLevel";
        public const string UpdateMenuAccessLevel = "dbo.UpdMenuAccessLevel";

        /* Menu Driver */
        public const string GetMenuDriverView = "dbo.GetMenuDriverView";
        public const string GetMenuDriver = "dbo.GetMenuDriver";
        public const string InsertMenuDriver = "dbo.InsMenuDriver";
        public const string UpdateMenuDriver = "dbo.UpdMenuDriver";
        public const string UpdateMenuDriverIcons = "dbo.UpdMenuDriverIcons";

        /* Menu Option Level */
        public const string GetMenuOptionLevelView = "dbo.GetMenuOptionLevelView";
        public const string GetMenuOptionLevel = "dbo.GetMenuOptionLevel";
        public const string InsertMenuOptionLevel = "dbo.InsMenuOptionLevel";
        public const string UpdateMenuOptionLevel = "dbo.UpdMenuOptionLevel";

        /* Message Type */
        public const string GetMessageTypeView = "dbo.GetMessageTypeView";
        public const string GetMessageType = "dbo.GetMessageType";
        public const string InsertMessageType = "dbo.InsMessageType";
        public const string UpdateMessageType = "dbo.UpdMessageType";

        /* Security By Role */
        public const string GetSecurityByRoleView = "dbo.GetSecurityByRoleView";
        public const string GetSecurityByRole = "dbo.GetSecurityByRole";
        public const string InsertSecurityByRole = "dbo.InsSecurityByRole";
        public const string UpdateSecurityByRole = "dbo.UpdSecurityByRole";

        /* Sub Security By Role */
        public const string GetSubSecurityByRoleView = "dbo.GetSubSecurityByRoleView";
        public const string GetSubSecurityByRole = "dbo.GetSubSecurityByRole";
        public const string InsertSubSecurityByRole = "dbo.InsSubSecurityByRole";
        public const string UpdateSubSecurityByRole = "dbo.UpdSubSecurityByRole";


        /* System Message */
        public const string GetSystemMessageView = "dbo.GetSystemMessageView";
        public const string GetSystemMessage = "dbo.GetSystemMessage";
        public const string InsertSystemMessage = "dbo.InsSystemMessage";
        public const string UpdateSystemMessage = "dbo.UpdSystemMessage";

        /* System Page Tab Name */
        public const string GetSystemPageTabNameView = "dbo.GetSysRefTabPageNameView";
        public const string GetSystemPageTabName = "dbo.GetSysRefTabPageName";
        public const string InsertSystemPageTabName = "dbo.InsSysRefTabPageName";
        public const string UpdateSystemPageTabName = "dbo.UpdSysRefTabPageName";

        /*System Reference*/
        public const string GetSystemReferenceView = "dbo.GetSysRefOptionView";
        public const string GetSystemReference = "dbo.GetSysRefOption";
        public const string InsertSystemReference = "dbo.InsSysRefOption";
        public const string UpdateSystemReference = "dbo.UpdSysRefOption";

        /* Validation */
        public const string GetValidationView = "dbo.GetValidationView";
        public const string GetValidation = "dbo.GetValidation";
        public const string InsertValidation = "dbo.InsValidation";
        public const string UpdateValidation = "dbo.UpdValidation";

        /* Report */
        public const string GetReportView = "dbo.GetReportView";
        public const string GetReport = "dbo.GetReport";
        public const string InsertReport = "dbo.InsReport";
        public const string UpdateReport = "dbo.UpdReport";

        /* Dashboard */
        public const string GetDashboardView = "dbo.GetDashboardView";
        public const string GetDashboard = "dbo.GetDashboard";
        public const string InsertDashboard = "dbo.InsDashboard";
        public const string UpdateDashboard = "dbo.UpdDashboard";

        /*Choose Column*/
        public const string InsAndUpdChooseColumn = "dbo.InsAndUpdChooseColumn";

        /* SystemAccount (OpnSezMe) */
        public const string GetSystemAccountView = "dbo.GetSystemAccountView";
        public const string GetSystemAccount = "dbo.GetSystemAccount";
        public const string InsertSystemAccount = "dbo.InsSystemAccount";
        public const string UpdateSystemAccount = "dbo.UpdSystemAccount";
        public const string UpdSysAccAndConBridgeRole = "dbo.UpdSysAccAndConBridgeRole";

        /* DeliveryStatus */
        public const string GetDeliveryStatusView = "dbo.GetDeliveryStatusView";
        public const string GetDeliveryStatus = "dbo.GetDeliveryStatus";
        public const string InsertDeliveryStatus = "dbo.InsDeliveryStatus";
        public const string UpdateDeliveryStatus = "dbo.UpdDeliveryStatus";
        public const string DeleteDeliveryStatus = "dbo.DeleteDeliveryStatus";

        /* StatusLog */
        public const string GetSystemStatusLogView = "dbo.GetSystemStatusLogView";

        /* Sync Nav Customers */
        public const string UpdateERPIdCustomer = "dbo.UpdateERPIdCustomer";

        /* Sync Nav Vendor */
        public const string UpdateERPIdVendor = "dbo.UpdateERPIdVendor";

        /* Sync Nav Cost Code */
        public const string UpdateNavCostCode = "dbo.UpdateNavCostCode";
        public const string UpdateNavCostCodeByItem = "dbo.UpdateNavCostCodeByItem";

        /* Sync Nav PriceCode */
        public const string UpdateNavPriceCode = "dbo.UpdateNavPriceCode";
        public const string UpdateNavPriceCodeByItem = "dbo.UpdateNavPriceCodeByItem";

        #endregion Administration

        #region Contact

        /* Contact */
        public const string GetContactView = "dbo.GetContactView";
        public const string GetContact = "dbo.GetContact";
        public const string InsertContact = "dbo.InsContact";
        public const string UpdateContact = "dbo.UpdContact";
        public const string UpdateContactCard = "dbo.UpdContactCard";
        public const string DeleteContact = "dbo.DeleteContact";
        public const string CheckContactLoggedIn = "dbo.CheckContactLoggedIn";
        public const string IsValidJobSiteCode = "dbo.IsValidJobSiteCode";
        public const string GetVendorIdforSiteCode = "dbo.GetVendorIdforSiteCode";
        /* Entity Contact By Contact Bridge  */
        public const string GetEntityContactView = "dbo.GetEntityContactView";
        public const string GetEntityContact = "dbo.GetEntityContact";
        public const string InsertEntityContact = "dbo.InsEntityContact";
        public const string UpdateEntityContact = "dbo.UpdEntityContact";
        public const string DeleteEntityContact = "dbo.DeleteEntityContact";

        #endregion Contact

        #region Customer

        /* Customer  */
        public const string GetCustomerView = "dbo.GetCustomerView";
        public const string GetCustomer = "dbo.GetCustomer";
        public const string InsertCustomer = "dbo.InsCustomer";
        public const string UpdateCustomer = "dbo.UpdCustomer";
        public const string UpdatePartialCustomer = "dbo.UpdPartialCustomer";
        public const string DeleteCustomer = "dbo.DeleteCustomer";
        public const string GetCustomers = "dbo.GetCustomers";

        /* Customer Contact  */
        public const string GetCustContactView = "dbo.GetCustContactView";
        public const string GetCustContact = "dbo.GetCustContact";
        public const string InsertCustContact = "dbo.InsCustContact";
        public const string UpdateCustContact = "dbo.UpdCustContact";
        public const string DeleteCustContact = "dbo.DeleteCustomerContact";

        /* Customer Business Term */
        public const string GetCustBusinessTermView = "dbo.GetCustBusinessTermView";
        public const string GetCustBusinessTerm = "dbo.GetCustBusinessTerm";
        public const string InsertCustBusinessTerm = "dbo.InsCustBusinessTerm";
        public const string UpdateCustBusinessTerm = "dbo.UpdCustBusinessTerm";

        /* Customer Dc Location */
        public const string GetCustDcLocationView = "dbo.GetCustDcLocationView";
        public const string GetCustDcLocation = "dbo.GetCustDcLocation";
        public const string InsertCustDcLocation = "dbo.InsCustDcLocation";
        public const string UpdateCustDcLocation = "dbo.UpdCustDcLocation";

        /* Customer Dc Location Contact */
        public const string GetCustDcLocationContactView = "dbo.GetCustDcLocationContactView";
        public const string GetCustDcLocationContact = "dbo.GetCustDcLocationContact";
        public const string InsertCustDcLocationContact = "dbo.InsCustDcLocationContact";
        public const string UpdateCustDcLocationContact = "dbo.UpdCustDcLocationContact";
        public const string BatchUpdateCustDcLocationContact = "dbo.BatchUpdateCustDcLocationContact";

        /* Customer Doc Reference */
        public const string GetCustDocReferenceView = "dbo.GetCustDocReferenceView";
        public const string GetCustDocReference = "dbo.GetCustDocReference";
        public const string InsertCustDocReference = "dbo.InsCustDocReference";
        public const string UpdateCustDocReference = "dbo.UpdCustDocReference";

        /* Customer Financial Calander */
        public const string GetCustFinancialCalenderView = "dbo.GetCustFinacialCalenderView";
        public const string GetCustFinancialCalender = "dbo.GetCustFinacialCalender";
        public const string InsertCustFinancialCalender = "dbo.InsCustFinacialCalender";
        public const string UpdateCustFinancialCalender = "dbo.UpdCustFinacialCalender";

        #endregion Customer

        #region Company Address
        public const string GetCompanyAddressView = "dbo.GetCompanyAddressView";
        public const string GetCompanyAddress = "dbo.GetCompanyAddress";
        public const string InsertCompanyAddress = "dbo.InsCompanyAddress";
        public const string UpdateCompanyAddress = "dbo.UpdCompanyAddress";
        public const string DeleteCompanyAddress = "dbo.DeleteCompanyAddress";
        public const string GetCompanyCorporateAddress = "dbo.GetCompanyCorporateAddress";
        #endregion

        #region Organization

        /* Organization */
        public const string GetOrganizationView = "dbo.GetOrganizationView";
        public const string GetOrganization = "dbo.GetOrganization";
        public const string InsertOrganization = "dbo.InsOrganization";
        public const string UpdateOrganization = "dbo.UpdOrganization";
        public const string DeleteOrganization = "dbo.DeleteOrganization";
        public const string UpdatePartialOrganization = "dbo.UpdPartialOrganization";

        /* Organization Credential */
        public const string GetOrgCredentialView = "dbo.GetOrgCredentialView";
        public const string GetOrgCredential = "dbo.GetOrgCredential";
        public const string InsertOrgCredential = "dbo.InsOrgCredential";
        public const string UpdateOrgCredential = "dbo.UpdOrgCredential";

        /* Organization Financial Calender */
        public const string GetOrgFinancialCalView = "dbo.GetOrgFinacialCalenderView";
        public const string GetOrgFinancialCalender = "dbo.GetOrgFinacialCalender";
        public const string InsertOrgFinancialCalender = "dbo.InsOrgFinacialCalender";
        public const string UpdateOrgFinancialCalender = "dbo.UpdOrgFinacialCalender";

        /* Organization Market Support */
        public const string GetOrgMarketSupportView = "dbo.GetOrgMarketSupportView";
        public const string GetOrgMarketSupport = "dbo.GetOrgMarketSupport";
        public const string InsertOrgMarketSupport = "dbo.InsOrgMarketSupport";
        public const string UpdateOrgMarketSupport = "dbo.UpdOrgMarketSupport";

        /* Organization Poc Contact */
        public const string GetOrgPocContactView = "dbo.GetOrgPocContactView";
        public const string GetOrgPocContact = "dbo.GetOrgPocContact";
        public const string InsertOrgPocContact = "dbo.InsOrgPocContact";
        public const string UpdateOrgPocContact = "dbo.UpdOrgPocContact";

        /* Organization Ref Role */
        public const string GetOrgRefRoleView = "dbo.GetOrgRefRoleView";
        public const string GetOrgRefRole = "dbo.GetOrgRefRole";
        public const string InsertOrgRefRole = "dbo.InsOrgRefRole";
        public const string UpdateOrgRefRole = "dbo.UpdOrgRefRole";
        public const string GetRefRoleSecurities = "dbo.GetRefRoleSecurities";

        /* Get permitted items by userid as per entity */
        public const string GetCustomEntityIdByEntityName = "dbo.GetCustomEntityIdByEntityName";

        #endregion Organization

        #region Vendor

        /* Vendor  */
        public const string GetVendorView = "dbo.GetVendorView";
        public const string GetVendor = "dbo.GetVendor";
        public const string InsertVendor = "dbo.InsVendor";
        public const string UpdateVendor = "dbo.UpdVendor";
        public const string DeleteVendor = "dbo.DeleteVendor";
        public const string GetVendors = "dbo.GetVendors";
        public const string UpdatePartialVendor = "dbo.UpdPartialVendor";

        /* Vendor Contact  */
        public const string GetVendContactView = "dbo.GetVendContactView";
        public const string GetVendContact = "dbo.GetVendContact";
        public const string InsertVendContact = "dbo.InsVendContact";
        public const string UpdateVendContact = "dbo.UpdVendContact";

        /* Vendor Business Term */
        public const string GetVendBusinessTermView = "dbo.GetVendBusinessTermView";
        public const string GetVendBusinessTerm = "dbo.GetVendBusinessTerm";
        public const string InsertVendBusinessTerm = "dbo.InsVendBusinessTerm";
        public const string UpdateVendBusinessTerm = "dbo.UpdVendBusinessTerm";

        /* Vendor Dc Location */
        public const string GetVendDcLocationView = "dbo.GetVendDCLocationView";
        public const string GetVendDcLocation = "dbo.GetVendDCLocation";
        public const string InsertVendDcLocation = "dbo.InsVendDCLocation";
        public const string UpdateVendDcLocation = "dbo.UpdVendDCLocation";

        /* Vendor Dc Location Contact */
        public const string GetVendDcLocationContactView = "dbo.GetVendDcLocationContactView";
        public const string GetVendDcLocationContact = "dbo.GetVendDcLocationContact";
        public const string InsertVendDcLocationContact = "dbo.InsVendDcLocationContact";
        public const string UpdateVendDcLocationContact = "dbo.UpdVendDcLocationContact";
        public const string BatchUpdateVendDcLocationContact = "BatchUpdateVendDcLocationContact";

        /* Vendor Doc Reference */
        public const string GetVendDocReferenceView = "dbo.GetVendDocReferenceView";
        public const string GetVendDocReference = "dbo.GetVendDocReference";
        public const string InsertVendDocReference = "dbo.InsVendDocReference";
        public const string UpdateVendDocReference = "dbo.UpdVendDocReference";

        /* Vendor Financial Calander */
        public const string GetVendFinancialCalenderView = "dbo.GetVendFinancialCalenderView";
        public const string GetVendFinancialCalender = "dbo.GetVendFinancialCalender";
        public const string InsertVendFinancialCalender = "dbo.InsVendFinancialCalender";
        public const string UpdateVendFinancialCalender = "dbo.UpdVendFinancialCalender";

        #endregion Vendor

        #region Job

        /* Job */
        public const string GetJobView = "dbo.GetJobView";
        public const string GetJob = "dbo.GetJob";
        public const string GetJobsSiteCodeByProgram = "dbo.GetJobsSiteCodeByProgram";
        public const string GetJobByCustomerView = "dbo.GetJobByCustomerView";
		public const string GetJobDataFromEDI204 = "dbo.GetJobDataFromEDI204";

		public const string InsertJob = "dbo.InsJob";
        public const string UpdateJob = "dbo.UpdJob";
        public const string DeleteJob = "dbo.DeleteJob";

        /* Job Destination */
        public const string GetJobDestination = "dbo.GetJobDestination";
        public const string InsJobDestination = "dbo.InsJobDestination";
        public const string UpdJobDestination = "dbo.UpdJobDestination";

        /* Job 2nd Poc */
        public const string GetJob2ndPoc = "dbo.GetJob2ndPoc";
        public const string InsJob2ndPoc = "dbo.InsJob2ndPoc";
        public const string UpdJob2ndPoc = "dbo.UpdJob2ndPoc";

        /* Job Seller */
        public const string GetJobSeller = "dbo.GetJobSeller";
        public const string InsJobSeller = "dbo.InsJobSeller";
        public const string UpdJobSeller = "dbo.UpdJobSeller";

        /* Job Map Route */
        public const string GetJobMapRoute = "dbo.GetJobMapRoute";
        public const string InsJobMapRoute = "dbo.InsJobMapRoute";
        public const string UpdJobMapRoute = "dbo.UpdJobMapRoute";

        /* Job Pod */
        public const string GetJobPod = "dbo.GetJob";

        /* Job Attribute */
        public const string GetJobAttributeView = "dbo.GetJobAttributeView";
        public const string GetJobAttribute = "dbo.GetJobAttribute";
        public const string InsertJobAttribute = "dbo.InsJobAttribute";
        public const string UpdateJobAttribute = "dbo.UpdJobAttribute";

		/* JobAdvanceReport */
		public const string GetJobAdvanceReportView = "dbo.GetJobAdvanceReportView";
		public const string GetJobAdvanceReport = "dbo.GetJobAdvanceReport";

        /* Job Card */
        public const string GetJobCardView = "dbo.GetJobCardView";
        public const string GetCardTileData = "dbo.GetCardTileData";
        public const string GetCardTileDataCount = "dbo.GetCardTileDataCount";

        /* Job Cargo */
        public const string GetJobCargoView = "dbo.GetJobCargoView";
        public const string GetJobCargo = "dbo.GetJobCargo";
        public const string InsertJobCargo = "dbo.InsJobCargo";
        public const string UpdateJobCargo = "dbo.UpdJobCargo";

		/* Job EDIXcbl */
		public const string GetJobEDIXcblView = "dbo.GetJobEDIXcblView";
		public const string GetJobEDIXcbl = "dbo.GetJobEDIXcbl";
		public const string InsertJobEDIXcbl = "dbo.InsJobEDIXcbl";
		public const string UpdateJobEDIXcbl = "dbo.UpdJobEDIXcbl";

		/* Job Cargo Detail */
		public const string GetJobCargoDetailView = "dbo.GetJobCargoDetailView";
        public const string GetJobCargoDetail = "dbo.GetJobCargoDetail";
        public const string InsertJobCargoDetail = "dbo.InsJobCargoDetail";
        public const string UpdateJobCargoDetail = "dbo.UpdJobCargoDetail";

        /* Job Doc Reference */
        public const string GetJobDocReferenceView = "dbo.GetJobDocReferenceView";
        public const string GetJobDocReference = "dbo.GetJobDocReference";
        public const string InsertJobDocReference = "dbo.InsJobDocReference";
        public const string UpdateJobDocReference = "dbo.UpdJobDocReference";

        /* Job Gateway */
        public const string GetJobGatewayView = "dbo.GetJobGatewayView";
        public const string GetJobGateway = "dbo.GetJobGateway";
        public const string InsertJobGateway = "dbo.InsJobGateway";
        public const string UpdateJobGateway = "dbo.UpdJobGateway";
        public const string UpdateJobGatewayAction = "dbo.UpdJobGatewayAction";
        public const string GetJobGatewayComplete = "dbo.GetJobGatewayComplete";
        public const string UpdJobGatewayComplete = "dbo.UpdJobGatewayComplete";
        public const string GetJobActions = "dbo.GetJobActions";
        public const string GetJobActionCodes = "dbo.GetAppoinmentStatusReasoneCode";
        public const string GetJobGateways = "dbo.GetJobGatewayFromProgram";

        /* Job Cost Sheet */
        public const string GetJobCostSheetView = "dbo.GetJobCostSheetView";
        public const string GetJobCostSheet = "dbo.GetJobCostSheet";
        public const string InsertJobCostSheet = "dbo.InsJobCostSheet";
        public const string UpdateJobCostSheet = "dbo.UpdJobCostSheet";
        public const string GetJobCostCodeAction = "dbo.GetJobCostCodeAction";
        public const string GetJobCostCodeByProgram = "dbo.GetJobCostCodeByProgram";

        /* Job  Billable Sheet */
        public const string GetJobBillableSheetView = "dbo.GetJobBillableSheetView";
        public const string GetJobBillableSheet = "dbo.GetJobBillableSheet";
        public const string InsertJobBillableSheet = "dbo.InsJobBillableSheet";
        public const string UpdateJobBillableSheet = "dbo.UpdJobBillableSheet";
        public const string GetJobPriceCodeAction = "dbo.GetJobPriceCodeAction";
        public const string GetJobPriceCodeByProgram = "dbo.GetJobPriceCodeByProgram";


        /* Job Ref Status */
        public const string GetJobRefStatusView = "dbo.GetJobRefStatusView";
        public const string GetJobRefStatus = "dbo.GetJobRefStatus";
        public const string InsertJobRefStatus = "dbo.InsJobRefStatus";
        public const string UpdateJobRefStatus = "dbo.UpdJobRefStatus";
        public const string UpdateJobProFlag = "dbo.UpdateJobProFlag";
        public const string UpdateJobAttributes = "dbo.UpdateJobAttributes";
        public const string InsertJobGatewayComment = "dbo.InsertJobGatewayComment";
		public const string InsertNextAvaliableJobGateway = "dbo.InsertNextAvaliableJobGateway";
		public const string CheckJobDuplication = "dbo.CheckJobDuplication";

		/* Job Roll up */
		public const string GetRollingupJobIdList = "dbo.GetRollingupJobIdList";
        public const string GetRollingupJobIdListByJobId = "dbo.GetRollingupJobIdListByJobId";
        #endregion Job

        #region Program

        /* Program */
        public const string GetProgramView = "dbo.GetProgramTreeView";
        public const string GetProgram = "dbo.GetProgram";
        public const string InsertProgram = "dbo.InsProgram";
        public const string UpdateProgram = "dbo.UpdProgram";
        public const string DeleteProgram = "dbo.DeleteProgram";
        public const string GetProgramTreeViewData = "dbo.GetProgramTreeViewData";

        public const string GetProgramLevel = "dbo.GetProgramLevel";

        public const string GetProgramCopyTreeViewData = "dbo.GetProgramCopyTreeViewData";
        public const string CopyPPPModel = "dbo.CopyPPPModel";
        public const string UdtCopyPPPModel = "dbo.UdtCopyPPPModel";


        /* Program Ref Attribute Default */
        public const string GetPrgRefAttributeDefaultView = "dbo.GetPrgRefAttributeDefaultView";
        public const string GetPrgRefAttributeDefault = "dbo.GetPrgRefAttributeDefault";
        public const string InsertPrgRefAttributeDefault = "dbo.InsPrgRefAttributeDefault";
        public const string UpdatePrgRefAttributeDefault = "dbo.UpdPrgRefAttributeDefault";

        /* Program Ref Gateway Default */
        public const string GetPrgRefGatewayDefaultView = "dbo.GetPrgRefGatewayDefaultView";
        public const string GetPrgRefGatewayDefault = "dbo.GetPrgRefGatewayDefault";
        public const string InsertPrgRefGatewayDefault = "dbo.InsPrgRefGatewayDefault";
        public const string UpdatePrgRefGatewayDefault = "dbo.UpdPrgRefGatewayDefault";

        /* Program Ship Appointment Reason Code */
        public const string GetPrgShipApptmtReasonCodeView = "dbo.GetPrgShipApptmtReasonCodeView";
        public const string GetPrgShipApptmtReasonCode = "dbo.GetPrgShipApptmtReasonCode";
        public const string InsertPrgShipApptmtReasonCode = "dbo.InsPrgShipApptmtReasonCode";
        public const string UpdatePrgShipApptmtReasonCode = "dbo.UpdPrgShipApptmtReasonCode";

        /* Program Ship Status Reason Code */
        public const string GetPrgShipStatusReasonCodeView = "dbo.GetPrgShipStatusReasonCodeView";
        public const string GetPrgShipStatusReasonCode = "dbo.GetPrgShipStatusReasonCode";
        public const string InsertPrgShipStatusReasonCode = "dbo.InsPrgShipStatusReasonCode";
        public const string UpdatePrgShipStatusReasonCode = "dbo.UpdPrgShipStatusReasonCode";

        /* Program Billable Rate */
        public const string GetProgramBillableRateView = "dbo.GetProgramBillableRateView";
        public const string GetProgramBillableRate = "dbo.GetProgramBillableRate";
        public const string InsertProgramBillableRate = "dbo.InsProgramBillableRate";
        public const string UpdateProgramBillableRate = "dbo.UpdProgramBillableRate";

        /* Program Cost Rate */
        public const string GetProgramCostRateView = "dbo.GetProgramCostRateView";
        public const string GetProgramCostRate = "dbo.GetProgramCostRate";
        public const string InsertProgramCostRate = "dbo.InsProgramCostRate";
        public const string UpdateProgramCostRate = "dbo.UpdProgramCostRate";

        /* Program Role */
        public const string GetProgramRoleView = "dbo.GetProgramRoleView";
        public const string GetProgramRole = "dbo.GetProgramRole";
        public const string InsertProgramRole = "dbo.InsProgramRole";
        public const string UpdateProgramRole = "dbo.UpdProgramRole";

        /* Program EDI Header */
        public const string GetPrgEdiHeaderView = "dbo.GetPrgEdiHeaderView";
        public const string GetPrgEdiHeader = "dbo.GetPrgEdiHeader";
        public const string InsertPrgEdiHeader = "dbo.InsPrgEdiHeader";
        public const string UpdatePrgEdiHeader = "dbo.UpdPrgEdiHeader";
        public const string GetEdiTreeViewData = "dbo.GetEdiTreeViewData";

        /* Program Vendor Location */
        public const string GetPrgVendLocationView = "dbo.GetPrgVendLocationView";
        public const string GetPrgVendLocation = "dbo.GetPrgVendLocation";
        public const string InsertPrgVendLocation = "dbo.InsPrgVendLocation";
        public const string UpdatePrgVendLocation = "dbo.UpdPrgVendLocation";
        public const string GetAssignUnassignProgram = "dbo.GetAssignUnassignProgram";
        public const string InsertAssignUnassignProgram = "dbo.InsAssignUnassignProgram";




        /* Program Cost Location */
        public const string GetPrgCostLocations = "dbo.GetPrgCostLocations";
        public const string InsertPrgCostLocations = "dbo.InsertPrgCostLocations";
        public const string UpdatePrgCostLocations = "dbo.UpdatePrgCostLocations";
        public const string GetAssignUnassignCostLocations = "dbo.GetAssignUnassignCostLocations";
        public const string InsAssignUnassignCostLocations = "dbo.InsAssignUnassignCostLocations";

        /* Program Billable Location */
        //public const string GetPrgVendLocationView = "dbo.GetPrgVendLocationView";
        public const string GetPrgBillableLocations = "dbo.GetPrgBillableLocations";
        //public const string GetPrgVendLocation = "dbo.GetPrgVendLocation";
        public const string InsertPrgBillableLocations = "dbo.InsertPrgBillaleLocations";
        public const string UpdatePrgBillableLocations = "dbo.UpdatePrgBillableLocations";
        //public const string GetAssignUnassignProgram = "dbo.GetAssignUnassignProgram";
        //public const string InsertAssignUnassignProgram = "dbo.InsAssignUnassignProgram";
        public const string GetAssignUnassignBillableLocations = "dbo.GetAssignUnassignBillableLocations";
        public const string InsAssignUnassignBillableLocations = "dbo.InsAssignUnassignBillableLocations";

        /* Program EDI Mapping */
        public const string GetPrgEdiMappingView = "dbo.GetPrgEdiMappingView";
        public const string GetPrgEdiMapping = "dbo.GetPrgEdiMapping";
        public const string InsertPrgEdiMapping = "dbo.InsPrgEdiMapping";
        public const string UpdatePrgEdiMapping = "dbo.UpdPrgEdiMapping";

        /* Program EDI Conditions */
        public const string GetPrgEdiConditionView = "dbo.GetPrgEdiConditionView";
        public const string GetPrgEdiCondition = "dbo.GetPrgEdiCondition";
        public const string InsertPrgEdiCondition = "dbo.InsPrgEdiCondition";
        public const string UpdatePrgEdiCondition = "dbo.UpdPrgEdiCondition";

        /* Program MVOC */
        public const string GetPrgMvocView = "dbo.GetPrgMvocView";
        public const string GetPrgMvoc = "dbo.GetPrgMvoc";
        public const string InsertPrgMvoc = "dbo.InsPrgMvoc";
        public const string UpdatePrgMvoc = "dbo.UpdPrgMvoc";

        /* MVOC Ref Question */
        public const string GetPrgMvocRefQuestionView = "dbo.GetPrgMvocRefQuestionView";
        public const string GetPrgMvocRefQuestion = "dbo.GetPrgMvocRefQuestion";
        public const string InsertPrgMvocRefQuestion = "dbo.InsPrgMvocRefQuestion";
        public const string UpdatePrgMvocRefQuestion = "dbo.UpdPrgMvocRefQuestion";

        #endregion Program

        #region Scanner

        /* CatalogList */
        public const string GetScrCatalogListView = "dbo.GetScrCatalogListView";
        public const string GetScrCatalogList = "dbo.GetScrCatalogList";
        public const string InsertScrCatalogList = "dbo.InsScrCatalogList";
        public const string UpdateScrCatalogList = "dbo.UpdScrCatalogList";

        /* OsdList */
        public const string GetScrOsdListView = "dbo.GetScrOsdListView";
        public const string GetScrOsdList = "dbo.GetScrOsdList";
        public const string InsertScrOsdList = "dbo.InsScrOsdList";
        public const string UpdateScrOsdList = "dbo.UpdScrOsdList";

        /* OsdReasonList */
        public const string GetScrOsdReasonListView = "dbo.GetScrOsdReasonListView";
        public const string GetScrOsdReasonList = "dbo.GetScrOsdReasonList";
        public const string InsertScrOsdReasonList = "dbo.InsScrOsdReasonList";
        public const string UpdateScrOsdReasonList = "dbo.UpdScrOsdReasonList";

        /* RequirementList */
        public const string GetScrRequirementListView = "dbo.GetScrRequirementListView";
        public const string GetScrRequirementList = "dbo.GetScrRequirementList";
        public const string InsertScrRequirementList = "dbo.InsScrRequirementList";
        public const string UpdateScrRequirementList = "dbo.UpdScrRequirementList";

        /* ReturnReasonList */
        public const string GetScrReturnReasonListView = "dbo.GetScrReturnReasonListView";
        public const string GetScrReturnReasonList = "dbo.GetScrReturnReasonList";
        public const string InsertScrReturnReasonList = "dbo.InsScrReturnReasonList";
        public const string UpdateScrReturnReasonList = "dbo.UpdScrReturnReasonList";

        /* ServiceList */
        public const string GetScrServiceListView = "dbo.GetScrServiceListView";
        public const string GetScrServiceList = "dbo.GetScrServiceList";
        public const string InsertScrServiceList = "dbo.InsScrServiceList";
        public const string UpdateScrServiceList = "dbo.UpdScrServiceList";

        /* ScnOrder */
        public const string GetScnOrderView = "dbo.GetScnOrderView";
        public const string GetScnOrder = "dbo.GetScnOrder";
        public const string InsertScnOrder = "dbo.InsScnOrder";
        public const string UpdateScnOrder = "dbo.UpdScnOrder";

        /* ScnCargo */
        public const string GetScnCargoView = "dbo.GetScnCargoView";
        public const string GetScnCargo = "dbo.GetScnCargo";
        public const string InsertScnCargo = "dbo.InsScnCargo";
        public const string UpdateScnCargo = "dbo.UpdScnCargo";

        /* ScnCargoDetail */
        public const string GetScnCargoDetailView = "dbo.GetScnCargoDetailView";
        public const string GetScnCargoDetail = "dbo.GetScnCargoDetail";
        public const string InsertScnCargoDetail = "dbo.InsScnCargoDetail";
        public const string UpdateScnCargoDetail = "dbo.UpdScnCargoDetail";

        /* ScnOrderService */
        public const string GetScnOrderServiceView = "dbo.GetScnOrderServiceView";
        public const string GetScnOrderService = "dbo.GetScnOrderService";
        public const string InsertScnOrderService = "dbo.InsScnOrderService";
        public const string UpdateScnOrderService = "dbo.UpdScnOrderService";

        /* ScrInfoList */
        public const string GetScrInfoListView = "dbo.GetScrInfoListView";
        public const string GetScrInfoList = "dbo.GetScrInfoList";
        public const string InsertScrInfoList = "dbo.InsScrInfoList";
        public const string UpdateScrInfoList = "dbo.UpdScrInfoList";

        /* ScnRouteList */
        public const string GetScnRouteListView = "dbo.GetScnRouteListView";
        public const string GetScnRouteList = "dbo.GetScnRouteList";
        public const string InsertScnRouteList = "dbo.InsScnRouteList";
        public const string UpdateScnRouteList = "dbo.UpdScnRouteList";

        /* ScnDriverList */
        public const string GetScnDriverListView = "dbo.GetScnDriverListView";
        public const string GetScnDriverList = "dbo.GetScnDriverList";
        public const string InsertScnDriverList = "dbo.InsScnDriverList";
        public const string UpdateScnDriverList = "dbo.UpdScnDriverList";

        /* ScnOrderRequirement */
        public const string GetScnOrderRequirementView = "dbo.GetScnOrderRequirementView";
        public const string GetScnOrderRequirement = "dbo.GetScnOrderRequirement";
        public const string InsertScnOrderRequirement = "dbo.InsScnOrderRequirement";
        public const string UpdateScnOrderRequirement = "dbo.UpdScnOrderRequirement";

        /* ScrGatewayList */
        public const string GetScrGatewayListView = "dbo.GetScrGatewayListView";
        public const string GetScrGatewayList = "dbo.GetScrGatewayList";
        public const string InsertScrGatewayList = "dbo.InsScrGatewayList";
        public const string UpdateScrGatewayList = "dbo.UpdScrGatewayList";

        /* ScnOrderOSD */
        public const string GetScnOrderOSDView = "dbo.GetScnOrderOSDView";
        public const string GetScnOrderOSD = "dbo.GetScnOrderOSD";
        public const string InsertScnOrderOSD = "dbo.InsScnOrderOSD";
        public const string UpdateScnOrderOSD = "dbo.UpdScnOrderOSD";

        #endregion Scanner

        #region Attachment

        public const string GetAttachmentView = "dbo.GetAttachmentView";
        public const string GetAttachment = "dbo.GetAttachment";
        public const string InsertAttachment = "dbo.InsAttachment";
        public const string UpdateAttachment = "dbo.UpdAttachment";
        public const string DeleteAttachmentAndUpdateCount = "dbo.DeleteAttachmentAndUpdateCount";

        #endregion Attachment

        #region Survey
        public const string GetSurveyQuestionsByJobId = "dbo.GetSurveyQuestionsByJobId";
        public const string InsSVYUSERMaster = "dbo.InsSVYUSERMaster";
        public const string UpdSVYUSERMaster = "dbo.UpdSVYUSERMaster";
        public const string InsSVYANS000Master = "dbo.InsSVYANS000Master";
        #endregion

		#region Order
		public const string GetDataForOrder = "dbo.GetDataForOrder";
		public const string UpdJobPurchaseOrderMapping = "dbo.UpdJobPurchaseOrderMapping";
		public const string UpdJobOrderItemMapping = "dbo.UpdJobOrderItemMapping";
		public const string GetJobOrderItemMapping = "dbo.GetJobOrderItemMapping";
		public const string DeleteJobOrderItemMapping = "dbo.DeleteJobOrderItemMapping";

		public const string UpdJobSalesOrderMapping = "dbo.UpdJobSalesOrderMapping";
		public const string DeleteJobOrderMapping = "dbo.DeleteJobOrderMapping";
		#endregion

        #region Logger
        public const string InsErrorLogInfo = "dbo.InsErrorLogInfo";
        #endregion

        #region Job Report
        public const string GetCustomerLocation = "dbo.GetCustomerLocations";
        #endregion

        #region Advanced Report
        public const string GetRecordsByCustomerEnity = "dbo.GetRecordsByCustomerEnity";
        public const string GetSiteCodeByProgramCustomer = "dbo.GetSiteCodeByProgramCustomer";
        public const string GetDCLocationByCustomer = "dbo.GetDCLocationByCustomer";
        public const string GetBrandByCustomer = "dbo.GetBrandByCustomer";
        public const string GetProgramGatewayCustomeProgram = "GetProgramGatewayCustomeProgram";
        public const string GetProgramByCustomer = "dbo.GetProgramByCustomer";
        #endregion
    }
}