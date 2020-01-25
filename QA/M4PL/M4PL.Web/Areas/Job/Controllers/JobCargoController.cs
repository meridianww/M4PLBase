/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobCargo
//Purpose:                                      Contains Actions to render view on Job's Cargo page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCargoController : BaseController<JobCargoView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Jobs cargo details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="JobCargoCommands"></param>
        /// <param name="commonCommands"></param>
        public JobCargoController(IJobCargoCommands JobCargoCommands, ICommonCommands commonCommands)
            : base(JobCargoCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(JobCargoView jobCargoView)
        {
            jobCargoView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobCargoView, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobCargoView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobCargoView.Id > 0 ? base.UpdateForm(jobCargoView) : base.SaveForm(jobCargoView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobCargoView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobCargoView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobCargoView, long> jobCargoView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            jobCargoView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobCargoView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(jobCargoView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }

            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public ActionResult TabView(string strRoute)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobCargo),
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionTabView),
                ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobCargo.ToString())
            };
            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
                pageInfo.Route.ParentRecordId = route.ParentRecordId;
            }
            return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", string WhereJobAdance = "")
        {
            base.DataView(strRoute);
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }
            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }
    }
}