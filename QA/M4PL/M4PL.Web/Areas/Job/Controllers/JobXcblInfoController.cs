﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
	public class JobXcblInfoController : BaseController<JobXcblInfoView>
	{
		private readonly IJobXcblInfoCommands _jobXcblInfoCommands;

		public JobXcblInfoController(IJobXcblInfoCommands jobXcblInfoCommands, ICommonCommands commonCommands)
			: base(jobXcblInfoCommands)
		{
			_commonCommands = commonCommands;
			_jobXcblInfoCommands = jobXcblInfoCommands;
		}

		public override ActionResult AddOrEdit(JobXcblInfoView jobXcblInfoView)
		{
			jobXcblInfoView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobXcblInfoView, Request.Params[WebApplicationConstants.UserDateTime]);
			var messages = ValidateMessages(jobXcblInfoView);

			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = true;
			if (jobXcblInfoView.IsAccepted)
				result = _jobXcblInfoCommands.AcceptJobXcblInfo(jobXcblInfoView.JobId, jobXcblInfoView.JobGatewayId); //jobXcblInfoView.Id > 0 ? base.UpdateForm(jobXcblInfoView) : base.SaveForm(jobXcblInfoView);
			else
				result = _jobXcblInfoCommands.RejectJobXcblInfo(jobXcblInfoView.JobGatewayId); //jobXcblInfoView.Id > 0 ? base.UpdateForm(jobXcblInfoView) : base.SaveForm(jobXcblInfoView);

			MvcRoute resRoute = null;
			if (result)
			{
                jobXcblInfoView.JobId = jobXcblInfoView.JobId > 0 ? jobXcblInfoView.JobId : (long)TempData["JobId"];
                if (jobXcblInfoView.JobId > 0)
				{
					var preProgramId = Session["ParentId"] != null ? (long)Session["ParentId"] : 0;
					var resultRoute = SessionProvider.ActiveUser.LastRoute;
					resultRoute.Entity = EntitiesAlias.JobXcblInfo;
					resultRoute.ParentEntity = EntitiesAlias.Program;
					resultRoute.Action = "FormView";
					resultRoute.RecordId = jobXcblInfoView.JobId;
					resultRoute.ParentRecordId = preProgramId;
					resultRoute.OwnerCbPanel = "pnlJobDetail";

					resRoute = new M4PL.Entities.Support.MvcRoute(resultRoute, MvcConstants.ActionForm);
					resRoute.Url = resRoute.ParentRecordId.ToString();
				}

				var displayMessage = new DisplayMessage();
				displayMessage = jobXcblInfoView.Id > 0 ?
					_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess)
					: _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(resRoute));

				return Json(new
				{
					status = true,
					route = resRoute,
					displayMessage = displayMessage,
					refreshContent = (jobXcblInfoView.Id == 0),
					record = result,
				},
					JsonRequestBehavior.AllowGet);
			}
			return ErrorMessageForInsertOrUpdate(jobXcblInfoView.Id, resRoute);
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_formResult.SessionProvider = SessionProvider;
			//_formResult.Record.Id = (_formResult.Record != null && _formResult.Record.Id == 0) ? route.RecordId : _formResult.Record.Id;
			//route.RecordId = jobgatewayID -- use this gateway id to get other relation information to job and gateway
			_formResult.Record = _jobXcblInfoCommands.GetJobXcblInfo(route.ParentRecordId, route.RecordId); /// need pass real data
			_formResult.Record.Id = (_formResult.Record != null && _formResult.Record.Id == 0) ? route.RecordId : _formResult.Record.Id;
			_formResult.SetupFormResult(_commonCommands, route);
			_formResult.CallBackRoute = new MvcRoute(BaseRoute, _formResult.Record.Id);
			_formResult.CallBackRoute.RecordId = route.RecordId;
			_formResult.CallBackRoute.ParentRecordId = route.ParentRecordId;
            TempData["JobId"] = route.ParentRecordId;
            return PartialView(_formResult);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			base.DataView(strRoute, gridName);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}
	}
}