/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              25/07/2019
//Program Name:                                 JobCostSheet
//Purpose:                                      Contains Actions to render view on Job's  Cost Sheet page
//====================================================================================================================================================*/

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
    public class JobCostSheetController : BaseController<JobCostSheetView>
    {
        
        public JobCostSheetController(IJobCostSheetCommands JobCostSheetCommands, ICommonCommands commonCommands)
            : base(JobCostSheetCommands)
        {
            _commonCommands = commonCommands;
        }

		[ValidateInput(false)]
		public override ActionResult AddOrEdit(JobCostSheetView jobCostSheetView)
		{
			jobCostSheetView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(jobCostSheetView, Request.Params[WebApplicationConstants.UserDateTime]);

			var descriptionByteArray = jobCostSheetView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobCostSheet, ByteArrayFields.CstComments.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};

			var messages = ValidateMessages(jobCostSheetView, EntitiesAlias.JobCostSheet);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = jobCostSheetView.Id > 0 ? base.UpdateForm(jobCostSheetView) : base.SaveForm(jobCostSheetView);

			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.RecordId = result.Id;
				route.PreviousRecordId = jobCostSheetView.Id;
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				var displayMessage = new DisplayMessage();
				displayMessage = jobCostSheetView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				if (byteArray != null)
					return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = jobCostSheetView.Id == 0, record = result }, JsonRequestBehavior.AllowGet);
				return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = (jobCostSheetView.Id == 0), record = result }, JsonRequestBehavior.AllowGet);
			}

			return ErrorMessageForInsertOrUpdate(jobCostSheetView.Id, route);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CstComments.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.CstComments.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditNotes(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CstComments.ToString());
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}
	}
}