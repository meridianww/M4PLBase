/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrServiceList
//Purpose:                                      Contains Actions to render view on ScrServiceList page
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
    public class ScrServiceListController : BaseController<ScrServiceListView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the ScrServiceList details of the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="scrServiceListCommands"></param>
        /// <param name="commonCommands"></param>
        public ScrServiceListController(IScrServiceListCommands scrServiceListCommands, ICommonCommands commonCommands)
            : base(scrServiceListCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ScrServiceListView, long> scrServiceListView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            scrServiceListView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            scrServiceListView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(scrServiceListView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }


        public override ActionResult AddOrEdit(ScrServiceListView scrServiceListView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(scrServiceListView, Request.Params[WebApplicationConstants.UserDateTime]);
            scrServiceListView.IsFormView = true;
            var messages = ValidateMessages(scrServiceListView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var descriptionByteArray = scrServiceListView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.ScrServiceList, ByteArrayFields.ServiceDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var record = scrServiceListView.Id > 0 ? UpdateForm(scrServiceListView) : SaveForm(scrServiceListView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = scrServiceListView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(scrServiceListView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(scrServiceListView.Id, route);
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.ServiceDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.ServiceDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}