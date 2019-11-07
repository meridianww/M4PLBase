/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              25/07/2019
//Program Name:                                 JobCostSheet
//Purpose:                                      Contains Actions to render view on Job's  Cost Sheet page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Text.RegularExpressions;
using M4PL.Utilities;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCostSheetController : BaseController<JobCostSheetView>
    {
		private readonly IJobCostSheetCommands _jobCostSheetCommands;

		public JobCostSheetController(IJobCostSheetCommands JobCostSheetCommands, ICommonCommands commonCommands)
            : base(JobCostSheetCommands)
        {
            _commonCommands = commonCommands;
			_jobCostSheetCommands = JobCostSheetCommands;
		}

		[ValidateInput(false)]
		public override ActionResult AddOrEdit(JobCostSheetView jobCostSheetView)
		{
			jobCostSheetView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobCostSheetView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = jobCostSheetView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobCostSheet, ByteArrayFields.CstComments.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(jobCostSheetView, EntitiesAlias.JobCostSheet);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = jobCostSheetView.Id > 0 ? base.UpdateForm(jobCostSheetView) : base.SaveForm(jobCostSheetView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				route.PreviousRecordId = jobCostSheetView.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = new DisplayMessage();
				displayMessage = jobCostSheetView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				if (byteArray != null)
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = jobCostSheetView.Id == 0, record = result }, JsonRequestBehavior.AllowGet);
				return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = (jobCostSheetView.Id == 0), record = result }, JsonRequestBehavior.AllowGet);
			}

			return ErrorMessageForInsertOrUpdate(jobCostSheetView.Id, route);
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
			_formResult.SessionProvider = SessionProvider;
			_formResult.Record = route.IsCostCodeAction && route.Filters != null && !string.IsNullOrEmpty(route.Filters.Value) ? _jobCostSheetCommands.GetJobCostCodeByProgram(Convert.ToInt64(route.Filters.Value), route.ParentRecordId) : _jobCostSheetCommands.Get(route.RecordId);
			_formResult.SetupFormResult(_commonCommands, route);
			if (_formResult.Record is SysRefModel)
			{
				(_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
					? new Random().Next(-1000, 0) :
					(_formResult.Record as SysRefModel).Id;
			}

			return PartialView(_formResult);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "")
		{

			RowHashes = new Dictionary<string, Dictionary<string, object>>();
			TempData["RowHashes"] = RowHashes;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_gridResult.FocusedRowId = route.RecordId;
			route.RecordId = 0;
			if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
				route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
			if (route.ParentEntity == EntitiesAlias.Common)
				route.ParentRecordId = 0;
			SetGridResult(route, gridName);
			AddActionsInActionContextMenu(route);
			if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
				return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}


		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobCostSheetView, long> jobCostSheetView, string strRoute, string gridName)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			jobCostSheetView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			jobCostSheetView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = base.BatchUpdate(jobCostSheetView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}

			SetGridResult(route);
			AddActionsInActionContextMenu(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CstComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.CstComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		private void AddActionsInActionContextMenu(MvcRoute currentRoute)
		{
			var route = currentRoute;
			var allActions = _jobCostSheetCommands.GetJobCostCodeAction(route.ParentRecordId);
			var actionMenu = _gridResult.GridSetting.ContextMenu.Where(x => x.SysRefName == "Actions").FirstOrDefault();
			if ((allActions == null || !allActions.Any()) && actionMenu != null)
			{
				_gridResult.GridSetting.ContextMenu.Remove(actionMenu);
			}

			var actionsContextMenu = _commonCommands.GetOperation(OperationTypeEnum.Actions);

			var actionContextMenuAvailable = false;
			var actionContextMenuIndex = -1;

			if (_gridResult.GridSetting.ContextMenu.Count > 0)
			{
				for (var i = 0; i < _gridResult.GridSetting.ContextMenu.Count; i++)
				{
					if (_gridResult.GridSetting.ContextMenu[i].SysRefName.EqualsOrdIgnoreCase(actionsContextMenu.SysRefName))
					{
						actionContextMenuAvailable = true;
						actionContextMenuIndex = i;
						break;
					}
				}
			}

			if (actionContextMenuAvailable)
			{
				_gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations = new List<Operation>();

				var routeToAssign = new MvcRoute(currentRoute);
				routeToAssign.Entity = EntitiesAlias.JobCostSheet;
				routeToAssign.Action = MvcConstants.ActionForm;
				routeToAssign.IsPopup = true;
				routeToAssign.RecordId = 0;

				if (allActions.Count > 0)
				{
					var groupedActions = allActions.GroupBy(x => x.CostActionCode);

					foreach (var singleApptCode in groupedActions)
					{
						var newOperation = new Operation();
						newOperation.LangName = singleApptCode.Key;
						foreach (var singleReasonCode in singleApptCode)
						{
							routeToAssign.Filters = new Entities.Support.Filter();
							routeToAssign.Filters.FieldName = singleReasonCode.CostCode;
							routeToAssign.IsCostCodeAction = true;
							var newChildOperation = new Operation();
							var newRoute = new MvcRoute(routeToAssign);

							newChildOperation.LangName = singleReasonCode.CostTitle;
							newRoute.Filters = new Entities.Support.Filter();
							newRoute.Filters.FieldName = singleReasonCode.CostCode;
							newRoute.Filters.Value = singleReasonCode.CostCodeId.ToString(); ////String.Format("{0}-{1}", newChildOperation.LangName, singleReasonCode.PcrCode);
							newChildOperation.Route = newRoute;
							newOperation.ChildOperations.Add(newChildOperation);

						}

						_gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations.Add(newOperation);
					}
				}
			}
		}
	}
}