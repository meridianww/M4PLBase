/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrOsdReasonList
//Purpose:                                      Contains Actions to render view on ScrOsdReasonList page
//====================================================================================================================================================*/
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Scanner.Controllers
{
    public class ScrOsdReasonListController : BaseController<ScrOsdReasonListView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the ScrOsdReasonList details of the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="scrOsdReasonListCommands"></param>
        /// <param name="commonCommands"></param>
        public ScrOsdReasonListController(IScrOsdReasonListCommands scrOsdReasonListCommands, ICommonCommands commonCommands)
            : base(scrOsdReasonListCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ScrOsdReasonListView, long> scrOsdReasonListView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            scrOsdReasonListView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            scrOsdReasonListView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(scrOsdReasonListView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(ScrOsdReasonListView scrOsdReasonListView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(scrOsdReasonListView, Request.Params[WebApplicationConstants.UserDateTime]);
            scrOsdReasonListView.IsFormView = true;
            var messages = ValidateMessages(scrOsdReasonListView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var descriptionByteArray = scrOsdReasonListView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.ScrOsdReasonList, ByteArrayFields.ReasonDesc.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var record = scrOsdReasonListView.Id > 0 ? UpdateForm(scrOsdReasonListView) : SaveForm(scrOsdReasonListView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = scrOsdReasonListView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(scrOsdReasonListView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(scrOsdReasonListView.Id, route);
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.ReasonDesc.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.ReasonDesc.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}