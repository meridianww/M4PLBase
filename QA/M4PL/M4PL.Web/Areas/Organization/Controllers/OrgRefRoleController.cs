/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationRefRole
//Purpose:                                      Contains Actions to render view on Organization's Ref Role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgRefRoleController : BaseController<OrgRefRoleView>
    {
       

        /// <summary>
        /// Interacts with the interfaces to get the Organization's ref role details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgRefRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgRefRoleController(IOrgRefRoleCommands orgRefRoleCommands, ICommonCommands commonCommands)
            : base(orgRefRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgRefRoleView orgRefRoleView)
        {
            orgRefRoleView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(orgRefRoleView, Request.Params[WebApplicationConstants.UserDateTime]);
            orgRefRoleView.OrgID = SessionProvider.ActiveUser.OrganizationId;
            orgRefRoleView.OrganizationId = SessionProvider.ActiveUser.OrganizationId;
            var messages = ValidateMessages(orgRefRoleView);
            var descriptionByteArray = orgRefRoleView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgRefRole, ByteArrayFields.OrgRoleDescription.ToString());
            var commentByteArray = orgRefRoleView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgRefRole, ByteArrayFields.OrgComments.ToString());
            var byteArray = new List<ByteArray> { descriptionByteArray, commentByteArray };

            if (orgRefRoleView.Id > 0 && _commonCommands.GetRefRoleSecurities(new ActiveUser { UserId = SessionProvider.ActiveUser.UserId, RoleId = orgRefRoleView.Id }).Count == 0)
                messages.Add(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.NoSecuredModule).Description);

            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = orgRefRoleView.Id > 0 ? base.UpdateForm(orgRefRoleView) : base.SaveForm(orgRefRoleView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView).SetParent(EntitiesAlias.Organization, orgRefRoleView.ParentId);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = orgRefRoleView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(orgRefRoleView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgRefRoleView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgRefRoleView, long> orgRefRoleView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            orgRefRoleView.Insert.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            orgRefRoleView.Update.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            var batchError = BatchUpdate(orgRefRoleView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        #region Tab View

        public ActionResult TabView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.RecordId == 0)
                route.Url = string.Empty;
            route.EntityName = _commonCommands.Tables[route.Entity].TblLangName;
            if (route.RecordId > 0)
            {
                var currentRefRole = _currentEntityCommands.Get(route.RecordId);
                if (currentRefRole != null)
                    route.Url = string.Concat(currentRefRole.OrgRoleCode, WebApplicationConstants.M4PLSeparator, currentRefRole.OrgRoleContactID.GetValueOrDefault(), WebApplicationConstants.M4PLSeparator, currentRefRole.OrgRoleTitle);
            }
            route.SetParent(EntitiesAlias.OrgRefRole, route.RecordId);
            return PartialView(MvcConstants.ViewTab, route);
        }

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(route.Entity).Select(x => x.CopyPageInfos()).ToList(),
                CallBackRoute = route,
            };

            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
                if ((pageInfo.TabTableName == EntitiesAlias.SecurityByRole.ToString()) && (!string.IsNullOrWhiteSpace(route.Url)))
                {
                    var currentPageTitle = (pageInfo.TabPageTitle.IndexOf(" - ") > -1) ? pageInfo.TabPageTitle.Remove(pageInfo.TabPageTitle.IndexOf(" - "), pageInfo.TabPageTitle.Length - pageInfo.TabPageTitle.IndexOf(" - ")) : pageInfo.TabPageTitle;
                    pageInfo.TabPageTitle = string.Concat(currentPageTitle, " - ", route.Url.Split(new[] { WebApplicationConstants.M4PLSeparator }, StringSplitOptions.None)[0]);
                }
            }

            return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
        }

        #endregion Tab View

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OrgRoleDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditComments(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.OrgComments.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
           
            if (route.ParentEntity == EntitiesAlias.OrgRefRole)
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            return base.FormView(JsonConvert.SerializeObject(route));
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentEntity = EntitiesAlias.Common;
            route.ParentRecordId = 0;
            base.DataView(JsonConvert.SerializeObject(route));
            return PartialView(_gridResult);
        }
    }
}