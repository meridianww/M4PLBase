#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program
{
	public class PrgEdiConditionController : BaseController<PrgEdiConditionView>
	{
		protected IPrgEdiConditionCommands _prgEdiConditionCommands;

		public PrgEdiConditionController(IPrgEdiConditionCommands prgEdiConditionCommands, ICommonCommands commonCommands)
			: base(prgEdiConditionCommands)
		{
			_commonCommands = commonCommands;
		}

		public override ActionResult AddOrEdit(PrgEdiConditionView prgEdiConditionView)
		{
			prgEdiConditionView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(prgEdiConditionView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = prgEdiConditionView.Id.GetVarbinaryByteArray(EntitiesAlias.PrgEdiHeader, ByteArrayFields.PehEdiDescription.ToString());
			var byteArray = new List<Entities.Support.ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(prgEdiConditionView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = prgEdiConditionView.Id > 0 ? base.UpdateForm(prgEdiConditionView) : base.SaveForm(prgEdiConditionView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = new DisplayMessage();
				displayMessage = prgEdiConditionView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				if (byteArray != null)
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = true }, JsonRequestBehavior.AllowGet);
				return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = true }, JsonRequestBehavior.AllowGet);
			}
			return ErrorMessageForInsertOrUpdate(prgEdiConditionView.Id, route);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgEdiConditionView, long> prgEdiConditionView, string strRoute, string gridName)
		{
			Dictionary<long, string> batchError = new Dictionary<long, string>();
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			prgEdiConditionView.Insert.ForEach(c => { c.PecParentProgramId = ((Request.Params["prgEdiHeaderId"] != null) ? (long.Parse(Request.Params["prgEdiHeaderId"])) : route.ParentRecordId); c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; c.ParentId = Convert.ToInt64(route.Filters.Value); });
			prgEdiConditionView.Update.ForEach(c => { c.PecParentProgramId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			batchError = BatchUpdate(prgEdiConditionView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			base.DataView(strRoute);
			return PartialView(_gridResult);
		}
	}
}