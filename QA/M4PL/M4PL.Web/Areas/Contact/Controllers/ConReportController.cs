/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ConReportController
//Purpose:                                      Contains Actions to render view on ConReport page
//====================================================================================================================================================*/
using M4PL.APIClient.Common;
using M4PL.APIClient.Contact;
using M4PL.APIClient.ViewModels.Contact;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Contact.Controllers
{
    public class ConReportController : BaseController<ConReportView>
    {
        protected ReportResult<ConReportView> _reportResult = new ReportResult<ConReportView>();

        /// <summary>
        /// Interacts with the interfaces to get the Contact details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="conReportCommands"></param>
        /// <param name="commonCommands"></param>
        public ConReportController(IConReportCommands conReportCommands, ICommonCommands commonCommands)
            : base(conReportCommands)
        {
            _commonCommands = commonCommands;
        }

        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Contact, _commonCommands.Tables[EntitiesAlias.Contact].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
            if (reportView != null && reportView.Id > 0)
            {
                _reportResult.Record = new ConReportView(reportView);
                return PartialView(MvcConstants.ViewReport, _reportResult);
            }
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }

        public ActionResult ReportInfo(string strRoute)
        {
            var formResult = new FormResult<ConReportView>();
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

        public override ActionResult AddOrEdit(ConReportView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
        }
    }
}