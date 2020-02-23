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
        protected ReportResult<JobReportView> _reportadvanceResult = new ReportResult<JobReportView>();

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
            _commonCommands.ActiveUser = SessionProvider.ActiveUser;
        }

        public ActionResult CardView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            _reportResult.SetupJobCardResult(_commonCommands, route, SessionProvider);            
            var jobcardView = new JobCardViewView();
            jobcardView.Id = 10;
            _reportResult.Record = new JobCardViewView(jobcardView);
            _reportResult.ReportRoute.Action = "JobCardTileByCustomer";
            _reportResult.ReportRoute.Entity = EntitiesAlias.JobCard;
            _reportResult.ReportRoute.Area = "Job";
            _reportResult.ReportRoute.RecordId = 0;

            return PartialView(MvcConstants.ViewJobCardViewDashboard, _reportResult);
        }
        public PartialViewResult JobCardTileByCustomer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.OwnerCbPanel = "JobCardGridViewTile";
            var record = _jobCardCommands.GetCardTileData(route.RecordId);
            if (record != null)
                _reportResult.Records = record.GetCardViewViews(route.RecordId);
            return PartialView(MvcConstants.ViewJobCardViewPartial, _reportResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var jobCardRequest = new JobCardRequest();
            if (route.DashCategoryRelationId > 0 )
            {
                jobCardRequest.DashboardCategoryRelationId = route.DashCategoryRelationId;
                jobCardRequest.CustomerId = route.CustomerId;
            }
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };                
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                sessionInfo.PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);
                sessionInfo.PagedDataInfo.PageSize = 30;
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = 30;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);

            }
            base.DataView(JsonConvert.SerializeObject(route));
            _gridResult.GridHeading = jobCardRequest != null ? jobCardRequest.CardType + " " + jobCardRequest.CardName : _gridResult.GridSetting.GridName;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
       
        #region Filtering & Sorting

        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.EditAll;
            base.GridFilteringView(filteringState, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.EditAll;
            base.GridSortingView(column, reset, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        #endregion Filtering & Sorting

        #region Paging

        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.EditAll;
            base.GridPagingView(pager, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #endregion Paging

        public override ActionResult RibbonMenu(string strRoute)
        {
            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.OwnerCbPanel = WebApplicationConstants.RibbonCbPanel;

            var ribbonMenus = _commonCommands.GetRibbonMenus().ToList();

            if (WebGlobalVariables.ModuleMenus.Count == 0)
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

            var mainModuleRibbons = (from mnu in WebGlobalVariables.ModuleMenus
                                     join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
                                     where mnu.MnuBreakDownStructure.StartsWith("01")
                                     select mnu.SetRibbonMenu()).ToList();

            SessionProvider.UserSecurities.ToList().ForEach(sec => mainModuleRibbons.GetNotAccessibleMenus(sec).ForEach(nmnu => mainModuleRibbons.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));

            //Comment this line if want to show on ribbon if it has no operations to perform
            mainModuleRibbons.RemoveAll(mnu => mnu.Children.Count == 0);
            //mainModuleRibbons.ForEach(m =>
            //{
            //    if (m.StatusId == 1) m.StatusId = 3;
            //});


            ribbonMenus.AddRange(mainModuleRibbons);
            ViewData[MvcConstants.LastActiveTabRoute] = route;
            ribbonMenus.ForEach(r => r.RibbonRoute(route, ribbonMenus.IndexOf(r), new MvcRoute { Entity = EntitiesAlias.JobCard, Area = EntitiesAlias.Job.ToString() }, _commonCommands, SessionProvider));
            ribbonMenus.ForEach(m =>
            {
                if (m.MnuTitle == "File") {
                    foreach (var ch in m.Children)
                    {
                        ch.StatusId = 3;
                    }
                }
            });

            return PartialView(MvcConstants.ViewRibbonMenu, ribbonMenus);
        }
    }
}