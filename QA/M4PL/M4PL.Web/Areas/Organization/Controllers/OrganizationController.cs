/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Organization
//Purpose:                                      Contains Actions to render view on Organization page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Interfaces;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrganizationController : BaseController<OrganizationView>, IPageControl
    {
        private PageControlResult _pageControlResult = new PageControlResult();

        /// <summary>
        /// Interacts with the interfaces to get the Organization details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="organizationCommands"></param>
        /// <param name="commonCommands"></param>
        public OrganizationController(IOrganizationCommands organizationCommands, ICommonCommands commonCommands)
            : base(organizationCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrganizationView, long> organizationView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            var batchError = BatchUpdate(organizationView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(OrganizationView organizationView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(organizationView, Request.Params[WebApplicationConstants.UserDateTime]);
            organizationView.IsFormView = true;
            var messages = ValidateMessages(organizationView);
            var descriptionByteArray = organizationView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Organization, ByteArrayFields.OrgDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);
            organizationView.OrgImage = organizationView.OrgImage == null || organizationView.OrgImage.Length == 0 ? null : organizationView.OrgImage;
            var record = organizationView.Id > 0 ? UpdateForm(organizationView) : SaveForm(organizationView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = organizationView.Id;
                var contactImageByteArray = record.Id.GetImageByteArray(EntitiesAlias.Organization, ByteArrayFields.OrgImage.ToString());
                _commonCommands.SaveBytes(contactImageByteArray, organizationView.OrgImage);
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                if (record.Id > 0 && record.Id == SessionProvider.ActiveUser.OrganizationId)//refresh header
                    route.Url = "UserHeaderCbPanel";//Using in ContentLayout;
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
                return SuccessMessageForInsertOrUpdate(organizationView.Id, route, byteArray, ((organizationView.Id == 0) && SessionProvider.ActiveUser.OrganizationId != record.Id), record.Id);
            }

            return ErrorMessageForInsertOrUpdate(organizationView.Id, route);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;
            SessionProvider.ViewPagedDataSession[EntitiesAlias.Organization].OpenedTabs = null;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new OrganizationView();
            route.CompanyId = _formResult.Record != null ? _formResult.Record.CompanyId : 0;
            BaseRoute.CompanyId = route.CompanyId;
            SessionProvider.ActiveUser.LastRoute.CompanyId = route.CompanyId;
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.Record.ArbRecordId = _formResult.Record.Id == 0 ? new Random().Next(-1000, 0) : _formResult.Record.Id;
            return PartialView(_formResult);
        }

        #region Tab View

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return PartialView(MvcConstants.ViewPageControlPartial, route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Organization));
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OrgDescription.ToString());
            if (route.RecordId == 0 && route.Filters != null && route.Filters.FieldName.Equals("ArbRecordId") && long.TryParse(route.Filters.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.OrgDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion Tab View
    }
}