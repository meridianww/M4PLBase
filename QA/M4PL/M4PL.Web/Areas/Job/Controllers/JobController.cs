/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Job
//Purpose:                                      Contains Actions to render view on Job page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobController : BaseController<JobView>
    {
        private readonly IJobCommands _jobCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Job details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="jobCommands"></param>
        /// <param name="commonCommands"></param>
        public JobController(IJobCommands jobCommands, ICommonCommands commonCommands)
            : base(jobCommands)
        {
            _jobCommands = jobCommands;
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobView, long> jobView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            jobView.Insert.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobView.Update.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(jobView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            _gridResult.FocusedRowId = route.RecordId;
            if (route.Action == "DataView") SessionProvider.ActiveUser.LastRoute.RecordId = 0;
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common
                && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;

            SetGridResult(route, gridName, false, true);
            if (SessionProvider.ViewPagedDataSession.Count > 0 && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = isJobParentEntity;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity)
                _gridResult.IsAccessPermission = true;
            else
                _gridResult.IsAccessPermission = _jobCommands.GetIsJobDataViewPermission(route.ParentRecordId);

            if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            //route.IsDataView = false;
            if (SessionProvider.ViewPagedDataSession.Count > 0
                && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;

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
            _formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            SessionProvider.ActiveUser.LastRoute.RecordId = 1;
            if (SessionProvider.ActiveUser.LastRoute.IsPBSReport)
            {
                route.OwnerCbPanel = "pnlJobDetail";
                SessionProvider.ActiveUser.LastRoute = SessionProvider.ActiveUser.ReportRoute;
                SessionProvider.ActiveUser.ReportRoute = null;
                route.IsPBSReport = true;
            }

            _formResult.SubmitClick = string.Format(JsConstants.JobFormSubmitClick, _formResult.FormId, JsonConvert.SerializeObject(route));
            _formResult.Record = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId);
            if (_formResult.Record.ProgramID != null && route.ParentRecordId == 0)
                route.ParentRecordId = route.ParentRecordId == 0 ? Convert.ToInt64(_formResult.Record.ProgramID) : route.ParentRecordId;
            bool isNullFIlter = false;
            if (route.Filters != null)
                isNullFIlter = true;

            ViewData["jobSiteCode"] = _jobCommands.GetJobsSiteCodeByProgram(route.RecordId, route.ParentRecordId, isNullFIlter);

            if (!_formResult.Record.JobCompleted)
            {
                _formResult.Record.JobDeliveryDateTimeActual = null;
                _formResult.Record.JobOriginDateTimeActual = null;
            }
            SessionProvider.ActiveUser.CurrentRoute = route;
            _formResult.SetupFormResult(_commonCommands, route);
            return PartialView(MvcConstants.ActionForm, _formResult);
        }

        [ValidateInput(false)]
        public override ActionResult AddOrEdit(JobView jobView)
        {
            jobView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobView, Request.Params[WebApplicationConstants.UserDateTime]);

            var descriptionByteArray = jobView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Job, ByteArrayFields.JobDeliveryComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(jobView);
            if (jobView.Id > 0 && messages != null && messages.Count() > 0)
            {
                if (messages.Contains("Customer Sales Order already exist"))
                {
                    messages.Remove("Customer Sales Order already exist");
                }
            }

            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobView.Id > 0 ? base.UpdateForm(jobView) : base.SaveForm(jobView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                route.PreviousRecordId = jobView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                var displayMessage = new DisplayMessage();
                displayMessage = jobView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                if (byteArray != null)
                    return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = jobView.Id == 0, record = result }, JsonRequestBehavior.AllowGet);
                return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = (jobView.Id == 0 || jobView.JobCompleted), record = result }, JsonRequestBehavior.AllowGet);
            }
            return ErrorMessageForInsertOrUpdate(jobView.Id, route);
        }

        public ActionResult AddOrEditDestination(JobDestination jobView)
        {
            jobView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobView, Request.Params[WebApplicationConstants.UserDateTime]);

            jobView.JobDeliveryState = Request.Params["JobDeliveryState_VI"].ToString();
            jobView.JobDeliveryCountry = Request.Params["JobDeliveryCountry_VI"].ToString();
            jobView.JobOriginState = Request.Params["JobOriginState_VI"].ToString();
            jobView.JobOriginCountry = Request.Params["JobOriginCountry_VI"].ToString();

            var messages = ValidateMessages(jobView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobView.Id > 0 ? _jobCommands.PutJobDestination(jobView) : new JobDestination();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobView.Id, route);
        }

        public ActionResult AddOrEdit2ndPoc(Job2ndPoc job2ndPoc)
        {
            job2ndPoc.IsFormView = true;
            job2ndPoc.JobDeliveryState = Request.Params["JobDeliveryState_VI"].ToString();
            job2ndPoc.JobDeliveryCountry = Request.Params["JobDeliveryCountry_VI"].ToString();
            job2ndPoc.JobOriginState = Request.Params["JobOriginState_VI"].ToString();
            job2ndPoc.JobOriginCountry = Request.Params["JobOriginCountry_VI"].ToString();

            SessionProvider.ActiveUser.SetRecordDefaults(job2ndPoc, Request.Params[WebApplicationConstants.UserDateTime]);
            var messages = ValidateMessages(job2ndPoc);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = job2ndPoc.Id > 0 ? _jobCommands.PutJob2ndPoc(job2ndPoc) : new Job2ndPoc();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(job2ndPoc.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(job2ndPoc.Id, route);
        }

        public ActionResult AddOrEditSeller(JobSeller jobSeller)
        {
            jobSeller.IsFormView = true;
            jobSeller.JobShipFromState = Request.Params["JobShipFromStateSeller_VI"].ToString();
            jobSeller.JobShipFromCountry = Request.Params["JobShipFromCountrySeller_VI"].ToString();
            jobSeller.JobSellerState = Request.Params["JobSellerState_VI"].ToString();
            jobSeller.JobSellerCountry = Request.Params["JobSellerCountry_VI"].ToString();

            SessionProvider.ActiveUser.SetRecordDefaults(jobSeller, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobSeller);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobSeller.Id > 0 ? _jobCommands.PutJobSeller(jobSeller) : new JobSeller();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobSeller.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobSeller.Id, route);
        }

        public ActionResult AddOrEditMapRoute(JobMapRoute jobMapRoute)
        {
            jobMapRoute.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobMapRoute, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobMapRoute);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobMapRoute.Id > 0 ? _jobCommands.PutJobMapRoute(jobMapRoute) : new JobMapRoute();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobMapRoute.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobMapRoute.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JobDeliveryComment.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.JobDeliveryComment.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        #region TreeList

        public ActionResult TreeView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentEntity = EntitiesAlias.Program;
            var treeSplitterControl = new Models.TreeSplitterControl();
            treeSplitterControl.TreeRoute = new MvcRoute(route, MvcConstants.ActionTreeListCallBack);
            treeSplitterControl.ContentRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            treeSplitterControl.ContentRoute.OwnerCbPanel = string.Concat(treeSplitterControl.ContentRoute.Entity, treeSplitterControl.ContentRoute.Action, "CbPanel");
            treeSplitterControl.ContentRoute = WebUtilities.EmptyResult(treeSplitterControl.ContentRoute);
            treeSplitterControl.SecondPaneControlName = string.Concat(route.Entity, WebApplicationConstants.Form);
            return PartialView(MvcConstants.ViewTreeListSplitter, treeSplitterControl);
        }

        public ActionResult TreeListCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var treeListResult = WebUtilities.SetupTreeResult(_commonCommands, route);
            return PartialView(MvcConstants.ViewTreeListCallBack, treeListResult);
        }

        #endregion TreeList

        #region TabView

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var pageControlResult = route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Job);

            if (route.TabIndex == 0 && route.RecordId == 0)
            {
                int index = 0;
                foreach (var pageInfo in pageControlResult.PageInfos)
                {
                    if (Enum.IsDefined(typeof(EntitiesAlias), pageInfo.TabTableName) && pageInfo.Route.Entity.Equals(route.Entity))
                    {
                        pageControlResult.SelectedTabIndex = index;
                        break;
                    }
                    index++;
                }
            }

            return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
        }

        public ActionResult DeliveryTabView(string strRoute)
        {
            //var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //return PartialView(MvcConstants.ViewInnerPageControlPartial, route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Job));

            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);


            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobDelivery),// Only for special case where setup sub view based on parent entity
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionDeliveryTabView),
                ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobDelivery.ToString()),
                EnableTabClick = true
            };
            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);

            }

            return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
        }

        public ActionResult DestinationFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobDestination>();

            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;
            formResult.Record = _jobCommands.GetJobDestination(route.RecordId, route.ParentRecordId) ?? new JobDestination();

            ////if (!formResult.Record.JobCompleted)
            ////{
            ////    formResult.Record.JobDeliveryDateTimeActual = null;
            ////    formResult.Record.JobOriginDateTimeActual = null;
            ////}
            formResult.SetupFormResult(_commonCommands, route);
            formResult.SubmitClick = string.Format(JsConstants.JobDestinationFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            formResult.ControlNameSuffix = "_Delivery_";
            if (route.IsPopup)
                return View(MvcConstants.ViewJobDestination, formResult);
            return PartialView(MvcConstants.ViewJobDestination, formResult);
        }

        public ActionResult PocFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<Job2ndPoc>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;

            formResult.Record = _jobCommands.GetJob2ndPoc(route.RecordId, route.ParentRecordId) ?? new Job2ndPoc();
            if (!formResult.Record.JobCompleted)
            {
                formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.Record.JobOriginDateTimeActual = null;
            }

            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.Job2ndPocFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (route.IsPopup)
                return View(MvcConstants.ViewJobPoc, formResult);
            return PartialView(MvcConstants.ViewJobPoc, formResult);
        }

        public ActionResult SellerFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobSeller>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;

            formResult.Record = _jobCommands.GetJobSeller(route.RecordId, route.ParentRecordId) ?? new JobSeller();
            if (!formResult.Record.JobCompleted)
                //// formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (route.IsPopup)
                return View(MvcConstants.ViewJobSeller, formResult);
            return PartialView(MvcConstants.ViewJobSeller, formResult);
        }

        public ActionResult MapRouteFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobMapRoute>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCommands.GetJobMapRoute(route.RecordId) : new JobMapRoute();
            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);
            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (SessionProvider.ActiveUser.IsSysAdmin
                && formResult.ColumnSettings.Any(obj => obj.ColAliasName
                .ToLower().Equals("job mileage")))
            {
                formResult.ColumnSettings.Where(d => d.ColAliasName.ToLower().Equals("job mileage")).FirstOrDefault().ColIsReadOnly = false;
            }
            if (route.IsPopup)
                return View(MvcConstants.ViewJobMapRoute, formResult);
            return PartialView(MvcConstants.ViewJobMapRoute, formResult);
        }

        public ActionResult PodFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var formResult = new FormResult<JobPod>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCommands.GetJobPod(route.RecordId) : new JobPod();
            formResult.Record.ControlNamePrefix = string.Concat(route.EntityName, "_Pod");
            formResult.SetupFormResult(_commonCommands, route);
            if (route.IsPopup)
                return View(MvcConstants.ViewJobPod, formResult);
            return PartialView(MvcConstants.ViewJobPod, formResult);
        }

        public ActionResult RichEditNotes(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JobDeliveryComment.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult PODBaseFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobView>();

            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;
            formResult.Record = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId) ?? new JobView();

            //formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            //formResult.CallBackRoute.Entity = EntitiesAlias.JobDocReference;
            //formResult.CallBackRoute.OwnerCbPanel = "AppCbPanel";
            formResult.SetupFormResult(_commonCommands, route);
            return PartialView(MvcConstants.ViewPODBaseFormView, formResult);
        }
        #endregion TabView
    }
}