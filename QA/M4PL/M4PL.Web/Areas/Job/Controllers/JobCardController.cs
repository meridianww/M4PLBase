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
        //  protected ReportResult<JobReportView> _reportadvanceResult = new ReportResult<JobReportView>();


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
            ViewData["Destinations"] = _jobCardCommands.GetDropDownDataForJobCard(route.RecordId, "Destination");

            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            _reportResult.SetupJobCardResult(_commonCommands, route, SessionProvider);
            var jobcardView = new JobCardViewView();
            jobcardView.Id = 10;
            _reportResult.Record = new JobCardViewView(jobcardView);
            _reportResult.ReportRoute.Action = "JobCardTileByCustomer";
            _reportResult.ReportRoute.Entity = EntitiesAlias.JobCard;
            _reportResult.ReportRoute.Area = "Job";
            _reportResult.ReportRoute.RecordId = _reportResult.Record.CompanyId = route.CompanyId.HasValue && route.CompanyId.Value > 0 ? route.CompanyId.Value : 0;
            _reportResult.ReportRoute.Location = route.Location;

            List<string> prefLocation = new List<string>();
            string result = _commonCommands != null && _commonCommands.ActiveUser != null && _commonCommands.ActiveUser.ConTypeId > 0
                ? _commonCommands.GetPreferedLocations(_commonCommands.ActiveUser.ConTypeId) : null;
            if (!string.IsNullOrEmpty(result))
            {
                _reportResult.ReportRoute.Location = new List<string>();
                prefLocation = result.Split(',').ToList();
                
                var ExistingDestination = (IList<M4PL.Entities.Job.JobCard>)ViewData["Destinations"];
                foreach (string item in prefLocation)
                {
                    if (ExistingDestination.Where(x => x.Destination == item).FirstOrDefault() != null)
                        _reportResult.ReportRoute.Location.Add(item);
                }
            }
            SessionProvider.CardTileData = null;
            return PartialView(MvcConstants.ViewJobCardViewDashboard, _reportResult);
        }

        public PartialViewResult JobCardTileByCustomer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var destinationSiteWhereCondition = WebExtension.GetJobCardWhereCondition(route.Location);
            var record = _jobCardCommands.GetCardTileData(route.RecordId, destinationSiteWhereCondition);
            if (record != null)
            {
                _reportResult.Records = record.GetCardViewViews(route.RecordId);
                var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
                if (recordData == null || (recordData != null && recordData.Count == 0))
                {
                    SessionProvider.CardTileData = record.GetCardViewViews(route.RecordId);
                }

            }

            return PartialView(MvcConstants.ViewJobCardViewPartial, _reportResult);
        }
        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var jobCardRequest = new JobCardRequest();
            TempData["CardTtile"] = null;
            var destinationSiteWhereCondition = WebExtension.GetJobCardWhereCondition(route.Location);
            if (filterId > 0)
            {
                jobCardRequest.DashboardCategoryRelationId = filterId;
                //jobCardRequest.CustomerId = route.CustomerId;

                var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
                if (recordData != null && recordData.Count > 0)
                {
                    var data = recordData.Where(x => x.Id == filterId).FirstOrDefault();
                    if (data != null)
                    {
                        jobCardRequest.DashboardCategoryRelationId = filterId;
                        jobCardRequest.BackGroundColor = data.CardBackgroupColor;
                        jobCardRequest.CardType = data.CardType;
                        jobCardRequest.CardName = data.Name;
                        jobCardRequest.DashboardCategoryName = data.DashboardCategoryName;
                        jobCardRequest.DashboardSubCategoryName = data.DashboardSubCategoryName;
                    }
                    TempData["CardTtile"] = jobCardRequest;
                    TempData.Keep();
                }
            }
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                sessionInfo.PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);
                sessionInfo.PagedDataInfo.WhereCondition = destinationSiteWhereCondition;
                sessionInfo.PagedDataInfo.PageSize = 30;
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = 30;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = destinationSiteWhereCondition;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);
                if (SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState != null &&
                    ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState) != null)
                    ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState).FilterExpression = string.Empty;
            }
            var cancelRoute = new MvcRoute(EntitiesAlias.JobCard, "CardView", "Job");
            cancelRoute.OwnerCbPanel = "AppCbPanel";
            cancelRoute.EntityName = "JobCard";
            cancelRoute.Url = string.Empty;
            //cancelRoute.CompanyId = route.CustomerId;
            cancelRoute.Location = route.Location;
            //cancelRoute.Filters.Value = null;
            TempData["BackUrl"] = string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", "DataView", Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
            TempData.Keep();
            SessionProvider.IsCardEditMode = false;
            base.DataView(JsonConvert.SerializeObject(route));
            _gridResult.GridHeading = jobCardRequest != null ? jobCardRequest.CardType + " " + jobCardRequest.CardName : _gridResult.GridSetting.GridName;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public PartialViewResult DestinationByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstDestination"] = false;
                return null;
            }
            else
                ViewData["isFirstDestination"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobCardViewView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            //_reportResult.Record.Destination = "ALL";
            _reportResult.ReportRoute = new MvcRoute(BaseRoute);
            _reportResult.ReportRoute.Action = "JobCardTileByCustomer";
            _reportResult.ReportRoute.Entity = EntitiesAlias.JobCard;
            _reportResult.ReportRoute.OwnerCbPanel = "JobCardViewTileCbPanel";
            _reportResult.ReportRoute.Area = "Job";
            _reportResult.ReportRoute.RecordId = 0;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Destinations"] = _jobCardCommands.GetDropDownDataForJobCard(id, "Destination");
            return PartialView("DestinationPartialView", _reportResult);
        }

        #region Filtering & Sorting

        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            long filterId = 0;
            if (TempData["CardTtile"] != null && filterId == 0)
                filterId = ((JobCardRequest)TempData["CardTtile"]).DashboardCategoryRelationId;
            //TempData["CardTtile"] = null;
            _gridResult.Permission = Permission.EditAll;
            var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
            if (recordData != null && recordData.Count > 0)
            {
                var jobCardRequest = WebExtension.GetJobCard(recordData, strRoute, filterId);
                TempData["CardTtile"] = jobCardRequest;
            }
            TempData.Peek("BackUrl");
            TempData["BackUrl"] = TempData["BackUrl"];
            TempData.Keep();
            base.GridFilteringView(filteringState, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            long filterId = 0;
            if (TempData["CardTtile"] != null)
                filterId = ((JobCardRequest)TempData["CardTtile"]).DashboardCategoryRelationId;
            TempData["CardTtile"] = null;
            _gridResult.Permission = Permission.EditAll;
            var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
            if (recordData != null && recordData.Count > 0)
            {
                var jobCardRequest = WebExtension.GetJobCard(recordData, strRoute, filterId);
                TempData["CardTtile"] = jobCardRequest;
            }
            TempData.Peek("BackUrl");
            TempData["BackUrl"] = TempData["BackUrl"];
            TempData.Keep();
            base.GridSortingView(column, reset, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        #endregion Filtering & Sorting

        #region Paging
        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.EditAll;
            long filterId = 0;
            if (TempData["CardTtile"] != null)
                filterId = ((JobCardRequest)TempData["CardTtile"]).DashboardCategoryRelationId;
            TempData["CardTtile"] = null;
            var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
            if (recordData != null && recordData.Count > 0)
            {
                var jobCardRequest = WebExtension.GetJobCard(recordData, strRoute, filterId);
                TempData["CardTtile"] = jobCardRequest;
            }
            //TempData.Peek("BackUrl");
            //TempData["BackUrl"] = TempData["BackUrl"];
            //TempData.Keep();
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
                if (m.MnuTitle == "File")
                {
                    foreach (var ch in m.Children)
                    {
                        if (ch.MnuTitle == "Records" && ch.Children.Any() &&
                        ch.Route != null && ch.Route.Area == "Job" &&
                        ch.Route.Controller == "JobCard" && route.Action == "DataView" && SessionProvider.IsCardEditMode)
                        {

                            if (ch.Children != null && ch.Children.Any(obj => obj.Route != null &&
                            obj.Route.Action != null && obj.Route.Action.ToLower() == "save"))
                            {
                                ch.StatusId = 1;
                                ch.Children.Where(obj => obj.MnuTitle == "New").FirstOrDefault().StatusId = 3;
                                ch.Children.Where(obj => obj.MnuTitle == "Refresh All").FirstOrDefault().StatusId = 1;
                                ch.Children.Where(obj => obj.MnuTitle == "Save").FirstOrDefault().StatusId = 1;
                            }
                            else
                                ch.StatusId = 3;
                        }
                        else
                            ch.StatusId = 3;
                    }
                }
            });

            if (route.Action == "DataView" && !SessionProvider.IsCardEditMode)
            {
                SessionProvider.IsCardEditMode = true;
            }
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            return PartialView(MvcConstants.ViewRibbonMenu, ribbonMenus);
        }
    }
}