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
//Date Programmed:                              10/10/2017
//Program Name:                                 OrgRolesRespController
//Purpose:                                      Contains Actions to render view on Organization's Act role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
	public class OrgRolesRespController : BaseController<OrgRolesRespView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the Organization's act role details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="orgRolesRespCommands"></param>
		/// <param name="commonCommands"></param>
		public OrgRolesRespController(IOrgRolesRespCommands orgRolesRespCommands, ICommonCommands commonCommands)
			: base(orgRolesRespCommands)
		{
			_commonCommands = commonCommands;
		}

		public override ActionResult AddOrEdit(OrgRolesRespView orgRefRoleView)
		{
			orgRefRoleView.IsFormView = true;
			var isPopup = (orgRefRoleView.ParentId > 0);
			orgRefRoleView.OrgID = (orgRefRoleView.ParentId == 0) ? SessionProvider.ActiveUser.OrganizationId : orgRefRoleView.ParentId;
			SessionProvider.ActiveUser.SetRecordDefaults(orgRefRoleView, Request.Params[WebApplicationConstants.UserDateTime]);

			orgRefRoleView.RoleCode = Request.Form["OrgRefRoleId"];
			//if ((!orgRefRoleView.OrgRoleContactID.HasValue || orgRefRoleView.OrgRoleContactID.GetValueOrDefault() < 1) && !string.IsNullOrWhiteSpace(Request.Form["hfOrgRoleContactID"]))
			//    orgRefRoleView.OrgRoleContactID = Request.Form["hfOrgRoleContactID"].ToLong();
			if (orgRefRoleView.RoleCode.EqualsOrdIgnoreCase(WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.OrgRefRole), SessionProvider).FirstOrDefault("OrgRoleId").ColAliasName)))
				orgRefRoleView.RoleCode = null;
			//if (!string.IsNullOrWhiteSpace(orgRefRoleView.RoleCode) && !orgRefRoleView.Id.HasValue)
			//    orgRefRoleView.Id = null;
			var messages = ValidateMessages(orgRefRoleView);
			var descriptionByteArray = orgRefRoleView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgRefRole, ByteArrayFields.OrgRoleDescription.ToString());
			var commentByteArray = orgRefRoleView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgRefRole, ByteArrayFields.OrgComments.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray, commentByteArray
			};
			if (orgRefRoleView.Id > 0 && _commonCommands.GetUserSecurities(new ActiveUser { UserId = SessionProvider.ActiveUser.UserId, OrganizationId = orgRefRoleView.OrgID.GetValueOrDefault(), RoleId = orgRefRoleView.Id }).Count == 0)
				//&& orgRefRoleView.OrgRoleContactID.GetValueOrDefault() > 0
				messages.Add(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.NoSecuredModule).Description);
			if (messages.Any())
				return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var record = orgRefRoleView.Id > 0 ? base.UpdateForm(orgRefRoleView) : base.SaveForm(orgRefRoleView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView).SetParent(EntitiesAlias.Organization, orgRefRoleView.OrgID.GetValueOrDefault(), isPopup);
			route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;

			if (record is SysRefModel)
			{
				route.RecordId = record.Id;
				route.PreviousRecordId = orgRefRoleView.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
				commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				if (!string.IsNullOrWhiteSpace(Request.Form["PreviousStatusId"]) && (record.StatusId != Convert.ToInt32(Request.Form["PreviousStatusId"])))
				{
					var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess);
					displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, reloadApplication = false }, JsonRequestBehavior.AllowGet);
				}
				else
					return SuccessMessageForInsertOrUpdate(orgRefRoleView.Id, route, byteArray);
			}
			return ErrorMessageForInsertOrUpdate(orgRefRoleView.Id, route);
		}

		#region Data View

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgRolesRespView, long> orgRefRoleView, string strRoute, string gridName)
		{
			var statusIdChanged = false;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var parentIdToTake = (route.ParentRecordId > 0) ? route.ParentRecordId : SessionProvider.ActiveUser.OrganizationId;
			if (parentIdToTake != SessionProvider.ActiveUser.OrganizationId)
				route.ParentRecordId = parentIdToTake;
			else
				route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;

			orgRefRoleView.Insert.ForEach(c => { c.OrgID = parentIdToTake; c.OrganizationId = parentIdToTake; });
			foreach (var actRole in orgRefRoleView.Update)
			{
				actRole.OrgID = parentIdToTake;
				actRole.OrganizationId = parentIdToTake;
				//if (actRole.PreviousStatusId != actRole.StatusId)
				//    statusIdChanged = true;
			}

			var batchError = BatchUpdate(orgRefRoleView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? statusIdChanged ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}

			route.ParentEntity = EntitiesAlias.Common;
			route.ParentRecordId = 0;
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.GridView);
		}

		#region Filtering & Sorting

		public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
			sessionInfo.PagedDataInfo.RecordId = route.RecordId;
			sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
			sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
			sessionInfo.GridViewColumnState = column;
			sessionInfo.GridViewColumnStateReset = reset;
			SetGridResult(route, gridName);
			return ProcessCustomBinding(route, MvcConstants.GridView);
		}

		#endregion Filtering & Sorting

		#endregion Data View

		#region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OrgRoleDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.OrgRoleDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OrgComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.OrgComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}