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
//Program Name:                                 VendorBusinessTerm
//Purpose:                                      Contains Actions to render view on Vendor's Business Term page
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
	public class VendBusinessTermController : BaseController<VendBusinessTermView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the Vendor's business term details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="vendorBusinessTermCommands"></param>
		/// <param name="commonCommands"></param>
		public VendBusinessTermController(IVendBusinessTermCommands vendorBusinessTermCommands, ICommonCommands commonCommands)
			: base(vendorBusinessTermCommands)
		{
			_commonCommands = commonCommands;
		}

		/// <summary>
		/// Performs edit or update action on the existing Vendor's business term record
		/// </summary>
		/// <param name="vendBusinessTermView"></param>
		/// <returns></returns>

		public override ActionResult AddOrEdit(VendBusinessTermView vendBusinessTermView)
		{
			vendBusinessTermView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(vendBusinessTermView, Request.Params[WebApplicationConstants.UserDateTime]);
			vendBusinessTermView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
			vendBusinessTermView.VbtVendorID = vendBusinessTermView.ParentId;
			var messages = ValidateMessages(vendBusinessTermView);
			var descriptionByteArray = vendBusinessTermView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.VendBusinessTerm, ByteArrayFields.VbtDescription.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};
			if (messages.Any())
				return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

			var record = vendBusinessTermView.Id > 0 ? base.UpdateForm(vendBusinessTermView) : base.SaveForm(vendBusinessTermView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

			if (record is SysRefModel)
			{
				route.RecordId = record.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
				return SuccessMessageForInsertOrUpdate(vendBusinessTermView.Id, route, byteArray);
			}
			return ErrorMessageForInsertOrUpdate(vendBusinessTermView.Id, route);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendBusinessTermView, long> vendBusinessTermView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			vendBusinessTermView.Insert.ForEach(c => { c.VbtVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			vendBusinessTermView.Update.ForEach(c => { c.VbtVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = BatchUpdate(vendBusinessTermView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		#region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.VbtDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.VbtDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}