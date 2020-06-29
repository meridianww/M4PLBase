/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerFinancialCalendar
//Purpose:                                      Contains Actions to render view on Customer's Financial Calender page
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
    public class CustFinancialCalendarController : BaseController<CustFinancialCalendarView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Customer's financial calender details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerFinancialCalendarCommands"></param>
        /// <param name="commonCommands"></param>
        public CustFinancialCalendarController(ICustFinancialCalendarCommands customerFinancialCalendarCommands, ICommonCommands commonCommands)
            : base(customerFinancialCalendarCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Customer's financial calender records
        /// </summary>
        /// <param name="custFinancialCalendarView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(CustFinancialCalendarView custFinancialCalendarView)
        {
            custFinancialCalendarView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(custFinancialCalendarView, Request.Params[WebApplicationConstants.UserDateTime]);
            custFinancialCalendarView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            custFinancialCalendarView.CustID = custFinancialCalendarView.ParentId;
            var messages = ValidateMessages(custFinancialCalendarView);
            var descriptionByteArray = custFinancialCalendarView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.CustFinancialCalendar, ByteArrayFields.FclDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = custFinancialCalendarView.Id > 0 ? base.UpdateForm(custFinancialCalendarView) : base.SaveForm(custFinancialCalendarView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(custFinancialCalendarView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(custFinancialCalendarView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustFinancialCalendarView, long> custFinancialCalendarView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            custFinancialCalendarView.Insert.ForEach(c => { c.CustID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custFinancialCalendarView.Update.ForEach(c => { c.CustID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(custFinancialCalendarView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.FclDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.FclDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}