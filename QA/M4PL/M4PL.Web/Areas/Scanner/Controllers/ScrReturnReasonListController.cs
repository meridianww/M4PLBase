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
//Program Name:                                 ScrReturnReasonList
//Purpose:                                      Contains Actions to render view on ScrReturnReasonList page
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
    public class ScrReturnReasonListController : BaseController<ScrReturnReasonListView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the ScrReturnReasonList details of the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="scrReturnReasonListCommands"></param>
        /// <param name="commonCommands"></param>
        public ScrReturnReasonListController(IScrReturnReasonListCommands scrReturnReasonListCommands, ICommonCommands commonCommands)
            : base(scrReturnReasonListCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ScrReturnReasonListView, long> scrReturnReasonListView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            scrReturnReasonListView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            scrReturnReasonListView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(scrReturnReasonListView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(ScrReturnReasonListView scrReturnReasonListView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(scrReturnReasonListView, Request.Params[WebApplicationConstants.UserDateTime]);
            scrReturnReasonListView.IsFormView = true;
            var messages = ValidateMessages(scrReturnReasonListView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var descriptionByteArray = scrReturnReasonListView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.ScrReturnReasonList, ByteArrayFields.ReturnReasonDesc.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var record = scrReturnReasonListView.Id > 0 ? UpdateForm(scrReturnReasonListView) : SaveForm(scrReturnReasonListView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = scrReturnReasonListView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(scrReturnReasonListView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(scrReturnReasonListView.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.ReturnReasonDesc.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.ReturnReasonDesc.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}