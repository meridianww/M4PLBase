/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerContact
//Purpose:                                      Contains Actions to render view on Cusotmer's contact page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustContactController : BaseController<CustContactView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the customer's contact details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerContactCommands"></param>
        /// <param name="commonCommands"></param>
        public CustContactController(ICustContactCommands customerContactCommands, ICommonCommands commonCommands)
            : base(customerContactCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Customer contact records
        /// </summary>
        /// <param name="custContactView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(CustContactView custContactView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(custContactView, Request.Params[WebApplicationConstants.UserDateTime]);
            custContactView.IsFormView = true;
            custContactView.ConPrimaryRecordId = custContactView.ParentId;
            var messages = ValidateMessages(custContactView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = custContactView.Id > 0 ? base.UpdateForm(custContactView) : base.SaveForm(custContactView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            return SuccessMessageForInsertOrUpdate(custContactView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustContactView, long> custContactView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            custContactView.Insert.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custContactView.Update.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(custContactView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
    }
}