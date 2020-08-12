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
//Program Name:                                 JobDocReference
//Purpose:                                      Contains Actions to render view on Job's Document Reference page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
	public class JobDocReferenceController : BaseController<JobDocReferenceView>
	{
		private readonly IJobDocReferenceCommands _jobDocReferenceCommands;

		/// <summary>
		/// Interacts with the interfaces to get the Job's document reference details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="JobDocReferenceCommands"></param>
		/// <param name="commonCommands"></param>
		public JobDocReferenceController(IJobDocReferenceCommands JobDocReferenceCommands, ICommonCommands commonCommands)
			: base(JobDocReferenceCommands)
		{
			_jobDocReferenceCommands = JobDocReferenceCommands;
			_commonCommands = commonCommands;
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
			_formResult.SessionProvider = SessionProvider;
			_formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : GetNextSequence();
			_formResult.SetupFormResult(_commonCommands, route);

			if (route.EntityName == EntitiesAlias.POD.ToString())
			{
				ViewData[WebApplicationConstants.isPOD] = true;
				if (_formResult.ComboBoxProvider.ContainsKey(Convert.ToInt32(LookupEnums.JobDocReferenceType)))
					_formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.JobDocReferenceType)] = _formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.JobDocReferenceType)].UpdateComboBoxToEditor(Convert.ToInt32(LookupEnums.JobDocReferenceType), EntitiesAlias.JobDocReference);
			}
			return PartialView(_formResult);
		}

		private JobDocReferenceView GetNextSequence()
		{
			long Id = _jobDocReferenceCommands.GetNextSequence();
			return new JobDocReferenceView() { Id = Id, IsNew = true };
		}

		public override ActionResult AddOrEdit(JobDocReferenceView jobDocReferenceView)
		{
			jobDocReferenceView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobDocReferenceView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = jobDocReferenceView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobCargoDetail, ByteArrayFields.CgoNotes.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(jobDocReferenceView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = !jobDocReferenceView.IsNew ? _jobDocReferenceCommands.PutWithSettings(jobDocReferenceView) : _jobDocReferenceCommands.PostWithSettings(jobDocReferenceView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				return SuccessMessageForInsertOrUpdate(jobDocReferenceView.Id, route, byteArray);
			}
			return ErrorMessageForInsertOrUpdate(jobDocReferenceView.Id, route);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobDocReferenceView, long> jobDocReferenceView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			jobDocReferenceView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			jobDocReferenceView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = base.BatchUpdate(jobDocReferenceView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}

			SetGridResult(route);
			_gridResult.GridSetting.GridName = gridName;
			return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
		}

		#region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JdrDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.JdrDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit

		public ActionResult TabView(string strRoute)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var pageControlResult = new PageControlResult
			{
				PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobDocReference),
				CallBackRoute = new MvcRoute(route, MvcConstants.ActionTabView),
				ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobCargo.ToString()),
				EnableTabClick = true
			};
			foreach (var pageInfo in pageControlResult.PageInfos)
			{
				pageInfo.SetRoute(route, _commonCommands);
				pageInfo.Route.ParentRecordId = route.ParentRecordId;
			}

			if (Session["tabName"] != null)
			{
				var jobDocReferenceType = (JobDocReferenceType)Enum.Parse(typeof(JobDocReferenceType), (string)Session["tabName"], true);
				switch (jobDocReferenceType)
				{
					case JobDocReferenceType.Document:
					default:
						pageControlResult.SelectedTabIndex = 0;
						break;

					case JobDocReferenceType.POD:
						pageControlResult.SelectedTabIndex = 1;
						break;

					case JobDocReferenceType.Damaged:
						pageControlResult.SelectedTabIndex = 2;
						break;
				}

				Session["tabName"] = null;
			}
			return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
				sessionInfo.PagedDataInfo.RecordId = route.RecordId;
				sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
				var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
				viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
				SessionProvider.ViewPagedDataSession = viewPagedDataSession;
			}
			else
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

			base.DataView(strRoute);
			if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
			{
				_gridResult.Operations.Remove(OperationTypeEnum.New);
				_gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
			}

			return PartialView(MvcConstants.ActionDataView, _gridResult);
		}

		public PartialViewResult DeliveryPodDataView(string strRoute, long selectedId = 0)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
				sessionInfo.PagedDataInfo.RecordId = route.RecordId;
				sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
				var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
				viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
				SessionProvider.ViewPagedDataSession = viewPagedDataSession;
			}
			else
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

			SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.DocTypeId={1}", route.Entity, (int)JobDocReferenceType.POD);

			var currentGridName = string.Format("DeliveryPod_{0}", WebUtilities.GetGridName(route));
			base.DataView(strRoute, currentGridName);
			if (selectedId > 0)
				_gridResult.FocusedRowId = selectedId;
			if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
			{
				_gridResult.Operations.Remove(OperationTypeEnum.New);
				_gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
			}
			_gridResult.GridSetting.GridName = currentGridName;
			if (route.EntityName == EntitiesAlias.POD.ToString())
			{
				_gridResult.ColumnSettings.Where(x => x.ColColumnName == JobPODColumns.DocTypeId.ToString()).ToList().ForEach(x => x.ColIsReadOnly = true);
			}
			return PartialView(MvcConstants.ActionDataView, _gridResult);
		}

		public PartialViewResult DocDeliveryPodDataView(string strRoute, long selectedId = 0)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
				sessionInfo.PagedDataInfo.RecordId = route.RecordId;
				sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
				var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
				viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
				SessionProvider.ViewPagedDataSession = viewPagedDataSession;
			}
			else
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

			SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.DocTypeId={1}", route.Entity, (int)JobDocReferenceType.POD);

			var currentGridName = WebUtilities.GetGridName(route);
			base.DataView(strRoute, WebUtilities.GetGridName(route));
			if (selectedId > 0)
				_gridResult.FocusedRowId = selectedId;
			_gridResult.GridSetting.GridName = currentGridName;
			return PartialView(MvcConstants.ActionDataView, _gridResult);
		}

		public PartialViewResult DocumentDataView(string strRoute, long selectedId = 0)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
				sessionInfo.PagedDataInfo.RecordId = route.RecordId;
				sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
				var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
				viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
				SessionProvider.ViewPagedDataSession = viewPagedDataSession;
			}
			else
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

			SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = null;// string.Format(" AND {0}.DocTypeId={1}", route.Entity, (int)JobDocReferenceType.Document);
			var currentGridName = WebUtilities.GetGridName(route);
			base.DataView(strRoute, currentGridName);
			if (selectedId > 0)
				_gridResult.FocusedRowId = selectedId;
			_gridResult.GridSetting.GridName = currentGridName;
			return PartialView(MvcConstants.ActionDataView, _gridResult);
		}

		public PartialViewResult DocDamagedDataView(string strRoute, long selectedId = 0)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
				sessionInfo.PagedDataInfo.RecordId = route.RecordId;
				sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
				var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
				viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
				SessionProvider.ViewPagedDataSession = viewPagedDataSession;
			}
			else
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();
			SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.DocTypeId={1}", route.Entity, (int)JobDocReferenceType.Damaged);
			var currentGridName = WebUtilities.GetGridName(route);
			base.DataView(strRoute, currentGridName);
			if (selectedId > 0)
				_gridResult.FocusedRowId = selectedId;
			if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
			{
				_gridResult.Operations.Remove(OperationTypeEnum.New);
				_gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
			}
			_gridResult.GridSetting.GridName = currentGridName;
			return PartialView(MvcConstants.ActionDataView, _gridResult);
		}
	}
}