/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Vendor
//Purpose:                                      Contains Actions to render view on Vendor page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Vendor;
using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Interfaces;
using M4PL.Web.Models;
using M4PL.Utilities;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class VendorController : BaseController<VendorView>, IPageControl
    {
        private PageControlResult _pageControlResult = new PageControlResult();

        /// <summary>
        /// Interacts with the interfaces to get the Vendor details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="vendorCommands"></param>
        /// <param name="commonCommands"></param>
        public VendorController(IVendorCommands vendorCommands, ICommonCommands commonCommands)
            : base(vendorCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<VendorView, long> vendorView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Organization, SessionProvider.ActiveUser.OrganizationId);
            vendorView.Insert.ForEach(c => { c.VendOrgID = SessionProvider.ActiveUser.OrganizationId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            vendorView.Update.ForEach(c => { c.VendOrgID = SessionProvider.ActiveUser.OrganizationId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(vendorView, route, gridName);
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

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            return base.DataView(JsonConvert.SerializeObject(route));
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            CommonIds maxMinFormData = null;
            maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(route.Entity.ToString(), route.ParentRecordId, route.RecordId);
            if (maxMinFormData != null)
            {
                _formResult.MaxID = maxMinFormData.MaxID;
                _formResult.MinID = maxMinFormData.MinID;
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
                if (maxMinFormData != null)
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].MaxID = maxMinFormData.MaxID;
                    SessionProvider.ViewPagedDataSession[route.Entity].MinID = maxMinFormData.MinID;
                }
            }
            _formResult.SessionProvider = SessionProvider;
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            SessionProvider.ViewPagedDataSession[EntitiesAlias.Vendor].OpenedTabs = null;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new VendorView();
            route.CompanyId = _formResult.Record != null ? _formResult.Record.CompanyId : 0;
            BaseRoute.CompanyId = route.CompanyId;
            SessionProvider.ActiveUser.LastRoute.CompanyId = route.CompanyId;
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.Record.ArbRecordId = _formResult.Record.Id == 0 ? new System.Random().Next(-1000, 0) : _formResult.Record.Id;
            return PartialView(_formResult);
        }

        public override ActionResult AddOrEdit(VendorView vendorView)
        {
            vendorView.IsFormView = true;
            var updateVendorTypeCodeCache = false;
            SessionProvider.ActiveUser.SetRecordDefaults(vendorView, Request.Params[WebApplicationConstants.UserDateTime]);
            vendorView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            vendorView.VendOrgID = SessionProvider.ActiveUser.OrganizationId;
            vendorView.VendTypeCode = Request.Form[VendColumnNames.VendTypeId.ToString()];
            if (string.IsNullOrWhiteSpace(vendorView.VendTypeCode) || vendorView.VendTypeCode.EqualsOrdIgnoreCase(WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.Vendor), SessionProvider).FirstOrDefault(VendColumnNames.VendTypeId.ToString()).ColCaption)))
            {
                vendorView.VendTypeCode = null;
                vendorView.VendTypeId = null;
            }
            if (!string.IsNullOrWhiteSpace(vendorView.VendTypeCode) && !vendorView.VendTypeId.HasValue)
            {
                vendorView.VendTypeId = 0;
                updateVendorTypeCodeCache = true;
            }

            var allSavedActivatedTabs = SessionProvider.ViewPagedDataSession[EntitiesAlias.Vendor].OpenedTabs.SplitComma().ToList();
            var addressTabIndex = BaseRoute.GetTabExecuteProgramIndex(SessionProvider, _commonCommands, MainModule.Vendor, MvcConstants.ActionAddressFormView);
            if (allSavedActivatedTabs.IndexOf(addressTabIndex.ToString()) > -1)
            {
                if (vendorView.VendBusinessAddressId == null)
                    vendorView.VendBusinessAddressId = 0;
                if (vendorView.VendCorporateAddressId == null)
                    vendorView.VendCorporateAddressId = 0;
                if (vendorView.VendWorkAddressId == null)
                    vendorView.VendWorkAddressId = 0;
            }

            var messages = ValidateMessages(vendorView);
            var descriptionByteArray = vendorView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Vendor, ByteArrayFields.VendDescription.ToString());
            var notesByteArray = vendorView.Id.GetVarbinaryByteArray(EntitiesAlias.Vendor, ByteArrayFields.VendNotes.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, notesByteArray
            };
            if (messages.Any())
                return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);
            vendorView.VendLogo = vendorView.VendLogo == null || vendorView.VendLogo.Length == 0 ? null : vendorView.VendLogo;
            var record = vendorView.Id > 0 ? UpdateForm(vendorView) : SaveForm(vendorView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = vendorView.Id;
                var vendLogoByteArray = record.Id.GetImageByteArray(EntitiesAlias.Vendor, ByteArrayFields.VendLogo.ToString());
                _commonCommands.SaveBytes(vendLogoByteArray, vendorView.VendLogo);

                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                notesByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                if (updateVendorTypeCodeCache)
                    _commonCommands.GetIdRefLangNames(LookupEnums.VendorType.ToInt(), true);// Refresh Cache

                return SuccessMessageForInsertOrUpdate(vendorView.Id, route, byteArray);
            }

            return ErrorMessageForInsertOrUpdate(vendorView.Id, route);
        }

        #region Tab View

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            WebUtilities.SaveActiveTab(EntitiesAlias.Vendor, route.TabIndex, SessionProvider);
            return PartialView(MvcConstants.ViewPageControlPartial, route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Vendor));
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.VendDescription.ToString());
            if (route.RecordId == 0 && route.Filters != null && route.Filters.FieldName.Equals("ArbRecordId") && long.TryParse(route.Filters.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.VendDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditNotes(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.VendNotes.ToString());

            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion Tab View
    }
}