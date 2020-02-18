using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using System.Linq;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCardController : BaseController<JobCardView>
    {
        protected CardViewResult<JobCardViewView> _reportResult = new CardViewResult<JobCardViewView>();
        private readonly IJobCardCommands _jobCardCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Jobs advance report details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="commonCommands"></param>
        public JobCardController(IJobCardCommands JobCardCommands, ICommonCommands commonCommands) : base(JobCardCommands)
        {
            _commonCommands = commonCommands;
            _jobCardCommands = JobCardCommands;
        }

        public ActionResult CardView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;            
            var record = _jobCardCommands.GetCardTileData(0);
            if (record != null)
            {
               _reportResult.Records = WebExtension.GetCardViewViews(record);
            }

            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;  
            return PartialView(MvcConstants.ViewJobCardViewDashboard, _reportResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var jobCardRequest = new JobCardRequest();
            if (!string.IsNullOrEmpty(route.Location) && !string.IsNullOrWhiteSpace(route.Location)) {
                string[] jobCardParams = route.Location.Split(',').Select(sValue => sValue.Trim()).ToArray();
                jobCardRequest.CardType = jobCardParams[0];
                jobCardRequest.CardName = jobCardParams[1];
            }
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                //sessionInfo.PagedDataInfo.WhereCondition = WebExtension.GetAdvanceWhereCondition(jobCardRequest, sessionInfo.PagedDataInfo);
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                sessionInfo.PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);
                sessionInfo.PagedDataInfo.PageSize = 30;
            }
            else
            {
                //SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition
                //    = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo);
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = 30;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);

            }
            base.DataView(JsonConvert.SerializeObject(route));
            //_gridResult.Permission = Permission.ReadOnly;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
            //SetGridResult(route, gridName, false, true);
            //if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
            //    return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            //return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.ReadOnly;
            return base.GridSortingView(column, reset, strRoute, gridName);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);

            CommonIds maxMinFormData = null;
            if (!route.IsPopup && route.RecordId != 0)
            {
                maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(EntitiesAlias.Job.ToString(), route.ParentRecordId, route.RecordId);
                if (maxMinFormData != null)
                {
                    _formResult.MaxID = maxMinFormData.MaxID;
                    _formResult.MinID = maxMinFormData.MinID;
                }
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
            _formResult.SubmitClick = string.Format(JsConstants.JobFormSubmitClick, _formResult.FormId, JsonConvert.SerializeObject(route));
            ////TempData["jobCostLoad"] = true;
            ////TempData["jobPriceLoad"] = true;
            _formResult.Record = _jobCardCommands.GetJobByProgram(route.RecordId, route.ParentRecordId);

            bool isNullFIlter = false;
            if (route.Filters != null)
                isNullFIlter = true;

            ViewData["jobSiteCode"] = _jobCardCommands.GetJobsSiteCodeByProgram(route.RecordId, route.ParentRecordId, isNullFIlter);

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
        public override ActionResult AddOrEdit(JobCardView jobView)
        {
            jobView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobView, Request.Params[WebApplicationConstants.UserDateTime]);

            var descriptionByteArray = jobView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobCard, ByteArrayFields.JobDeliveryComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(jobView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobView.Id > 0 ? base.UpdateForm(jobView) : null;

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if(result!= null)
            {
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

            var result = jobView.Id > 0 ? _jobCardCommands.PutJobDestination(jobView) : new JobDestination();

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

            var result = job2ndPoc.Id > 0 ? _jobCardCommands.PutJob2ndPoc(job2ndPoc) : new Job2ndPoc();

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

            var result = jobSeller.Id > 0 ? _jobCardCommands.PutJobSeller(jobSeller) : new JobSeller();

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

            var result = jobMapRoute.Id > 0 ? _jobCardCommands.PutJobMapRoute(jobMapRoute) : new JobMapRoute();

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
            //else
            //{
            //    pageControlResult.CallBackRoute.Entity = EntitiesAlias.JobCard;
            //}

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
            formResult.Record = _jobCardCommands.GetJobDestination(route.RecordId, route.ParentRecordId) ?? new JobDestination();

            ////if (!formResult.Record.JobCompleted)
            ////{
            ////    formResult.Record.JobDeliveryDateTimeActual = null;
            ////    formResult.Record.JobOriginDateTimeActual = null;
            ////}
            formResult.SetupFormResult(_commonCommands, route);
            formResult.SubmitClick = string.Format(JsConstants.JobDestinationFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            formResult.ControlNameSuffix = "_Delivery_";
            //if (route.IsPopup)
            //    return View(MvcConstants.ViewJobDestination, formResult);
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

            formResult.Record = _jobCardCommands.GetJob2ndPoc(route.RecordId, route.ParentRecordId) ?? new Job2ndPoc();
            if (!formResult.Record.JobCompleted)
            {
                formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.Record.JobOriginDateTimeActual = null;
            }

            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.Job2ndPocFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            //if (route.IsPopup)
            //    return View(MvcConstants.ViewJobPoc, formResult);
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

            formResult.Record = _jobCardCommands.GetJobSeller(route.RecordId, route.ParentRecordId) ?? new JobSeller();
            if (!formResult.Record.JobCompleted)
                //// formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            //if (route.IsPopup)
            //    return View(MvcConstants.ViewJobSeller, formResult);
            return PartialView(MvcConstants.ViewJobSeller, formResult);
        }

        public ActionResult MapRouteFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobMapRoute>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCardCommands.GetJobMapRoute(route.RecordId) : new JobMapRoute();
            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);
            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            //if (route.IsPopup)
            //    return View(MvcConstants.ViewJobMapRoute, formResult);
            return PartialView(MvcConstants.ViewJobMapRoute, formResult);
        }

        public ActionResult PodFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var formResult = new FormResult<JobPod>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCardCommands.GetJobPod(route.RecordId) : new JobPod();
            formResult.Record.ControlNamePrefix = string.Concat(route.EntityName, "_Pod");
            formResult.SetupFormResult(_commonCommands, route);
            //if (route.IsPopup)
            //    return View(MvcConstants.ViewJobPod, formResult);
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

        #endregion TabView
    }
}