/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Contact
//Purpose:                                      Contains Actions to render view on Contact page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.CompanyAddress;
using M4PL.APIClient.Contact;
using M4PL.APIClient.ViewModels;
using M4PL.APIClient.ViewModels.CompanyAddress;
using M4PL.APIClient.ViewModels.Contact;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Contact.Controllers
{
    public class ContactController : BaseController<ContactView>
    {
        private readonly IContactCommands _contactCommands;

        /// <summary>
        /// Interacts with the interfaces to get the contacts details of the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="contactCommands"></param>
        /// <param name="commonCommands"></param>
        public ContactController(IContactCommands contactCommands, ICommonCommands commonCommands)
            : base(contactCommands)
        {
            _contactCommands = contactCommands;
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ContactView, long> contactView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            contactView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            contactView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var isLoggedInUserStatusChanged = false;
            var updateErrors = new System.Collections.Generic.Dictionary<long, string>();
            foreach (var item in contactView.Update)
            {
                if (item.StatusId > WebApplicationConstants.ActiveStatusId)
                {
                    if (item.StatusId > WebApplicationConstants.InactiveStatusId)
                    {
                        if (_commonCommands.CheckRecordUsed(item.Id.ToString(), EntitiesAlias.Contact))
                        {
                            var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.DeleteMoreInfo);
                            displayMessage.Description = "Selected record is associated with the other modules."; //-> Once Delete More info page will be done, will remove this line.
                            contactView.SetErrorText(item, displayMessage.Description);
                            if (!updateErrors.ContainsKey(-100))
                                updateErrors.Add(-100, "ModelInValid");
                        }
                    }
                    if (!updateErrors.Any(b => b.Key == -100))
                        isLoggedInUserStatusChanged = _contactCommands.CheckContactLoggedIn(item.Id);
                }
            }

            if (!updateErrors.Any(b => b.Key == -100))
            {
                var batchError = BatchUpdate(contactView, route, gridName);
                if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
                {
                    var displayMessage = batchError.Count == 0 ? isLoggedInUserStatusChanged ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                    displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                    ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
                }
            }

            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(ContactView contactView)
        {
            contactView.IsFormView = true;
            var isContactCard = contactView.StatusId == null;
            var isLoggedInUserStatusChanged = false;
            if ((contactView.Id == 0) && (contactView.StatusId == null))
                contactView.StatusId = WebApplicationConstants.ActiveStatusId;
            else if ((contactView.Id > 0) && (contactView.StatusId > WebApplicationConstants.ActiveStatusId))
            {
                if (contactView.StatusId > WebApplicationConstants.InactiveStatusId)
                {
                    if (_commonCommands.CheckRecordUsed(contactView.Id.ToString(), EntitiesAlias.Contact))
                    {
                        var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.DeleteMoreInfo);
                        displayMessage.Description = "Selected record is associated with the other modules."; //-> Once Delete More info page will be done, will remove this line.
                        return Json(new { status = false, errMessages = new System.Collections.Generic.List<string> { displayMessage.Description } }, JsonRequestBehavior.AllowGet);
                    }
                }
                isLoggedInUserStatusChanged = _contactCommands.CheckContactLoggedIn(contactView.Id);
            }
            SessionProvider.ActiveUser.SetRecordDefaults(contactView, Request.Params[WebApplicationConstants.UserDateTime]);
            contactView.ConImage = contactView.ConImage == null || contactView.ConImage.Length == 0 ? null : contactView.ConImage;
            var messages = ValidateMessages(contactView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var record = (isContactCard) ? (contactView.Id > 0) ? _contactCommands.PutContactCard(contactView) : _contactCommands.PostContactCard(contactView) : (contactView.Id > 0) ? UpdateForm(contactView) : SaveForm(contactView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            route.RecordId = record.Id;
            route.PreviousRecordId = contactView.Id;
            route.CompanyId = contactView.ConCompanyId;
            if (record is SysRefModel)
            {
                if (record.Id == SessionProvider.ActiveUser.ContactId)//refresh header
                    route.Url = "UserHeaderCbPanel";//Using in ContentLayout;
                if (isContactCard)
                    return Json(new { status = true, route = route }, JsonRequestBehavior.AllowGet);
                else
                {
                    var contactImageByteArray = record.Id.GetImageByteArray(EntitiesAlias.Contact, ByteArrayFields.ConImage.ToString());
                    _commonCommands.SaveBytes(contactImageByteArray, contactView.ConImage);
                }
                if (isLoggedInUserStatusChanged)
                {
                    var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess);
                    displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                    return Json(new { status = true, route = route, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
                }
                else
                    return SuccessMessageForInsertOrUpdate(contactView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(contactView.Id, route);
        }

        #region Paste Form View

        public override ActionResult PasteFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            CopyRecord(route.RecordIdToCopy);
            route.RecordIdToCopy = 0;
            _formResult.SetupFormResult(_commonCommands, route);
            return PartialView(MvcConstants.ActionForm, _formResult);
        }

        internal override void CopyRecord(long recordId)
        {
            base.CopyRecord(recordId);
            _formResult.Record.Id = 0;
            //Below for nullifying entity specific properties(not required/unique ones)
            _formResult.Record.ConMiddleName = null;
            _formResult.Record.ConJobTitle = null;
            _formResult.Record.ConImage = null;
            _formResult.Record.ConBusinessPhoneExt = null;
            _formResult.Record.ConHomePhone = null;
            _formResult.Record.ConMobilePhone = null;
            _formResult.Record.ConEmailAddress = null;
            _formResult.Record.ConEmailAddress2 = null;
            _formResult.Record.ConHomeAddress1 = null;
            _formResult.Record.ConHomeAddress2 = null;
            _formResult.Record.ConHomeCity = null;
            _formResult.Record.ConHomeStateId = null;
            _formResult.Record.ConHomeZipPostal = null;
            _formResult.Record.ConHomeCountryId = null;
            _formResult.Record.ConAttachments = null;
            _formResult.Record.ConFullName = null;
            _formResult.Record.ConFileAs = null;
        }

        #endregion Paste Form View

        #region Contact Card

        public ActionResult ContactCardFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            var dropDownViewModel = new DropDownViewModel();
            dropDownViewModel.ParentId = route.ParentRecordId;
            if (route.Filters != null)
            {
                dropDownViewModel.JobSiteCode = route.Filters.FieldName;

            }
            if (RouteData.Values.ContainsKey("strDropDownViewModel") && (RouteData.Values["strDropDownViewModel"] != null))
            {
                dropDownViewModel.JobSiteCode = route.Filters.FieldName;

            }
            if (RouteData.Values.ContainsKey("strDropDownViewModel") && (RouteData.Values["strDropDownViewModel"] != null))
            {
                dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
            }
            ConcurrentDictionary<EntitiesAlias, ConcurrentDictionary<long, ViewResultInfo>> Data = _formResult.SessionProvider.ResultViewSession;
            _formResult.Record = route.RecordId > 0 ? _commonCommands.GetContactById(route.RecordId) : route.CompanyId.HasValue && route.CompanyId > 0 ? _commonCommands.GetContactAddressByCompany((long)route.CompanyId) : new ContactView();
            if (route.RecordId == 0)
            {
                _formResult.Record.JobId = route.PreviousRecordId;
            }

                if (!string.IsNullOrEmpty(dropDownViewModel.JobSiteCode))
                _formResult.Record.JobSiteCode = dropDownViewModel.JobSiteCode;

            if (dropDownViewModel.ParentId != null && Convert.ToInt64(dropDownViewModel.ParentId) > 0)
            {
                _formResult.Record.ParentId = Convert.ToInt64(dropDownViewModel.ParentId);
                route.ParentRecordId = Convert.ToInt64(dropDownViewModel.ParentId);
            }

            _formResult.ControlNameSuffix = EntitiesAlias.Contact.ToString();
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);
            BaseRoute.CompanyId = route.CompanyId;
            if (route.OwnerCbPanel == WebApplicationConstants.JobDriverCBPanel)
            {

                _formResult.ColumnSettings.Where(c => c.ColColumnName == ContactColumnNames.ConTypeId.ToString()).FirstOrDefault().ColIsReadOnly = true;
                if (_formResult.ComboBoxProvider.ContainsKey(Convert.ToInt32(LookupEnums.ContactType)))
                    _formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.ContactType)] = _formResult.ComboBoxProvider[Convert.ToInt32(LookupEnums.ContactType)].UpdateComboBoxToEditor(Convert.ToInt32(LookupEnums.ContactType), EntitiesAlias.JobDriverContactInfo);
            }
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            return PartialView(MvcConstants.ViewContactCardPartial, _formResult);
        }
        public ActionResult CompanyAddressCardFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = new ContactView();
            _formResult.ControlNameSuffix = EntitiesAlias.Contact.ToString();
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);

            return PartialView(MvcConstants.ViewContactCardPartial, _formResult);
        }
        #endregion 
    }
}