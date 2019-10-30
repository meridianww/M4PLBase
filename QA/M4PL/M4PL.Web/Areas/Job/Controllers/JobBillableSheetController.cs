﻿/*All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              26/07/2019
Program Name:                                 JobBillableSheetController
Purpose:                                      Contains Actions to render view on Job's  Billable Sheet page
=================================================================================================================*/
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

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobBillableSheetController : BaseController<JobBillableSheetView>
    {

        public JobBillableSheetController(IJobBillableSheetCommands JobBillableSheetCommands, ICommonCommands commonCommands)
            : base(JobBillableSheetCommands)
        {
            _commonCommands = commonCommands;
        }

		[ValidateInput(false)]
		public override ActionResult AddOrEdit(JobBillableSheetView jobBillableSheetView)
		{
			jobBillableSheetView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobBillableSheetView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = jobBillableSheetView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobBillableSheet, ByteArrayFields.PrcComments.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(jobBillableSheetView, EntitiesAlias.JobBillableSheet);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = jobBillableSheetView.Id > 0 ? base.UpdateForm(jobBillableSheetView) : base.SaveForm(jobBillableSheetView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				route.PreviousRecordId = jobBillableSheetView.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = new DisplayMessage();
				displayMessage = jobBillableSheetView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				if (byteArray != null)
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = jobBillableSheetView.Id == 0, record = result }, JsonRequestBehavior.AllowGet);
				return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = (jobBillableSheetView.Id == 0), record = result }, JsonRequestBehavior.AllowGet);
			}

			return ErrorMessageForInsertOrUpdate(jobBillableSheetView.Id, route);
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
			_formResult.SessionProvider = SessionProvider;
			_formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new JobBillableSheetView() { JobID = route.ParentRecordId };
			_formResult.SetupFormResult(_commonCommands, route);
			if (_formResult.Record is SysRefModel)
			{
				(_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
					? new Random().Next(-1000, 0) :
					(_formResult.Record as SysRefModel).Id;
			}

			return PartialView(_formResult);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobBillableSheetView, long> jobBillableSheetView, string strRoute, string gridName)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			jobBillableSheetView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			jobBillableSheetView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = base.BatchUpdate(jobBillableSheetView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}

			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrcComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PrcComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditNotes(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrcComments.ToString());
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}
	}
}