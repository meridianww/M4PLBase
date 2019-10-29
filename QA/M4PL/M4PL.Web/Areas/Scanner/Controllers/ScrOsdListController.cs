/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrOsdList
//Purpose:                                      Contains Actions to render view on ScrOsdList page
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
    public class ScrOsdListController : BaseController<ScrOsdListView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the ScrOsdList details of the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="scrOsdListCommands"></param>
        /// <param name="commonCommands"></param>
        public ScrOsdListController(IScrOsdListCommands scrOsdListCommands, ICommonCommands commonCommands)
            : base(scrOsdListCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ScrOsdListView, long> scrOsdListView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            scrOsdListView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            scrOsdListView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(scrOsdListView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(ScrOsdListView scrOsdListView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(scrOsdListView, Request.Params[WebApplicationConstants.UserDateTime]);
            scrOsdListView.IsFormView = true;
            var messages = ValidateMessages(scrOsdListView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var descriptionByteArray = scrOsdListView.ArbRecordId.GetNvarcharByteArray(EntitiesAlias.ScrOsdList, ByteArrayFields.OSDNote.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var record = scrOsdListView.Id > 0 ? UpdateForm(scrOsdListView) : SaveForm(scrOsdListView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = scrOsdListView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(scrOsdListView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(scrOsdListView.Id, route);
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OSDNote.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.OSDNote.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}