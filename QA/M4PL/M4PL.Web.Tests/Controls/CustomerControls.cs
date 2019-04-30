using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Controls
{
    class CustomerControls
    {
        public const string GridFocusedRowClass = "dxgvFocusedRow_Office2010Black";
        public const string CustomerToogleFilterRow = "CustomerGridView_DXFilterRow";
        public const string CusCodeToggleFilterPath = "CustomerGridView_DXFREditorcol4_I";
        public const string FilterBoxChecked = "CustomerGridView_DXFilterBar_CBFilterEnabled_S_D";
        public const string CusNew = "CustomerGridView_DXContextMenu_Rows_DXI0_T";
        public const string CusEdit = "CustomerGridView_DXContextMenu_Rows_DXI1_T";
        public const string CusChooseColumn = "CustomerGridView_DXContextMenu_Rows_DXI2_T";
        public const string CusStatusBar = "CustomerGridView_tcStatusBar";
        public const string CustomerId = "Id_I"; 
        public const string ErpId = "CustERPID_I";
        //public const //string OrgId = "";
        public const string CusItem = "CustItemNumber_I";
        public const string CusCode = "CustCode_I";
        public const string CusTitle = "CustTitle_I";
        public const string CusType = "CustTypeId_I";
        public const string CusWebPage = "CustWebPage_I";
        public const string CusStatus = "StatusId_I";
        public const string CusLogo = "CustLogo_DXButtonPanel_DXOpenDialogButton";
        public const string CusDescription = "";
        public const string CusAddress = "pageControl_T1T";
        public const string CusNotes = "//span[contains(text(),'Notes')]";
        public const string CusSaveBtn = "btnCustomerSave_CD";
        public const string CusCancelBtn = "btnCustomerCancel_CD";
        public const string CusUpdateBtn = "btnCustomerSave_CD";
        public const string CusUpdateOkBtn = "btnOk_CD";
        public const string CusNewRbn = "M4PLRibbon_T0G3I1";
        public const string CusSaveRbn = "M4PLRibbon_T0G3I2_RI";
        public const string CusChooseColumnRbn = "M4PLRibbon_T0G2I4_RI";
        public const string CusFormViewBtn = "M4PLRibbon_T0G0I0_LI";
        public const string CusDataShtViewBtn = "M4PLRibbon_T0G0I1_LI";
        public const string CusWorkAddress = "CustWorkAddressId_I";
        public const string CWorkAddressContactIcon = "btnCustWorkAddressId0Img";
        public const string CusSaveOkBtn = "//span[contains(text(),'Ok')]";
        public const string ToggleFilter = "M4PLRibbon_T0G2I6";
        public const string CusCodeSearch = "CustomerGridView_DXFREditorcol2_I";
        public const string ToggleFilterCode = "CustomerGridView_DXFREditorcol2_I";
        public const string SearchCode = "CustomerGridView_DXFREditorcol2_I";
        public const string SearchedRow0 = "//tr[@id='CustomerGridView_DXDataRow0']//td";
        public const string EditIconRightClick = "CustomerGridView_DXContextMenu_Rows_DXI1_T";
        public const string AdrCorp = "CustCorporateAddressId_I";
        public const string AdrBusiness = "CustBusinessAddressId_I";
        public const string AdrWork = "CustWorkAddressId_I";

        #region Customer WA ContactCard

        public const string CAWAContactId= "Id_popupContact_I";
        public const string CAWAFirstName= "ConFirstName_popupContact_I";
        public const string CAWALastName = "ConLastName_popupContact_I";
        public const string CAWABusinessPhone = "ConBusinessPhone_popupContact_I";
        public const string CAWAIndEmail = "ConEmailAddress2_popupContact_I";
        public const string CAWANewContact = "CustWorkAddressIdCbPanelSecondNavigationPane_DXI2_T";
        public const string CAWASave = "CustWorkAddressIdCbPanelSecondNavigationPane_DXI1_T";
        public const string CAWACancel = "CustWorkAddressIdCbPanelSecondNavigationPane_DXI0_T";


        #endregion Customer WA ContactCard

        // public const // Controls for Customer Sub Tabs Financial Calendar

        public const string FCTab = "pageControl_T3T";
        public const string FC0Row = "CustFinancialCalendarGridView_DXDataRow0";
        public const string FCSearchedColumnCode = "CustFinancialCalendarGridView_DXFREditorcol1_I";
        public const string CusFinancialCal = "//span[contains(text(),'Financial Calendar')]";
        public const string FCEmptyRow = "CustFinancialCalendarGridView_DXEmptyRow";
        public const string FCNew = "CustFinancialCalendarGridView_DXContextMenu_Rows_DXI0_T";
        public const string FCEdit = "CustFinancialCalendarGridView_DXContextMenu_Rows_DXI1_T";
        public const string FCChooseColumn = "//div[@id='CustFinancialCalendarGridView_DXContextMenu_Rows_DXI1_T']//span[contains(text(),'Choose Column')]";
        public const string FCToggleFilter = "CustFinancialCalendarGridView_DXContextMenu_Rows_DXI3_T";
        public const string FCToggleFilterRow = "CustFinancialCalendarGridView_DXFilterRow";
        public const string FilterBoxCheckedFC = "CustFinancialCalendarGridView_DXFilterBar_CBFilterEnabled_S_D";
        public const string FCId = "Id_popup_I";
        public const string FCPeriodOrder = "FclPeriod_popup_I";
        public const string FCCode = "FclPeriodCode_popup_I";
        public const string FCTitle = "FclPeriodTitle_popup_I";
        public const string FCPeriodStart = "FclPeriodStart_popup_I";
        public const string FCPeriodEnd = "FclPeriodEnd_popup_I";
        public const string FCAutoCode = "FclAutoShortCode_popup_I";
        public const string FCWorkDays = "FclWorkDays_popup_I";
        public const string FCType = "FinCalendarTypeId_popup_I";
        public const string FCStatus = "StatusId_popup_I";
        public const string FCSave = "CustomerCustFinancialCalendarDataView4FinancialCalendarCbPanelSecondNavigationPane_DXI1_T";
        public const string FCCancel = "CustomerCustFinancialCalendarDataView4FinancialCalendarCbPanelSecondNavigationPane_DXI0_T";
        public const string FCSaveOkbtn = "btnOk_CD";
        public const string FCPeriodStartIcon = "FclPeriodStart_popup_B-1Img";
        public const string FCPeriodEndIcon = "FclPeriodEnd_popup_B-1Img";
        public const string FCPeriodStartTodayIcn = "FclPeriodStart_popup_DDD_C_BT";
        public const string FCPeriodEndTodayIcn = "FclPeriodEnd_popup_DDD_C_BT";


        #region Customer Contact

        public const string CCTab = "pageControl_T4T";
        public const string CusCustContact = "//span[contains(text(),'Customer Contacts')]";
        public const string CCEmptyRow = "CustContactGridView_DXEmptyRow";
        public const string CC0Row = "CustContactGridView_DXDataRow0";
        public const string CCNew = "CustContactGridView_DXContextMenu_Rows_DXI0_T";
        public const string CCEdit = "CustContactGridView_DXContextMenu_Rows_DXI1_T";
        public const string CCChooseColumn = "//img[@id='CustContactGridView_DXContextMenu_Rows_DXI1_Img']";
        public const string CCId = "Id_popup_I";
        public const string CCItem = "CustItemNumber_popup_I";
        public const string CCCode = "CustContactCode_popup_I";
        public const string CCTitle = "CustContactTitle_popup_I";
        public const string CCContact = "CustContactMSTRID_popup_I";
        public const string CCContactIconDrpdown = "CustContactMSTRID_popup_B-1";
        public const string CCContactCardIcon = "btnCustContactMSTRID0Img";
        public const string CCJobTitle = "ConJobTitleCustContactMSTRID0_popup_I";
        public const string CCAddress = "ConBusinessAddress1CustContactMSTRID0_popup_I";
        public const string CCWorkEmail = "ConEmailAddressCustContactMSTRID0_popup_I";
        public const string CCMobilePhone = "ConMobilePhoneCustContactMSTRID0_popup_I";
        public const string CCBusinessPhone = "ConBusinessPhoneCustContactMSTRID0_popup_I";
        public const string CCStatus = "StatusId_popup_I";
        public const string CCSaveIcn = "CustomerCustContactDataView5CustomerContactsCbPanelSecondNavigationPane_DXI1_T";
        public const string CCCancelIcn = "CustomerCustContactDataView5CustomerContactsCbPanelSecondNavigationPane_DXI0_T";
        public const string CCSaveOkBtn = "btnOk_CD";

        #endregion Customer Contact

        #region Customer Contact - Contact Card

        public const string CCContactId = "Id_popupContact_I";
        public const string CCContactFirstName = "ConFirstName_popupContact_I";
        public const string CCContactLastName = "ConLastName_popupContact_I";
        public const string CCContactBusinessPhone = "ConBusinessPhone_popupContact_CC";
        public const string CCContactIndEmail = "ConEmailAddress2_popupContact_I";
        public const string CCContactNew = "CustContactMSTRIDCbPanelSecondNavigationPane_DXI2_T";
        public const string CCContactSave = "CustContactMSTRIDCbPanelSecondNavigationPane_DXI1_T";
        public const string CCContactCancel = "CustContactMSTRIDCbPanelSecondNavigationPane_DXI0_T";

        #endregion Customer Contact - Contact Card

        #region Customer DCLocation
        public const string CDCLoc = "pageControl_T5T";
        public const string DCEmptyRow = "CustDcLocationGridView_DXEmptyRow";
        public const string DC0Row = "CustDcLocationGridView_DXDataRow0";
        public const string DCNew = "CustDcLocationGridView_DXContextMenu_Rows_DXI0_T";
        public const string DCEdit = "//img[@id='CustDcLocationGridView_DXContextMenu_Rows_DXI1_Img']";
        public const string DCChooseColumn = "//img[@id='CustDcLocationGridView_DXContextMenu_Rows_DXI1_Img']";
        public const string DCId = "Id_popup_I";
        public const string DCItem = "CdcItemNumber_popup_I";
        public const string DCCode = "CdcLocationCode_popup_I";
        public const string DCCusCode = "CdcCustomerCode_popup_I";
        public const string DCTitle = "CdcLocationTitle_popup_I";
        public const string DCContact = "CdcContactMSTRID_popup_I";
        public const string DCContactDrpdwn = "CdcContactMSTRID_popup_B-1";
        public const string DCContactCardIcon = "btnCdcContactMSTRID0Img";
        public const string DCJobTitle = "ConJobTitleCdcContactMSTRID0_popup_I']";
        public const string DCAddress = "ConBusinessAddress1CdcContactMSTRID0_popup_I']";
        public const string DCWorkEmail = "ConEmailAddressCdcContactMSTRID0_popup_I']";
        public const string DCMobilePhone = "ConMobilePhoneCdcContactMSTRID0_popup']";
        public const string DCBusinessPhone = "ConBusinessPhoneCdcContactMSTRID0_popup_I']";
        public const string DCStatus = "StatusId_popup_I']";
        public const string DCSaveIcon = "CustomerCustDcLocationDataView6DCLocationsCbPanelSecondNavigationPane_DXI1_T";
        public const string DCCancel = "CustomerCustDcLocationDataView6DCLocationsCbPanelSecondNavigationPane_DXI0_T";
        public const string DCSaveOkbtn = "btnOk_CD";
        public const string DCContactxIcon = "CdcContactMSTRID_popup_B-100";

        #endregion Customer DCLocation

        public const string CDCContactId = "Id_popupContact_I";
        public const string CDCContactFirstName = "ConFirstName_popupContact_I";
        public const string CDCContactLastName = "ConLastName_popupContact_I";
        public const string CDCContactBusinessPhone = "ConBusinessPhone_popupContact_I";
        public const string CDCContactIndEmail = "ConEmailAddress2_popupContact_I";
        public const string CDCContactNew = "CdcContactMSTRIDCbPanelSecondNavigationPane_DXI2_T";
        public const string CDCContactSave = "CdcContactMSTRIDCbPanelSecondNavigationPane_DXI1_T";
        public const string CDCContactCancel = "CdcContactMSTRIDCbPanelSecondNavigationPane_DXI0_T";

        #region Customer Document

        public const string CusDoc = "pageControl_T6T";
        public const string DocEmptyRow = "CustDocReferenceGridView_DXEmptyRow";
        public const string CD0Row = "CustDocReferenceGridView_DXDataRow0";
        public const string CDNew = "CustDocReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string CDEdit = "CustDocReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string CDChooseColumn = "";
        public const string CDId = "Id_popup_I";
        public const string CDItem = "CdrItemNumber_popup_I";
        public const string CDCode = "CdrCode_popup_I";
        public const string CDTitle = "CdrTitle_popup_I";
        public const string CDDocument = "DocRefTypeId_popup_I";
        public const string CDDocumentDrpdwnIcn = "DocRefTypeId_popup_B-1";
        public const string CDType = "DocCategoryTypeId_popup_I";
        public const string CDTypeDrpdwnIcn = "DocCategoryTypeId_popup_B-1";
        public const string CDDateStart = "CdrDateStart_popup_I";
        public const string CDDateStartDrpdwnIcn = "CdrDateStart_popup_B-1";
        public const string CDDateStartTodayBtn = "CdrDateStart_popup_DDD_C_BT";
        public const string CDDateEnd = "CdrDateEnd_popup_I";
        public const string CDDateEndDrpdwnIcn = "CdrDateEnd_popup_B-1";
        public const string CDDateEndTodayBtn = "CdrDateEnd_popup_DDD_C_BT";
        public const string CDRenewal = "CdrRenewal_popup_S_D";
        public const string CDStatus = "StatusId_popup_I";
        public const string CDSaveIcn = "CustomerCustDocReferenceDataView7DocumentsCbPanelSecondNavigationPane_DXI1_T";
        public const string CDCancelIcn = "CustomerCustDocReferenceDataView7DocumentsCbPanelSecondNavigationPane_DXI0_T";
        public const string CDSaveOkBtn = "btnOk_CD";

        #endregion Customer Document


        #region Customer Business Term

        public const string BTTab = "pageControl_T2T";
        public const string BTEmptyRow = "CustBusinessTermGridView_DXEmptyRow";
        public const string BT0Row = "CustBusinessTermGridView_DXDataRow0";
        public const string BT1Row = "";
        public const string CusBusinessTerms = "//span[contains(text(),'Business Terms')]";
        public const string BTGRID = "CustBusinessTermGridView_DXEmptyRow";
        public const string BTNew = "CustBusinessTermGridView_DXContextMenu_Rows_DXI0_T";
        public const string BTChooseColumn = "CustBusinessTermGridView_DXContextMenu_Rows_DXI2_T";
        public const string BTChooseColumnClose = "CustomerCustBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI0_T";
        public const string BTToggleFilter = "CustBusinessTermGridView_DXContextMenu_Rows_DXI3_T";
        public const string BTToggleFilterRow = "CustBusinessTermGridView_DXFilterRow";
        public const string BTSearchedColumnCode = "CustBusinessTermGridView_DXFREditorcol1_I";
        public const string FilterBoxCheckedBT = "CustBusinessTermGridView_DXFilterBar_CBFilterEnabled_S_D";
        public const string BTGrid = "CustBusinessTermGridView_DXEmptyRow";
        public const string BTCode = "CbtCode_popup_I";
        public const string BTTitle = "CbtTitle_popup_I";
        public const string BTItem = "CbtItemNumber_popup_I";
        public const string BTType = "BusinessTermTypeId_popup_I";
        public const string BTActiveDate = "CbtActiveDate_popup_I";
        public const string BTValue = "CbtValue_popup_I";
        public const string BTHighTh = "CbtHiThreshold_popup_I";
        public const string BTLowTh = "CbtLoThreshold_popup_I";
        public const string BTStatus = "StatusId_popup_I";
        public const string BTSavebtn = "CustomerCustBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI1_T";
        public const string BTCancel = "CustomerCustBusinessTermDataView3BusinessTermsCbPanelSecondNavigationPane_DXI0_T";
        public const string BTSaveOKBtn = "btnOk_CD";
        public const string BTEdit = "CustBusinessTermGridView_DXContextMenu_Rows_DXI1_T";
        public const string BTAttachmentPanel = "pnlCreAttachment_CB";
        public const string BTAttachmentHeaderRow = "AttachmentGridView_DXHeadersRow0";
        public const string BTAttachmentNew = "AttachmentGridView_DXCBtn0";
        public const string BTAttachmentBrowse = "//*[@id='ucAttFileName_Browse0']/a";
        public const string BTAttachmentGridStatusBarFooter = "AttachmentGridView_tcStatusBar";
        public const string BTAttachmentSaveChanges = "btnSaveAttachmentGridView_CD";
        public const string BTAttachmentPageHeader = "AttachmentGridView_DXPagerBottom";

        public const string BTActiveDate_Icon = "CbtActiveDate_popup_B-1Img";
        public const string BTActiveDate_Today = "CbtActiveDate_popup_DDD_C_BT";
        public const string BTGridEdit = "CustBusinessTermGridView_DXContextMenu_Rows_DXI1_T";

        #endregion
    }
}
