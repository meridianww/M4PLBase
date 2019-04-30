using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Controls
{
    class AdministrationControls
    {
        #region Form View ColumnAlias

        public const string Id = "Id_I";
        public const string LCTxtBox = "LangCode_I";
        public const string LCDrpdwnIcn = "LangCode_B-1";
        public const string SortOrder = "ColSortOrder_I";
        public const string TableName = "ColTableName_I";
        public const string TableNameDrpdwn = "ColTableName_B-1";
        public const string ColumnName = "ColColumnName_I";
        public const string ColumnNameDrpdwn = "ColColumnName_B-1";
        public const string AliasName = "ColAliasName_I";
        public const string Caption = "ColCaption_I";
        public const string LookupCode = "ColLookupId_I";
        public const string IsReadOnly = "ColIsReadOnly_S_D";
        public const string IsVisible = "ColIsVisible_S_D";
        public const string IsDefault = "ColIsDefault_S_D";
        public const string Status = "StatusId_I";
        public const string StatusDrpdwn = "StatusId_B-1";
        public const string StatusActive = "StatusId_DDD_L_LBI0T0";
        public const string StatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string StatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string Savebtn = "btnColumnAliasSave";
        public const string Cancelbtn = "btnColumnAliasCancel";
        public const string ConfirmationOk = "btnOk_CD";

        #endregion FormView ColumnAlias


        #region DeliveryStatus

        public const string GridData = "DeliveryStatusGridView_DXDataRow0";
        public const string New = "DeliveryStatusGridView_DXContextMenu_Rows_DXI0_T";
        public const string Edit = "DeliveryStatusGridView_DXContextMenu_Rows_DXI1_T";
        public const string ChooseColumn = "DeliveryStatusGridView_DXContextMenu_Rows_DXI2_T";
        public const string Save = "btnDeliveryStatusSave";
        public const string Cancel = "btnDeliveryStatusCancel";
        public const string OkConfrm = "btnOk_CD";
        public const string ToggleFilterHeaderTextBoxCode = "DeliveryStatusGridView_DXFREditorcol2_I";
        public const string Code = "DeliveryStatusCode_I";
        public const string Title = "DeliveryStatusTitle_I";
        public const string StatusDDIcon = "StatusId_B-1";
        public const string StatusDDOptionWarning = "StatusId_DDD_L_LBI0T0";
        public const string StatusDDOptionOk = "StatusId_DDD_L_LBI1T0";
        public const string StatusDDOptionCompleted = "StatusId_DDD_L_LBI2T0";
        public const string SeverityDDIcon = "SeverityId_B-1";
        public const string SeverityDDOptionNone = "SeverityId_DDD_L_LBI0T0";
        public const string SeverityDDOptionLow = "SeverityId_DDD_L_LBI1T0";
        public const string SeverityDDOptionMedium = "SeverityId_DDD_L_LBI2T0";
        public const string SeverityDDOptionHigh = "SeverityId_DDD_L_LBI3T0";

        #endregion DeliveryStatus

        #region MenuDriver
        public const string MDStatusBar = "MenuDriverGridView_tcStatusBar";
        public const string MDGridData = "MenuDriverGridView_DXDataRow0";
        public const string MDNew = "MenuDriverGridView_DXContextMenu_Rows_DXI0_T";
        public const string MDEdit = "MenuDriverGridView_DXContextMenu_Rows_DXI1_T";
        public const string MDChooseColumn = "MenuDriverGridView_DXContextMenu_Rows_DXI2_T";
        public const string ToggleFilterHeaderTextBoxBreakDownStructure = "MenuDriverGridView_DXFREditorcol3_I";
        public const string MDId = "Id_I";
        public const string LangCode = "LangCode_I";
        public const string MainModule = "MnuModuleId_I";
        public const string MainModuleDrpdwn = "MnuModuleId_B-1";
        public const string MainModuleOptionScanner = "MnuModuleId_DDD_L_LBI7T0";
        public const string BrkdwnStructure = "MnuBreakDownStructure_I";
        public const string MDTitle = "MnuTitle_I";
        public const string TabOver = "MnuTabOver_I";
        public const string Menu = "MnuRibbon_RB0_I_D";
        public const string Ribbon = "MnuRibbon_RB1_I_D";
        public const string RibbonTabName = "MnuRibbonTabName_I";
        public const string MDStatus = "StatusId_I";
        public const string MDStatusDrpdwn = "StatusId_B-1";
        public const string MDStatusActive = "StatusId_DDD_L_LBI0T0";
        public const string MDStatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string MDStatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string IconVerySmall = "MnuIconVerySmall_DXButtonPanel_DXOpenDialogButton";
        public const string IconSmall = "MnuIconSmall_DXButtonPanel_DXOpenDialogButton";
        public const string IconMedium = "MnuIconMedium_DXButtonPanel";
        public const string IconLarge = "MnuIconLarge_DXButtonPanel_DXOpenDialogButton";
        public const string ExecutePrgm = "MnuExecuteProgram_I";
        public const string PrgmType = "MnuProgramTypeId_I";
        public const string PrgmDrpdwn = "MnuProgramTypeId_B-1";
        public const string PrgmDrpdwnOptionMenus = "MnuProgramTypeId_DDD_L_LBI0T0";
        public const string PrgmTypeMenu = "MnuProgramTypeId_DDD_L_LBI0T0";
        public const string PrgmTypeExecutables = "MnuProgramTypeId_DDD_L_LBI1T0";
        public const string PrgmTypeMSOffice = "MnuProgramTypeId_DDD_L_LBI2T0";
        public const string Classification = "MnuClassificationId_I";
        public const string ClassificationDrpdwn = "MnuClassificationId_B-1";
        public const string ClassificationMenuOption = "MnuClassificationId_DDD_L_LBI10T0";
        public const string ClassificationMenuGroup = "MnuClassificationId_DDD_L_LBI11T0";
        public const string OptionLevel = "MnuOptionLevelId_I";
        public const string OptionLevelDrpdwn = "MnuOptionLevelId_B-1";
        public const string OptionLevelNoRight = "MnuOptionLevelId_DDD_L_LBI0T0";
        public const string OptionLevelDashboard = "MnuOptionLevelId_DDD_L_LBI1T0";
        public const string OptionLevelReport = "MnuOptionLevelId_DDD_L_LBI2T0";
        public const string OptionLevelScreens = "MnuOptionLevelId_DDD_L_LBI3T0";
        public const string OptionLevelProcesses = "MnuOptionLevelId_DDD_L_LBI4T0";
        public const string OptionLevelSystems = "MnuOptionLevelId_DDD_L_LBI5T0";
        public const string MDSave = "btnMenuDriverSave";
        public const string MDCancel = "btnMenuDriverCancel";
        public const string MDConfirmOk = "btnOk_CD";
        #endregion MenuDriver


        #region MessageType

        public const string MsgTypStatusBar = "MessageTypeGridView_tcStatusBar";
        public const string MTGridData = "MessageTypeGridView_DXDataRow0";
        public const string MTNew = "MessageTypeGridView_DXContextMenu_Rows_DXI0_T";
        public const string MTEdit = "MessageTypeGridView_DXContextMenu_Rows_DXI1_T";
        public const string MTChooseColumn = "MessageTypeGridView_DXContextMenu_Rows_DXI2_T";
        public const string MTSave = "btnMessageTypeSave";
        public const string MTCancel = "btnMessageTypeCancel";
        public const string MTConfirmationOk = "btnOk_CD";

        public const string ToggleFilterHeaderTextBoxTitle = "MessageTypeGridView_DXFREditorcol3_I";

        public const string MTTitle = "SysMsgtypeTitle_I";
        public const string HeaderIcon = "SysMsgTypeHeaderIcon_DXButtonPanel_DXOpenDialogButton";
        public const string Icon = "SysMsgTypeIcon_DXButtonPanel_DXOpenDialogButton";
        #endregion MessageType

        #region SystemAccount

        public const string SysAccStatusBar = "SystemAccountGridView_tcStatusBar";
        public const string SysAccGrid_Record = "SystemAccountGridView_DXDataRow0";
        public const string SysAccNew = "SystemAccountGridView_DXContextMenu_Rows_DXI0_T";
        public const string SysAccEdit = "SystemAccountGridView_DXContextMenu_Rows_DXI1_T";
        public const string SysAccChooseColumn = "SystemAccountGridView_DXContextMenu_Rows_DXI2_T";
        public const string SysAccId = "Id_I";
        public const string SysAccScreenName = "SysScreenName_I";
        public const string SysAccContact = "SysUserContactID_I";
        public const string SysAccContactDrpdwn = "SysUserContactID_B-1";
        public const string SysAccContactCard = "btnSysUserContactID0_CD";
        public const string SysAccPassword = "txtSysPassword";
        public const string SysAccPasswordShow = "btnPassword_I";
        public const string SysAccRoleCode = "SysOrgRefRoleId_I";
        public const string SysAccRoleCodeDrpdwn = "SysOrgRefRoleId_B-1";
        public const string SysAccStatus = "StatusId_I";
        public const string SysAccStatusDrpdwn = "StatusId_B-1";
        public const string SysAccStatusActive = "StatusId_DDD_L_LBI0T0";
        public const string SysAccStatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string SysAccStatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string SysAccAttempts = "SysAttempts_I";
        public const string SysAccAttemptRefresh = "btnAttempts_CD";
        public const string SysAccSysAdmn = "IsSysAdmin_S_D";
        public const string SysAccSave = "btnSystemAccountSave";
        public const string SysAccSaveOk = "btnOk_CD";
        public const string SysAccCancel = "btnSystemAccountCancel";
        public const string SysAccUpdate = "btnSystemAccountSave";
        public const string RoleCodePOC = "SysOrgRefRoleId_DDD_L_LBI0T0";
        public const string ToggleFilterContact = "SysUserContactID_I";
        public const string ContactSearchedNameRow = "SysUserContactID_DDD_L_LBI0T0";


        //Contact Card Controls

        public const string SysAccConTitle = "ConTitleId_popupContact_I";
        public const string SysAccConFN = "ConFirstName_popupContact_I";
        public const string SysAccConMN = "ConMiddleName_popupContact_I";
        public const string SysAccConLN = "ConLastName_popupContact_I";
        public const string SysAccConJT = "ConJobTitle_popupContact_I";
        public const string SysAccConComp = "ConOrgId_popupContact_I";
        public const string SysAccConBussPhn = "ConBusinessPhone_popupContact_I";
        public const string SysAccConPhnExt = "ConBusinessPhoneExt_popupContact_I";
        public const string SysAccConMobPhn = "ConMobilePhone_popupContact_I";
        public const string SysAccConType = "ConTypeId_popup_I";
        public const string SysAccConWrkEml = "ConEmailAddress_popupContact_I";
        public const string SysAccConIndEml = "ConEmailAddress2_popupContact_I";
        public const string SysAccConBAL1 = "ConBusinessAddress1_popupContact_I";
        public const string SysAccConBAL2 = "ConBusinessAddress2_popupContact_I";
        public const string SysAccConBC = "ConBusinessCity_popupContact_I";
        public const string SysAccConBZP = "ConBusinessZipPostal_popupContact_I";
        public const string SysAccConBSP = "ConBusinessStateId_popup_I";
        public const string SysAccConBCR = "ConBusinessCountryId_popupContact_I";
        public const string SysAccConSaveIcn = "SysUserContactIDCbPanelSecondNavigationPane_DXI1_T";
        public const string SysAccConCancelIcn = "SysUserContactIDCbPanelSecondNavigationPane_DXI0_T";
        public const string SysAccConAddNewIn = "SysUserContactIDCbPanelSecondNavigationPane_DXI2_T";
        #endregion SystemAccount

        #region SystemMessage

        public const string SysMsgStatusBar = "SystemMessageGridView_tcStatusBar";
        public const string SMGridData = "SystemMessageGridView_DXDataRow0";
        public const string SMNew = "SystemMessageGridView_DXContextMenu_Rows_DXI0_T";
        public const string SMEdit = "SystemMessageGridView_DXContextMenu_Rows_DXI1_T";
        public const string SMChooseColumn = "SystemMessageGridView_DXContextMenu_Rows_DXI2_T";
        public const string SMSave = "btnSystemMessageSave";
        public const string SMCancel = "btnSystemMessageCancel";
        public const string SMConfirmationOk = "btnOk_CD";

        public const string SMToggleFilterHeaderTextBoxCode = "SystemMessageGridView_DXFREditorcol2_I";

        public const string SMCode = "SysMessageCode_I";
        public const string SMTitle = "SysMessageScreenTitle_I";
        public const string MsgTitle = "SysMessageTitle_I";
        public const string SystemMsgBtnSelection = "SysMessageButtonSelection_I";
        public const string Description = "SysMessageDescription_I";
        public const string Instruction = "SysMessageInstruction_I";
        #endregion SystemMessage

        #region SystemReference

        public const string SysRefStatusBar = "SystemReferenceGridView_tcStatusBar";
        public const string SRGridData = "SystemReferenceGridView_DXDataRow0";
        public const string SRNew = "SystemReferenceGridView_DXContextMenu_Rows_DXI0_T";
        public const string SREdit = "SystemReferenceGridView_DXContextMenu_Rows_DXI1_T";
        public const string SRChooseColumn = "SystemReferenceGridView_DXContextMenu_Rows_DXI2_T";
        public const string SRSave = "btnSystemReferenceSave";
        public const string SRCancel = "btnSystemReferenceCancel";
        public const string SRConfirmationOk = "btnOk_CD";

        public const string ToggleFilterHeaderTextBoxOptionName = "SystemReferenceGridView_DXFREditorcol2_I";

        public const string LookupCodeDDIcon = "SysLookupId_B-1";
        public const string LookupCodeDDOptionQuestionType = "SysLookupId_DDD_L_LBI26T0";
        public const string OptionName = "SysOptionName_I";
        public const string SRIsDefault = "SysDefault_S_D";
        public const string IsAdmin = "IsSysAdmin_S_D";
        #endregion SystemReference

        #region DatabaseValidation

        public const string DBValStatusBar = "ValidationGridView_tcStatusBar";
        public const string DBGrid_Record = "ValidationGridView_DXDataRow0";
        public const string DBNew = "ValidationGridView_DXContextMenu_Rows_DXI0_T";
        public const string DBEdit = "ValidationGridView_DXContextMenu_Rows_DXI1_T";
        public const string DBChooseColumn = "ValidationGridView_DXContextMenu_Rows_DXI2_T";
        public const string DBId = "Id_I";
        public const string DBLang = "LangCode_I";
        public const string DBLangdrpdwn = "LangCode_B-1";
        public const string DBLangEN = "LangCode_DDD_L_LBI1T0";
        public const string DBLangSpanish = "LangCode_DDD_L_LBI1T0";
        public const string DBLangPortuguese = "LangCode_DDD_L_LBI2T0";
        public const string DBLangGerman = "LangCode_DDD_L_LBI3T0";
        public const string DBTableName = "ValTableName_I";
        public const string DBTableNameDrpdwn = "ValTableName_B-1";
        public const string DBFieldName = "ValFieldName_I";
        public const string DBFieldNameDrpdwn = "ValFieldName_B-1";
        public const string DBRequired = "ValRequired_S_D";
        public const string DBRequiredMessage = "ValRequiredMessage_I";
        public const string DBUnique = "ValUnique_S_D";
        public const string DBUniqueMessage = "ValUniqueMessage_I";
        public const string DBStatus = "StatusId_I";
        public const string DBStatusdrpdwn = "StatusId_B-1";
        public const string DBStatusActive = "StatusId_DDD_L_LBI0T0";
        public const string DBStatusInactive = "StatusId_DDD_L_LBI1T0";
        public const string DBStatusArchive = "StatusId_DDD_L_LBI2T0";
        public const string DBSave = "btnValidationSave";
        public const string DBCancel = "btnValidationCancel";
        public const string SearchedFieldRow = "ValFieldName_DDD_L_LBI0T0";
        #endregion DatabaseValidation
    }
}
