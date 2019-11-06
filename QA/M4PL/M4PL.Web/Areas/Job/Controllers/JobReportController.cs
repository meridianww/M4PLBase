/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobReportController
//Purpose:                                      Contains Actions to render view on JobReport page
//====================================================================================================================================================*/

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

        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
            if (reportView != null && reportView.Id > 0)
            {
                _reportResult.Record = new JobReportView(reportView);
                return PartialView(MvcConstants.ViewReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }

        public ActionResult VocReport(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
            if (reportView != null && reportView.Id > 0)
            {
                _reportResult.Record = new JobReportView(reportView);
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
            if (!string.IsNullOrEmpty(route.Location))
            {
                _reportResult.Report = new XtraReport();
                _reportResult.Report.Name = "VOCReport";
                route.Location = "NJ";
                DetailBand detailBand = new DetailBand();
                _reportResult.Report.Bands.Add(new DetailBand());

                var record = _jobReportCommands.GetVocReportData(route.Location, route.StartDate, route.EndDate);
                if (record != null)
                {
                    XRTable table = record.GetReportRecordFromJobVocReportRecord();
                    detailBand.Controls.Add(table);

                    _reportResult.Report.Bands[0].Controls.Add(table);
                    //using (System.IO.MemoryStream ms = new System.IO.MemoryStream(byteArray.Bytes))
                    //    _reportResult.Report.LoadLayoutFromXml(ms);
                }
            }
            else
            {
                if (route.RecordId > 0)
                    byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
                if (byteArray.Bytes != null && byteArray.Bytes.Length > 100)
                {
                    _reportResult.Report = new XtraReportProvider();
                    using (System.IO.MemoryStream ms = new System.IO.MemoryStream(byteArray.Bytes))
                        _reportResult.Report.LoadLayoutFromXml(ms);
                }
            }

            return PartialView(MvcConstants.ViewReportViewer, _reportResult);
        }

        public override ActionResult AddOrEdit(JobReportView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
        }

        public IList<JobVocReport> GetVocReportViews(string locationCode, DateTime? startDate, DateTime? endDate)
        {
            return _jobReportCommands.GetVocReportData(locationCode, startDate, endDate);
        }
    }
}