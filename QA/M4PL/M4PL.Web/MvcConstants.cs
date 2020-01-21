/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 MvcConstants
//Purpose:                                      Provides all the Mvc Constants to be used throughout the application
//====================================================================================================================================================*/

namespace M4PL.Web
{
    public class MvcConstants
    {
        //PLEASE KEEP A- Z Order!!!!
        #region Controllers
        public const string ControllerCommon = "Common";
        public const string ControllerMvcBase = "MvcBase";
        #endregion

        #region Actions

        public const string ActionForm = "FormView";
        public const string ActionRichEditor = "RichEditor";
        public const string ActionSaveRichEditor = "SaveRichEditor";
        public const string ActionAddForm = "AddFormView";
        public const string ActionAddOrEdit = "AddOrEdit";
        public const string ActionAddressForm = "AddressForm";
        public const string ActionAddressFormView = "AddressFormView";
        public const string ActionAdvancedSortFilter = "AdvancedSortFilter";
        public const string ActionBatchUpdate = "DataViewBatchUpdate";
        public const string ActionChangeTheme = "ChangeTheme";
        public const string ActionCheckRecordUsed = "CheckRecordUsed";
        public const string ActionChooseColumn = "ChooseColumns";
        public const string ActionClearFilter = "ClearFilter";
        public const string ActionComboBoxContacts = "ComboBoxContacts";
        public const string ActionContactComboBox = "ContactComboBox";
        public const string ActionContactCardForm = "ContactCardFormView";
        public const string ActionContactCardAddOrEdit = "ContactCardAddOrEdit";
        public const string ActionCopyRecord = "CopyRecord";
        public const string ActionDoClick = "DoClick";
        public const string ActionSaveDashboard = "SaveDashboard";
        public const string ActionDashboard = "Dashboard";
        public const string ActionDashboardInfo = "DashboardInfo";
        public const string ActionDashboardViewer = "DashboardViewer";
        public const string ActionDataView = "DataView";
        public const string ActionDelete = "Delete";
        public const string ActionDeliveryTabView = "DeliveryTabView";
        public const string ActionDeleteRecordAssociation = "DeleteRecordAssociation";
        public const string ActionDisplayMessage = "DisplayMessage";
        public const string ActionDownloadAttachment = "DownloadAttachment";
        public const string ActionDropDownView = "GetDropDownView";
        public const string ActionDropDownViewTemplate = "GetDropDownViewTemplate";
        public const string ActionExportExcel = "ExportExcel";
        public const string ActionExportEmail = "ExportEmail";
        public const string ActionExportPdf = "ExportPdf";
        public const string ActionGatewayActionForm = "GatewayActionFormView";
        public const string ActionGetOpenDialog = "GetOpenDialog";
        public const string ActionRefreshAll = "Refresh";
        public const string ActionError = "Error";
        public const string ActionFind = "Find";
        public const string ActionNotFound = "NotFound";
        public const string ActionIntDropDownViewTemplate = "GetIntDropDownViewTemplate";
        public const string ActionGoToRecord = "GoToRecord";
        public const string ActionGridView = "GridView";
        public const string ActionIndex = "Index";
        public const string ActionInnerCallBackPanel = "InnerCallbackPanelPartial";
        public const string ActionLeftMenu = "LeftMenu";
        public const string ActionLastOperation = "LastOperation";
        public const string ActionMoveColumnUp = "MoveColumnUp";
        public const string ActionMoveColumnDown = "MoveColumnDown";
        public const string ActionPasteForm = "PasteFormView";
        public const string ActionPopupNavigation = "GetPopupNavigationTemplate";
        public const string ActionPageControl = "PageControlCallbackPartial";
        public const string ActionGridPagingView = "GridPagingView";
        public const string ActionGridSortingView = "GridSortingView";
        public const string ActionGridGroupingView = "GridGroupingView";
        public const string ActionGridFilteringView = "GridFilteringView";
        public const string ActionIsScheduled = "IsScheduled";
        public const string ActionJobActionAddOrEdit = "JobActionAddOrEdit";
        public const string ActionPopupForm = "PopupFormView";
        public const string ActionPreviousNextValue = "GetPreviousNextValue";
        public const string ActionRemoveSort = "RemoveSort";
        public const string ActionReplace = "Replace";
        public const string ActionCreate = "Create";
        public const string ActionRichEditFormView = "RichEditFormView";
        public const string ActionRichEditDescription = "RichEditDescription";
        public const string ActionRichEditNotes = "RichEditNotes";
        public const string ActionRichEditComments = "RichEditComments";
        public const string ActionRichEditInstructions = "RichEditInstructions";
        public const string ActionRibbonMenu = "RibbonMenu";
        public const string ActionReport = "Report";
        public const string ActionReportInfo = "ReportInfo";
        public const string ActionReportViewer = "ReportViewer";
        public const string ActionAdvanceReportViewer = "AdvanceReportViewer";
        public const string ActionExportReportViewer = "ExportReportViewer";
        public const string ActionSelect = "Select";
        public const string ActionSortAsc = "SortAsc";
        public const string ActionSortDesc = "SortDesc";
        public const string ActionToggleFilter = "ToggleFilter";
        public const string ActionTreeViewCallback = "TreeCallback";
        public const string ActionTreeListCallBack = "TreeListCallBack";
        public const string ActionTreeListMoveNode = "TreeListMoveNode";
        public const string ActionSaveActiveTab = "SaveActiveTab";
        public const string ActionSaveBytes = "SaveBytes";
        public const string ActionSaveReport = "SaveReport";
        public const string ActionShowMessage = "ShowMessage";
        public const string InsAndUpdChooseColumn = "InsAndUpdChooseColumn";
        public const string ActionEntityComboBox = "EntityComboBox";
        public const string ActionDataViewFilter = "DataViewFilter";
        public const string ActionMapVendor = "MapVendor";

