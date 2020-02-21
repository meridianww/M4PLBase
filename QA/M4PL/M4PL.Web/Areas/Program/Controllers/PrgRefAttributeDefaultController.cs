/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRefAttributeDefault
//Purpose:                                      Contains Actions to render view on Program's Ref Attribute Default page
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
    public class PrgRefAttributeDefaultController : BaseController<PrgRefAttributeDefaultView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's attribute details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="PrgRefAttributeDefaultCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgRefAttributeDefaultController(IPrgRefAttributeDefaultCommands PrgRefAttributeDefaultCommands, ICommonCommands commonCommands)
            : base(PrgRefAttributeDefaultCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(PrgRefAttributeDefaultView prgRefAttributeDefaultView)
        {
            prgRefAttributeDefaultView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgRefAttributeDefaultView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgRefAttributeDefaultView.ProgramID = prgRefAttributeDefaultView.ParentId;
            var descriptionByteArray = prgRefAttributeDefaultView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRefAttributeDefault, ByteArrayFields.AttDescription.ToString());
            var commentByteArray = prgRefAttributeDefaultView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRefAttributeDefault, ByteArrayFields.AttComments.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, commentByteArray
            };
            var messages = ValidateMessages(prgRefAttributeDefaultView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgRefAttributeDefaultView.Id > 0 ? base.UpdateForm(prgRefAttributeDefaultView) : base.SaveForm(prgRefAttributeDefaultView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(prgRefAttributeDefaultView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(prgRefAttributeDefaultView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgRefAttributeDefaultView, long> prgRefAttributeDefaultView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgRefAttributeDefaultView.Insert.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgRefAttributeDefaultView.Update.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgRefAttributeDefaultView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.AttDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.AttDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.AttComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.AttComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}