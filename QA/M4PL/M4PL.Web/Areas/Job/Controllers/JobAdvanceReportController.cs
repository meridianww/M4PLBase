﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      Contains Actions to render view on Jobs's AdvanceReport page
//====================================================================================================================================================*/

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
    public class JobAdvanceReportController : BaseController<JobAdvanceReportView>
    {
        protected ReportResult<JobReportView> _reportResult = new ReportResult<JobReportView>();
        private readonly IJobAdvanceReportCommands _jobAdvanceReportCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Jobs advance report details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="JobAdvanceReportCommands"></param>
        /// <param name="commonCommands"></param>
        public JobAdvanceReportController(IJobAdvanceReportCommands JobAdvanceReportCommands, ICommonCommands commonCommands)
            : base(JobAdvanceReportCommands)
        {
            _commonCommands = commonCommands;
            _jobAdvanceReportCommands = JobAdvanceReportCommands;
        }
        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad = true;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition = null;
            }

            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupAdvancedReportResult(_commonCommands, route, SessionProvider);

            if (reportView != null && reportView.Id > 0)
            {
                ViewData["isFirstLoadProductType"] = true;
                ViewData["isFirstLoadServiceType"] = true;
                ViewData["isFirstLoadOrderType"] = true;
                ViewData["isFirstDestination"] = true;
                ViewData["isFirstProgram"] = true;
                ViewData["isFirstLoadOrgin"] = true;
                ViewData["isFirstBrand"] = true;
                ViewData["isFirstLoadGatewayStatus"] = true;
                ViewData["isFirstLoadChannel"] = true;
                ViewData["isFirstLoadWeightUnitType"] = true;
                ViewData["isFirstLoadPackagingCode"] = true;
                ViewData["isFirstLoadCargoTitle"] = true;
                ViewData["Programs"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "Program");
                ViewData["Origins"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "Origin");
                ViewData["Destinations"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "Destination");
                ViewData["Brands"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "Brand");
                ViewData["GatewayTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "GatewayStatus");
                ViewData["ServiceModes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "ServiceMode");
                ViewData["ProductTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "ProductType");
                ViewData["OrderTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "OrderType");
                ViewData["JobStatusIds"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "JobStatus");
                ViewData["JobChannels"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "JobChannel");
                ViewData["DateTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "DateType");
                ViewData["Schedules"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "Scheduled");
                ViewData["PackagingTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "PackagingCode");
                //ViewData["WeightUnitTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "WeightUnit");
                //ViewData["CargoTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(0, "CargoTitle");

                _reportResult.ReportRoute.Action = "AdvanceReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                _reportResult.Record.StartDate = DateTime.Now.AddDays(-1);
                _reportResult.Record.EndDate = DateTime.Now;
                _reportResult.Record.ProgramCode = "ALL";
                _reportResult.Record.Origin = "ALL";
                _reportResult.Record.Destination = "ALL";
                _reportResult.Record.Brand = "ALL";
                _reportResult.Record.GatewayStatus = "ALL";
                _reportResult.Record.ServiceMode = "ALL";
                _reportResult.Record.ProductType = "ALL";
                _reportResult.Record.PackagingCode = "ALL";
                ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
                return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }
        public PartialViewResult ProgramByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstProgram"] = false;
                return null;
            }
            else
                ViewData["isFirstProgram"] = true;

            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ProgramByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.ProgramCode = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Programs"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Program");
            return PartialView("ProgramByCustomer", _reportResult);
        }
        public PartialViewResult OrginByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadOrgin"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadOrgin"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "OrginByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Origin = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Origins"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Origin");
            return PartialView("OrginByCustomer", _reportResult);
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
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Destination = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Destinations"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Destination");
            return PartialView("DestinationByProgramCustomer", _reportResult);
        }
        public PartialViewResult BrandByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstBrand"] = false;
                return null;
            }
            else
                ViewData["isFirstBrand"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Brands"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Brand");
            return PartialView("BrandByProgramCustomer", _reportResult);
        }
        public PartialViewResult GatewayStatusByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadGatewayStatus"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadGatewayStatus"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "GatewayStatusByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["GatewayTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "GatewayStatus");
            return PartialView("GatewayStatusByProgramCustomer", _reportResult);
        }
        public PartialViewResult ServiceModeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadServiceType"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadServiceType"] = true;

            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ServiceModeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["ServiceModes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "ServiceMode");
            return PartialView("ServiceModeByCustomer", _reportResult);
        }
        public PartialViewResult ProductTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadProductType"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadProductType"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ProductTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["ProductTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "ProductType");
            return PartialView("ProductTypeByCustomer", _reportResult);
        }
        public PartialViewResult ScheduleByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ScheduleByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.ScheduledName = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Schedules"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Scheduled");
            return PartialView("ScheduleByCustomer", _reportResult);
        }
        public PartialViewResult OrderTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "OrderTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.OrderTypeName = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["OrderTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "OrderType");
            return PartialView("OrderTypeByCustomer", _reportResult);
        }
        public PartialViewResult JobStatusIdByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "JobStatusIdByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.JobStatusIdName = "Active";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["JobStatusIds"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "JobStatus");
            return PartialView("JobStatusIdByCustomer", _reportResult);
        }
        public PartialViewResult ChannelByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadChannel"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadChannel"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ChannelByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["JobChannels"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "JobChannel");
            return PartialView("ChannelByCustomer", _reportResult);
        }
        public PartialViewResult DateTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DateTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["DateTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "DateType");
            return PartialView("DateTypeByCustomer", _reportResult);
        }
        public PartialViewResult PackagingTypeByJob(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadPackagingCode"] = false;
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "PackagingTypeByJob", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["PackagingTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "PackagingCode");
            return PartialView("PackagingTypeByJob", _reportResult);
        }
        public PartialViewResult CargoTitleByJob(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadCargoTitle"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadCargoTitle"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "CargoTitleByJob", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Origin = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["CargoTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "CargoTitle");
            return PartialView("CargoTitleByJob", _reportResult);
        }
        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(strRoute);
            if (!strJobAdvanceReportRequestRoute.StartDate.HasValue)
                strJobAdvanceReportRequestRoute.StartDate = DateTime.Now.AddDays(-1);
            if (!strJobAdvanceReportRequestRoute.EndDate.HasValue)
                strJobAdvanceReportRequestRoute.EndDate = DateTime.Now;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = 0;
            var requestRout = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DataView", "Job");
            requestRout.OwnerCbPanel = "JobAdvanceReportGridView";// "JobAdvanceReportGridView";
            SessionProvider.ActiveUser.ReportRoute = null;

            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.WhereCondition = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, sessionInfo.PagedDataInfo);
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                sessionInfo.PagedDataInfo.Params = JsonConvert.SerializeObject(strJobAdvanceReportRequestRoute);
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
                if (strJobAdvanceReportRequestRoute.IsFormRequest || SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad)
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad = false;
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition
                        = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo);
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(strJobAdvanceReportRequestRoute);
                }
                else
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = true;
                    strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params);
                }
            }

            SetGridResult(requestRout, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));

            _gridResult.Permission = Permission.ReadOnly;

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.ReadOnly;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
            sessionInfo.GridViewColumnState = column;
            sessionInfo.GridViewColumnStateReset = reset;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            if (TempData["RowHashes"] != null)
                TempData.Keep();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var currentPageSize = GetorSetUserGridPageSize();
            GetorSetUserGridPageSize(pager.PageSize);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.PageNumber = pager.PageIndex + 1;
            sessionInfo.PagedDataInfo.PageSize = pager.PageSize;
            var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
            viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
            SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            _gridResult.SessionProvider = SessionProvider;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, gridName, (currentPageSize != pager.PageSize), reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));
            _gridResult.GridViewModel.ApplyPagingState(pager);
            _gridResult.Permission = Permission.ReadOnly;

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition == null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition =
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition;
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) && route.RecordId > 0)
            {
                route.RecordId = 0;
            }
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;

            if (sessionInfo.Filters == null)
                sessionInfo.Filters = new Dictionary<string, string>();
            if (string.IsNullOrEmpty(filteringState.FilterExpression) && (filteringState.ModifiedColumns.Count > 0))
                route.Filters = null;

            //used to reset page index of the grid when Filter applied and pageing is opted
            ViewData[WebApplicationConstants.ViewDataFilterPageNo] = sessionInfo.PagedDataInfo.PageNumber;
            sessionInfo.PagedDataInfo.WhereCondition = filteringState.BuildGridFilterWhereCondition(route.Entity, ref filters, _commonCommands);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                sessionInfo.PagedDataInfo.WhereCondition = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition
                    + sessionInfo.PagedDataInfo.WhereCondition;
            }
            if (sessionInfo.Filters != null && filters.Count > 0 && sessionInfo.Filters.Count != filters.Count)//Have to search from starting if setup filter means from page 1
                sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.Filters = filters;
            sessionInfo.GridViewFilteringState = filteringState;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            _gridResult.SessionProvider = SessionProvider;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));

            route.Filters = null;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
    }
}