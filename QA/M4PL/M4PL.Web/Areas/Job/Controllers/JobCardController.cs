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
            _reportResult.Records = WebExtension.GetCardViewViews();
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;  
            return PartialView(MvcConstants.ViewJobCardViewDashboard, _reportResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var jobCardRequest = new JobCardRequest();
            jobCardRequest.CardName = "Active";
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
            _gridResult.Permission = Permission.ReadOnly;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
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
    }
}