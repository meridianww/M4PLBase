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
//Program Name:                                 MessageType
//Purpose:                                      Contains Actions to render view on Administration Message Type's page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class MessageTypeController : BaseController<MessageTypeView>
    {
        /// <summary>
        /// /// <summary>
        /// Interacts with the interfaces to get the message type details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// </summary>
        /// <param name="messageTypeCommands"></param>
        /// <param name="commonCommands"></param>
        public MessageTypeController(IMessageTypeCommands messageTypeCommands, ICommonCommands commonCommands)
            : base(messageTypeCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<MessageTypeView, long> messageTypeView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            messageTypeView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            messageTypeView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(messageTypeView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(MessageTypeView messageTypeView)
        {
            messageTypeView.IsFormView = true;
            var messages = ValidateMessages(messageTypeView);
            var descriptionByteArray = messageTypeView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.MessageType, ByteArrayFields.SysMsgTypeDescription.ToString());
            var byteArray = new List<ByteArray> { descriptionByteArray };

            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            messageTypeView.SysMsgTypeHeaderIcon = messageTypeView.SysMsgTypeHeaderIcon == null || messageTypeView.SysMsgTypeHeaderIcon.Length == 0 ? null : messageTypeView.SysMsgTypeHeaderIcon;
            messageTypeView.SysMsgTypeIcon = messageTypeView.SysMsgTypeIcon == null || messageTypeView.SysMsgTypeIcon.Length == 0 ? null : messageTypeView.SysMsgTypeIcon;

            var record = messageTypeView.Id > 0 ? UpdateForm(messageTypeView) : SaveForm(messageTypeView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = messageTypeView.Id;
                var sysMsgTypeHeaderIconByteArray = record.Id.GetImageByteArray(EntitiesAlias.MessageType, ByteArrayFields.SysMsgTypeHeaderIcon.ToString());
                var sysMsgTypeIconByteArray = record.Id.GetImageByteArray(EntitiesAlias.MessageType, ByteArrayFields.SysMsgTypeIcon.ToString());
                _commonCommands.SaveBytes(sysMsgTypeHeaderIconByteArray, messageTypeView.SysMsgTypeHeaderIcon);
                _commonCommands.SaveBytes(sysMsgTypeIconByteArray, messageTypeView.SysMsgTypeIcon);
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(messageTypeView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(messageTypeView.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.SysMsgTypeDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.SysMsgTypeDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}