        public const string ActionUnassignPrgVendorTreeCallback = "UnassignPrgVendorTreeCallback";
        public const string ActionAssignPrgVendorTreeCallback = "AssignPrgVendorTreeCallback";

        public const string ActionAssignedCostLocationTreeCallback = "AssignedCostLocationTreeCallback";
        public const string ActionUnassignedCostLocationTreeCallback = "UnassignedCostLocationTreeCallback";

        public const string ActionAssignedBillableLocationTreeCallback = "AssignedBillableLocationTreeCallback";
        public const string ActionUnassignedBillableLocationTreeCallback = "UnassignedBillableLocationTreeCallback";

        public const string ActionTreeView = "TreeView";
        public const string ActionPrevNext = "PrevNext";
        public const string ActionTabView = "TabView";
        public const string ActionTabViewCallBack = "TabViewCallBack";
        public const string ActionAttachmentDataView = "AttachmentDataView";
        public const string ActionDataViewRoundPanel = "DataViewRoundPanel ";
        public const string ActionUpdateAttachmentDownloadDate = "UpdateAttachmentDownloadDate";
        public const string ActionPerformCallBack = "PerformCallback";
        public const string ActionShowFilterControl = "ShowFilterControl";
        public const string ActionSessionTimeOut = "SessionTimeOut";
        public const string ActionEmptyResult = "EmptyResult";
        public const string ActionMapVendorCallback = "MapVendorCallback";
        public const string ActionSwitchOrganization = "SwitchOrganization";
        public const string ActionLogOut = "LogOut";
        public const string ActionColAliasDataViewCallback = "ColAliasDataViewCallback";
        public const string ActionAddOrEditJobGatewayComplete = "UpdateJobGatewayComplete";

        public const string ActionJobGatewayDataView = "JobGatewayDataView";
        public const string ActionJobGatewayActions = "JobGatewayActions";
        public const string ActionJobGatewayLog = "JobGatewayLog";
        public const string ActionJobGatewayAll = "JobGatewayAll";
        public const string ActionDocumentDataView = "DocumentDataView";
        public const string ActionDeliveryPodDataView = "DeliveryPodDataView";
        public const string ActionDocDamagedDataView = "DocDamagedDataView";
        public const string ActionDocDeliveryPodDataView = "DocDeliveryPodDataView";

