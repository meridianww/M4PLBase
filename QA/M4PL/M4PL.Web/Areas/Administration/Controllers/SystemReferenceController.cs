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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 SystemReference
//Purpose:                                      Contains Actions to render view on Administration's System Ref option page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
	public class SystemReferenceController : BaseController<SystemReferenceView>
	{
		protected PageControlResult _pageControlResult = new PageControlResult();

		public readonly ISystemReferenceCommands _systemReferenceCommands;
		public Dictionary<int, string> sysrefIDdictionary { get; set; }

		/// <summary>
		/// Interacts with the interfaces to get the lookup details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="systemReferenceCommands"></param>
		/// <param name="commonCommands"></param>
		public SystemReferenceController(ISystemReferenceCommands systemReferenceCommands, ICommonCommands commonCommands)
			: base(systemReferenceCommands)
		{
			_commonCommands = commonCommands;
			_systemReferenceCommands = systemReferenceCommands;
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SystemReferenceView, long> systemReferenceView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			if (systemReferenceView.Update.Count() > 0)
			{
				Dictionary<int, string> data = null;
				data = (Dictionary<int, string>)TempData["sysLookupIDandCode"];
				if (data != null)
				{
					for (int i = 0; i < systemReferenceView.Update.Count(); i++)
					{
						if (systemReferenceView.Update[i].SysLookupId == 0)
						{
							systemReferenceView.Update[i].SysLookupId = data.FirstOrDefault(t => t.Value.Trim().ToLower() == systemReferenceView.Update[i].SysLookupCode.Trim().ToLower()).Key;
						}
					}
				}
			}
			var batchError = BatchUpdate(systemReferenceView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))
			{
				//Added for refresh the lookup cache

				var lookupIds = systemReferenceView.Insert.Select(c => c.SysLookupId).ToList();
				lookupIds.AddRange(systemReferenceView.Update.Select(c => c.SysLookupId).ToList());
				if (systemReferenceView.DeleteKeys.Count > 0)
					lookupIds.AddRange(_systemReferenceCommands.GetDeletedRecordLookUpIds(string.Join(",", systemReferenceView.DeleteKeys)).Select(x => x.SysRefId));
				foreach (var lookupId in lookupIds.Distinct())
				{
					_commonCommands.GetIdRefLangNames(lookupId, true);
				}

				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			if (_gridResult.ColumnSettings != null && _gridResult.ColumnSettings.Count > 0)
			{
				_gridResult.ColumnSettings.ToList().ForEach(c =>
				{
					if (c.ColColumnName.Equals(WebApplicationConstants.SysLookupId, System.StringComparison.OrdinalIgnoreCase))
					{
						c.ColIsVisible = false;
					}
				});
			}
			return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			base.DataView(strRoute);
			if (_gridResult.Records.Count() > 0)
				sysrefIDdictionary = new Dictionary<int, string>();
			var data = _gridResult.Records.Select(x => new { x.SysLookupId, x.SysLookupCode }).Distinct().ToList();
			for (int i = 0; i < data.Count(); i++)
			{
				if (!sysrefIDdictionary.ContainsKey(data[i].SysLookupId))
				{
					sysrefIDdictionary.Add(data[i].SysLookupId, data[i].SysLookupCode);
				}
			}

			TempData["sysLookupIDandCode"] = sysrefIDdictionary;

			_gridResult.ColumnSettings.ToList().ForEach(c =>
			{
				if (c.ColColumnName.Equals(WebApplicationConstants.SysLookupId, System.StringComparison.OrdinalIgnoreCase))
				{
					c.ColIsVisible = false;
				}
			});
			return PartialView(_gridResult);
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			CommonIds maxMinFormData = null;
			maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(route.Entity.ToString(), route.ParentRecordId, route.RecordId);
			if (maxMinFormData != null)
			{
				_formResult.MaxID = maxMinFormData.MaxID;
				_formResult.MinID = maxMinFormData.MinID;
			}
			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
				if (maxMinFormData != null)
				{
					SessionProvider.ViewPagedDataSession[route.Entity].MaxID = maxMinFormData.MaxID;
					SessionProvider.ViewPagedDataSession[route.Entity].MinID = maxMinFormData.MinID;
				}
			}
			_formResult.SessionProvider = SessionProvider;
			if (SessionProvider.ViewPagedDataSession.Count() > 0
			&& SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
			&& SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
			{
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
			}
			_formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new SystemReferenceView();
			TempData[WebApplicationConstants.OldSysLookupId] = _formResult.Record.SysLookupId;
			SetupFormResult(_formResult, _commonCommands, route);
			if (route.IsPopup)
				return View(_formResult);
			return PartialView(_formResult);
		}

		public override ActionResult AddOrEdit(SystemReferenceView systemReferenceView)
		{
			systemReferenceView.IsFormView = true;
			systemReferenceView.SysLookupCode = Request.Form[SysRefOptionColumns.SysLookupId.ToString()]; // If Adding new lookup you will get that name;
			string dateTime = Request.Params[WebApplicationConstants.UserDateTime];
			systemReferenceView.LangCode = SessionProvider.ActiveUser.LangCode;

			//Assigning DateChanged and DateEntered here because SystemReference entity is not derived from SysRefModel/BaseModel.
			if (!string.IsNullOrEmpty(dateTime) && dateTime.ToLong() > 0)
			{
				if (systemReferenceView.Id > 0)
					systemReferenceView.DateChanged = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(Math.Round(dateTime.ToLong() / 1000d));
				else
					systemReferenceView.DateEntered = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(Math.Round(dateTime.ToLong() / 1000d));
			}
			if (systemReferenceView.Id > 0)
				systemReferenceView.ChangedBy = SessionProvider.ActiveUser.UserName;
			else
				systemReferenceView.EnteredBy = SessionProvider.ActiveUser.UserName;
			var messages = ValidateMessages(systemReferenceView, BaseRoute.Entity);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
			var result = systemReferenceView.Id > 0 ? UpdateForm(systemReferenceView) : SaveForm(systemReferenceView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result.Id > 0)
			{
				_commonCommands.GetIdRefLangNames(systemReferenceView.SysLookupId, true);// Refresh Cache for selected Lookup
				if (TempData.Keys.Count > 0)
				{
					var oldSysLookupId = Convert.ToInt32(TempData[WebApplicationConstants.OldSysLookupId]);
					if (oldSysLookupId != systemReferenceView.SysLookupId)
						_commonCommands.GetIdRefLangNames(oldSysLookupId, true);// Refresh Cache for previously selected Lookup
				}

				return SuccessMessageForInsertOrUpdate(systemReferenceView.Id, route);
			}

			return ErrorMessageForInsertOrUpdate(systemReferenceView.Id, route);
		}

		private void SetupFormResult<TView>(FormResult<TView> formResult, ICommonCommands commonCommands, MvcRoute route)
		{
			var resultViewSession = formResult.SessionProvider.ResultViewSession;
			var entityRecord = resultViewSession.GetOrAdd(route.Entity, new ConcurrentDictionary<long, ViewResultInfo>());
			formResult.SessionProvider.ResultViewSession = resultViewSession;
			var arbRecordId = !entityRecord.ContainsKey(route.RecordId) && route.RecordId < 1 ? (0 - entityRecord.Keys.Count) : route.RecordId;
			var sessionRecord = entityRecord.GetOrAdd(route.RecordId, new ViewResultInfo
			{
				Id = arbRecordId,
				Route = route,
			});
			route = sessionRecord.Route;

			if (route.RecordId > 0 && (formResult.Record is SystemReferenceView))
			{
				(formResult.Record as SystemReferenceView).ChangedBy = formResult.SessionProvider.ActiveUser.UserName;
				(formResult.Record as SystemReferenceView).DateChanged = DateTime.Now;
			}
			else
			{
				if (formResult.Record is SystemReferenceView)
				{
					(formResult.Record as SystemReferenceView).EnteredBy = formResult.SessionProvider.ActiveUser.UserName;
					(formResult.Record as SystemReferenceView).DateEntered = DateTime.Now;
				}
			}

			formResult.ColumnSettings = WebUtilities.GetUserColumnSettings(commonCommands.GetColumnSettings(route.Entity), formResult.SessionProvider);

			formResult.IsPopUp = route.IsPopup;

			formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);

			formResult.AllowedImageExtensions = commonCommands.GetIdRefLangNames(17, true).Select(s => s.LangName).ToArray();
			var imageExtensionDisplayMessage = commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.AllowedImageExtension);
			formResult.ImageExtensionWarningMsg = (imageExtensionDisplayMessage != null && imageExtensionDisplayMessage.Description != null) ? imageExtensionDisplayMessage.Description.Replace("''", string.Concat("'", string.Join(",", formResult.AllowedImageExtensions), "'")) : string.Empty;

			formResult.Operations = commonCommands.FormOperations(route);
			formResult.Operations[OperationTypeEnum.New].Route.Action = MvcConstants.ActionAddOrEdit;
			formResult.Operations[OperationTypeEnum.Edit].Route.Action = MvcConstants.ActionAddOrEdit;
			formResult.Operations[OperationTypeEnum.Save].Route.Action = MvcConstants.ActionAddOrEdit;
			formResult.Operations[OperationTypeEnum.Update].Route.Action = MvcConstants.ActionAddOrEdit;
			formResult.Operations[OperationTypeEnum.Cancel].Route.Action = MvcConstants.ActionDataView;

			foreach (var colSetting in formResult.ColumnSettings)
				if (colSetting.ColLookupId > 0)
				{
					formResult.ComboBoxProvider = formResult.ComboBoxProvider ?? new Dictionary<int, IList<IdRefLangName>>();
					if (formResult.ComboBoxProvider.ContainsKey(colSetting.ColLookupId))
						formResult.ComboBoxProvider[colSetting.ColLookupId] = commonCommands.GetIdRefLangNames(colSetting.ColLookupId, true);
					else
						formResult.ComboBoxProvider.Add(colSetting.ColLookupId, commonCommands.GetIdRefLangNames(colSetting.ColLookupId, true));
				}
		}
	}
}