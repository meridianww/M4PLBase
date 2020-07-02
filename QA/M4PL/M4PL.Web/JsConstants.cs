#region Copyright

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
//Date Programmed:                              10/13/2017
//Program Name:                                 JsConstants
//Purpose:                                      Provides all the Js Constants to be used throughout the application
//====================================================================================================================================================*/

namespace M4PL.Web
{
	public class JsConstants
	{
		//->{0} -> Current FormId, {1} -> strRoute
		public const string FormSubmitClick = "function(s, form){{ M4PLWindow.FormView.OnAddOrEdit(s, {0}, \'{1}\', \'{2}\');}}";

		//->{0} -> Current FormId,{1} -> strRoute
		public const string FormCancelClick = "function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}";

		//{0} -> Current FormId
		//{1} -> Control Suffix
		//{2} -> current route
		//{3} -> flag for is new contact button
		public const string RecordPopupSubmitClick = "M4PLWindow.FormView.OnPopupAddOrEdit({0}, \'{1}\', {2},\'{3}\', {4})";

		public const string NavSyncRecordPopupCancelClick = "M4PLWindow.FormView.OnPopupCancel({0}, \'{1}\', {2},\'{3}\', {4})";

		//->{0} -> Current Route, {1} -> Contact Card EntityFor
		public const string RecordPopupNewClick = "M4PLCommon.ContactCombobox.OnNewClick({0})";

		public const string RecordPopupCancelClick = "DevExCtrl.PopupControl.Close()";

		//->{0} -> Current Form, {1} -> strRoute, {2} -> arbValue
		public const string ChooseColumnSubmitClick = "M4PLWindow.ChooseColumns.InsAndUpdChooseColumn(s, e, {0}, \'{1}\', {2}, \'{3}\')";

		//->{0} -> Current GridName,{1} -> CallBack that application has to perform after successful confirm click.
		public const string DeleteConfirmClick = "function(s, e){{ DevExCtrl.Button.OnGridDeleteYes(s, e, {0});}}";

		public const string ReloadApplicationClick = "function(s, e){{ M4PLCommon.Common.ReloadApplication();}}";

		//new organization Id and Organization formview route as lastroute
		public const string NewOrganizationCreated = "function(orgId, lastRoute){{ M4PLCommon.Common.SwitchOrganization({0}, \'{1}\');}}";

		public const string CloseDisplayMessage = "function(s, e){ DisplayMessageControl.Hide(); }";

		//->{0} -> Current FormId,{1} -> Current CallBackActionControllerArea that application has to perform after successful submit.
		public const string ContactValueChanged = "function(s, e){{ M4PLCommon.ContactCombobox.OnValueChanged({0},  {1}, \'{2}\');}}";

		public const string UpdateSessionTimeClick = "M4PLCommon.SessionTimeout.UpdateSessionTime()";
		public const string KeepAliveSessionClick = "M4PLCommon.SessionTimeout.SendKeepAlive()";
		public const string JobFormSubmitClick = "function(s, form){{ M4PLJob.FormView.OnAddOrEdit(s, {0}, \'{1}\', GlobalLoadingPanel); }}";
		public const string JobDestinationFormSubmitClick = "function(s, form){{ M4PLJob.FormView.OnAddOrEditDestination(s, {0}, \'{1}\', GlobalLoadingPanel);}}";
		public const string Job2ndPocFormSubmitClick = "function(s, form){{ M4PLJob.FormView.OnAddOrEdit2ndPoc(s, {0}, \'{1}\', GlobalLoadingPanel);}}";
		public const string JobSellerFormSubmitClick = "function(s, form){{ M4PLJob.FormView.OnAddOrEditSeller(s, {0}, \'{1}\', GlobalLoadingPanel);}}";
		public const string JobMapRouteFormSubmitClick = "function(s, form){{ M4PLJob.FormView.OnAddOrEditMapRoute(s, {0}, \'{1}\', GlobalLoadingPanel);}}";
		public const string MapVendorCloseEvent = "DevExCtrl.PopupControl.MapVendorClose(\'{0}\')";
		public const string DeleteMoreInfoEvent = "function(){{DisplayMessageControl.Hide(); DevExCtrl.PopupControl.GetDeleteInfoModules(\'{0}\');}}";
		public const string JobGatewayCompleteRecordPopupSubmitClick = "M4PLWindow.FormView.OnPopupUpdateJobGatewayComplete({0}, \'{1}\', {2},\'{3}\')";

		public const string ProgramCopyCloseEvent = "DevExCtrl.PopupControl.ProgramCopyClose(\'{0}\')";
		public const string IgnoreChangesClick = "M4PLCommon.CheckHasChanges.OnIgnoreChanges()";
		public const string CloseConfirmationMessage = "function(s, e){ DisplayMessageControl.Hide(); M4PLCommon.IsFromSubTabCancelClick=false; }";

		public const string CopyPasteProgram = "DevExCtrl.Button.CopyPaste(s, e,  {0}, {1},{2})";

		public const string SaveChangesOnConfirmClick = "M4PLCommon.CheckHasChanges.OnSaveChangesAndProceed()";
		public const string SaveChangesOnIsAdminChange = "M4PLCommon.CheckHasChanges.OnIsAdminChanges(\'{0}\',\'{1}\')";
		public const string SaveChangesOnIsAdminChangeDataView = "M4PLCommon.CheckHasChanges.OnIsAdminChangesDataView(\'{0}\',{1},\'{2}\')";

		public const string GridView_DoNotValidateClientSide = "function(s, e){ e.isValid = true; }";

		public const string NavSyncERPIDRadioButtonOnChange = "M4PLCommon.NavSync.NAVRadioSelected({0})";
		public const string NavSyncNavBarIndexFocus = "M4PLCommon.NavSync.NavBarIndexSelect( \'{0}\', \'{1}\')";
	}
}