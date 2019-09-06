/*All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              26/07/2019
Program Name:                                 JobBillableSheetController
Purpose:                                      Contains Actions to render view on Job's  Billable Sheet page
=================================================================================================================*/
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobBillableSheetController : BaseController<JobBillableSheetView>
    {

        public JobBillableSheetController(IJobBillableSheetCommands JobBillableSheetCommands, ICommonCommands commonCommands)
            : base(JobBillableSheetCommands)
        {
            _commonCommands = commonCommands;
        }

		[ValidateInput(false)]
		public override ActionResult AddOrEdit(JobBillableSheetView jobBillableSheetView)
		{
			jobBillableSheetView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobBillableSheetView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = jobBillableSheetView.Id.GetVarbinaryByteArray(EntitiesAlias.JobBillableSheet, ByteArrayFields.PrcComments.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(jobBillableSheetView, EntitiesAlias.JobBillableSheet);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = jobBillableSheetView.Id > 0 ? base.UpdateForm(jobBillableSheetView) : base.SaveForm(jobBillableSheetView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				route.PreviousRecordId = jobBillableSheetView.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = new DisplayMessage();
				displayMessage = jobBillableSheetView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				if (byteArray != null)
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = jobBillableSheetView.Id == 0, record = result }, JsonRequestBehavior.AllowGet);
				return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = (jobBillableSheetView.Id == 0), record = result }, JsonRequestBehavior.AllowGet);
			}

			return ErrorMessageForInsertOrUpdate(jobBillableSheetView.Id, route);
		}

		public ActionResult RichEditComments(string strRoute)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrcComments.ToString());
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditNotes(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrcComments.ToString());
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}
	}
}