/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              09/25/2018
//Program Name:                                 CustDcLocationContact
//Purpose:                                      Contains Actions to render view on Customer's DC Location Contact page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustDcLocationContactController : BaseController<CustDcLocationContactView>
    {
        protected ICustDcLocationContactCommands _customerDCLocationContactCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Cusotmer's DC Location details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerDCLocationContactCommands"></param>
        /// <param name="commonCommands"></param>
        public CustDcLocationContactController(ICustDcLocationContactCommands customerDCLocationContactCommands, ICommonCommands commonCommands)
            : base(customerDCLocationContactCommands)
        {
            _commonCommands = commonCommands;
            _customerDCLocationContactCommands = customerDCLocationContactCommands;

        }

        /// <summary>
        /// Performs edit or update action on the existing Customer's DC location records
        /// </summary>
        /// <param name="custDcLocationContactView"></param>
        /// <returns></returns>

        public override ActionResult AddOrEdit(CustDcLocationContactView custDcLocationContactView)
        {
            custDcLocationContactView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(custDcLocationContactView, Request.Params[WebApplicationConstants.UserDateTime]);
            custDcLocationContactView.ConPrimaryRecordId = custDcLocationContactView.ParentId;
            custDcLocationContactView.StatusId = WebApplicationConstants.ActiveStatusId;
            var messages = ValidateMessages(custDcLocationContactView, EntitiesAlias.Contact);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var currentContactId = custDcLocationContactView.Id;
            if (custDcLocationContactView.ContactMSTRID.HasValue)
                custDcLocationContactView.Id = custDcLocationContactView.ContactMSTRID.Value;
            custDcLocationContactView.ContactMSTRID = currentContactId;

            var result = custDcLocationContactView.Id > 0 ? base.UpdateForm(custDcLocationContactView) : base.SaveForm(custDcLocationContactView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView).SetParent(EntitiesAlias.Customer, custDcLocationContactView.ParentId, true);
            if (result is SysRefModel)
            {
                route.RecordId = result.ContactMSTRID.Value;
                route.Url = custDcLocationContactView.ContactMSTRID.ToString();
                route.Entity = EntitiesAlias.CustDcLocation;
                route.SetParent(EntitiesAlias.Customer, result.ParentId);
                return SuccessMessageForInsertOrUpdate(custDcLocationContactView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(custDcLocationContactView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustDcLocationContactView, long> custDcLocationContactView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            custDcLocationContactView.Insert.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custDcLocationContactView.Update.ForEach(c => { c.ConPrimaryRecordId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(custDcLocationContactView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #region Form View

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = _customerDCLocationContactCommands.Get(route.RecordId, route.ParentRecordId);
            _formResult.SetupFormResult(_commonCommands, route);
            if (_formResult.ComboBoxProvider.ContainsKey(Convert.ToInt32(LookupEnums.ContactType)))
                _formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.ContactType)] = _formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.ContactType)].UpdateComboBoxToEditor(Convert.ToInt32(LookupEnums.ContactType),EntitiesAlias.CustDcLocationContact);
            return PartialView(MvcConstants.ViewCustDcLocationContact, _formResult);
        }

        #endregion 
    }
}