        public const string ActionCopyTo = "CopyTo";
        public const string ActionCopyFrom = "CopyFrom";
        public const string ActionCopy = "Copy";
        public const string ActionPopupMenu = "PopupMenu";
		public const string ActionCompanyComboBox = "CompanyComboBox";
		public const string ActionCompanyCardForm = "CompanyAddressCardFormView";
		public const string ActionProgramRollUpBillingJob = "ProgramRollUpBillingJob";

		#endregion Actions

		#region Views

		public const string CallBackPanelPartial = "_CallbackPanelPartial";
        public const string ChooseColumnForm = "~/Views/Common/_ChooseColumnForm.cshtml";
        public const string ChooseColumnPartial = "~/Views/Common/_ChooseColumnPartial.cshtml";
        public const string DisplayMessagePartial = "_DisplayMessagePartial";
        public const string DropDownPartial = "_DropDownPartial";
        public const string IntDropDownPartial = "_IntDropDownPartial";
        public const string EnteredChangedPartial = "_EnteredChangedPartial";
        public const string GridView = "GridView";
        public const string GridViewPartial = "_GridViewPartial";
        public const string NavigationPanePartial = "_NavigationPanePartial";

        public const string ViewPageControlPartial = "_PageControlPartial";
        public const string ViewInnerPageControlPartial = "_InnerPageControlPartial";

        public const string ViewBlank = "_BlankPartial";
        public const string ViewDashboard = "Dashboard";
        public const string View_Dashboard = "_Dashboard";
        public const string ViewDashboardInfo = "_DashboardInfo";
        public const string ViewDashboardViewer = "_DashboardViewer";
        public const string ViewDeleteMoreInfo = "_DeleteMoreDataView";
        public const string ViewDeleteMoreList = "_ListViewPartial";
        public const string ViewDeleteMoreSplitter = "_DeleteMoreSplitter";

        public const string ViewPopupForm = "_PopupFormPartial";
        public const string ViewPopupForm2 = "_PopupForm2Partial";
        public const string ViewForm = "FormView";
        public const string ViewLeftMenu = "_LeftMenuPartial";
        public const string ViewRibbonMenu = "_RibbonPartial";
        public const string ViewContactCard = "_ContactCardPartial";
        public const string ViewContactComboBox = "_ContactComboBox";
        public const string ViewAddressForm = "_AddressForm";
        public const string ViewRichEditForm = "_RichEditForm";
        public const string ViewRichEditorPartial = "_RichEditorPartial";
        public const string AttachmentGridViewPartial = "_AttachmentGridViewPartial";
        public const string OrgActSecurityGridViewParital = "_OrgActSecurityPartialView";
        public const string ViewTreeViewPartial = "_TreeViewPartial";
        public const string ViewTreeViewSplitter = "_TreeViewSplitter";
        public const string ViewTreeViewCallbackPartial = "_TreeViewContentPanelCallbackPartial";
        public const string ViewDetailGridViewPartial = "_GridDetailViewPartial";

        public const string ViewInnerCallBackPanelPartial = "_InnerCallbackPanelPartial";
        public const string ViewAttachmentDataViewPartial = "_AttachmentDataViewPartial";
        public const string ViewTab = "TabView";
        public const string ViewContactCardPartial = "_ContactCardPartial";

        public const string ViewReport = "Report";
        public const string ViewVocReport = "VocReport";
        public const string ViewJobAdvanceReport = "JobAdvanceReport";
        public const string ViewRichEditRoundPanel = "_RichEditRoundPanel";
        public const string ViewReportInfo = "_ReportInfo";
        public const string ViewReportViewer = "_ReportViewer";
        public const string ViewTreeViewPanelCallbackPartial = "_TreeViewPanelCallbackPartial";
        public const string ViewMenuDriverHelp = "_MenuDriverHelpPartial";
        public const string ViewPopupControl = "_PopupControl";
        public const string ViewRecordPopupControl = "_RecordPopupControl";
        public const string ViewRecordSubPopupControl = "_RecordSubPopupControl";
        public const string ViewDisplayPopupControl = "_DisplayMessageControl";
        public const string ViewTreeListSplitter = "_TreeSplitterPartial";
        public const string ViewTreeListCallBack = "_TreeListPartial";

