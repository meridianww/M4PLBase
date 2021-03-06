﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              17/12/2017
//Program Name:                                 SystemAccount
//Purpose:                                      Contains Actions to render view on Administration's SystemAccount(OpnSezMe) page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
	public class SystemAccountController : BaseController<SystemAccountView>
	{
		private readonly ISystemAccountCommands _systemAccountCommands;

		/// <summary>
		/// Interacts with the interfaces to get the System Account(OpnSezMe) user's details of individual page and renders to the respective page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="systemAccountCommands"></param>
		/// <param name="commonCommands"></param>
		public SystemAccountController(ISystemAccountCommands systemAccountCommands, ICommonCommands commonCommands)
			: base(systemAccountCommands)
		{
			_commonCommands = commonCommands;
			_systemAccountCommands = systemAccountCommands;
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SystemAccountView, long> systemAccountView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			systemAccountView.Insert.ForEach(c =>
			{
				c.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
			});
			systemAccountView.Update.ForEach(c =>
			{
				c.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
			});
			for (int i = 0; i < systemAccountView.Update.Count(); i++)
			{
				systemAccountView.Update[i].SysPassword = _systemAccountCommands.Get(systemAccountView.Update[i].Id).SysPassword;
			}
			var batchError = BatchUpdate(systemAccountView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}

			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		public PartialViewResult DataViewBatchUpdateOnSysAdminChange(string input, string strRoute, string gridName)
		{
			var systemAccountView = JsonConvert.DeserializeObject<MVCxGridViewBatchUpdateValues<SystemAccountView, long>>(input); ;
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			systemAccountView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			systemAccountView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });

			var batchError = BatchUpdate(systemAccountView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		#region RichEdit

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.SysComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.SysComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit

		public override ActionResult AddOrEdit(SystemAccountView systemAccountView)
		{
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

			var commentsByteArray = systemAccountView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.SystemAccount, ByteArrayFields.SysComments.ToString());
			var byteArray = new List<ByteArray> {
				commentsByteArray
			};
			systemAccountView.IsFormView = true;

			SessionProvider.ActiveUser.SetRecordDefaults(systemAccountView, Request.Params[WebApplicationConstants.UserDateTime]);
			systemAccountView.SysOrgId = SessionProvider.ActiveUser.OrganizationId;

			var messages = ValidateMessages(systemAccountView);

			if (systemAccountView.SysOrgRefRoleId.HasValue && _commonCommands.GetRefRoleSecurities(new ActiveUser { UserId = SessionProvider.ActiveUser.UserId, RoleId = systemAccountView.SysOrgRefRoleId.GetValueOrDefault() }).Count == 0)
				messages.Add(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.NoSecuredModule).Description);

			if (messages.Any())
				return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var record = systemAccountView.Id > 0 ? UpdateForm(systemAccountView) : SaveForm(systemAccountView);

			if (record is SysRefModel)
			{
				route.RecordId = record.Id;
				route.PreviousRecordId = systemAccountView.Id;
				commentsByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = record.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);

				return SuccessMessageForInsertOrUpdate(systemAccountView.Id, route, byteArray);
			}

			return ErrorMessageForInsertOrUpdate(systemAccountView.Id, route);
		}

		public JsonResult MessageOnSysAdminChange(long recordId, MvcRoute route, SystemAccountView systemAccountView, List<ByteArray> byteArray)
		{
			var strRoute = JsonConvert.SerializeObject(new MvcRoute(BaseRoute, MvcConstants.ActionDataView));
			systemAccountView.UpdateRoles = true;
			string inputYes = JsonConvert.SerializeObject(systemAccountView);
			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.SysAccountUpdate);
			var yesOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Yes.ToString()));
			yesOperation.ClickEvent = "function(s, e) {{ " + string.Format(JsConstants.SaveChangesOnIsAdminChange, inputYes, strRoute) + " }}";
			systemAccountView.UpdateRoles = false;
			string inputNo = JsonConvert.SerializeObject(systemAccountView);
			var noOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.No.ToString()));
			noOperation.ClickEvent = "function(s, e) {{ " + string.Format(JsConstants.SaveChangesOnIsAdminChange, inputNo, strRoute) + " }}";
			return Json(new { status = false, displayMessage = displayMessage, route = route, byteArray = byteArray }, JsonRequestBehavior.AllowGet);
		}

		public override ActionResult FormView(string strRoute)
		{
			base.FormView(strRoute);
			_formResult.ColumnSettings.ToList().ForEach(c =>
			{
				if (c.ColColumnName.Equals(WebApplicationConstants.IsSysAdmin, System.StringComparison.OrdinalIgnoreCase))
					c.ColIsReadOnly = !SessionProvider.ActiveUser.IsSysAdmin;
			});
			TempData["IsSysAdminPrev"] = _formResult.Record.IsSysAdmin;
			return PartialView(_formResult);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			base.DataView(strRoute);
			_gridResult.ColumnSettings.ToList().ForEach(c =>
			{
				if (c.ColColumnName.Equals(WebApplicationConstants.IsSysAdmin, System.StringComparison.OrdinalIgnoreCase))
				{
					c.ColIsReadOnly = !SessionProvider.ActiveUser.IsSysAdmin;
					c.ColIsVisible = SessionProvider.ActiveUser.IsSysAdmin;
				}
			});
			return PartialView(_gridResult);
		}
	}
}