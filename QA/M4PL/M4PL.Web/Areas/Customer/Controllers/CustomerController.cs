/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Customer
//Purpose:                                      Contains Actions to render view on Customer page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Interfaces;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustomerController : BaseController<CustomerView>, IPageControl
    {
        private PageControlResult _pageControlResult = new PageControlResult();

        /// <summary>
        /// Interacts with the interfaces to get the Customer details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="customerCommands"></param>
        /// <param name="commonCommands"></param>
        public CustomerController(ICustomerCommands customerCommands, ICommonCommands commonCommands)
            : base(customerCommands)
        {
            _commonCommands = commonCommands;
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", string WhereJobAdance = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            return base.DataView(JsonConvert.SerializeObject(route));
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustomerView, long> customerView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Organization, SessionProvider.ActiveUser.OrganizationId);
            customerView.Insert.ForEach(c => { c.CustOrgId = SessionProvider.ActiveUser.OrganizationId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            customerView.Update.ForEach(c => { c.CustOrgId = SessionProvider.ActiveUser.OrganizationId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(customerView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            route.ParentEntity = EntitiesAlias.Common;
            route.ParentRecordId = 0;
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            if (!route.IsPopup && route.RecordId != 0)
            {
                var pagedDataInfo = new PagedDataInfo()
                {
                    Entity = route.Entity,
                };
                var data = _commonCommands.GetMaxMinRecordsByEntity(pagedDataInfo, route.ParentRecordId, route.RecordId);
                if (data != null)
                {
                    _formResult.MaxID = data.MaxID;
                    _formResult.MinID = data.MinID;
                }
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            SessionProvider.ViewPagedDataSession[EntitiesAlias.Customer].OpenedTabs = null;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new CustomerView();
            route.CompanyId = _formResult.Record != null ? _formResult.Record.CompanyId : 0;
            BaseRoute.CompanyId = route.CompanyId;
            SessionProvider.ActiveUser.LastRoute.CompanyId = route.CompanyId;
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.Record.ArbRecordId = _formResult.Record.Id == 0 ? new Random().Next(-1000, 0) : _formResult.Record.Id;
            return PartialView(_formResult);
        }

        public override ActionResult AddOrEdit(CustomerView customerView)
        {
            customerView.IsFormView = true;
            var updateCustomerTypeCodeCache = false;
            SessionProvider.ActiveUser.SetRecordDefaults(customerView, Request.Params[WebApplicationConstants.UserDateTime]);
            customerView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            customerView.CustOrgId = SessionProvider.ActiveUser.OrganizationId;
            customerView.CustTypeCode = Request.Form[CustColumnNames.CustTypeId.ToString()];
            if (string.IsNullOrWhiteSpace(customerView.CustTypeCode) || customerView.CustTypeCode.EqualsOrdIgnoreCase(WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.Customer), SessionProvider).FirstOrDefault(CustColumnNames.CustTypeId.ToString()).ColCaption)))
            {
                customerView.CustTypeCode = null;
                customerView.CustTypeId = null;
            }
            if (!string.IsNullOrWhiteSpace(customerView.CustTypeCode) && !customerView.CustTypeId.HasValue)
            {
                customerView.CustTypeId = 0;
                updateCustomerTypeCodeCache = true;
            }

            var allSavedActivatedTabs = SessionProvider.ViewPagedDataSession[EntitiesAlias.Customer].OpenedTabs.SplitComma().ToList();
            var addressTabIndex = BaseRoute.GetTabExecuteProgramIndex(SessionProvider, _commonCommands, MainModule.Customer, MvcConstants.ActionAddressFormView);
            if (allSavedActivatedTabs.IndexOf(addressTabIndex.ToString()) > -1)
            {
                if (customerView.CustBusinessAddressId == null)
                    customerView.CustBusinessAddressId = 0;
                if (customerView.CustCorporateAddressId == null)
                    customerView.CustCorporateAddressId = 0;
                if (customerView.CustWorkAddressId == null)
                    customerView.CustWorkAddressId = 0;
            }

            var messages = ValidateMessages(customerView);
            var descriptionByteArray = customerView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Customer, ByteArrayFields.CustDescription.ToString());
            var notesByteArray = customerView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Customer, ByteArrayFields.CustNotes.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, notesByteArray
            };
            if (messages.Any())
                return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);
            customerView.CustLogo = customerView.CustLogo == null || customerView.CustLogo.Length == 0 ? null : customerView.CustLogo;
            var record = customerView.Id > 0 ? UpdateForm(customerView) : SaveForm(customerView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = customerView.Id;
                var custLogoByteArray = record.Id.GetImageByteArray(EntitiesAlias.Customer, ByteArrayFields.CustLogo.ToString());
                _commonCommands.SaveBytes(custLogoByteArray, customerView.CustLogo);

                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                notesByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                if (updateCustomerTypeCodeCache)
                    _commonCommands.GetIdRefLangNames(LookupEnums.CustomerType.ToInt(), true);// Refresh Cache

                return SuccessMessageForInsertOrUpdate(customerView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(customerView.Id, route);
        }

        #region Tab View

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            WebUtilities.SaveActiveTab(EntitiesAlias.Customer, route.TabIndex, SessionProvider);
            return PartialView(MvcConstants.ViewPageControlPartial, route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Customer));
        }

        public virtual PartialViewResult AddressFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.Record = _currentEntityCommands.Get(route.RecordId);
            _formResult.ColumnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(route.Entity), SessionProvider);
            _formResult.SessionProvider = SessionProvider;
            return PartialView(_formResult);
        }

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            long newDocumentId;
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CustDescription.ToString());
            if (route.RecordId == 0 && route.Filters != null && route.Filters.FieldName.Equals("ArbRecordId") && long.TryParse(route.Filters.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.CustDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditNotes(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CustNotes.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion Tab View
    }
}