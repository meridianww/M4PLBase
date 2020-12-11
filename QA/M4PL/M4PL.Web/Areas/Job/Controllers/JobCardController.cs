#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using DevExpress.Web.Mvc;
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
using System.Linq;
using System.Web.Mvc;

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
            _reportResult.ReportRoute.IsEdit = route.IsEdit;

            List<string> prefLocation = new List<string>();
            var result = _commonCommands != null && _commonCommands.ActiveUser != null && _commonCommands.ActiveUser.ConTypeId > 0
                && SessionProvider.ActiveUser.PreferredLocation != null
                ? SessionProvider.ActiveUser.PreferredLocation : null;
            // _commonCommands.GetPreferedLocations(_commonCommands.ActiveUser.ConTypeId) : null;
            if (result != null && result.Any() /*!string.IsNullOrEmpty(result)*/ && TempData["Destinations"] == null && route.Location == null)
            {
                _reportResult.ReportRoute.Location = new List<string>();
                prefLocation = result.Select(t => t.PPPVendorLocationCode).ToList();

                var ExistingDestination = (IList<M4PL.Entities.Job.JobCard>)ViewData["Destinations"];
                foreach (string item in prefLocation)
                {
                    if (ExistingDestination.Where(x => x.Destination == item).FirstOrDefault() != null)
                        _reportResult.ReportRoute.Location.Add(item);
                }
            }
            if (!route.IsEdit)
            {
                SessionProvider.CardTileData = null;
                TempData["Destinations"] = null;
            }

            return PartialView(MvcConstants.ViewJobCardViewDashboard, _reportResult);
        }
        public PartialViewResult JobCardTileByCustomer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.IsEdit && SessionProvider.CardTileData != null)
            {
                var recordData = (IList<APIClient.ViewModels.Job.JobCardViewView>)SessionProvider.CardTileData;
                if (recordData != null)
                {
                    _reportResult.Records = recordData;
                    return PartialView(MvcConstants.ViewJobCardViewPartial, _reportResult);
                }
            }
            var destinationSiteWhereCondition = WebExtension.GetJobCardWhereCondition(route.Location);
            var record = _jobCardCommands.GetCardTileData(route.RecordId, destinationSiteWhereCondition);
            TempData["JobCardCustomerId"] = route.RecordId;
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
            TempData["Destinations"] = route.Location;
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var jobCardRequest = new JobCardRequest();
            //TempData["CardTtile"] = null;
            var destinationSiteWhereCondition = WebExtension.GetJobCardWhereCondition(route.Location);
            bool isExport = false;
            if (Request.ContentType == "application/x-www-form-urlencoded")
            {
                isExport = true;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                if (filterId > 0)
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Empty;
                    if (SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState != null &&
                        ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState) != null)
                        ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState).FilterExpression = string.Empty;

                }
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId =
                        filterId == 0 ? SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId : filterId;

            }
            else
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession; viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId =
                    filterId == 0 ? SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId : filterId;
                route.IsEdit = true;
            }
            if (SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId > 0)
            {
                filterId = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobCardFilterId;
                jobCardRequest.DashboardCategoryRelationId = filterId;
                if (route.CompanyId != 0)
                    jobCardRequest.CustomerId = route.CompanyId;
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
                route.ParentRecordId = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId;
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = 30;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition += destinationSiteWhereCondition;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(jobCardRequest);
                //if (SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState != null &&
                //    ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState) != null)
                //    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition += 
                //        ((DevExpress.Web.Mvc.GridViewFilteringState)SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState).FilterExpression;
            }
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsExport = isExport;
            var cancelRoute = new MvcRoute(EntitiesAlias.JobCard, "CardView", "Job");
            cancelRoute.OwnerCbPanel = "AppCbPanel";
            cancelRoute.EntityName = "JobCard";
            cancelRoute.Url = string.Empty;
            cancelRoute.CompanyId = TempData["JobCardCustomerId"] != null ? (long)TempData["JobCardCustomerId"] : route.CompanyId;
            TempData.Keep("JobCardCustomerId");
            cancelRoute.Location = route.Location;
            cancelRoute.IsEdit = true;
            //cancelRoute.Filters.Value = null;
            TempData["BackUrl"] = string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", "DataView", Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
            SessionProvider.IsCardEditMode = false;
            if (_gridResult.SessionProvider == null)
                _gridResult.SessionProvider = SessionProvider;

            base.DataView(JsonConvert.SerializeObject(route));
            //To Add Actions Operation in ContextMenu
            //if (!isExport)
            //    _gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.JobCard, false);
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
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobCardView, long> JobCardView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            JobCardView.Insert.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            JobCardView.Update.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(JobCardView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        #region Filtering & Sorting
        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            long filterId = 0;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
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
            //To Add Actions Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.JobCard, false);

            route.Filters = null;
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
            //To Add Actions Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.JobCard, false);

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
            base.GridPagingView(pager, strRoute, gridName);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //To Add Actions Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.JobCard, false);

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        #endregion Paging
        public override ActionResult RibbonMenu(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.Action != "CardView")
                return base.RibbonMenu(strRoute);
            else
            {
                if (_commonCommands == null)
                {
                    _commonCommands = new CommonCommands();
                    _commonCommands.ActiveUser = SessionProvider.ActiveUser;
                }

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
                                {
                                    ch.StatusId = 3;
                                }
                            }
                            else
                            {
                                ch.StatusId = 3;
                                if (ch.MnuTitle == "Remittance")
                                {
                                    ch.StatusId = 1;
                                }
                                //if (ch.Children.Any(obj => obj.MnuTitle == "Retrieve Invoices"))
                                //{
                                //    ch.Children.FirstOrDefault(obj => obj.MnuTitle == "Retrieve Invoices").StatusId = 1;
                                //}
                            }
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
        #region secret santa
        public ActionResult JobCardGrid(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewBag.FilterId = filterId;
            return PartialView("JobCardGrid", route);
        }
        #endregion
    }
}