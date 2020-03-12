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
        protected ReportResult<JobAdvanceReportFilterView> _advanceReportResult = new ReportResult<JobAdvanceReportFilterView>();
        private readonly IJobReportCommands _jobReportCommands;
        private readonly IJobAdvanceReportCommands _jobAdvanceReportCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Job details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="jobReportCommands"></param>
        /// <param name="commonCommands"></param>
        public JobReportController(IJobReportCommands jobReportCommands, ICommonCommands commonCommands, IJobAdvanceReportCommands jobAdvanceReportCommands)
            : base(jobReportCommands)
        {
            _commonCommands = commonCommands;
            _jobReportCommands = jobReportCommands;
            _jobAdvanceReportCommands = jobAdvanceReportCommands;
            _jobAdvanceReportCommands.ActiveUser = _jobReportCommands.ActiveUser;
        }

        //Advance custom report for job
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
                _reportResult.ReportRoute.Action = "AdvanceReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                _reportResult.Record.StartDate = DateTime.UtcNow.AddDays(-1);
                _reportResult.Record.EndDate = DateTime.UtcNow;
                ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
                return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }

        public ActionResult VocReport(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
           // SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest = null;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);

            if (reportView != null && reportView.Id > 0)
            {
                ViewData["isFirstLoadLocation"] = true;
                ViewData["Locations"] = _jobReportCommands.GetDropDownDataForLocation(0, "Location");
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
            var strVOCReportRequestRoute = new JobVOCReportRequest();
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                strVOCReportRequestRoute = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest;
                //SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest = null;
            }
            else
            {
                strVOCReportRequestRoute = new JobVOCReportRequest()
                {
                    EndDate = route.EndDate,
                    StartDate = route.StartDate,
                    Location = route.Location,
                    IsPBSReport = route.IsPBSReport,
                    CompanyId = route.CompanyId
                };
            }
            _reportResult.ReportRoute = new MvcRoute(route, "VocReportViewer");
            _reportResult.ExportRoute = new MvcRoute(route, MvcConstants.ActionExportReportViewer);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());
            _reportResult.Report = new XtraReport();
            _reportResult.Report.Name = "VOCReport";
            _reportResult.Report.Landscape = true;
            bool tableRecordExistOrNot = true;
            if (strVOCReportRequestRoute.CompanyId != null || strVOCReportRequestRoute.IsPBSReport)
            {
                var Locations = string.Empty;
                if (strVOCReportRequestRoute.Location != null && strVOCReportRequestRoute.Location.Count > 0 && !strVOCReportRequestRoute.Location.Contains("ALL"))
                    Locations = string.Format("{0}", string.Join(",", strVOCReportRequestRoute.Location.OfType<string>()));
                else
                    Locations = "All";


                var record = _jobReportCommands.GetVocReportData(strVOCReportRequestRoute.CompanyId ?? 0, Locations, strVOCReportRequestRoute.StartDate, strVOCReportRequestRoute.EndDate, strVOCReportRequestRoute.IsPBSReport);
                if (record != null)
                {
                    tableRecordExistOrNot = false;
                    PageHeaderBand PageHeader = new PageHeaderBand() { HeightF = 60f };
                    XRTable tableHeader = WebExtension.CreateReportHearderAndTableHearder();
                    PageHeader.Controls.Add(tableHeader);
                    _reportResult.Report.Bands.Add(PageHeader);


                    XRTable table = record.GetReportRecordFromJobVocReportRecord(strVOCReportRequestRoute.IsPBSReport);
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
            var strVOCReportRequestRoute = new JobVOCReportRequest();
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                strVOCReportRequestRoute = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest;
                //SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest = null;
            }
            else
            {
                strVOCReportRequestRoute = new JobVOCReportRequest()
                {
                    EndDate = route.EndDate,
                    StartDate = route.StartDate,
                    Location = route.Location,
                    IsPBSReport = route.IsPBSReport,
                    CompanyId = route.CompanyId
                };
            }
            var report = new XtraReport();
            report.Name = "VOCReport";
            report.Landscape = true;

            PageHeaderBand PageHeader = new PageHeaderBand() { HeightF = 60f };
            XRTable tableHeader = WebExtension.CreateReportHearderAndTableHearder();
            PageHeader.Controls.Add(tableHeader);
            report.Bands.Add(PageHeader);

            if (strVOCReportRequestRoute.CompanyId != null || strVOCReportRequestRoute.IsPBSReport)
            {
                var Locations = string.Empty;
                if (strVOCReportRequestRoute.Location != null && strVOCReportRequestRoute.Location.Count > 0 && !strVOCReportRequestRoute.Location.Contains("ALL"))
                    Locations = string.Format("{0}", string.Join(",", strVOCReportRequestRoute.Location.OfType<string>()));
                else
                    Locations = "All";
                var record = _jobReportCommands.GetVocReportData(strVOCReportRequestRoute.CompanyId ?? 0, Locations, strVOCReportRequestRoute.StartDate, strVOCReportRequestRoute.EndDate, strVOCReportRequestRoute.IsPBSReport);
                if (record != null)
                {
                    XRTable table = record.GetReportRecordFromJobVocReportRecord(strVOCReportRequestRoute.IsPBSReport);
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
            if (id == 0)
            {
                ViewData["isFirstLoadLocation"] = false;
                return null;
            }
            else
            {
                ViewData["isFirstLoadLocation"] = true;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobReport, "CustomerLocation", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CompanyId = id;
            _reportResult.Record.Id = 0;
            _reportResult.Record.ProgramCode = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            ViewData["Locations"] = _jobReportCommands.GetDropDownDataForLocation(_reportResult.Record.CustomerId, "Location");
            return PartialView("CustomerLocation", _reportResult);
        }

        [HttpPost]
        public ActionResult FilterVOCReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var strVOCReportRequestRoute = new JobVOCReportRequest();
            strVOCReportRequestRoute = new JobVOCReportRequest()
            {
                EndDate = route.EndDate,
                StartDate = route.StartDate,
                Location = route.Location,
                IsPBSReport = route.IsPBSReport,
                CompanyId = route.CompanyId
            };
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest = strVOCReportRequestRoute;
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.JobVOCReportRequest = strVOCReportRequestRoute;
            }
            route.EndDate = null;
            route.StartDate = null;
            route.Location = null;
            route.IsPBSReport = false;
            route.CompanyId = null;
            return Json(route, JsonRequestBehavior.AllowGet);
        }

    }
}