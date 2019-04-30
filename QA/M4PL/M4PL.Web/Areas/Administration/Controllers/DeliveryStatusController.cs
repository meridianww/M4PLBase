/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   AKhil
//Date Programmed:                              06/06/2018
//Program Name:                                 DeliveryStatus
//Purpose:                                      Contains Actions to render view on Delivery status over the Pages in the system
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class DeliveryStatusController : BaseController<DeliveryStatusView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the column alias details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="deliveryStatusCommands"></param>
        /// <param name="commonCommands"></param>
        public DeliveryStatusController(IDeliveryStatusCommands deliveryStatusCommands, ICommonCommands commonCommands)
            : base(deliveryStatusCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<DeliveryStatusView, long> deliveryStatusView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            deliveryStatusView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            deliveryStatusView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });

            var batchError = BatchUpdate(deliveryStatusView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(DeliveryStatusView deliveryStatusView)
        {
            deliveryStatusView.IsFormView = true;
            deliveryStatusView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            SessionProvider.ActiveUser.SetRecordDefaults(deliveryStatusView, Request.Params[WebApplicationConstants.UserDateTime]);
            var viewModel = deliveryStatusView as SysRefModel;
            var messages = ValidateMessages(deliveryStatusView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var descriptionByteArray = deliveryStatusView.Id.GetVarbinaryByteArray(EntitiesAlias.DeliveryStatus, ByteArrayFields.DeliveryStatusDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            var record = viewModel.Id > 0 ? UpdateForm(deliveryStatusView) : SaveForm(deliveryStatusView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = deliveryStatusView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(viewModel.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(deliveryStatusView.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.DeliveryStatusDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}