        public const string ViewJobDestination = "DestinationFormView";
        public const string ViewJobMapRoute = "MapRouteFormView";
        public const string ViewJobPoc = "PocFormView";
        public const string ViewJobPod = "PodFormView";
        public const string ViewJobSeller = "SellerFormView";

        public const string ViewColAliasPanelPartial = "_ColAliasPanelPartial";

        public const string ViewError = "_Error";
        public const string ViewNotFound = "_NotFound";
        public const string ViewMenuGridViewPartial = "_MenuGridViewPartial";

        public const string ViewCustDcLocationContact = "_CustDcLocationContactPartial";
        public const string ViewVendDcLocationContact = "_VendDcLocationContactPartial";

        public const string ViewGatewayAction = "_JobGatewayAction";
		public const string ViewCompanyComboBox = "_CompanyComboBox";
		public const string ViewProgramRollUpBillingJob = "_ProgramRollUpBillingJob"; 
        #endregion Views

        #region Editor Template

        public const string EditorTimeEdit = "TimeEdit";
        public const string EditorReadOnlyTextBoxTemplate = "ReadOnlyTextBoxTemplate";

        #endregion Editor Template

        #region Image Url
        public const string M4PL_Defaultgroup = "/Content/Images/groups.png";
        public const string M4PL_LogOutImage = "/Content/Images/exit.png";
        public const string M4PL_SettingImage = "/Content/Images/setting.png";
        public const string M4PL_QuestionImage = "/Content/Images/question.png";
        public const string M4PL_SupportInboxImage = "/Content/Images/SupportInbox.png";
        public const string M4PL_Error_Icon_Image = "/Content/Images/error.png";
        public const string DefaultTruck = "/Content/Images/truck.png";
        #endregion

        #region ViewData constants

        public const string Count = "Count";
        public const string ColumnSettings = "ColumnSettings";
        public const string GridColumnSettings = "GridColumnSettings";
        public const string ProgramID = "ProgramID";
        public const string LastActiveTabRoute = "LastActiveTabRoute";
        public const string Filters = "Filters";
        public const string DefaultRoute = "DefaultRoute";
        public const string DefaultGroupByColumns = "DefaultGroupByColumns";
        public const string OkLangName = "OkLangName";
        public const string NameSuffix = "NameSuffix";
        public const string OnInit = "OnInit";
        public const string OnChangeEvent = "OnChangeEvent";
        public const string UserIcon = "UserIcon";
        public const string IsReadOnly = "IsReadOnly";
        public const string IsRightAlign = "IsRightAlign";
        public const string Readonly = "Readonly";
        public const string IsEditable = "IsEditable";
        public const string KeyPressEvent = "KeyPressEvent";
        public const string DoNotAddTextChangedEvent = "DoNotAddTextChangedEvent";
        public const string tvRoute = "tvRoute";
        public const string UserMenus = "UserMenus";
        public const string Columns = "Columns";
        public const string textFormat = "textFormat";
        public const string DXCallbackErrorMessage = "DXCallbackErrorMessage";
        public const string SelectedColumns = "SelectedColumns";
        public const string contentRoute = "contentRoute";
        public const string tvContentRoute = "tvContentRoute";
        public const string CheckedChanged = "CheckedChanged";
        public const string ImageHeight = "ImageHeight";
        public const string ImageWidth = "ImageWidth";
        public const string IsAddable = "IsAddable";
        public const string OnChange = "OnChange";
        public const string CurrentValue = "CurrentValue";
        public const string CurrentName = "CurrentName";
        public const string ParentColumnName = "ParentColumnName";
        public const string onTextChange = "onTextChange";
        public const string IsRecordEdit = "IsRecordEdit";
        public const string MakeSkypeCall = "MakeSkypeCall";
        public const string OnValueChange = "OnValueChange";
        public const string CompanyFormResult = "CompanyAddressFormResult";
        public const string IsCompanyAddress = "IsCompanyAddress";

        #endregion
    }
}