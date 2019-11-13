/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorDocReference
//Purpose:                                      Contains Actions to render view on Vendor's Document Reference page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Vendor;
using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class VendDocReferenceController : BaseController<VendDocReferenceView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Vendor's document reference details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="vendDocReferenceCommands"></param>
        /// <param name="commonCommands"></param>
        public VendDocReferenceController(IVendDocReferenceCommands vendDocReferenceCommands, ICommonCommands commonCommands)
            : base(vendDocReferenceCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Vendor's document reference record
        /// </summary>
        /// <param name="vendDocReferenceView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(VendDocReferenceView vendDocReferenceView)
        {
            vendDocReferenceView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(vendDocReferenceView, Request.Params[WebApplicationConstants.UserDateTime]);
            vendDocReferenceView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            vendDocReferenceView.VdrVendorID = vendDocReferenceView.ParentId;
            var messages = ValidateMessages(vendDocReferenceView);
            var descriptionByteArray = vendDocReferenceView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.VendDocReference, ByteArrayFields.VdrDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = vendDocReferenceView.Id > 0 ? base.UpdateForm(vendDocReferenceView) : base.SaveForm(vendDocReferenceView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(vendDocReferenceView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(vendDocReferenceView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendDocReferenceView, long> vendDocReferenceView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            vendDocReferenceView.Insert.ForEach(c => { c.VdrVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            vendDocReferenceView.Update.ForEach(c => { c.VdrVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(vendDocReferenceView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.VdrDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.VdrDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}