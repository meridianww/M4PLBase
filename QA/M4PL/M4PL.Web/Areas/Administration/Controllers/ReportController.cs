#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   AKhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ReportController
//Purpose:                                      Contains Actions to render view on Report over the Pages in the system
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class ReportController : BaseController<ReportView>
    {
        protected ReportResult<ReportView> _reportResult = new ReportResult<ReportView>();

        /// <summary>
        /// Interacts with the interfaces to get the menu driver details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="reportCommands"></param>
        /// <param name="commonCommands"></param>
        public ReportController(IReportCommands reportCommands, ICommonCommands commonCommands)
            : base(reportCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Provides batch edit operation for the security module
        /// Creation of new records and validation for the mandatory fields
        /// </summary>
        /// <param name="reportViews"></param>
        /// <returns></returns>

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ReportView, long> reportView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            reportView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            reportView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(reportView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _reportResult.Record = _currentEntityCommands.Get(route.RecordId);
            _reportResult.Report = new XtraReportProvider();
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());
            if (route.RecordId > 0)
            {
                var dbReport = _commonCommands.GetByteArrayByIdAndEntity(byteArray);
                if (dbReport != null && dbReport.Bytes != null && dbReport.Bytes.Length > 100)
                    using (System.IO.MemoryStream ms = new System.IO.MemoryStream(dbReport.Bytes))
                        _reportResult.Report.LoadLayoutFromXml(ms);
            }
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }
            _reportResult.CallBackRoute = new MvcRoute(BaseRoute);
            _reportResult.CallBackRoute.Action = MvcConstants.ActionSaveReport;
            return PartialView(MvcConstants.ViewForm, _reportResult);
        }

        public void SaveReport(long reportId)
        {
            var bytes = ReportDesignerExtension.GetReportXml("ReportDesigner");
            var byteArray = new ByteArray { Id = reportId, Entity = EntitiesAlias.Report, FieldName = ByteArrayFields.RprtTemplate.ToString(), Type = SQLDataTypes.varbinary };
            _commonCommands.SaveBytes(byteArray, bytes);
        }

        public override ActionResult AddOrEdit(ReportView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
        }
    }
}