/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationPocContact
//Purpose:                                      Contains Actions to render view on Organization's Poc Contact page
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
    public class OrgPocContactController : BaseController<OrgPocContactView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Organization poc contacts details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgPocContactCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgPocContactController(IOrgPocContactCommands orgPocContactCommands, ICommonCommands commonCommands)
            : base(orgPocContactCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgPocContactView orgPocContactView)
        {
            orgPocContactView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(orgPocContactView, Request.Params[WebApplicationConstants.UserDateTime]);
            orgPocContactView.ConOrgId = orgPocContactView.ParentId;
            orgPocContactView.OrganizationId = orgPocContactView.ParentId;
            var messages = ValidateMessages(orgPocContactView);
            var descriptionByteArray = orgPocContactView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgPocContact, ByteArrayFields.ConDescription.ToString());
            var instructionByteArray = orgPocContactView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgPocContact, ByteArrayFields.ConInstruction.ToString());
            var byteArray = new List<ByteArray> { descriptionByteArray, instructionByteArray };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = orgPocContactView.Id > 0 ? base.UpdateForm(orgPocContactView) : base.SaveForm(orgPocContactView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView, SessionProvider.ActiveUser.LastRoute.CompanyId);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                instructionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(orgPocContactView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgPocContactView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgPocContactView, long> orgPocContactView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            orgPocContactView.Insert.ForEach(c => { c.ConOrgId = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            orgPocContactView.Update.ForEach(c => { c.ConOrgId = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            var batchError = BatchUpdate(orgPocContactView, route, gridName);
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.ConDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.ConDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditInstructions(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.ConInstruction.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.ConInstruction.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}