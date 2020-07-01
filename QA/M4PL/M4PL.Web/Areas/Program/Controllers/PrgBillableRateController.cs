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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramBillableRate
//Purpose:                                      Contains Actions to render view on Program's Act role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgBillableRateController : BaseController<ProgramBillableRateView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program billable rate details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="ProgramBillableRateCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgBillableRateController(IPrgBillableRateCommands ProgramBillableRateCommands, ICommonCommands commonCommands)
            : base(ProgramBillableRateCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(ProgramBillableRateView programBillableRateView)
        {
            programBillableRateView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(programBillableRateView, Request.Params[WebApplicationConstants.UserDateTime]);
            programBillableRateView.ProgramLocationId = programBillableRateView.ParentId;
            programBillableRateView.StatusId = WebApplicationConstants.ActiveStatusId;
            var messages = ValidateMessages(programBillableRateView, EntitiesAlias.PrgBillableRate);

            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = programBillableRateView.Id > 0 ? base.UpdateForm(programBillableRateView) : base.SaveForm(programBillableRateView);

            ////var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView, SessionProvider.ActiveUser.LastRoute.CompanyId).SetParent(EntitiesAlias.Program, programBillableRateView.ParentId, true);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                route.Url = result.ProgramLocationId.ToString();
                route.Entity = EntitiesAlias.PrgBillableLocation;
                route.SetParent(EntitiesAlias.Program, result.ProgramId);

                return SuccessMessageForInsertOrUpdate(programBillableRateView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(programBillableRateView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ProgramBillableRateView, long> programBillableRateView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            programBillableRateView.Insert.ForEach(c => { c.ProgramLocationId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            programBillableRateView.Update.ForEach(c => { c.ProgramLocationId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(programBillableRateView, route, gridName);
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

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PbrDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PbrDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}