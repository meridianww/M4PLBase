/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramShipApptmtReasonCode
//Purpose:                                      Contains Actions to render view on Program's ShipApptmtReasonCode page
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
    public class PrgShipApptmtReasonCodeController : BaseController<PrgShipApptmtReasonCodeView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's ship appointment reason code details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="PrgShipApptmtReasonCodeCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgShipApptmtReasonCodeController(IPrgShipApptmtReasonCodeCommands PrgShipApptmtReasonCodeCommands, ICommonCommands commonCommands)
            : base(PrgShipApptmtReasonCodeCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(PrgShipApptmtReasonCodeView prgShipApptmtReasonCodeView)
        {
            prgShipApptmtReasonCodeView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgShipApptmtReasonCodeView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgShipApptmtReasonCodeView.PacProgramID = prgShipApptmtReasonCodeView.ParentId;

            var descriptionByteArray = prgShipApptmtReasonCodeView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgShipApptmtReasonCode, ByteArrayFields.PacApptDescription.ToString());
            var commentByteArray = prgShipApptmtReasonCodeView.Id.GetVarbinaryByteArray(EntitiesAlias.PrgShipApptmtReasonCode, ByteArrayFields.PacApptComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray,commentByteArray
            };

            var messages = ValidateMessages(prgShipApptmtReasonCodeView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgShipApptmtReasonCodeView.Id > 0 ? base.UpdateForm(prgShipApptmtReasonCodeView) : base.SaveForm(prgShipApptmtReasonCodeView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(prgShipApptmtReasonCodeView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(prgShipApptmtReasonCodeView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgShipApptmtReasonCodeView, long> prgShipApptmtReasonCodeView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgShipApptmtReasonCodeView.Insert.ForEach(c => { c.PacProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgShipApptmtReasonCodeView.Update.ForEach(c => { c.PacProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgShipApptmtReasonCodeView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PacApptDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PacApptDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditComments(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PacApptComment.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}