/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerDocReference
//Purpose:                                      Contains Actions to render view on Customer's Document Reference page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustDocReferenceController : BaseController<CustDocReferenceView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Customer's document reference details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerDocReferenceCommands"></param>
        /// <param name="commonCommands"></param>
        public CustDocReferenceController(ICustDocReferenceCommands customerDocReferenceCommands, ICommonCommands commonCommands)
            : base(customerDocReferenceCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Customer's document reference records
        /// </summary>
        /// <param name="custDocReferenceView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(CustDocReferenceView custDocReferenceView)
        {
            custDocReferenceView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(custDocReferenceView, Request.Params[WebApplicationConstants.UserDateTime]);
            custDocReferenceView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            custDocReferenceView.CdrCustomerID = custDocReferenceView.ParentId;
            var messages = ValidateMessages(custDocReferenceView);
            var descriptionByteArray = custDocReferenceView.Id.GetVarbinaryByteArray(EntitiesAlias.CustDocReference, ByteArrayFields.CdrDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = custDocReferenceView.Id > 0 ? base.UpdateForm(custDocReferenceView) : base.SaveForm(custDocReferenceView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(custDocReferenceView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(custDocReferenceView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustDocReferenceView, long> custDocReferenceView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);

            custDocReferenceView.Insert.ForEach(c => { c.CdrCustomerID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custDocReferenceView.Update.ForEach(c => { c.CdrCustomerID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(custDocReferenceView, route, gridName);
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

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CdrDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}