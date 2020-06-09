/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 WebApplicationConstants
//Purpose:                                      Provides all the WebApplication Constants to be used throughout the application
//====================================================================================================================================================*/

namespace M4PL.Web
{
    public class WebApplicationConstants
    {
        //PLEASE KEEP A- Z Order!!!!
        public const string ActiveUser = "ActiveUser";
        public const string AssociatedColumnName = "AssociatedColName";
        public const string AppCbPanel = "AppCbPanel";
        public const string AttachmentHeaderText = "AttachmentHeaderText";
        public const string AttachmentMaxItemNumber = "AttachmentMaxItemNumber";
        public const int ActiveStatusId = 1;
        public const int ArchieveStatusId = 3;
        public const string ByteArray = "ByteArray";
        public const string ClientId = "ClientId";
        public const string ColIsSysAdminPrev = "IsSysAdminPrev";
        public const string ColPreviousStatusId = "PreviousStatusId";
        public const string CommonCommand = "CommonCommand";

        public const string ChooseColumnFormId = "ChooseColumnForm";
        public const string ChooseColumnSelectedColumns = "SelectedColumns";
        public const string ColumnSetting = "ColumnSetting";
        public const string ColumnValidation = "ColumnValidation";
        public const string SaveButtonCssClass = "popupSaveButton";
        public const string CurrentRecord = "CurrentRecord";
        public const string DXCallBackError = "DXCallBackError";
        public const string NotFoundError = "NotFoundError";
        public const string Delete = "Delete";
        public const string Deleted = "(Deleted)";
        public const string Edit = "Edit";
        public const string EntityName = "EntityName";
        public const string EntityImage = "EntityImage";
        public const string Form = "Form";
        public const string GridFilters = "Filters";

        public const string GridLayout = "GridLayout";
        public const string GridBatchEditDisplayMessage = "BatchEditDisplayRoute";
        public const string GridName = "GridView";
        public const int InactiveStatusId = 2;
        public const string InsideGrid = "InsideGrid";
        public const string KeyFieldName = "Id";

        public const string MaxValue = "MaxValue";
        public const string MinValue = "MinValue";
        public const string ParentFieldName = "ParentId";
        public const string PageSize = "M4PLPageSize";
        public const string PopupSuffix = "_popup";
        public const string PagedDataInfo = "PagedDataInfo";
        public const string PhoneMaskOnlyLiterals = "   -   -";
        public const string ProgGtwyDefaultOldSort = "PgdGatewaySortOrder";
        public const string PrgGtwyDefaultSortColm4 = "PgdGatewaySortOrder";
        public const string ProgramDetail = "Program Detail";
        public const string ProjectDetail = "Project Detail";
        public const string PhaseDetail = "Phase Detail";
        public const string RecordInfo = "RecordInfo";
        public const string TimeOffset = "TimeOffset";
        public const string Save = "Save";
        public const string SortOrderAsc = "ASC";
        public const string TabPage = "TabPage";
        public const string Update = "Update";
        public const string UserDataSession = "UserDataSession";
        public const string UserColumnSettings = "UserColumnSettings";
        public const string UserSecurity = "UserSecurity";
        public const string UserSettings = "UserSettings";
        public const string M4PLFileUpload = "FileUpload";
        public const string M4PLSeparator = "#M4PL#";
        public const string TabName = "TabView";
        public const string ActiveTab = "ActiveTab";
        public const string AttachmentGridName = "GetAttachmenGridPartial";
        public const string ViewResultSession = "ViewResultSession";
        public const string ViewPagedDataSession = "ViewPagedDataSession";
        public const string DetailGrid = "DetailGrid";
        public const string RibbonCbPanel = "RibbonCbPanel";
        public const string JobDriverCBPanel = "JobDriverIdCbPanel";
        public const string JobDetailCbPanel = "JobDataViewCbPanel";
        public const string ItemNumber = "ItemNumber";
        public const string LineOrder = "LineOrder";
        public const string LineItem = "LineItem";
        public const string MvcPageAction = "MvcPageAction";
        public const string SortOrder = "SortOrder";
        public const string SaveRichEdit = "SaveRichEdit";
        public const string BatchError = "BatchError";
        public const string DefaultDate = "1/1/2017";
        public const string DummyDate = "01/01/1753";
        public const string UserDateTime = "UserDateTime";
        public const string ByteArrayRecordId = "ByteArrayRecordId";
        public const string RefTableName = "RefTableName";
        public const string SecMainModuleId = "SecMainModuleId";
        public const string ModuleId = "ModuleId";
        public const string RibbonBreakdownStructurePrefix = "01.";
        public const int DefaultThresholdPercentage = 10;
        public const string GridViewBannerSuffix = "_banner";
        public const string FindTextBox = "FindTextBox";
        public const string ReplaceTextBox = "ReplaceTextBox";
        public const string Preferences = "Preferences";
        public const string Themes = "Themes";
        public const string PreferedLocations = "Locations";
        public const string ViewDataFilterPageNo = "FilterPageNo";

        public const string JobTabNames = "Poc,Seller,MapRoute";
        public const string isPOD = "IsPOD";
        public const string ClearFilterManually = "ClearFilterManually";

        public const string EnableTimeSection = "EnableTimeSection";

        public const string AllowNegative = "AllowNegative";
        public const string IsEditable = "IsEditable";
        public const string SetCurrentDate = "SetCurrentDate";
        public const string DisplayFromRight = "DisplayFromRight";

        public const string EdiMapEdiTableName = "PemEdiTableName";
        public const string EdiMapM4PLTableName = "PemSysTableName";
        public const string EdiMapEdiFieldName = "PemEdiFieldName";
        public const string EdiMapM4PLFieldName = "PemSysFieldName";

        public const string EdiJobFieldName = "PecJobField";
        public const string EdiJob2FieldName = "PecJobField2";

        public const string PehSendReceive = "PehSndRcv";
        public const string IsSysAdmin = "IsSysAdmin";
        public const string IsReadOnly = "IsReadOnly";
        public const string ClientEnabled = "ClientEnabled";
        public const string SysLookupId = "SysLookupId";
        public const string ReadOnlyRelationalEntity = "ReadOnlyRelationalEntity";
        public const string StrDropdownViewModel = "strDropDownViewModel";
        public const string OldSysLookupId = "OldLookupId";
        public const string UserTheme = "UserTheme";


        #region Mask Formats And DevEx properties

        public const string MaskFormat = "MaskFormat";
        public const string MaskFixedPointDecimal = "f";
        public const string ImageWidth = "ImageWidth";
        public const string ImageHeight = "ImageHeight";
        public const string SetDefaultTime = "SetDefaultTime";
        public const string DefaultTime = "DefaultTime";

        #endregion


        #region RefSetting
        public const string SysSessionTimeOut = "SysSessionTimeOut";
        public const string SysWarningTime = "SysWarningTime";
        public const string SysMainModuleId = "SysMainModuleId";
        public const string SysDefaultAction = "SysDefaultAction";
        public const string SysStatusesIn = "SysStatusesIn";
        public const string SysGridViewPageSizes = "SysGridViewPageSizes";
        public const string SysPageSize = "SysPageSize";
        public const string SysComboBoxPageSize = "SysComboBoxPageSize";
        public const string SysThresholdPercentage = "SysThresholdPercentage";
        public const string SysDateFormat = "SysDateFormat";
        public const string Theme = "Theme";

        #endregion
    }
}