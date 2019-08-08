/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorContact
//Purpose:                                      Contains Actions to render view on Vendor's Contact page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Vendor;
using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class VendContactController : BaseController<VendContactView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Vendor's contact details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="vendContactCommands"></param>
        /// <param name="commonCommands"></param>
        public VendContactController(IVendContactCommands vendContactCommands, ICommonCommands commonCommands)
            : base(vendContactCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Vendor's contact record
        /// </summary>
        /// <param name="vendContactView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(VendContactView vendContactView)
        {
            vendContactView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(vendContactView, Request.Params[WebApplicationConstants.UserDateTime]);
            vendContactView.ConPrimaryRecordId = vendContactView.ParentId;
            var messages = ValidateMessages(vendContactView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var record = vendContactView.Id > 0 ? base.UpdateForm(vendContactView) : base.SaveForm(vendContactView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView, SessionProvider.ActiveUser.LastRoute.CompanyId);
            return SuccessMessageForInsertOrUpdate(vendContactView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendContactView, long> vendContactView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            vendContactView.Insert.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            vendContactView.Update.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(vendContactView, route, gridName);
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