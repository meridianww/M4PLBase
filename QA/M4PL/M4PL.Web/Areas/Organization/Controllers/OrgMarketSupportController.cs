/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationMarketSupport
//Purpose:                                      Contains Actions to render view on Organization's Act role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgMarketSupportController : BaseController<OrgMarketSupportView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Organizaton's market support details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgMarketSupportCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgMarketSupportController(IOrgMarketSupportCommands orgMarketSupportCommands, ICommonCommands commonCommands)
            : base(orgMarketSupportCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgMarketSupportView orgMarketSupportView)
        {
            orgMarketSupportView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(orgMarketSupportView, Request.Params[WebApplicationConstants.UserDateTime]);
            orgMarketSupportView.OrgID = orgMarketSupportView.ParentId;
            orgMarketSupportView.OrganizationId = orgMarketSupportView.ParentId;
            var messages = ValidateMessages(orgMarketSupportView);
            var descriptionByteArray = orgMarketSupportView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgMarketSupport, ByteArrayFields.MrkDescription.ToString());
            var instructionByteArray = orgMarketSupportView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgMarketSupport, ByteArrayFields.MrkInstructions.ToString());
            var byteArray = new List<ByteArray> { descriptionByteArray, instructionByteArray };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = orgMarketSupportView.Id > 0 ? base.UpdateForm(orgMarketSupportView) : base.SaveForm(orgMarketSupportView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                instructionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(orgMarketSupportView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgMarketSupportView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgMarketSupportView, long> orgMarketSupportView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            orgMarketSupportView.Insert.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            orgMarketSupportView.Update.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            var batchError = BatchUpdate(orgMarketSupportView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.MrkDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.MrkDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditInstructions(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.MrkInstructions.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}