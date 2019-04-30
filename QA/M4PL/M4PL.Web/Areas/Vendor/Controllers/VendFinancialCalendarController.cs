/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorFinancialCalendar
//Purpose:                                      Contains Actions to render view on Vendor's Financial Calendar page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Vendor;
using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class VendFinancialCalendarController : BaseController<VendFinancialCalendarView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Vendor's financial calendar details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="vendFinancialCalendarCommands"></param>
        /// <param name="commonCommands"></param>
        public VendFinancialCalendarController(IVendFinancialCalendarCommands vendFinancialCalendarCommands, ICommonCommands commonCommands)
            : base(vendFinancialCalendarCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Vendor's financial calendar record
        /// </summary>
        /// <param name="vendFinancialCalendarView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(VendFinancialCalendarView vendFinancialCalendarView)
        {
            vendFinancialCalendarView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(vendFinancialCalendarView, Request.Params[WebApplicationConstants.UserDateTime]);
            vendFinancialCalendarView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            vendFinancialCalendarView.VendID = vendFinancialCalendarView.ParentId;
            var messages = ValidateMessages(vendFinancialCalendarView);
            var descriptionByteArray = vendFinancialCalendarView.Id.GetVarbinaryByteArray(EntitiesAlias.VendFinancialCalendar, ByteArrayFields.FclDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = vendFinancialCalendarView.Id > 0 ? base.UpdateForm(vendFinancialCalendarView) : base.SaveForm(vendFinancialCalendarView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(vendFinancialCalendarView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(vendFinancialCalendarView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendFinancialCalendarView, long> vendFinancialCalendarView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            vendFinancialCalendarView.Insert.ForEach(c => { c.VendID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            vendFinancialCalendarView.Update.ForEach(c => { c.VendID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(vendFinancialCalendarView, route, gridName);
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

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.FclDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}