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


namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCardController : BaseController<JobView>
    {
        protected CardViewResult<JobCardViewView> _reportResult = new CardViewResult<JobCardViewView>();
        private readonly IJobCardCommands _jobCardViewCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Jobs advance report details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="commonCommands"></param>
        public JobCardController(IJobCardCommands JobCardViewCommands, ICommonCommands commonCommands) : base(JobCardViewCommands)
        {
            _commonCommands = commonCommands;
            _jobCardViewCommands = JobCardViewCommands;
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
            }
            else
            {
                //SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition
                //    = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo);
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);

            }
            return base.DataView(JsonConvert.SerializeObject(route));
        }

    }
}