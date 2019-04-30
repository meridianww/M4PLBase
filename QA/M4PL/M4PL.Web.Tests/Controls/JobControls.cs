using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Controls
{
    class JobControls
    {

        #region Job
        public const string JobGrid = "JobGridView_DXMainTable";
        public const string JobGridEmpty = "//tr[@id='JobGridView_DXEmptyRow'and @class='dxgvEmptyDataRow_Office2010Black dxgvLVR']";
        public const string JobGrid_Record = "";
        public const string ToggleFilterRow = "JobGridView_DXFilterRow";
        public const string CSOToggle = "JobGridView_DXFREditorcol1_I";
        public const string SearchedRow = "JobGridView_DXDataRow0";
        public const string JobNew = "JobGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobEdit = "JobGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobChooseColumn = "JobGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobTree = "TreeList_U";
        public const string JobSearchPrg = "//span[contains(text(),'PHTRIE')]/parent::td";
        public const string JobCust = "//*[contains(@id,'e93d4f85-ff65-40f2-be95-ecc1371f3549')]";
        //public const string JobCusCodeArrow = "//span[contains(text(),'DRMTEST')]/preceding::img[@alt='Expand'][1]";
        //public const string JobCusCodeArrow = "//span[contains(text(),'DRMTEST')]/preceding::td[@class='dxtlIndentWithButton_Office2010Black dxtlLineMiddle_Office2010Black dxtl__IM']";
        public const string JobCusCodeArrow = "//span[contains(text(),'CRS')]/../../td";


        #endregion

        #region Form View
        //Job Detail Region

        public const string CusCodeSearch = "//span[contains(text(),'CUSEDIT31')]";
        public const string CusCodeDrillDown = "TreeList_R-Customer_95_20274";
        public const string PrgCodeSearch = "//span[contains(text(),'CUSCODE')]";

        public const string JobId = "Id_I";
        public const string ProgramId = "ProgramIDName_I";
        public const string SiteCode = "JobSiteCode_I";
        public const string CustomerSalesOrder = "JobCustomerSalesOrder_I";
        public const string CustomerPurchaseOrder = "JobCustomerPurchaseOrder_I";
        public const string ConsigneeCode = "JobConsigneeCode_I";
        public const string PlantCode = "PlantIDCode_I";
        public const string CarrierId = "CarrierID_I";
        public const string ManifestNumber = "JobManifestNo_I";
        public const string BilingofLading = "JobBOL_I";
        public const string BilingofLadingMaster = "JobBOLMaster_I";
        public const string BilingofLadingChild = "JobBOLChild_I";
        public const string Brand = "JobCarrierContract_I";

        //Status Detail Region

        public const string JobType = "JobType_I";
        public const string JobTypeDrpdwn = "JobType_B-1";
        public const string JobTypeOriginal = "JobType_DDD_L_LBI0T0";
        public const string JobTypeReturn = "JobType_DDD_L_LBI1T0";
        public const string ShipmentType = "ShipmentType_I";
        public const string ShipmentTypeDrpdwn = "ShipmentType_B-1";
        public const string ShipmentTypeCDS = "ShipmentType_DDD_L_LBI0T0";
        public const string ShipmentTypeDS = "ShipmentType_DDD_L_LBI1T0";
        public const string Status = "StatusId_I";
        public const string StatusDrpdwn = "StatusId_B-1";
        public const string StatusActive = "StatusId_DDD_L_LBI0T0";
        public const string StatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string StatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string GatewayStatus = "JobGatewayStatus_I";
        public const string StatusedDate = "JobStatusedDate_I";
        public const string StatusedDateDrpdwn = "JobStatusedDate_B-1";
        public const string StatusedDateToday = "JobStatusedDate_DDD_C_BT";
        public const string Completed = "JobCompleted_S_D";

        //Analyst,Responsible and Driver Details Region

        public const string AnalystContact = "JobDeliveryAnalystContactID_I";
        public const string AnalystContactDrpdwn = "JobDeliveryAnalystContactID_B-1";
        public const string AnalystBusinessPhone = "ConBusinessPhoneJobDeliveryAnalystContactID0_I";
        public const string AnalystMobilePhone = "ConMobilePhoneJobDeliveryAnalystContactID0_I";
        public const string AnalystWorkEmail = "ConEmailAddressJobDeliveryAnalystContactID0_I";
        public const string ResponsibleContact = "JobDeliveryResponsibleContactID_I";
        public const string ResponsibleContactDrpdwn = "JobDeliveryResponsibleContactID_B-1";
        public const string ResponsibleBusinessPhone = "ConBusinessPhoneJobDeliveryResponsibleContactID0_I";
        public const string ResponsibleMobilePhone = "ConMobilePhoneJobDeliveryResponsibleContactID0_I";
        public const string ResponsibleWorkEmail = "ConEmailAddressJobDeliveryResponsibleContactID0_I";
        public const string Driver = "JobDriverId_I";
        public const string DriverDrpdwn = "JobDriverId_B-1";
        public const string DriverContactCard = "btnJobDriverId0_CD";
        public const string DriverBusinessPhone = "ConBusinessPhoneJobDriverId0_I";
        public const string DriverMobilePhone = "ConMobilePhoneJobDriverId0_I";
        public const string DriverWorkEmail = "ConEmailAddressJobDriverId0_I";
        public const string DriverRouteId = "JobRouteId_I";
        public const string DriverStop = "JobStop_I";


        //User Defined Codes

        public const string UserDefinePanel = "pnlUserDefinedFieldDetail_RPHT";
        public const string UD1 = "JobUser01_I";
        public const string UD2 = "JobUser02_I";
        public const string UD3 = "JobUser03_I";
        public const string UD4 = "JobUser04_I";
        public const string UD5 = "JobUser05_I";

        public const string JobSaveOk = "btnOk_CD";
        public const string JobSave = "btnJobSave";
        public const string JobUpdatebtn = "btnJobSave";
        public const string JobCancelbtn = "btnJobCancel";

        #endregion

        #region Job Tabs

        public const string JobDestinationPanel = "pnlDestinationTabs_RPHT";
        public const string JobDestinationTabSelected = "Job_JobDeliveryPageControl_AT0T";
        public const string JobDestinationTab = "Job_JobDeliveryPageControl_T0T";
        public const string Job2ndPoc = "Job_JobDeliveryPageControl_T1T";
        public const string JobSeller = "Job_JobDeliveryPageControl_T2T";
        public const string JobMapRoute = "Job_JobDeliveryPageControl_T3T";
        public const string JobAttributes = "Job_JobDeliveryPageControl_T4T";
        public const string JobPod = "Job_JobDeliveryPageControl_T5T";

        //Destination Tab - Origin Panel

        public const string OSitename = "JobOriginSiteName_I";
        public const string OPOC = "JobOriginSitePOC_I";
        public const string OPOCPhone = "JobOriginSitePOCPhone_I";
        public const string OEmail = "JobOriginSitePOCEmail_I";
        public const string OStreetAddress = "JobOriginStreetAddress_I";
        public const string OStreetAddress2 = "JobOriginStreetAddress2_I";
        public const string OCity = "JobOriginCity_I";
        public const string OState = "JobOriginState_I";
        public const string OPostalCode = "JobOriginPostalCode_I";
        public const string OCountry = "JobOriginCountry_I";
        public const string ODateBaseline = "JobOriginDateTimeBaseline_I";
        public const string ODateBaselineDrpdwn = "JobOriginDateTimeBaseline_B-1";
        public const string ODateBaselineToday = "JobOriginDateTimeBaseline_DDD_C_BT";
        public const string OWindowStartTime = "WindowPckStartTime_I";
        public const string OWindowStartTimeDrpdwn = "WindowPckStartTime_B-1";
        public const string OWindowStartTimeToday = "WindowPckStartTime_DDD_C_BT";
        public const string ODatePlanned = "JobOriginDateTimePlanned_I";
        public const string ODatePlannedDrpdwn = "JobOriginDateTimePlanned_B-1";
        public const string ODatePlannedToday = "JobOriginDateTimePlanned_DDD_C_BT";
        public const string OWindowEndTime = "WindowPckEndTime_I";
        public const string OWindowEndTimeDrpdwn = "WindowPckEndTime_B-1";
        public const string OWindowEndTimeToday = "WindowPckEndTime_DDD_C_BT";
        public const string ODateActual = "JobOriginDateTimeActual_I";
        public const string ODateActualDrpdwn = "JobOriginDateTimeActual_B-1";
        public const string ODateActualToday = "JobOriginDateTimeActual_DDD_C_BT";
        public const string OTimeZone = "JobOriginTimeZone_I";

        //Destination Tab - Destination Panel

        public const string DSitename = "JobDeliverySiteName_I";
        public const string DPOC = "JobDeliverySitePOC_I";
        public const string DPOCPhone = "JobDeliverySitePOCPhone_I";
        public const string DEmail = "JobDeliverySitePOCEmail_I";
        public const string DStreetAddress = "JobDeliveryStreetAddress_I";
        public const string DStreetAddress2 = "JobDeliveryStreetAddress2_I";
        public const string DCity = "JobDeliveryCity_I";
        public const string DState = "JobDeliveryState_I";
        public const string DPostalCode = "JobDeliveryPostalCode_I";
        public const string DCountry = "JobDeliveryCountry_I";
        public const string DDateBaseline = "JobDeliveryDateTimeBaseline_I";
        public const string DDateBaselineDrpdwn = "JobDeliveryDateTimeBaseline_B-1";
        public const string DDateBaselineToday = "JobDeliveryDateTimeBaseline_DDD_C_BT";
        public const string DWindowStartTime = "WindowDelStartTime_I";
        public const string DWindowStartTimeDrpdwn = "WindowDelStartTime_B-1";
        public const string DWindowStartTimeToday = "WindowDelStartTime_DDD_C_BT";
        public const string DDatePlanned = "JobDeliveryDateTimePlanned_I";
        public const string DDatePlannedDrpdwn = "JobDeliveryDateTimePlanned_B-1";
        public const string DDatePlannedToday = "JobDeliveryDateTimePlanned_DDD_C_BT";
        public const string DWindowEndTime = "WindowDelEndTime_I";
        public const string DWindowEndTimeDrpdwn = "WindowDelEndTime_B-1";
        public const string DWindowEndTimeToday = "WindowDelEndTime_DDD_C_BT";
        public const string DDateActual = "JobDeliveryDateTimeActual_I";
        public const string DDateActualDrpdwn = "JobDeliveryDateTimeActual_B-1";
        public const string DDateActualToday = "JobDeliveryDateTimeActual_DDD_C_BT";
        public const string DTimeZone = "JobDeliveryTimeZone_I";

        //2nd POC Tab - Origin Panel

        public const string O2Sitename = "JobOriginSiteName_Delivery_Poc_I";
        public const string O2POC2 = "JobOriginSitePOC2_I";
        public const string O2POCPhone = "JobOriginSitePOCPhone2_I";
        public const string O2Email = "JobOriginSitePOCEmail2_I";
        public const string O2StreetAddress = "JobOriginStreetAddress_Delivery_Poc_I";
        public const string O2StreetAddress2 = "JobOriginStreetAddress2_Delivery_Poc_I";
        public const string O2City = "JobOriginCity_Delivery_Poc_I";
        public const string O2State = "JobOriginState_Delivery_Poc_I";
        public const string O2PostalCode = "JobOriginPostalCode_Delivery_Poc_I";
        public const string O2Country = "JobOriginCountry_Delivery_Poc_I";
        public const string O2DateBaseline = "JobOriginDateTimeBaseline_Delivery_Poc_I";
        public const string O2DateBaselineDrpdwn = "JobOriginDateTimeBaseline_Delivery_Poc_B-1";
        public const string O2DateBaselineToday = "JobOriginDateTimeBaseline_Delivery_Poc_DDD_C_BT";
        public const string O2DatePlanned = "JobOriginDateTimePlanned_Delivery_Poc_I";
        public const string O2DatePlannedDrpdwn = "JobOriginDateTimePlanned_Delivery_Poc_B-1";
        public const string O2DatePlannedToday = "JobOriginDateTimePlanned_Delivery_Poc_DDD_C_BT";
        public const string O2DateActual = "JobOriginDateTimeActual_Delivery_Poc_I";
        public const string O2DateActualDrpdwn = "JobOriginDateTimeActual_Delivery_Poc_B-1";
        public const string O2DateActualToday = "JobOriginDateTimeActual_Delivery_Poc_DDD_C_BT";
        public const string O2TimeZone = "JobOriginTimeZone_Delivery_Poc_I";



        //2nd POC Tab - Destination Panel

        public const string D2Sitename = "JobDeliverySiteName_Delivery_Poc_I";
        public const string D2POC2 = "JobDeliverySitePOC2_I";
        public const string D2POCPhone = "JobDeliverySitePOCPhone2_I";
        public const string D2Email = "JobDeliverySitePOCEmail2_I";
        public const string D2StreetAddress = "JobDeliveryStreetAddress_Delivery_Poc_I";
        public const string D2StreetAddress2 = "JobDeliveryStreetAddress2_Delivery_Poc_I";
        public const string D2City = "JobDeliveryCity_Delivery_Poc_I";
        public const string D2State = "JobDeliveryState_Delivery_Poc_I";
        public const string D2PostalCode = "JobDeliveryPostalCode_Delivery_Poc_I";
        public const string D2Country = "JobDeliveryCountry_Delivery_Poc_I";
        public const string D2DateBaseline = "JobDeliveryDateTimeBaseline_Delivery_Poc_I";
        public const string D2DateBaselineDrpdwn = "JobDeliveryDateTimeBaseline_Delivery_Poc_B-1";
        public const string D2DateBaselineToday = "JobDeliveryDateTimeBaseline_Delivery_Poc_DDD_C_BT";
        public const string D2DatePlanned = "JobDeliveryDateTimePlanned_Delivery_Poc_I";
        public const string D2DatePlannedDrpdwn = "JobDeliveryDateTimePlanned_Delivery_Poc_B-1";
        public const string D2DatePlannedToday = "JobDeliveryDateTimePlanned_Delivery_Poc_DDD_C_BT";
        public const string D2DateActual = "JobDeliveryDateTimeActual_Delivery_Poc_I";
        public const string D2DateActualDrpdwn = "JobDeliveryDateTimeActual_Delivery_Poc_B-1";
        public const string D2DateActualToday = "JobDeliveryDateTimeActual_Delivery_Poc_DDD_C_BT";
        public const string D2TimeZone = "JobDeliveryTimeZone_Delivery_Poc_I";

        //Seller Tab  - Seller Panel

        public const string SSitename = "JobSellerSiteName_I";
        public const string SPOC2 = "JobSellerSitePOC_I";
        public const string SPOCPhone = "JobSellerSitePOCPhone_I";
        public const string SEmail = "JobSellerSitePOCEmail_I";
        public const string SStreetAddress = "JobSellerStreetAddress_I";
        public const string SStreetAddress2 = "JobSellerStreetAddress2_I";
        public const string SCity = "JobSellerCity_I";
        public const string SState = "JobSellerState_Delivery_Seller_I";
        public const string SPostalCode = "JobSellerPostalCode_I";
        public const string SCountry = "JobSellerCountry_I";
        public const string S2POC = "JobSellerSitePOC2_I";
        public const string S2POCPhone = "JobSellerSitePOCPhone2_I";
        public const string S2POCEmail = "JobSellerSitePOCEmail2_I";


        //Seller Tab - Destination Panel

        public const string SDSitename = "JobDeliverySiteName_I";
        public const string SDPOC2 = "JobDeliverySitePOC_I";
        public const string SDPOCPhone = "JobDeliverySitePOCPhone_I";
        public const string SDEmail = "JobDeliverySitePOCEmail_I";
        public const string SDStreetAddress = "JobDeliveryStreetAddress_I";
        public const string SDStreetAddress2 = "JobDeliveryStreetAddress2_I";
        public const string SDCity = "JobDeliveryCity_I";
        public const string SDState = "JobDeliveryState_Delivery_Seller_I";
        public const string SDPostalCode = "JobDeliveryPostalCode_I";
        public const string SDCountry = "JobDeliveryCountry_I";
        public const string SDDateBaseline = "JobDeliveryDateTimeBaseline_Delivery_Seller_I";
        public const string SDDateBaselineDrpdwn = "JobDeliveryDateTimeBaseline_Delivery_Seller_B-1";
        public const string SDDateBaselineToday = "JobDeliveryDateTimeBaseline_Delivery_Seller_DDD_C_BT";
        public const string SDDatePlanned = "JobDeliveryDateTimePlanned_Delivery_Seller_I";
        public const string SDDatePlannedDrpdwn = "JobDeliveryDateTimePlanned_Delivery_Seller_B-1";
        public const string SDDatePlannedToday = "JobDeliveryDateTimePlanned_Delivery_Seller_DDD_C_BT";
        public const string SDDateActual = "JobDeliveryDateTimeActual_Delivery_Seller_I";
        public const string SDDateActualDrpdwn = "JobDeliveryDateTimeActual_Delivery_Seller_B-1";
        public const string SDDateActualToday = "JobDeliveryDateTimeActual_Delivery_Seller_DDD_C_BT";
        public const string SDTimeZone = "JobDeliveryTimeZone_Delivery_Seller_I";

        public const string JobGatewayTab = "pageControl_T0T";
        public const string JobGatewaysAll = "Gateways_JobDeliveryPageControl_T0T";
        public const string JobGateways = "Gateways_JobDeliveryPageControl_T1T";
        public const string JobGatewayActions = "Gateways_JobDeliveryPageControl_T2T";
        public const string JobGatewayLogss = "Gateways_JobDeliveryPageControl_T3T";


        public const string JobCargo = "pageControl_T1T";
        public const string JobDocument = "pageControl_T2T";
        public const string JobNotes = "pageControl_T3T";


        #endregion

        #region Job Gateways
        public const string JobGtwGatewayAllSelectedTab = "Gateways_JobDeliveryPageControl_AT0T";
        public const string JobGtwGateway = "Gateways_JobDeliveryPageControl_T1";
        public const string JobGtwGatewayRow = "JobGatewayGridView_DXHeadersRow0";
        public const string JobGtwGatewayEmptyRow = "//tr[@id='JobGatewayGridView_DXEmptyRow']//td[@class='dxgvHEC']";
        public const string JobGtwEmptyRow = " //tr[@id='JobGatewayGridView_DXEmptyRow' and @class='dxgvEmptyDataRow_Office2010Black dxgvLVR']";
        public const string JobGatewaysAllGridNew = "JobGatewayGridView_DXEmptyRow";
        public const string JobGatewaysAllEmpty = "//tr[@id='JobGatewayGridView_DXEmptyRow' and @class='dxgvEmptyDataRow_Office2010Black dxgvLVR']";
        public const string JobGatewaysAllNew = "JobGatewayGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobGatewaysAllEdit = "JobGatewayGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobGatewaysAllChooseColumn = "JobGatewayGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobGatewaysAllSave = "JobGatewayJobGatewayJobGatewayAll1AllCbPanelSecondNavigationPane_DXI1_T";
        public const string JobGatewaysAllCancel = "JobGatewayJobGatewayJobGatewayAll1AllCbPanelSecondNavigationPane_DXI0_T";
        public const string JobGatewaysAllSaveOk = "btnOk_CD";

        public const string Id = "Id_popup_I";
        public const string GtwJobId = "JobID_popup_I";
        public const string Item = "GwyGatewaySortOrder_popup_I";
        public const string GtwType = "GatewayTypeId_popup_I";
        public const string GtwTypeDrpdwn = "GatewayTypeId_popup_B-1";
        public const string GtwTypeGateway = "GatewayTypeId_popup_DDD_L_LBI0T0";
        public const string GtwTypeAction = "GatewayTypeId_popup_DDD_L_LBI1T0";
        public const string GtwTypeDocument = "GatewayTypeId_popup_DDD_L_LBI2T0";
        public const string GtwTypeComment = "GatewayTypeId_popup_DDD_L_LBI3T0";
        public const string Code = "GwyGatewayCode_popup_I";
        public const string Title = "GwyGatewayTitle_popup_I";
        public const string Duration = "GwyGatewayDuration_popup_I";
        public const string Units = "GatewayUnitId_popup_I";
        public const string UnitsDrpdwn = "GatewayUnitId_popup_B-1";
        public const string UnitsDay = "GatewayUnitId_popup_DDD_L_LBI0T0";
        public const string UnitsHour = "GatewayUnitId_popup_DDD_L_LBI1T0";
        public const string UnitsMinute = "GatewayUnitId_popup_DDD_L_LBI2T0";
        public const string Default = "GwyGatewayDefault_popup_S_D";
        public const string GtwCompleted = "GwyCompleted_popup_S_D";
        public const string BCD = "GwyGatewayECD_popup_I";
        public const string BCDDrpdwn = "GwyGatewayECD_popup_B-1";
        public const string BCDToday = "GwyGatewayECD_popup_DDD_C_BT";
        public const string PCD = "GwyGatewayPCD_popup_I";
        public const string PCDDrpdwn = "GwyGatewayPCD_popup_DDD_C_BT";
        public const string PCDToday = "GwyGatewayPCD_popup_DDD_C_BT";
        public const string ACD = "GwyGatewayACD_popup_I";
        public const string ACDDrpdwn = "GwyGatewayACD_popup_DDD_C_BT";
        public const string ACDToday = "GwyGatewayACD_popup_DDD_C_BT";
        public const string GtwRefType = "GwyDateRefTypeId_popup_I";
        public const string GtwRefTypeDrpdwn = "GwyDateRefTypeId_popup_B-1";
        public const string GtwRefTypePckDate = "GwyDateRefTypeId_popup_DDD_L_LBI0T0";
        public const string GtwRefTypeDelDate = "GwyDateRefTypeId_popup_DDD_L_LBI1T0";
        public const string GtwRefTypeManual = "GwyDateRefTypeId_popup_DDD_L_LBI2T0";
        public const string GtwScanner = "Scanner_popup_S_D";
        public const string GtwShpStatusRsnCode = "GwyShipStatusReasonCode_popup_I";
        public const string GtwShpStatusRsnCodeDrpdwn = "GwyShipStatusReasonCode_popup_B-1";
        public const string GtwShpAppntRsnCode = "GwyShipApptmtReasonCode_popup_I";
        public const string GtwShpAppntRsnCodeDrpdwn = "GwyShipApptmtReasonCode_popup_B-1";
        public const string GtwOrderType = "GwyOrderType_popup_I";
        public const string GtwOrderTypeDrpdwn = "GwyOrderType_popup_B-1";
        public const string GtwOrderTypeOriginal = "GwyOrderType_popup_DDD_L_LBI0T0";
        public const string GtwOrderTypeReturn = "GwyOrderType_popup_DDD_L_LBI1T0";
        public const string GtwShpmntType = "GwyShipmentType_popup_I";
        public const string GtwShpmntTypeDrpdwn = "GwyShipmentType_popup_B-1";
        public const string GtwShpmntTypeCDS = "GwyShipmentType_popup_DDD_L_LBI0T0";
        public const string GtwShpmntTypeDS = "GwyShipmentType_popup_DDD_L_LBI1T0";
        public const string GtwAnalystCon = "GwyGatewayAnalyst_popup_I";
        public const string GtwAnalystConDrpdwn = "GwyGatewayAnalyst_popup_B-1";
        public const string GtwRespCon = "GwyGatewayResponsible_popup_I";
        public const string GtwRespConDrpdwn = "GwyGatewayResponsible_popup_B-1";
        public const string GtwStatus = "StatusId_popup_I";
        public const string GtwStatusDrpdwn = "StatusId_popup_B-1";
        public const string GtwStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string GtwStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string GtwStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string GtwSave = "JobGatewayJobGatewayJobGatewayAll1AllCbPanelSecondNavigationPane_DXI1_T";
        public const string GtwCancel = "JobGatewayJobGatewayJobGatewayAll1AllCbPanelSecondNavigationPane_DXI0_T";
        public const string GtwSaveOk = "btnOk_CD";

        public const string JobGatewaysGtwGridNew = "Gateways_JobGatewayGridView_DXEmptyRow";
        public const string JobGatewaysGtw_Record = "";
        public const string JobGatewaysGtwNew = "Gateways_JobGatewayGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobGatewaysGtwEdit = "Gateways_JobGatewayGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobGatewaysGtwChooseColumn = "Gateways_JobGatewayGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobGatewaysGtwSave = "JobGatewayJobGatewayJobGatewayDataView2GatewaysCbPanelSecondNavigationPane_DXI1_T";
        public const string JobGatewaysGtwCancel = "JobGatewayJobGatewayJobGatewayDataView2GatewaysCbPanelSecondNavigationPane_DXI0_T";
        public const string JobGatewaysGtwSaveOk = "btnOk_CD";


        public const string JobGatewaysActionGridNew = "Actions_JobGatewayGridView_DXEmptyRow";
        public const string JobGatewaysActionRecord = "";
        public const string JobGatewaysActionNew = "Actions_JobGatewayGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobGatewaysActionEdit = "Actions_JobGatewayGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobGatewaysActionChooseColumn = "Actions_JobGatewayGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobGatewaysActionSave = "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanelSecondNavigationPane_DXI1_T";
        public const string JobGatewaysActionCancel = "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanelSecondNavigationPane_DXI0_T";
        public const string JobGatewaysActionSaveOk = "btnOk_CD";


        public const string JobGatewaysLogGridNew = "Logs_JobGatewayGridView_DXEmptyRow";
        public const string JobGatewaysLogRecord = "";
        public const string JobGatewaysLogNew = "Logs_JobGatewayGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobGatewaysLogEdit = "Logs_JobGatewayGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobGatewaysLogChooseColumn = "Logs_JobGatewayGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobGatewaysLogSave = "JobGatewayJobGatewayJobGatewayLog4LogCbPanelSecondNavigationPane_DXI1_T";
        public const string JobGatewaysLogCancel = "JobGatewayJobGatewayJobGatewayLog4LogCbPanelSecondNavigationPane_DXI0_T";
        public const string JobGatewaysLogSaveOk = "btnOk_CD";



        #endregion


        #region Job Attributes
        public const string JobAttrbuteColumn0 = "JobAttributeGridView_DXHeadersRow0";
        public const string JobAttrbuteGridEmpty = "//tr[@id='JobAttributeGridView_DXEmptyRow']//div[@class='dxgvFCW']";
        public const string JobAttrbuteNew = "JobAttributeGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobAttrbuteEdit = "JobAttributeGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobAttrbuteChooseColumn = "JobAttributeGridView_DXContextMenu_Rows_DXI3_T";
        public const string AttId = "Id_popup_I";
        public const string AttJobId = "JobID_popup_I";
        public const string AttItem = "AjbLineOrder_popup_I";
        public const string AttCode = "AjbAttributeCode_popup_I";
        public const string AttTitle = "AjbAttributeTitle_popup_I";
        public const string AttQty = "AjbAttributeQty_popup_I";
        public const string AttUnits = "AjbUnitTypeId_popup_I";
        public const string AttUnitsDrpdwn = "AjbUnitTypeId_popup_B-1";
        public const string AttUnitCode = "AjbUnitTypeId_popup_DDD_L_LBI0T0";
        public const string AttUnitFeet = "AjbUnitTypeId_popup_DDD_L_LBI1T0";
        public const string AttUnitYN = "AjbUnitTypeId_popup_DDD_L_LBI2T0";
        public const string AttUnitText = "AjbUnitTypeId_popup_DDD_L_LBI3T0";
        public const string AttDefault = "AjbDefault_popup_S_D";
        public const string AttStatus = "StatusId_popup_I";
        public const string AttStatusDrpdwn = "StatusId_popup_B-1";
        public const string AttStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string AttStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string AttStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string JobAttrbuteSave = "JobDeliveryJobAttributeDataView5AttributesCbPanelSecondNavigationPane_DXI1_T";
        public const string JobAttrbuteCancel = "JobDeliveryJobAttributeDataView5AttributesCbPanelSecondNavigationPane_DXI0_T";
        public const string JobAttrbuteSaveOk = "btnOk_CD";
        #endregion


        #region Job Cargo

        public const string JbCargoSelectedTab = "Cargo_JobCargoPageControl_AT0T";
        public const string JobCargoSummaryTab = "Cargo_JobCargoPageControl_T0T";
        public const string JobCargoDetailedTab = "Cargo_JobCargoPageControl_T1T";
        public const string JobCargoMissingTab = "Cargo_JobCargoPageControl_T2T";
        public const string JobCargoDamagedTab = "Cargo_JobCargoPageControl_T3T";
        public const string JobCargoReportTab = "Cargo_JobCargoPageControl_T4T";



        public const string JobCargoGrid_Record = "";
        public const string JobCargoGrid = "//tr[@id='JobCargoGridView_DXEmptyRow']//div[@class='dxgvFCW']";
        public const string JobCargoNew = "JobCargoGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobCargoEdit = "JobCargoGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobCargoChooseColumn = "JobCargoGridView_DXContextMenu_Rows_DXI2_T";
        public const string CargoId = "Id_popup_I";
        public const string CargoJobId = "JobID_popup_I";
        public const string CargoItem = "CgoLineItem_popup_I";
        public const string NumberCode = "CgoPartNumCode_popup_I";
        public const string SerialNumber = "CgoSerialNumber_popup_I";
        public const string CargoTitle = "CgoTitle_popup_I";
        public const string Packaging = "CgoPackagingType_popup_I";
        public const string PackagingDrpdwn = "CgoPackagingType_popup_B-1";
        public const string PackagingPallets = "CgoPackagingType_popup_DDD_L_LBI0T0";
        public const string PackagingCabinets = "CgoPackagingType_popup_DDD_L_LBI1T0";
        public const string PackagingPeices = "CgoPackagingType_popup_DDD_L_LBI2T0";
        public const string MasterCartonLabel = "CgoMasterCartonLabel_popup_I";
        public const string Weight = "CgoWeight_popup_I";
        public const string WeightUnit = "CgoWeightUnits_popup_I";
        public const string WeightUnitDrpdwn = "CgoWeightUnits_popup_B-1";
        public const string WeightUnitLbs = "CgoWeightUnits_popup_DDD_L_LBI0T0";
        public const string WeightUnitKgs = "CgoWeightUnits_popup_DDD_L_LBI1T0";
        public const string Length = "CgoLength_popup_I";
        public const string Width = "CgoWidth_popup_I";
        public const string Height = "CgoHeight_popup_I";
        public const string VolumeUnits = "CgoVolumeUnits_popup_I";
        public const string VolumeUnitsDrpdwn = "CgoVolumeUnits_popup_B-1";
        public const string VolumeUnitsCF = "CgoVolumeUnits_popup_DDD_L_LBI0T0";
        public const string Cubes = "CgoCubes_popup_I";
        public const string QtyExpected = "CgoQtyExpected_popup_I";
        public const string QtyOnHand = "CgoQtyOnHand_popup_I";
        public const string QtyDamaged = "CgoQtyDamaged_popup_I";
        public const string QtyOnHold = "CgoQtyOnHold_popup_I";
        public const string QtyShortOver = "CgoQtyShortOver_popup_I";
        public const string QtyUnit = "CgoQtyUnits_popup_I";
        public const string QtyUnitDrpdwn = "CgoQtyUnits_popup_B-1";
        public const string QtyUnitPallets = "CgoQtyUnits_popup_DDD_L_LBI0T0";
        public const string QtyUnitCabinet = "CgoQtyUnits_popup_DDD_L_LBI1T0";
        public const string QtyUnitPeices = "CgoQtyUnits_popup_DDD_L_LBI2T0";
        public const string ReasonCodeOSD = "CgoReasonCodeOSD_popup_I";
        public const string ReasonCodeHold = "CgoReasonCodeHold_popup_I";
        public const string Latitude = "CgoLatitude_popup_I";
        public const string Longitude = "CgoLongitude_popup_I";
        public const string SeverityCode = "CgoSeverityCode_popup_I";
        public const string CargStatus = "StatusId_popup_I";
        public const string CargStatusDrpdwn = "StatusId_popup_B-1";
        public const string CargStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string CargStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string CargStatusArchive = "StatusId_popup_DDD_L_LBI2T0";



        public const string JobCargoSave = "JobCargoJobCargoDataView1SummaryCbPanelSecondNavigationPane_DXI1_T";
        public const string JobCargoCancel = "JobCargoJobCargoDataView1SummaryCbPanelSecondNavigationPane_DXI0_T";
        public const string JobCargoSaveOk = "btnOk_CD";


        #endregion

        #region Job Documents

        public const string JobDocByCategorySelected = "Document_JobCargoPageControl_AT0T";
        public const string JobDocumentGridHeader = "JobGatewayGridView_DXHeadersRow0";
        public const string JobDocByCategoryGrid = "//tr[@id='DocumentPod_JobDocReferenceGridView_DXEmptyRow']//div[@class='dxgvFCW']";
        public const string JobDocByCategory_Record = "DocumentPod_JobDocReferenceGridView_DXEmptyRow0";
        public const string JobDocByCategoryNew = "DocumentPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobDocByCategoryChooseColumn = "DocumentPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI3_T";
        public const string JobDocByCategoryEdit = "DocumentPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string DocId = "Id_popup_I";
        public const string DocJobId = "JobID_popup_I";
        public const string DocItem = "JdrItemNumber_popup_I";
        public const string DocCode = "JdrCode_popup_I";
        public const string DocTitle = "JdrTitle_popup_I";
        public const string DocDocument = "DocTypeId_popup_I";
        public const string DocDocumentDrpdwn = "'DocTypeId_popup_B-1";
        public const string DocDocumentDocument = "DocTypeId_popup_DDD_L_LBI0T0";
        public const string DocDocumentPOD = "DocTypeId_popup_DDD_L_LBI1T0";
        public const string DocDocumentDamaged = "DocTypeId_popup_DDD_L_LBI2T0";
        public const string DocDateStart = "JdrDateStart_popup_I";
        public const string DocDateStartDrpdwn = "JdrDateStart_popup_B-1";
        public const string DocDateStartToday = "JdrDateStart_popup_DDD_C_BT";
        public const string DocDateEnd = "JdrDateEnd_popup_I";
        public const string DocDateEndDrpdwn = "JdrDateEnd_popup_B-1";
        public const string DocDateEndToday = "JdrDateEnd_popup_DDD_C_BT";
        public const string DocRenewal = "JdrRenewal_popup_S_D";
        public const string DocStatus = "StatusId_popup_I";
        public const string DocStatusDrpdwn = "StatusId_popup_B-1";
        public const string DocStatusActive = "StatusId_popup_DDD_L_LBI0T0";
        public const string DocStatusInactive = "StatusId_popup_DDD_L_LBI1T0";
        public const string DocStatusArchive = "StatusId_popup_DDD_L_LBI2T0";
        public const string JobDocByCategorySave = "JobDocReferenceJobDocReferenceDocumentDataView1ByCategoryCbPanelSecondNavigationPane_DXI1_T";
        public const string JobDocByCategoryCancel = "JobDocReferenceJobDocReferenceDocumentDataView1ByCategoryCbPanelSecondNavigationPane_DXI0_T";
        public const string JobDocByCategorySaveOk = "btnOk_CD";



        public const string JobDocPodGrid = "DocDeliveryPod_JobDocReferenceGridView_DXEmptyRow";
        public const string JobDocPodGridNew = "DocDeliveryPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobDocPodEdit = "DocDeliveryPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobDocPodChooseColumn = "DocDeliveryPod_JobDocReferenceGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobDocPodSave = "JobDocReferenceJobDocReferenceDocDeliveryPodDataView2PODCbPanelSecondNavigationPane_DXI1_T";
        public const string JobDocCancel = "JobDocReferenceJobDocReferenceDocDeliveryPodDataView2PODCbPanelSecondNavigationPane_DXI0_T";
        public const string JobDocPodSaveOk = "btnOk_CD";


        public const string JobDocDamageGrid = "DocDamagedDataView_JobDocReferenceGridView_DXEmptyRow";
        public const string JobDocDamageNew = "DocDamagedDataView_JobDocReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string JobDocDamageEdit = "DocDamagedDataView_JobDocReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string JobDocDamageChooseColumn = "DocDamagedDataView_JobDocReferenceGridView_DXContextMenu_Rows_DXI2_T";
        public const string JobDocDamageSave = "JobDocReferenceJobDocReferenceDocDamagedDataView2DamagedCbPanelSecondNavigationPane_DXI1_T";
        public const string JobDocDamageCancel = "JobDocReferenceJobDocReferenceDocDamagedDataView2DamagedCbPanelSecondNavigationPane_DXI0_T";
        public const string JobDocDamageSaveOk = "btnOk_CD";


        #endregion
    }
}
