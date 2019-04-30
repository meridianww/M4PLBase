using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Controls
{
    class VendorControls
    {
        public const string VenStatusBar = "VendorGridView_tcStatusBar";
        public const string VenSaveBtn = "btnVendorSave";
        public const string VenCancelBtn = "btnVendorCancel";
        public const string GridFocusedRowClass = "dxgvFocusedRow_Office2010Black";
        public const string VendorToogleFilterRow = "VendorGridView_DXFilterRow";
        public const string VenCodeToggleFilterPath = "VendorGridView_DXFREditorcol4_I";
        public const string FilterBoxChecked = "VendorGridView_DXFilterBar_CBFilterEnabled_S_D";
        public const string VendNew = "VendorGridView_DXContextMenu_Rows_DXI0_T";
        public const string VendEdit = "VendorGridView_DXContextMenu_Rows_DXI1_T";
        public const string VendChooseColumn = "VendorGridView_DXContextMenu_Rows_DXI2_T";
        public const string VendStatusBar = "VendorGridView_tcStatusBar";
        public const string VendId = "Id_I";
        public const string ErpId = "VendERPID_I";
        public const string VendItem = "VendItemNumber_I";
        public const string VendCode = "VendCode_I";
        public const string VendTitle = "VendTitle_I";
        public const string VendType = "VendTypeId_I";
        public const string VendWebPage = "VendWebPage_I";
        public const string VendStatus = "StatusId_I";
        public const string VendLogo = "VendLogo_DXButtonPanel_DXOpenDialogButton";
        public const string VendSaveBtn = "btnVendorSave_CD";
        public const string VendCancelBtn = "btnVendorCancel_CD";
        public const string VenSearchedRow0 = "//tr[@id='VendorGridView_DXDataRow0']//td";
        public const string VenAdrCorp = "VenCorporateAddressId_I";
        public const string VenAdrBusiness = "VenBusinessAddressId_I";
        public const string VenAdrWork = "VenWorkAddressId_I";

        public const string VenWAContactCard = "btnVendWorkAddressId0_CD";
        public const string VWAContactId = "Id_popupContact";
        public const string VWAFirstName = "ConFirstName_popupContact_I";
        public const string VWALastName = "ConLastName_popupContact_I";
        public const string VWAIndEmail = "ConEmailAddress2_popupContact_I";
        public const string VWABusinessPhone = "ConBusinessPhone_popupContact_I";
        public const string VWASave = "VendWorkAddressIdCbPanelSecondNavigationPane_DXI1_T";

        public const string VenDescriptionOnTab = "pageControl_AT0T";
        public const string VenDescriptionTab = "pageControl_T0T";
        public const string VenAddress = "pageControl_T1T";
        public const string VenBTTab = "pageControl_T2T";
        public const string VenFCTab = "pageControl_T3T";
        public const string VenVCTab = "pageControl_T4T";
        public const string VenDCLocTab = "pageControl_T5T";
        public const string VenDocTab = "pageControl_T6T";
        public const string VenNotesTab = "pageControl_T7T";


        #region Vendor Business Term

        public const string VenBTEmptyRow = "VendBusinessTermGridView_DXEmptyRow";
        public const string VenBT0Row = "VendBusinessTermGridView_DXDataRow0";
        public const string VenBTGRID = "VendBusinessTermGridView_DXEmptyRow";
        public const string VenBTNew = "VendBusinessTermGridView_DXContextMenu_Rows_DXI0_T";
        public const string VenBTChooseColumn = "VendBusinessTermGridView_DXContextMenu_Rows_DXI2_T";
        public const string VenBTChooseColumnClose = "VendorVendBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI0_T";
        public const string VenBTToggleFilter = "VendBusinessTermGridView_DXContextMenu_Rows_DXI3_";
        public const string VenBTToggleFilterRow = "VendBusinessTermGridView_DXFilterRow";
        public const string VenBTGrid = "VendBusinessTermGridView_DXEmptyRow";
        public const string VenBTCode = "VbtCode_popup_I";
        public const string VenBTTitle = "VbtTitle_popup_I";
        public const string VenBTItem = "VbtItemNumber_popup_I";
        public const string VenBTType = "BusinessTermTypeId_popup_I";
        public const string VenBTActiveDate = "VbtActiveDate_popup_I";
        public const string VenBTValue = "VbtValue_popup_I";
        public const string VenBTHighTh = "VbtHiThreshold_popup_I";
        public const string VenBTLowTh = "VbtLoThreshold_popup_I";
        public const string VenBTStatus = "StatusId_popup_I";
        public const string VenBTSavebtn = "VendorVendBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI1_T";
        public const string VenBTCancel = "VendorVendBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI0_T";
        public const string VenBTSaveOKBtn = "btnOk_CD";
        public const string VenBTEdit = "VendBusinessTermGridView_DXContextMenu_Rows_DXI1_T";
        public const string VenBTActiveDate_Icon = "VbtActiveDate_popup_B-1Img";
        public const string VenBTActiveDate_Today = "VbtActiveDate_popup_DDD_C_BT";
        public const string VenBTGridEdit = "VendBusinessTermGridView_DXContextMenu_Rows_DXI1_T";

        #endregion Vendor Business Term

        #region Vendor Financial Calendar

        public const string VenFCEmptyRow = "//tr[@id='VendFinancialCalendarGridView_DXEmptyRow']//td";
        public const string VenFCNew = "VendFinancialCalendarGridView_DXContextMenu_Rows_DXI0_T";
        public const string VenFCEdit = "";
        public const string VenFCChooseColumn = "";
        public const string VenFCId = "Id_popup_I";
        public const string VenFCPeriodOrder = "FclPeriod_popup_I";
        public const string VenFCCode = "FclPeriodCode_popup_I";
        public const string VenFCTitle = "FclPeriodTitle_popup_I";
        public const string VenFCPeriodStart = "FclPeriodStart_popup_I";
        public const string VenFCPeriodEnd = "FclPeriodEnd_popup_I";
        public const string VenFCAutoCode = "FclAutoShortCode_popup_I";
        public const string VenFCWorkDays = "FclWorkDays_popup_I";
        public const string VenFCType = "FinCalendarTypeId_popup_I";
        public const string VenFCStatus = "StatusId_popup_I";
        public const string VenFCSave = "VendorVendFinancialCalendarDataView4FinancialCalendarCbPanelSecondNavigationPane_DXI1_T";
        public const string VenFCCancel = "VendorVendFinancialCalendarDataView4FinancialCalendarCbPanelSecondNavigationPane_DXI0_T";
        public const string VenFCSaveOkbtn = "btnOk_CD";
        public const string VenFCPeriodStartIcon = "FclPeriodStart_popup_B-1Img";
        public const string VenFCPeriodEndIcon = "FclPeriodEnd_popup_B-1Img";
        public const string VenFCPeriodStartTodayIcn = "FclPeriodStart_popup_DDD_C_BT";
        public const string VenFCPeriodEndTodayIcn = "FclPeriodEnd_popup_DDD_C_BT";

        #endregion Vendor Financial Calendar

        #region Vendor Contacts

        public const string VCEmptyRow = "VendContactGridView_DXEmptyRow";
        public const string VCNew = "VendContactGridView_DXContextMenu_Rows_DXI0_T";
        public const string VCEdit = "VendContactGridView_DXContextMenu_Rows_DXI1_T";
        public const string VCChooseColumn = "//img[@id='CustContactGridView_DXContextMenu_Rows_DXI1_Img']";
        public const string VCId = "Id_popup_I";
        public const string VCItem = "VendItemNumber_popup_I";
        public const string VCCode = "VendContactCode_popup_I";
        public const string VCTitle = "VendContactTitle_popup_I";
        public const string VCContact = "VendContactMSTRID_popup_I";
        public const string VCContactIconDrpdown = "VendContactMSTRID_popup_B-1";
        public const string VCContactCardIcon = "btnVendContactMSTRID0Img";
        public const string VCJobTitle = "ConJobTitleVendContactMSTRID0_popup_I";
        public const string VCAddress = "ConBusinessAddress1CustContactMSTRID0_popup_I";
        public const string VCWorkEmail = "ConEmailAddressCustContactMSTRID0_popup_I";
        public const string VCMobilePhone = "ConMobilePhoneCustContactMSTRID0_popup_I";
        public const string VCBusinessPhone = "ConBusinessPhoneCustContactMSTRID0_popup_I";
        public const string VCStatus = "StatusId_popup_I";
        public const string VCSaveIcn = "VendorVendContactDataView5VendorContactsCbPanelSecondNavigationPane_DXI1_T";
        public const string VCCancelIcn = "VendorVendContactDataView5VendorContactsCbPanelSecondNavigationPane_DXI0_T";
        public const string VCSaveOkBtn = "btnOk_CD";
        public const string VCContactXIcon = "VendContactMSTRID_popup_B-100";

        public const string VCContactId = "Id_popupContact_I";
        public const string VCContactFirstName = "ConFirstName_popupContact_I";
        public const string VCContactLastName = "ConLastName_popupContact_I";
        public const string VCContactBusinessPhone = "ConBusinessPhone_popupContact_CC";
        public const string VCContactIndEmail = "ConEmailAddress2_popupContact_I";
        public const string VCContactNew = "VendContactMSTRIDCbPanelSecondNavigationPane_DXI2_T";
        public const string VCContactSave = "VendContactMSTRIDCbPanelSecondNavigationPane_DXI1_T";
        public const string VCContactCancel = "VendContactMSTRIDCbPanelSecondNavigationPane_DXI0_T";

        #endregion Vendor Contacts

        #region Vendor DC Location

        public const string VDCEmptyRow = "VendDcLocationGridView_DXEmptyRow";
        public const string VDCNew = "VendDcLocationGridView_DXContextMenu_Rows_DXI0_T";
        public const string VDCEdit = "/";
        public const string VDCChooseColumn = "";
        public const string VDCId = "Id_popup_I";
        public const string VDCItem = "VdcItemNumber_popup_I";
        public const string VDCCode = "VdcLocationCode_popup_I";
        public const string VDCCusCode = "VdcCustomerCode_popup_I";
        public const string VDContactXIcon = "VdcContactMSTRID_popup_B-100";
        public const string VDCTitle = "VdcLocationTitle_popup_I";
        public const string VDCContact = "VdcContactMSTRID_popup_I";
        public const string VDCContactDrpdwn = "VdcContactMSTRID_popup_B-1";
        public const string VDCContactCardIcon = "btnVdcContactMSTRID0_CD";
        public const string VDCJobTitle = "ConJobTitleCdcContactMSTRID0_popup_I']";
        public const string VDCAddress = "ConBusinessAddress1CdcContactMSTRID0_popup_I']";
        public const string VDCWorkEmail = "ConEmailAddressCdcContactMSTRID0_popup_I']";
        public const string VDCMobilePhone = "ConMobilePhoneCdcContactMSTRID0_popup']";
        public const string VDCBusinessPhone = "ConBusinessPhoneCdcContactMSTRID0_popup_I']";
        public const string VDCStatus = "StatusId_popup_I']";
        public const string VDCSaveIcon = "VendorVendDcLocationDataView6DCLocationsCbPanelSecondNavigationPane_DXI1_T";
        public const string VDCCancel = "VendorVendDcLocationDataView6DCLocationsCbPanelSecondNavigationPane_DXI0_T";
        public const string VDCSaveOkbtn = "btnOk_CD";

        public const string VDCContactId = "Id_popupContact_I";
        public const string VDCContactFirstName = "ConFirstName_popupContact_I";
        public const string VDCContactLastName = "ConLastName_popupContact_I";
        public const string VDCContactBusinessPhone = "ConBusinessPhone_popupContact_I";
        public const string VDCContactIndEmail = "ConEmailAddress2_popupContact_I";
        public const string VDCContactNew = "VdcContactMSTRIDCbPanelSecondNavigationPane_DXI2_T";
        public const string VDCContactSave = "VdcContactMSTRIDCbPanelSecondNavigationPane_DXI1_T";
        public const string VDCContactCancel = "VdcContactMSTRIDCbPanelSecondNavigationPane_DXI0_T";

        #endregion Vendor DC Location 

        #region Vendor Document

        public const string VDocEmptyRow = "VendDocReferenceGridView_DXEmptyRow";
        public const string VDNew = "VendDocReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string VDEdit = "VendDocReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string VDChooseColumn = "";
        public const string VDId = "Id_popup_I";
        public const string VDItem = "VdrItemNumber_popup_I";
        public const string VDCode = "VdrCode_popup_I";
        public const string VDTitle = "VdrTitle_popup_I";
        public const string VDDocument = "DocRefTypeId_popup_I";
        public const string VDDocumentDrpdwnIcn = "DocRefTypeId_popup_B-1";
        public const string VDType = "DocCategoryTypeId_popup_I";
        public const string VDTypeDrpdwnIcn = "DocCategoryTypeId_popup_B-1";
        public const string VDDateStart = "VdrDateStart_popup_I";
        public const string VDDateStartDrpdwnIcn = "VdrDateStart_popup_B-1";
        public const string VDDateStartTodayBtn = "VdrDateStart_popup_DDD_C_BT";
        public const string VDDateEnd = "VdrDateEnd_popup_I";
        public const string VDDateEndDrpdwnIcn = "VdrDateEnd_popup_B-1";
        public const string VDDateEndTodayBtn = "VdrDateEnd_popup_DDD_C_BT";
        public const string VDRenewal = "VdrRenewal_popup_S_D";
        public const string VDStatus = "StatusId_popup_I";
        public const string VDSaveIcn = "VendorVendDocReferenceDataView7DocumentsCbPanelSecondNavigationPane_DXI1_T";
        public const string VDCancelIcn = "VendorVendDocReferenceDataView7DocumentsCbPanelSecondNavigationPane_DXI0_T";
        public const string VDSaveOkBtn = "btnOk_CD";

        #endregion Vendor Document
    }
}

