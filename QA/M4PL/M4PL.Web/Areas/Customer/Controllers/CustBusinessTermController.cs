/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerBusinessTerm
//Purpose:                                      Contains Actions to render view on Customer's Business Term page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustBusinessTermController : BaseController<CustBusinessTermView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the customer business terms details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerBusinessTermCommands"></param>
        /// <param name="commonCommands"></param>
        public CustBusinessTermController(ICustBusinessTermCommands customerBusinessTermCommands, ICommonCommands commonCommands)
            : base(customerBusinessTermCommands)
        {
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Peforms edit or update actions on the existing customer business terms records
        /// </summary>
        /// <param name="custBusinessTermView"></param>
        /// <returns></returns>
        public override ActionResult AddOrEdit(CustBusinessTermView custBusinessTermView)
        {
            custBusinessTermView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(custBusinessTermView, Request.Params[WebApplicationConstants.UserDateTime]);
            custBusinessTermView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            custBusinessTermView.CbtCustomerId = custBusinessTermView.ParentId;
            var messages = ValidateMessages(custBusinessTermView);
            var descriptionByteArray = custBusinessTermView.Id.GetVarbinaryByteArray(EntitiesAlias.CustBusinessTerm, ByteArrayFields.CbtDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = custBusinessTermView.Id > 0 ? base.UpdateForm(custBusinessTermView) : base.SaveForm(custBusinessTermView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(custBusinessTermView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(custBusinessTermView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustBusinessTermView, long> custBusinessTermView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);

            var currentThresholdPercentage = (WebUtilities.GetSystemSettings(SessionProvider.ActiveUser.LangCode).Settings.FirstOrDefault(x => x.Entity.Equals(EntitiesAlias.System) && x.Name.Equals(WebApplicationConstants.SysThresholdPercentage)).ToInt() > 0) ? WebUtilities.GetSystemSettings(SessionProvider.ActiveUser.LangCode).Settings.FirstOrDefault(x => x.Entity.Equals(EntitiesAlias.System) && x.Name.Equals(WebApplicationConstants.SysThresholdPercentage)).ToInt() : WebApplicationConstants.DefaultThresholdPercentage;

            custBusinessTermView.Insert.ForEach(c => { c.CbtCustomerId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custBusinessTermView.Update.ForEach(c =>
            {
                c.CbtCustomerId = route.ParentRecordId;
                c.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            });
            var batchError = BatchUpdate(custBusinessTermView, route, gridName);
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CbtDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}