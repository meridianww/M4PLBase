/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 PrgReportController
//Purpose:                                      Contains Actions to render view on Program's PrgReport page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgReportController : BaseController<PrgReportView>
    {
        protected ReportResult<PrgReportView> _reportResult = new ReportResult<PrgReportView>();

        /// <summary>
        /// Interacts with the interfaces to get the Program details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgReportCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgReportController(IPrgReportCommands prgReportCommands, ICommonCommands commonCommands)
            : base(prgReportCommands)
        {
            _commonCommands = commonCommands;
        }

        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Program, _commonCommands.Tables[EntitiesAlias.Program].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
            if (reportView != null && reportView.Id > 0)
            {
                _reportResult.Record = new PrgReportView(reportView);
                return PartialView(MvcConstants.ViewReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));

        }

        public ActionResult ReportInfo(string strRoute)
        {
            var formResult = new FormResult<PrgReportView>();
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

        public override ActionResult AddOrEdit(PrgReportView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
        }
    }
}