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

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCostSheetController : BaseController<JobCostSheetView>
    {
        private readonly IJobCostSheetCommands _jobCostSheetCommands;
        //private bool _jobCostLoad = true;

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
            _formResult.Record = route.Filters != null && !string.IsNullOrEmpty(route.Filters.Value)
                ? _jobCostSheetCommands.GetJobCostCodeByProgram(Convert.ToInt64(route.Filters.Value), route.ParentRecordId)
                : _jobCostSheetCommands.Get(route.RecordId);

            if (_formResult.Record != null)
            {
                _formResult.Record.CstQuantity = _formResult.Record.CstQuantity > 0 ? _formResult.Record.CstQuantity : 1;
            }

            _formResult.SetupFormResult(_commonCommands, route);
            if (_formResult.Record is SysRefModel)
            {
                (_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
                    ? new Random().Next(-1000, 0) :
                    (_formResult.Record as SysRefModel).Id;
            }

            return PartialView(_formResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {

            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            route.RecordId = 0;
            var jobCodeActions = _jobCostSheetCommands.GetJobCostCodeAction(route.ParentRecordId);
            TempData["IsCostCodeAction"] = jobCodeActions.Count > 0 ? true : false;
            TempData.Keep();
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;
            SetGridResult(route, gridName, false, false, jobCodeActions);
            if ((!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid)) || (TempData["jobCostLoad"] != null && (bool)TempData["jobCostLoad"]))
            {
                TempData["jobCostLoad"] = false;
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            }

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }


        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobCostSheetView, long> jobCostSheetView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            jobCostSheetView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobCostSheetView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(jobCostSheetView, route, gridName);
            var jobCodeActions = _jobCostSheetCommands.GetJobCostCodeAction(route.ParentRecordId);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }

            SetGridResult(route, "", false, false, jobCodeActions);
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
            {
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            }

            return base.RichEditFormView(byteArray);
        }
    }
}