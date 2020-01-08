/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobReportController
//Purpose:                                      Contains Actions to render view on JobReport page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using DevExpress.XtraPrinting;
using DevExpress.XtraReports.UI;
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
using System.Drawing;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobReportController : BaseController<JobReportView>
    {
        protected ReportResult<JobReportView> _reportResult = new ReportResult<JobReportView>();
        private readonly IJobReportCommands _jobReportCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Job details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="jobReportCommands"></param>
        /// <param name="commonCommands"></param>
        public JobReportController(IJobReportCommands jobReportCommands, ICommonCommands commonCommands)
            : base(jobReportCommands)
        {
            _commonCommands = commonCommands;
            _jobReportCommands = jobReportCommands;
        }

        //Default report from administration report
        //public ActionResult Report(string strRoute)
        //{
        //    var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
        //    route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
        //    route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
        //    var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
        //    if (reportView != null && reportView.Id > 0)
        //    {
        //        _reportResult.Record = new JobReportView(reportView);
        //        return PartialView(MvcConstants.ViewReport, _reportResult);
        //    }
        //    return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        //}

        //Advance custom report for job
        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupAdvancedReportResult(_commonCommands, route, SessionProvider);
            //return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult); 
            if (reportView != null && reportView.Id > 0)
            {
                _reportResult.ReportRoute.Action = "AdvanceReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                _reportResult.Record.StartDate = DateTime.UtcNow.AddDays(-1);
                _reportResult.Record.EndDate = DateTime.UtcNow;
                ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
                return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }


        public ActionResult AdvanceReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _reportResult.ReportRoute = new MvcRoute(route, "AdvanceReportViewer");
            //_reportResult.ExportRoute = new MvcRoute(route, MvcConstants.ActionExportReportViewer);           
            return PartialView(MvcConstants.ViewReportViewer, _reportResult);
        }

        public ActionResult VocReport(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
            if (reportView != null && reportView.Id > 0)
            {
                //_reportResult.ExportRoute.Action = "VocReportViewer";
                _reportResult.ReportRoute.Action = "VocReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                _reportResult.Record.StartDate = DateTime.UtcNow.AddDays(-1);
                _reportResult.Record.EndDate = DateTime.UtcNow;
                return PartialView(MvcConstants.ViewVocReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }

        public ActionResult ReportInfo(string strRoute)
        {
            var formResult = new FormResult<JobReportView>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            formResult.Record = _currentEntityCommands.Get(route.RecordId);
            formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionReportInfo);
            formResult.Operations = new Dictionary<OperationTypeEnum, Operation>();
            formResult.Operations.Add(OperationTypeEnum.Edit, _commonCommands.GetOperation(OperationTypeEnum.Edit));
            formResult.SessionProvider = SessionProvider;
            formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
            return PartialView(MvcConstants.ViewReportInfo, formResult);
        }

        public ActionResult ReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _reportResult.ReportRoute = new MvcRoute(route, MvcConstants.ActionReportViewer);
            _reportResult.ExportRoute = new MvcRoute(route, MvcConstants.ActionExportReportViewer);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());

            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            if (byteArray.Bytes != null && byteArray.Bytes.Length > 100)
            {
                _reportResult.Report = new XtraReportProvider();
                using (System.IO.MemoryStream ms = new System.IO.MemoryStream(byteArray.Bytes))
                    _reportResult.Report.LoadLayoutFromXml(ms);
            }
            return PartialView(MvcConstants.ViewReportViewer, _reportResult);
        }

        public override ActionResult AddOrEdit(JobReportView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
        }

        public ActionResult VocReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _reportResult.ReportRoute = new MvcRoute(route, "VocReportViewer");
            _reportResult.ExportRoute = new MvcRoute(route, MvcConstants.ActionExportReportViewer);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());
            _reportResult.Report = new XtraReport();
            _reportResult.Report.Name = "VOCReport";
            _reportResult.Report.Landscape = true;
            bool tableRecordExistOrNot = true;
            if ((route.CompanyId != null) || route.IsPBSReport)
            {
                var record = _jobReportCommands.GetVocReportData(route.CompanyId ?? 0, route.Location, route.StartDate, route.EndDate, route.IsPBSReport);
                if (record != null)
                {
                    tableRecordExistOrNot = false;
                    PageHeaderBand PageHeader = new PageHeaderBand() { HeightF = 60f };
                    XRTable tableHeader = WebExtension.CreateReportHearderAndTableHearder();
                    PageHeader.Controls.Add(tableHeader);
                    _reportResult.Report.Bands.Add(PageHeader);


                    XRTable table = record.GetReportRecordFromJobVocReportRecord(route.IsPBSReport);
                    DetailBand detailBand = new DetailBand();
                    detailBand.Controls.Add(table);
                    _reportResult.Report.Band.Controls.Add(detailBand);

                    DateTime dt = DateTime.UtcNow;
                    ReportFooterBand reportFooter = new ReportFooterBand();
                    _reportResult.Report.Bands.Add(reportFooter);
                    reportFooter.Controls.Add(new XRLabel()
                    {
                        Text = dt.ToString("dddd, dd MMMM yyyy"),
                        SizeF = new SizeF(500, 80),
                        TextAlignment = TextAlignment.BottomLeft,
                        Font = new Font("Arial", 10),
                        WidthF = 650f
                    });
                    XRPageInfo pageInfoPage = new XRPageInfo();
                    reportFooter.Controls.Add(pageInfoPage);
                    pageInfoPage.Format = "Page {0} of {1}";
                    pageInfoPage.LocationF = new PointF(180F, 40F);
                    pageInfoPage.SizeF = new SizeF(180F, 40F);
                    pageInfoPage.Font = new Font("Arial", 9, FontStyle.Regular);
                    pageInfoPage.ForeColor = Color.Black;
                    pageInfoPage.TextAlignment = TextAlignment.BottomRight;
                    pageInfoPage.PageInfo = DevExpress.XtraPrinting.PageInfo.NumberOfTotal;
                }
            }
            if (tableRecordExistOrNot)
            {
                PageHeaderBand PageHeader = new PageHeaderBand() { HeightF = 40f };
                XRTable tableHeader = WebExtension.CreateReportHeaderBand();
                PageHeader.Controls.Add(tableHeader);
                _reportResult.Report.Bands.Add(PageHeader);
            }
            return PartialView(MvcConstants.ViewReportViewer, _reportResult);
        }

        public override ActionResult ExportReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var report = new XtraReport();
            report.Name = "VOCReport";
            report.Landscape = true;

            PageHeaderBand PageHeader = new PageHeaderBand() { HeightF = 60f };
            XRTable tableHeader = WebExtension.CreateReportHearderAndTableHearder();
            PageHeader.Controls.Add(tableHeader);
            report.Bands.Add(PageHeader);

            if ((route.CompanyId != null) || route.IsPBSReport)
            {
                var record = _jobReportCommands.GetVocReportData(route.CompanyId ?? 0, route.Location, route.StartDate, route.EndDate, route.IsPBSReport);
                if (record != null)
                {
                    XRTable table = record.GetReportRecordFromJobVocReportRecord(route.IsPBSReport);
                    DetailBand detailBand = new DetailBand();
                    detailBand.Controls.Add(table);
                    report.Band.Controls.Add(detailBand);

                    DateTime dt = DateTime.UtcNow;
                    ReportFooterBand reportFooter = new ReportFooterBand();
                    report.Bands.Add(reportFooter);
                    reportFooter.Controls.Add(new XRLabel()
                    {
                        Text = dt.ToString("dddd, dd MMMM yyyy"),
                        SizeF = new SizeF(500, 80),
                        TextAlignment = TextAlignment.BottomLeft,
                        Font = new Font("Arial", 10),
                        WidthF = 650f
                    });
                    XRPageInfo pageInfoPage = new XRPageInfo();
                    reportFooter.Controls.Add(pageInfoPage);
                    pageInfoPage.Format = "Page {0} of {1}";
                    pageInfoPage.LocationF = new PointF(180F, 40F);
                    pageInfoPage.SizeF = new SizeF(180F, 40F);
                    pageInfoPage.Font = new Font("Arial", 9, FontStyle.Regular);
                    pageInfoPage.ForeColor = Color.Black;
                    pageInfoPage.PageInfo = DevExpress.XtraPrinting.PageInfo.NumberOfTotal;
                }
            }

            return DocumentViewerExtension.ExportTo(report);
        }

        public PartialViewResult CustomerLocation(string model, long id)
        {
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "CustomerLocation", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CompanyId = id;
            return PartialView("CustomerLocation", _reportResult);
        }
        public PartialViewResult ProgramByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "ProgramByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Programs"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Program");
            return PartialView("ProgramByCustomer", _reportResult);
        }

        public PartialViewResult OrginByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "OrginByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Origins"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Origin");
            return PartialView("OrginByCustomer", _reportResult);
        }

        public PartialViewResult DestinationByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Destinations"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Destination");
            return PartialView("DestinationByProgramCustomer", _reportResult);
        }
        public PartialViewResult BrandByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Brands"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Brand");
            return PartialView("BrandByProgramCustomer", _reportResult);
        }
        public PartialViewResult GatewayStatusByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "GatewayStatusByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["GatewayTittles"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "GatewayStatus");
            return PartialView("GatewayStatusByProgramCustomer", _reportResult);
        }
        public PartialViewResult ServiceModeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "ServiceModeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["ServiceModes"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "ServiceMode");
            return PartialView("ServiceModeByCustomer", _reportResult);
        }
        public PartialViewResult ProductTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "ProductTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["ProductTypes"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "ProductType");
            return PartialView("ProductTypeByCustomer", _reportResult);
        }
        public PartialViewResult ScheduleByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "ScheduleByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Schedules"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "Scheduled");
            return PartialView("ScheduleByCustomer", _reportResult);
        }
        public PartialViewResult OrderTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "OrderTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["OrderTypes"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "OrderType");
            return PartialView("OrderTypeByCustomer", _reportResult);
        }
        public PartialViewResult JobStatusIdByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "JobStatusIdByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["JobStatusIds"] = _jobReportCommands.GetDropDownDataForProgram(_reportResult.Record.CustomerId, "JobStatus");
            return PartialView("JobStatusIdByCustomer", _reportResult);
        }
    }
}