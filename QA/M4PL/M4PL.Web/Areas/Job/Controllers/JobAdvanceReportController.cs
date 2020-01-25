﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      Contains Actions to render view on Jobs's AdvanceReport page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
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
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupAdvancedReportResult(_commonCommands, route, SessionProvider);

            //_reportResult.Record.GridSettings = 
            //return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult); 
            if (reportView != null && reportView.Id > 0)
            {
                ViewData["ShowGrid"] = false;
                _reportResult.ReportRoute.Action = "AdvanceReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                _reportResult.Record.StartDate = DateTime.UtcNow.AddDays(-1);
                _reportResult.Record.EndDate = DateTime.UtcNow;
                ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
                return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }
        public PartialViewResult ProgramByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ProgramByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Id = 0;
            _reportResult.Record.ProgramCode = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Programs"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Program");
            return PartialView("ProgramByCustomer", _reportResult);
        }

        public PartialViewResult OrginByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
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
                return null;
            }
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
                return null;
            }
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
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "GatewayStatusByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["GatewayTittles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "GatewayStatus");
            return PartialView("GatewayStatusByProgramCustomer", _reportResult);
        }
        public PartialViewResult ServiceModeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
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
                return null;
            }
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
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ChannelByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["JobChannels"] = _jobAdvanceReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "JobChannel");
            return PartialView("ChannelByCustomer", _reportResult);
        }

        public PartialViewResult GetjobAdvanceReport(string strRoute)
        {
            ViewData["ShowGrid"] = true;
            //return PartialView(MvcConstants.ViewBlank);
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(strRoute);
           var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //var pageDataInfo = new PagedDataInfo
            //{
            //    PageSize = 100,
            //    PageNumber = 1,
            //    Entity = EntitiesAlias.JobAdvanceReport,
            //    WhereCondition = WebExtension.GetAdvanceWhereCondition(record),
            //};

            //var result = new MvcRoute()
            //{
            //    Action = MvcConstants.ActionDataView,
            //    Entity = EntitiesAlias.JobAdvanceReport
            //};

            //_jobAdvanceReportCommands.ActiveUser = SessionProvider.ActiveUser;
            //var result = _jobAdvanceReportCommands.GetPagedData(pageDataInfo);     

            //var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //route.ParentEntity = EntitiesAlias.Job;
            //route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;

            //_gridResult.SessionProvider = SessionProvider;
            //SetGridResult(new MvcRoute(EntitiesAlias.JobAdvanceReport, "DataView", "Job"), "", false, false, null, WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute));
            //_gridResult.GridViewModel.ApplyPagingState(pager);
            //return PartialView(MvcConstants.ViewDetailGridViewPartial /*"JobAdvanceReportGridPartial"*/, _gridResult);
            //return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return PartialView("JobAdvanceReportGridPartial");
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", string WhereJobAdance="")
        {
            string strAdavaceReport = string.Empty;
            try
            {
                ViewData["ShowGrid"] = true;
                var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(strRoute);
                strAdavaceReport = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute);
            }
            catch {
                ViewData["ShowGrid"] = false;
            }            
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentEntity = EntitiesAlias.Job;
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.JobAdvanceReportCbPanel;
            base.DataView(JsonConvert.SerializeObject(route),"JobAdvanceGridView", strAdavaceReport);
            return PartialView(_gridResult);
        }
    }
}