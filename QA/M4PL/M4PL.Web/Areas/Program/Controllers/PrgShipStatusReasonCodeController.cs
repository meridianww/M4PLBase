﻿#region Copyright

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
//Program Name:                                 ProgramShipStatusReasonCode
//Purpose:                                      Contains Actions to render view on Program's ShipStatusReasonCode page
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
	public class PrgShipStatusReasonCodeController : BaseController<PrgShipStatusReasonCodeView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the Program's ShipStatusReasonCode details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="PrgShipStatusReasonCodeCommands"></param>
		/// <param name="commonCommands"></param>
		public PrgShipStatusReasonCodeController(IPrgShipStatusReasonCodeCommands PrgShipStatusReasonCodeCommands, ICommonCommands commonCommands)
			: base(PrgShipStatusReasonCodeCommands)
		{
			_commonCommands = commonCommands;
		}

		public override ActionResult AddOrEdit(PrgShipStatusReasonCodeView prgShipStatusReasonCodeView)
		{
			prgShipStatusReasonCodeView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(prgShipStatusReasonCodeView, Request.Params[WebApplicationConstants.UserDateTime]);
			prgShipStatusReasonCodeView.PscProgramID = prgShipStatusReasonCodeView.ParentId;

			var descriptionByteArray = prgShipStatusReasonCodeView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgShipStatusReasonCode, ByteArrayFields.PscShipDescription.ToString());
			var commentByteArray = prgShipStatusReasonCodeView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgShipStatusReasonCode, ByteArrayFields.PscShipComment.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray,commentByteArray
			};

			var messages = ValidateMessages(prgShipStatusReasonCodeView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = prgShipStatusReasonCodeView.Id > 0 ? base.UpdateForm(prgShipStatusReasonCodeView) : base.SaveForm(prgShipStatusReasonCodeView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
				commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				return SuccessMessageForInsertOrUpdate(prgShipStatusReasonCodeView.Id, route, byteArray);
			}
			return ErrorMessageForInsertOrUpdate(prgShipStatusReasonCodeView.Id, route);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgShipStatusReasonCodeView, long> prgShipStatusReasonCodeView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			prgShipStatusReasonCodeView.Insert.ForEach(c => { c.PscProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			prgShipStatusReasonCodeView.Update.ForEach(c => { c.PscProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = BatchUpdate(prgShipStatusReasonCodeView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PscShipDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PscShipDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PscShipComment.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PscShipComment.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}