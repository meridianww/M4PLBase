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
//Program Name:                                 JobRefStatus
//Purpose:                                      Contains Actions to render view on Job's Ref Status page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
	public class JobRefStatusController : BaseController<JobRefStatusView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the Job's ref status details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="JobRefStatusCommands"></param>
		/// <param name="commonCommands"></param>
		public JobRefStatusController(IJobRefStatusCommands JobRefStatusCommands, ICommonCommands commonCommands)
			: base(JobRefStatusCommands)
		{
			_commonCommands = commonCommands;
		}

		public override ActionResult AddOrEdit(JobRefStatusView jobRefStatusView)
		{
			jobRefStatusView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobRefStatusView, Request.Params[WebApplicationConstants.UserDateTime]);
			jobRefStatusView.JobID = jobRefStatusView.ParentId;
			var messages = ValidateMessages(jobRefStatusView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = jobRefStatusView.Id > 0 ? base.UpdateForm(jobRefStatusView) : base.SaveForm(jobRefStatusView);

			var descriptionByteArray = jobRefStatusView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobRefStatus, ByteArrayFields.JbsDescription.ToString());
			_commonCommands.SaveBytes(descriptionByteArray, RichEditExtension.SaveCopy(descriptionByteArray.ControlName, DevExpress.XtraRichEdit.DocumentFormat.OpenXml));

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
			}
			return Json(new { status = true, route = route, fileUpload = new List<ByteArray>() }, JsonRequestBehavior.AllowGet);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobRefStatusView, long> jobRefStatusView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			jobRefStatusView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			jobRefStatusView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = base.BatchUpdate(jobRefStatusView, route, gridName);
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
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JbsDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.JbsDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit

		public ActionResult TabView(string strRoute)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var pageControlResult = new PageControlResult
			{
				PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobRefStatus),
				CallBackRoute = new MvcRoute(route, MvcConstants.ActionTabView),
				ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobCargo.ToString())
			};
			foreach (var pageInfo in pageControlResult.PageInfos)
			{
				pageInfo.SetRoute(route, _commonCommands);
				pageInfo.Route.ParentRecordId = route.ParentRecordId;
			}
			return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
		}
	}
}