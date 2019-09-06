/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramCostRate
//Purpose:                                      Contains Actions to render view on Program's Cost Rate page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgCostRateController : BaseController<ProgramCostRateView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's cost rate details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="ProgramCostRateCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgCostRateController(IPrgCostRateCommands ProgramCostRateCommands, ICommonCommands commonCommands)
            : base(ProgramCostRateCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(ProgramCostRateView programCostRateView)
        {
            programCostRateView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(programCostRateView, Request.Params[WebApplicationConstants.UserDateTime]);
            programCostRateView.ProgramLocationId = programCostRateView.ParentId;
			programCostRateView.StatusId = WebApplicationConstants.ActiveStatusId;
			var messages = ValidateMessages(programCostRateView, EntitiesAlias.PrgBillableRate);

            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = programCostRateView.Id > 0 ? base.UpdateForm(programCostRateView) : base.SaveForm(programCostRateView);

            ////var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView, SessionProvider.ActiveUser.LastRoute.CompanyId).SetParent(EntitiesAlias.Program, programCostRateView.ParentId, true);
			if (result is SysRefModel)
            {
                route.RecordId = result.Id;
				route.Url = result.ProgramLocationId.ToString();
				route.Entity = EntitiesAlias.PrgCostLocation;
				route.SetParent(EntitiesAlias.Program, result.ProgramId);

				return SuccessMessageForInsertOrUpdate(programCostRateView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(programCostRateView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ProgramCostRateView, long> programCostRateView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            programCostRateView.Insert.ForEach(c => { c.ProgramLocationId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            programCostRateView.Update.ForEach(c => { c.ProgramLocationId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(programCostRateView, route, gridName);
			route.Url = route.ParentRecordId.ToString();
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PcrDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}