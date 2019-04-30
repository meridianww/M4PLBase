/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorDcLocation
//Purpose:                                      Contains Actions to render view on Vendor's DcLocation page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Vendor;
using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class VendDcLocationController : BaseController<VendDcLocationView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Vendor's dc location details and renders to the page
        /// Gets the page related information on the cache basis

        /// </summary>
        /// <param name="vendDCLocationCommands"></param>
        /// <param name="commonCommands"></param>
        public VendDcLocationController(IVendDcLocationCommands vendDCLocationCommands, ICommonCommands commonCommands)
            : base(vendDCLocationCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Performs edit or update action on the existing Vendor's dc location record
        /// </summary>
        /// <param name="vendDcLocationView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(VendDcLocationView vendDcLocationView)
        {
            vendDcLocationView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(vendDcLocationView, Request.Params[WebApplicationConstants.UserDateTime]);
            vendDcLocationView.VdcVendorID = vendDcLocationView.ParentId;
            var messages = ValidateMessages(vendDcLocationView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = vendDcLocationView.Id > 0 ? base.UpdateForm(vendDcLocationView) : base.SaveForm(vendDcLocationView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(vendDcLocationView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(vendDcLocationView.Id, route);

        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendDcLocationView, long> vendDcLocationView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            vendDcLocationView.Insert.ForEach(c => { c.VdcVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            vendDcLocationView.Update.ForEach(c => { c.VdcVendorID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(vendDcLocationView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            long expandRowId;
            Int64.TryParse(route.Url, out expandRowId);
            base.DataView(strRoute);
            _gridResult.GridSetting.ChildGridRoute.ParentRecordId = expandRowId;
            return PartialView(_gridResult);
        }
    }
}