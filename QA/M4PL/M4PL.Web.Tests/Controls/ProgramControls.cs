using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Controls
{
     class ProgramControls
    {
        #region Program 

        public const string FocussedClass = "dxbButton_Office2010Black form-btn pull-right dxbButtonSys dxbTSys";
        public const string SearchedCustomer = "//span[text()='CUS-02']";
        public const string CusCodeArrow = "//span[contains(text(),'CUS-02')]/preceding::img[@alt='Expand'][1]";
        public const string SearchedProgram = "ProgramTree_N18_0";
        public const string ProgramCodeArrow = "";
        public const string SearchedProject = "";
        public const string ProjectCodeArrow = "";
        public const string SearchedPhase = "";
        public const string PrgNewBtn = "btnAddProgram";
        public const string PrgID = "Id_I";
        public const string PrgCustomer = "CustomerCode_I";
        public const string PrgItem = "PrgItemNumber_I";
        public const string PrgCode = "PrgProgramCode_I";
        public const string ProjectCode = "PrgProjectCode_I";
        public const string PhaseCode = "PrgPhaseCode_I";
        public const string PrgTitle = "PrgProgramTitle_I";
        public const string PrgAccCode = "PrgAccountCode_I";
        public const string PrgStatus = "StatusId_I";
        public const string PrgStatusDrpdwn = "StatusId_B-1";
        public const string PrgStatusActive = "StatusId_DDD_L_LBI0T0";
        public const string PrgStatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string PrgStatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string PrgDateStart = "PrgDateStart_I";
        public const string PrgDateStartDrpdwn = "PrgDateStart_B-1";
        public const string PrgDateStartToday = "PrgDateStart_DDD_C_BT";
        public const string PrgDateEnd = "PrgDateEnd_I";
        public const string PrgDateEndDrpdwn = "PrgDateEnd_B-1";
        public const string PrgDateEndToday = "PrgDateEnd_DDD_C_BT";
        public const string PrgPckTime = "PrgPickUpTimeDefault_I";
        public const string PrgDelvryTime = "PrgDeliveryTimeDefault_I";
        public const string PrgRecvdThrshldDefault = "PckDay_S_D";
        public const string PrgRecvdThrshldEarliest = "PckEarliest_I";
        public const string PrgRecvdThrshldLatest = "PckLatest_I";
        public const string PrgDelvryThrshldDefault = "DelDay_S_D";
        public const string PrgDelvryThrshldEarliest = "DelEarliest_I";
        public const string PrgDelvryThrshldLatest = "DelLatest_I";
        public const string PrgSave = "btnProgramSave_CD";
        public const string PrgCancel = "btnProgramCancel";
        public const string PrgSaveOkbtn = "btnOk_CD";
        public const string PrgUpdate = "btnProgramSave_CD";

        public const string PrgDescription = "pageControl_T0T";
        public const string PrgGateways = "pageControl_T1T";
        public const string PrgContacts = "pageControl_T2T";
        public const string PrgPriceCode = "pageControl_T3T";
        public const string PrgVendors = "pageControl_T4T";
        public const string PrgCostCode = "pageControl_T5T";
        public const string PrgRsnCode = "pageControl_T6T";
        public const string PrgApptCode = "pageControl_T7T";
        public const string PrgAttribute = "pageControl_T8T";
        public const string PrgCatalogue = "pageControl_T9T";
        public const string PrgCustJourney = "pageControl_T10T";
        public const string PrgNotes = "pageControl_T11T";

        #endregion

        #region Program Gateways - Gateways

        public const string PrgGtwGrid_Record = "PrgRefGatewayDefaultGridView_DXDataRow0";
        public const string PrgGtwGrid = "PrgRefGatewayDefaultGridView_DXEmptyRow";
        public const string PrgGtwNew = "PrgRefGatewayDefaultGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgGtwEdit = "PrgRefGatewayDefaultGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgGtwChooseColumn = "PrgRefGatewayDefaultGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgGtwId = "Id_popup_I";
        public const string PrgGtwItem = "PgdGatewaySortOrder_popup_I'";
        public const string PrgGtwCode = "PgdGatewayCode_popup_I";
        public const string PrgGtwTitle = "PgdGatewayTitle_popup_I";
        public const string PrgGtwDuration = "PgdGatewayDuration_popup_I";
        public const string PrgGtwUnits = "UnitTypeId_popup_I";
        public const string PrgGtwUnitDrpdwn = "UnitTypeId_popup_B-1";
        public const string PrgGtwUnitDay = "UnitTypeId_popup_DDD_L_LBI0T0";
        public const string PrgGtwUnitHour = "UnitTypeId_popup_DDD_L_LBI1T0";
        public const string PrgGtwUnitMinute = "UnitTypeId_popup_DDD_L_LBI2T0";
        public const string PrgGtwDefault = "PgdGatewayDefault_popup_S_D";
        public const string PrgGtwType = "GatewayTypeId_popup_I";
        public const string PrgGtwTypeDrpdwn = "GatewayTypeId_popup_B-1";
        public const string PrgGtwTypeGateway = "GatewayTypeId_popup_DDD_L_LBI0T0";
        public const string PrgGtwTypeAction = "GatewayTypeId_popup_DDD_L_LBI1T0";
        public const string PrgGtwTypeDocument = "GatewayTypeId_popup_DDD_L_LBI2T0";
        public const string PrgGtwTypeComment = "GatewayTypeId_popup_DDD_L_LBI3T0";
        public const string PrgGtwRefType = "GatewayDateRefTypeId_popup_I";
        public const string PrgGtwRefTypeDrpdwn = "GatewayDateRefTypeId_popup_B-1";
        public const string PrgGtwRefTypePckDate = "GatewayDateRefTypeId_popup_DDD_L_LBI0T0";
        public const string PrgGtwRefTypeDelDate = "GatewayDateRefTypeId_popup_DDD_L_LBI1T0";
        public const string PrgGtwRefTypeManual = "GatewayDateRefTypeId_popup_DDD_L_LBI2T0";
        public const string PrgGtwScanner = "Scanner_popup_S_D";
        public const string PrgGtwShpStatusRsnCode = "PgdShipStatusReasonCode_popup_I";
        public const string PrgGtwShpStatusRsnCodeDrpdwn = "PgdShipStatusReasonCode_popup_B-1";
        public const string PrgGtwShpAppntRsnCode = "PgdShipApptmtReasonCode_popup_I";
        public const string PrgGtwShpAppntRsnCodeDrpdwn = "PgdShipApptmtReasonCode_popup_B-1";
        public const string PrgGtwOrderType = "PgdOrderType_popup_I";
        public const string PrgGtwOrderTypeDrpdwn = "PgdOrderType_popup_B-1";
        public const string PrgGtwOrderTypeOriginal = "PgdOrderType_popup_DDD_L_LBI0T0";
        public const string PrgGtwOrderTypeReturn = "PgdOrderType_popup_DDD_L_LBI1T0";
        public const string PrgGtwShpmntType = "PgdShipmentType_popup_I";
        public const string PrgGtwShpmntTypeDrpdwn = "PgdShipmentType_popup_B-1";
        public const string PrgGtwShpmntTypeCDS = "PgdShipmentType_popup_DDD_L_LBI0T0";
        public const string PrgGtwShpmntTypeDS = "PgdShipmentType_popup_DDD_L_LBI1T0";
        public const string PrgGtwAnalystCon = "PgdGatewayAnalyst_popup_I";
        public const string PrgGtwAnalystConDrpdwn = "PgdGatewayAnalyst_popup_B-1";
        public const string PrgGtwRespCon = "PgdGatewayResponsible_popup_I";
        public const string PrgGtwRespConDrpdwn = "PgdGatewayResponsible_popup_B-1";
        public const string PrgGtwStatus = "StatusId_popup_I";
        public const string PrgGtwStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgGtwStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgGtwStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgGtwStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgGtwSave = "ProgramPrgRefGatewayDefaultDataView2GatewaysCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgGtwCancel = "ProgramPrgRefGatewayDefaultDataView2GatewaysCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgGtwSaveOk = "btnOk_CD";

        #endregion

        #region Program Attributes - Attributes

        public const string PrgAttGrid = "PrgRefAttributeDefaultGridView_DXEmptyRow";
        public const string PrgAttNew = "PrgRefAttributeDefaultGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgAttEdit = "PrgRefAttributeDefaultGridView_DXContextMenu_Rows_DXI1_T";


        public const string PrgAttChooseColumn = "PrgRefAttributeDefaultGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgAttId = "Id_popup_I";
        public const string PrgAttItem = "AttItemNumber_popup_I";
        public const string PrgAttCode = "AttCode_popup_I";
        public const string PrgAttTitle = "AttTitle_popup_I";
        public const string PrgAttQty = "AttQuantity_popup_I";
        public const string PrgAttUnits = "UnitTypeId_popup_I";
        public const string PrgAttUnitsDrpdwn = "UnitTypeId_popup_B-1";
        public const string PrgAttUnitCode = "UnitTypeId_popup_DDD_L_LBI0T0";
        public const string PrgAttUnitFeet = "UnitTypeId_popup_DDD_L_LBI1T0";
        public const string PrgAttUnitYN = "UnitTypeId_popup_DDD_L_LBI2T0";
        public const string PrgAttUnitText = "UnitTypeId_popup_DDD_L_LBI3T0";
        public const string PrgAttDefault = "AttDefault_popup_S_D";
        public const string PrgAttStatus = "StatusId_popup_I";
        public const string PrgAttStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgAttStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgAttStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgAttStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgAttSave = "ProgramPrgRefAttributeDefaultDataView9AttributesCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgAttCancel = "ProgramPrgRefAttributeDefaultDataView9AttributesCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgAttSaveOk = "btnOk_CD";
        #endregion

        #region Program Roles - Contacts


        public const string PrgContactGrid_Record = "PrgRoleGridView_DXDataRow0";
        public const string PrgContactGrid = "PrgRoleGridView_DXDataRow";
        public const string PrgContactNew = "PrgRoleGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgContactEdit = "PrgRoleGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgContactChooseColumn = "PrgRoleGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgContactId = "Id_popup_I";
        public const string PrgContactItem = "PrgRoleSortOrder_popup_I";
        public const string PrgContactRoleCode = "OrgRefRoleId_popup_I";
        public const string PrgContactRoleCodeDrpdwn = "OrgRefRoleId_popup_B-1";
        public const string PrgContactPrgRoleCode = "PrgRoleId_popup_I'";
        public const string PrgContactPrgRoleCodeDrpdwn = "PrgRoleId_popup_B-1";
        public const string PrgContactTitle = "PrgRoleTitle_popup_I";
        public const string PrgContactContact = "PrgRoleContactID_popup_I";
        public const string PrgContactContactDrpdwn = "PrgRoleContactID_popup_B-1";
        public const string PrgContactCard = "btnPrgRoleContactID0_CD";
        public const string PrgContactRoleType = "RoleTypeId_popup_I";
        public const string PrgContactRoleTypeDrpdwn = "RoleTypeId_popup_B-1";
        public const string PrgContactRoleTypeVendor = "RoleTypeId_popup_DDD_L_LBI0T0";
        public const string PrgContactRoleTypeAgent = "RoleTypeId_popup_DDD_L_LBI1T0";
        public const string PrgContactRoleTypeConsultant = "RoleTypeId_popup_DDD_L_LBI2T0";
        public const string PrgContactRoleTypeCustomer = "RoleTypeId_popup_DDD_L_LBI3T0";
        public const string PrgContactRoleTypeDriver = "RoleTypeId_popup_DDD_L_LBI4T0";
        public const string PrgContactRoleTypeEmployee = "RoleTypeId_popup_DDD_L_LBI5T0";
        public const string PrgContactStatus = "StatusId_popup_I";
        public const string PrgContactStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgContactStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgContactStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgContactStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgContactProgram = "PrgLogical_popup_S_D";
        public const string PrgContactJob = "JobLogical_popup_S_D";
        public const string PrgContactJobAnalyst = "PrxJobDefaultAnalyst_popup_S_D";
        public const string PrgContactJobResp = "PrxJobDefaultResponsible_popup_S";
        public const string PrgContactJobGWAnalyst = "PrxJobGWDefaultAnalyst_popup_S_D";
        public const string PrgContactJobGWResp = "PrxJobGWDefaultResponsible_popup_S_D";
        public const string PrgContactSave = "ProgramPrgRoleDataView3ContactsCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgContactCancel = "ProgramPrgRoleDataView3ContactsCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgContactSaveOk = "btnOk_CD";

        #endregion


        #region Program Billable Rate - Price Codes

        public const string PrgPCGridRecord = "PrgBillableRateGridView_DXDataRow0";
        public const string PrgPCGrid = "PrgBillableRateGridView_DXEmptyRow";
        public const string PrgPCNew = "PrgBillableRateGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgPCEdit = "PrgBillableRateGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgPCChooseColumn = "PrgBillableRateGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgPCId = "Id_popup_I";
        public const string PrgPCCode = "PbrCode_popup_I";
        public const string PrgPCCustomerCode = "PbrCustomerCode_popup_I";
        public const string PrgPCTitle = "PbrTitle_popup_I";
        public const string PrgPCEffectiveDate = "PbrEffectiveDate_popup_I";
        public const string PrgPCEffectiveDateDrpdwn = "PbrEffectiveDate_popup_B-1";
        public const string PrgPCEffectiveDateToday = "PbrEffectiveDate_popup_DDD_C_BT";
        public const string PrgPCCategory = "RateCategoryTypeId_popup_I";
        public const string PrgPCCategoryDrpdwn = "RateCategoryTypeId_popup_B-1";
        public const string PrgPCCategoryDelivery = "RateCategoryTypeId_popup_DDD_L_LBI0T0";
        public const string PrgPCCategoryBrokerage = "RateCategoryTypeId_popup_DDD_L_LBI1T0";
        public const string PrgPCCategoryStorage = "RateCategoryTypeId_popup_DDD_L_LBI2T0";
        public const string PrgPCCategoryLabour = "RateCategoryTypeId_popup_DDD_L_LBI3T0";
        public const string PrgPCRateId = "RateTypeId_popup_I";
        public const string PrgPCRateDrpdwn = "RateTypeId_popup_B-1";
        public const string PrgPCRateSimple = "RateTypeId_popup_DDD_L_LBI0T0";
        public const string PrgPCRateExpression = "RateTypeId_popup_DDD_L_LBI1T0";
        public const string PrgPCRateTiered = "RateTypeId_popup_DDD_L_LBI2T0";
        public const string PrgPCRateCompounded = "RateTypeId_popup_DDD_L_LBI3T0";
        public const string PrgPCRateDerivative = "RateTypeId_popup_DDD_L_LBI4T0";
        public const string PrgPCType = "RateUnitTypeId_popup_I";
        public const string PrgPCTypeDrpdwn = "RateUnitTypeId_popup_DDD_L_LBI0T0";
        public const string PrgPCTypeDay = "RateUnitTypeId_popup_DDD_L_LBI1T0";
        public const string PrgPCTypeHour = "RateUnitTypeId_popup_DDD_L_LBI2T0";
        public const string PrgPCTypeMinute = "RateUnitTypeId_popup_DDD_L_LBI3T0";
        public const string PrgPCBillablePrice = "PbrBillablePrice_popup_I";
        public const string PrgPCFormat = "PbrFormat_popup_I";
        public const string PrgPCStatus = "StatusId_popup_I";
        public const string PrgPCStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgPCStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgPCStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgPCStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgPCExpression1 = "PbrExpression01_popup_I";
        public const string PrgPCLogic1 = "PbrLogic01_popup_I";
        public const string PrgPCExpression2 = "PbrExpression02_popup_I";
        public const string PrgPCLogic2 = "PbrLogic02_popup_I";
        public const string PrgPCExpression3 = "PbrExpression03_popup_I";
        public const string PrgPCLogic3 = "PbrLogic03_popup_I";
        public const string PrgPCExpression4 = "PbrExpression04_popup_I";
        public const string PrgPCLogic4 = "PbrLogic04_popup_I";
        public const string PrgPCExpression5 = "PbrExpression05_popup_I";
        public const string PrgPCLogic5 = "PbrLogic05_popup_I";
        public const string PrgPCSave = "ProgramPrgBillableRateDataView4PriceCodesCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgPCCancel = "ProgramPrgBillableRateDataView4PriceCodesCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgPCSaveOk = "btnOk_CD";

        #endregion


        #region Program Cost Rate - Cost Rates
        public const string PrgCCGrid_Record = "PrgCostRateGridView_DXEmptyRow0";
        public const string PrgCCGrid = "PrgCostRateGridView_DXEmptyRow";
        public const string PrgCCNew = "PrgCostRateGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgCCEdit = "PrgCostRateGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgCCChooseColumn = "PrgCostRateGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgCCId = "Id_popup_I";
        public const string PrgCCCode = "PcrCode_popup_I";
        public const string PrgCCVendorCode = "PcrVendorCode_popup_I";
        public const string PrgCCTitle = "PcrTitle_popup_I";
        public const string PrgCCEffectiveDate = "PcrEffectiveDate_popup_I";
        public const string PrgCCEffectiveDateDrpdwn = "PcrEffectiveDate_popup_B-1";
        public const string PrgCCEffectiveDateToday = "PcrEffectiveDate_popup_DDD_C_BT";
        public const string PrgCCCategory = "RateCategoryTypeId_popup_I";
        public const string PrgCCCategoryDrpdwn = "RateCategoryTypeId_popup_B-1";
        public const string PrgCCCategoryDelivery = "RateCategoryTypeId_popup_DDD_L_LBI0T0";
        public const string PrgCCCategoryBrokerage = "RateCategoryTypeId_popup_DDD_L_LBI1T0";
        public const string PrgCCCategoryStorage = "RateCategoryTypeId_popup_DDD_L_LBI2T0";
        public const string PrgCCCategoryLabour = "RateCategoryTypeId_popup_DDD_L_LBI3T0";
        public const string PrgCCRateId = "RateTypeId_popup_I";
        public const string PrgCCRateDrpdwn = "RateTypeId_popup_B-1";
        public const string PrgCCRateSimple = "RateTypeId_popup_DDD_L_LBI0T0";
        public const string PrgCCRateExpression = "RateTypeId_popup_DDD_L_LBI1T0";
        public const string PrgCCRateTiered = "RateTypeId_popup_DDD_L_LBI2T0";
        public const string PrgCCRateCompounded = "RateTypeId_popup_DDD_L_LBI3T0";
        public const string PrgCCRateDerivative = "RateTypeId_popup_DDD_L_LBI4T0";
        public const string PrgCCType = "RateUnitTypeId_popup_I";
        public const string PrgCCTypeDrpdwn = "RateUnitTypeId_popup_DDD_L_LBI0T0";
        public const string PrgCCTypeDay = "RateUnitTypeId_popup_DDD_L_LBI1T0";
        public const string PrgCCTypeHour = "RateUnitTypeId_popup_DDD_L_LBI2T0";
        public const string PrgCCTypeMinute = "RateUnitTypeId_popup_DDD_L_LBI3T0";
        public const string PrgCCCostRate = "PcrCostRate_popup_I";
        public const string PrgCCFormat = "PcrFormat_popup_I";
        public const string PrgCCStatus = "StatusId_popup_I";
        public const string PrgCCStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgCCStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgCCStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgCCStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgCCExpression1 = "PcrExpression01_popup_I";
        public const string PrgCCLogic1 = "PcrLogic01_popup_I";
        public const string PrgCCExpression2 = "PcrExpression02_popup_I";
        public const string PrgCCLogic2 = "PcrLogic02_popup_I";
        public const string PrgCCExpression3 = "PcrExpression03_popup_I";
        public const string PrgCCLogic3 = "PcrLogic03_popup_I";
        public const string PrgCCExpression4 = "PcrExpression04_popup_I";
        public const string PrgCCLogic4 = "PcrLogic04_popup_I";
        public const string PrgCCExpression5 = "PcrExpression05_popup_I";
        public const string PrgCCLogic5 = "PcrLogic05_popup_I";
        public const string PrgCCSave = "ProgramPrgCostRateDataView6CostCodesCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgCCCancel = "ProgramPrgCostRateDataView6CostCodesCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgCCSaveOk = "btnOk_CD";
        #endregion


        #region Program Vendors - Vendors


        public const string SearchedVendor = "//span[contains(text(),'DRWN(Darwin Logistics and Transportation Center)')] /preceding::span[@id='PrgUnAssignVendor_N4_D'][1]";
        public const string PrgVendorGrid = "PrgVendLocationGridView_DXEmptyRow";
        public const string PrgVendorGrid_Record = "PrgVendLocationGridView_DXEmptyRow0";
        public const string PrgVendorMap = "PrgVendLocationGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgVendorMapAssign = "btnAssign_CD";
        public const string PrgVendorMapUnassign = "btnUnAssign";
        public const string PrgVendorMapCancel = "ProgramPrgVendLocationDataView5VendorsCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgVendorEdit = "PrgVendLocationGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgVendorChooseColumn = "PrgVendLocationGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgVendorId = "Id_popup_I";
        public const string PrgVendorVendor = "VendorCode_popup_I";
        public const string PrgVendorItem = "PvlItemNumber_popup_I";
        public const string PrgVendorLocCode = "PvlLocationCode_popup_I";
        public const string PrgVendorCusLocCode = "PvlLocationCodeCustomer_popup_I";
        public const string PrgVendorTitle = "PvlLocationTitle_popup_I";
        public const string PrgVendorUC1 = "PvlUserCode1_popup_I";
        public const string PrgVendorUC2 = "PvlUserCode2_popup_I";
        public const string PrgVendorUC3 = "PvlUserCode3_popup_I";
        public const string PrgVendorUC4 = "PvlUserCode4_popup_I";
        public const string PrgVendorUC5 = "PvlUserCode5_popup_I";
        public const string PrgVendorContact = "PvlContactMSTRID_popup_I";
        public const string PrgVendorDrpdwn = "PvlContactMSTRID_popup_B-1";
        public const string PrgVendorContactCard = "btnPvlContactMSTRID0_CD";
        public const string PrgVendJobtitle = "ConJobTitlePvlContactMSTRID0_popup_I";
        public const string PrgVendAddress = "ConBusinessAddress1PvlContactMSTRID0_popup_I";
        public const string PrgVendJobTitle = "ConEmailAddressPvlContactMSTRID0_popup_I";
        public const string PrgVendWorkEmail = "ConEmailAddressPvlContactMSTRID0_popup_I";
        public const string PrgVendMobilePhn = "ConMobilePhonePvlContactMSTRID0_popup_I";
        public const string PrgVendBusinessPhn = "ConBusinessPhonePvlContactMSTRID0_popup_I";
        public const string PrgVendStatus = "StatusId_popup_I";
        public const string PrgVendStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgVendStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgVendStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgVendStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgVendDateStart = "PvlDateStart_popup_I";
        public const string PrgVendDateStartDrpdwn = "PvlDateStart_popup_B-1";
        public const string PrgVendDateStartToday = "PvlDateStart_popup_DDD_C_BT";
        public const string PrgVendDateEnd = "PvlDateEnd_popup_I";
        public const string PrgVendDateEndDrpdwn = "PvlDateEnd_popup_B-1";
        public const string PrgVendDateEndToday = "PvlDateEnd_popup_DDD_C_BT";
        public const string PrgVendSave = "ProgramPrgVendLocationDataView5VendorsCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgVendCancel = "ProgramPrgVendLocationDataView5VendorsCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgVendSaveOk = "btnOk_CD";

        #endregion

        #region Program Reason Codes - Reason Codes


        public const string PrgRCGrid = "PrgShipStatusReasonCodeGridView_DXEmptyRow";
        public const string PrgRCGrid_Record = "PrgShipStatusReasonCodeGridView_DXEmptyRow0";
        public const string PrgRCNew = "PrgShipStatusReasonCodeGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgRCEdit = "PrgShipStatusReasonCodeGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgRCChooseColumn = "PrgShipStatusReasonCodeGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgRCId = "Id_popup_I";
        public const string PrgRCItem = "PscShipItem_popup_I";
        public const string PrgRCReasonCode = "PscShipReasonCode_popup_I";
        public const string PrgRCShipLength = "PscShipLength_popup_I";
        public const string PrgRCInternalCode = "PscShipInternalCode_popup_I";
        public const string PrgRCPriorityCode = "PscShipPriorityCode_popup_I";
        public const string PrgRCTitle = "PscShipTitle_popup_I";
        public const string PrgRCCategoryCode = "PscShipCategoryCode_popup_I";
        public const string PrgRCUC1 = "PscShipUser01Code_popup_I";
        public const string PrgRCUC2 = "PscShipUser02Code_popup_I";
        public const string PrgRCUC3 = "PscShipUser03Code_popup_I";
        public const string PrgRCUC4 = "PscShipUser04Code_popup_I";
        public const string PrgRCUC5 = "PscShipUser05Code_popup_I";
        public const string PrgRCStatus = "StatusId_popup_I";
        public const string PrgRCStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgRCStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgRCStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgRCStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgRCSave = "ProgramPrgShipStatusReasonCodeDataView7ReasonCodesCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgRCCancel = "ProgramPrgShipStatusReasonCodeDataView7ReasonCodesCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgRCSaveOk = "btnOk_CD";

        #endregion

        #region Program Appointment Codes - Appointment Codes

        public const string PrgACGrid = "PrgShipApptmtReasonCodeGridView_DXEmptyRow";
        public const string PrgACGrid_Record = "PrgShipApptmtReasonCodeGridView_DXEmptyRow0";
        public const string PrgACNew = "PrgShipApptmtReasonCodeGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgACEdit = "PrgShipApptmtReasonCodeGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgACChooseColumn = "PrgShipApptmtReasonCodeGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgACId = "Id_popup_I";
        public const string PrgACItem = "PacApptItem_popup_I";
        public const string PrgACReasonCode = "PacApptReasonCode_popup_I";
        public const string PrgACShipLength = "PacApptLength_popup_I";
        public const string PrgACInternalCode = "PacApptInternalCode_popup_I";
        public const string PrgACPriorityCode = "PacApptPriorityCode_popup_I";
        public const string PrgACTitle = "PacApptTitle_popup_I";
        public const string PrgACCategoryCode = "PacApptCategoryCode_popup_I";
        public const string PrgACUC1 = "PacApptUser01Code_popup_I";
        public const string PrgACUC2 = "PacApptUser02Code_popup_I";
        public const string PrgACUC3 = "PacApptUser03Code_popup_I";
        public const string PrgACUC4 = "PacApptUser04Code_popup_I";
        public const string PrgACUC5 = "PacApptUser05Code_popup_I";
        public const string PrgACStatus = "StatusId_popup_I";
        public const string PrgACStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgACStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgACStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgACStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgACSave = "ProgramPrgShipApptmtReasonCodeDataView8AppointmentCodesCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgACCancel = "ProgramPrgShipApptmtReasonCodeDataView8AppointmentCodesCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgACSaveOk = "btnOk_CD";
        #endregion

        #region Program Catalog - Catalog
        public const string PrgCatGrid = "ScrCatalogListGridView_DXEmptyRow";
        public const string PrgCatNew = "ScrCatalogListGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgCatEdit = "ScrCatalogListGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgCatChooseColumn = "ScrCatalogListGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgCatPrgmId = "CatalogProgramIDName_popup_I";
        public const string PrgCatStatus = "StatusId_popup_I";
        public const string PrgCatStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgCatStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgCatStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgCatStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgCatId = "Id_popup_I";
        public const string PrgCatItem = "CatalogItemNumber_popup_I";
        public const string PrgCatCode = "CatalogCode_popup_I";
        public const string PrgCatCusCode = "CatalogCustCode_popup_I";
        public const string PrgCatTitle = "CatalogTitle_popup_I";
        public const string PrgCatUOM = "CatalogUoMCode_popup_I";
        public const string PrgCatWidth = "CatalogWidth_popup_I";
        public const string PrgCatLength = "CatalogLength_popup_I";
        public const string PrgCatHeight = "CatalogHeight_popup_I";
        public const string PrgCatCubes = "CatalogCubes_popup_I";
        public const string PrgCatDimension = "CatalogWLHUoM_popup_I";
        public const string PrgCatDimensionDrpdwn = "CatalogWLHUoM_popup_B-1";
        public const string PrgCatDimensionInches = "CatalogWLHUoM_popup_DDD_L_LBI0T0";
        public const string PrgCatDimensionFeet = "CatalogWLHUoM_popup_DDD_L_LBI1T0";
        public const string PrgCatDimensionMeter = "CatalogWLHUoM_popup_DDD_L_LBI2T0";
        public const string PrgCatWeight = "CatalogWeight_popup_I";
        public const string PrgCatWeightDrpdwn = "CatalogWeight_popup_B-1";
        public const string PrgCatWeightLbs = "CatalogWeight_popup_DDD_L_LBI0T0";
        public const string PrgCatWeightKg = "CatalogWeight_popup_DDD_L_LBI1T0";
        public const string PrgCatImage = "CatalogPhoto_DXButtonPanel";
        public const string PrgCatSave = "ProgramScrCatalogListDataView10CatalogueCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgCatCancel = "ProgramScrCatalogListDataView10CatalogueCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgCatSaveOk = "btnOk_CD";
        #endregion

        #region Program CustomerJourney
        public const string PrgMVOCGrid = "PrgMvocGridView_DXEmptyRow";
        public const string PrgMVOCGrid_Record = "PrgMvocGridView_DXEmptyRow0";
        public const string PrgMVOCNew = "PrgMvocGridView_DXContextMenu_Rows_DXI0_T";
        public const string PrgMVOCEdit = "PrgMvocGridView_DXContextMenu_Rows_DXI1_T";
        public const string PrgMVOCChooseColumn = "PrgMvocGridView_DXContextMenu_Rows_DXI2_T";
        public const string PrgMVOCId = "Id_popup_I";
        public const string PrgMVOCSurvCode = "VocSurveyCode_popup_I";
        public const string PrgMVOCSurvTitle = "VocSurveyTitle_popup_I";
        public const string PrgDateOpen = "VocDateOpen_popup_I";
        public const string PrgDateOpenDrpdwn = "VocDateOpen_popup_B-1";
        public const string PrgDateOpenToday = "VocDateOpen_popup_DDD_C_BT";
        public const string PrgDateClose = "VocDateClose_popup_I";
        public const string PrgDateCloseDrpdwn = "VocDateClose_popup_B-1";
        public const string PrgDateCloseToday = "VocDateClose_popup_DDD_C_BT";
        public const string PrgMVOCStatus = "StatusId_popup_I";
        public const string PrgMVOCStatusDrpdwn = "StatusId_popup_B-1";
        public const string PrgMVOCStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string PrgMVOCStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string PrgMVOCStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string PrgMVOCSave = "ProgramPrgMvocDataView11CustJourneyCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgMVOCCancel = "ProgramPrgMvocDataView11CustJourneyCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgMVOCSaveOk = "btnOk_CD";


        public const string PrgMVOCDrilldownIcon = "PrgMvocGridView_LD";
        public const string PrgMVOCSecondryGrid = "PrgMvocRefQuestionGridView10008_DXEmptyRow";
        public const string PrgMVOCSecondryNew = "PrgMvocRefQuestionGridView10008_DXContextMenu_Rows_DXI0_T";
        public const string PrgMVOCSecondryEdit = "PrgMvocRefQuestionGridView10008_DXContextMenu_Rows_DXI1_T";
        public const string PrgMVOCSecondryChooseColumn = "PrgMvocRefQuestionGridView10008_DXContextMenu_Rows_DXI2_T";
        public const string PrgMVOCSecondryId = "Id_popup_I";
        public const string PrgMVOCSecondryQues = "QueQuestionNumber_popup_I";
        public const string PrgMVOCSecondryCode = "QueCode_popup_I";
        public const string PrgMVOCSecondryTitle = "QueTitle_popup_I";
        public const string PrgMVOCSecondryType = "QuesTypeId_popup_I";
        public const string PrgMVOCSecondryTypeDrpdwn = "QuesTypeId_popup_B-1";
        public const string PrgMVOCSecondryTypeKeyIn = "QuesTypeId_popup_DDD_L_LBI0T0";
        public const string PrgMVOCSecondryTypeRange = "QuesTypeId_popup_DDD_L_LBI1T0";
        public const string PrgMVOCSecondryTypeYesNo = "QuesTypeId_popup_DDD_L_LBI2T0";
        public const string PrgMVOCSecondryType_YNAnswer = "QueType_YNAnswer_popup_S_D";
        public const string PrgMVOCSecondryType_YNDefault = "QueType_YNDefault_popup_S_D";
        public const string PrgMVOCSecondryType_Range = "QueType_RangeLo_popup_I";
        public const string PrgMVOCSecondryType_RangeHi = "QueType_RangeHi_popup_I";
        public const string PrgMVOCSecondryType_RangeAns = "QueType_RangeAnswer_popup_I";
        public const string PrgMVOCSecondryType_RangeDefault = "QueType_RangeDefault_popup_I";
        public const string PrgMVOCSecondrySave = "ProgramPrgMvocDataView11CustJourneyCbPanelSecondNavigationPane_DXI1_T";
        public const string PrgMVOCSecondryCancel = "ProgramPrgMvocDataView11CustJourneyCbPanelSecondNavigationPane_DXI0_T";
        public const string PrgMVOCSecondrySaveOk = "btnOk_CD";

        #endregion

    }
}
