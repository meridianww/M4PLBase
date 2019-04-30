/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrgActRole
//Purpose:                                      Contains Actions to render view on Organization's Act role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Text;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgActRoleController : BaseController<OrgActRoleView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Organization's act role details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgActRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgActRoleController(IOrgActRoleCommands orgActRoleCommands, ICommonCommands commonCommands)
            : base(orgActRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgActRoleView orgActRoleView)
        {
            orgActRoleView.IsFormView = true;
            var isPopup = (orgActRoleView.ParentId > 0);
            orgActRoleView.OrgID = (orgActRoleView.ParentId == 0) ? SessionProvider.ActiveUser.OrganizationId : orgActRoleView.ParentId;
            SessionProvider.ActiveUser.SetRecordDefaults(orgActRoleView, Request.Params[WebApplicationConstants.UserDateTime]);

            orgActRoleView.RoleCode = Request.Form["OrgRefRoleId"];
            if ((!orgActRoleView.OrgRoleContactID.HasValue || orgActRoleView.OrgRoleContactID.GetValueOrDefault() < 1) && !string.IsNullOrWhiteSpace(Request.Form["hfOrgRoleContactID"]))
                orgActRoleView.OrgRoleContactID = Request.Form["hfOrgRoleContactID"].ToLong();
            if (orgActRoleView.RoleCode.EqualsOrdIgnoreCase(WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.OrgActRole), SessionProvider).FirstOrDefault("OrgRoleId").ColAliasName)))
                orgActRoleView.RoleCode = null;
            if (!string.IsNullOrWhiteSpace(orgActRoleView.RoleCode) && !orgActRoleView.OrgRefRoleId.HasValue)
                orgActRoleView.OrgRefRoleId = null;
            var messages = ValidateMessages(orgActRoleView);
            var descriptionByteArray = orgActRoleView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgActRole, ByteArrayFields.OrgRoleDescription.ToString());
            var commentByteArray = orgActRoleView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgActRole, ByteArrayFields.OrgComments.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, commentByteArray
            };
            if (orgActRoleView.OrgRefRoleId > 0 && orgActRoleView.OrgRoleContactID.GetValueOrDefault() > 0 && _commonCommands.GetUserSecurities(new ActiveUser { UserId = SessionProvider.ActiveUser.UserId, OrganizationId = orgActRoleView.OrgID.GetValueOrDefault(), RoleId = orgActRoleView.Id }).Count == 0)
                messages.Add(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.NoSecuredModule).Description);
            if (messages.Any())
                return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var record = orgActRoleView.Id > 0 ? base.UpdateForm(orgActRoleView) : base.SaveForm(orgActRoleView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView).SetParent(EntitiesAlias.Organization, orgActRoleView.OrgID.GetValueOrDefault(), isPopup);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = orgActRoleView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                if ((orgActRoleView.Id == SessionProvider.ActiveUser.RoleId) && !string.IsNullOrWhiteSpace(Request.Form["PreviousStatusId"]) && (record.StatusId != Convert.ToInt32(Request.Form["PreviousStatusId"])))
                {
                    var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess);
                    displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                    return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, reloadApplication = false }, JsonRequestBehavior.AllowGet);
                }
                else
                    return SuccessMessageForInsertOrUpdate(orgActRoleView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgActRoleView.Id, route);
        }

        #region Data View

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgActRoleView, long> orgActRoleView, string strRoute, string gridName)
        {
            var statusIdChanged = false;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var parentIdToTake = (route.ParentRecordId > 0) ? route.ParentRecordId : SessionProvider.ActiveUser.OrganizationId;
            if (parentIdToTake != SessionProvider.ActiveUser.OrganizationId)
                route.ParentRecordId = parentIdToTake;
            else
                route.ParentRecordId = SessionProvider.ActiveUser.OrganizationId;

            orgActRoleView.Insert.ForEach(c => { c.OrgID = parentIdToTake; c.OrganizationId = parentIdToTake; });
            foreach (var actRole in orgActRoleView.Update)
            {
                actRole.OrgID = parentIdToTake;
                actRole.OrganizationId = parentIdToTake;
                if ((actRole.Id == SessionProvider.ActiveUser.RoleId) && (actRole.PreviousStatusId != actRole.StatusId))
                    statusIdChanged = true;
            }

            var batchError = BatchUpdate(orgActRoleView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? statusIdChanged ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.LoggedInUserUpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }

            route.ParentEntity = EntitiesAlias.Common;
            route.ParentRecordId = 0;
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridView);
        }

      

        #region Filtering & Sorting

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
            sessionInfo.GridViewColumnState = column;
            sessionInfo.GridViewColumnStateReset = reset;
            SetGridResult(route, gridName);
            return ProcessCustomBinding(route, MvcConstants.GridView);
        }

        #endregion Filtering & Sorting

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentEntity = EntitiesAlias.Common;
            route.ParentRecordId = 0;
            base.DataView(JsonConvert.SerializeObject(route), gridName);
            return PartialView(_gridResult);
        }


        #endregion Data View

        #region Tab View

        public ActionResult TabView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.EntityName = _commonCommands.Tables[route.Entity].TblLangName;
            if (route.RecordId > 0)
            {
                var currentActRole = _currentEntityCommands.Get(route.RecordId);
                if (currentActRole != null)
                    route.Url = string.Concat(currentActRole.OrgID.GetValueOrDefault(), WebApplicationConstants.M4PLSeparator, currentActRole.RoleCode, WebApplicationConstants.M4PLSeparator, currentActRole.OrgRoleTitle, WebApplicationConstants.M4PLSeparator, currentActRole.OrgRoleContactID.GetValueOrDefault(), WebApplicationConstants.M4PLSeparator, currentActRole.OrgRoleContactIDName);
            }
            route.SetParent(EntitiesAlias.OrgActRole, route.RecordId);
            return PartialView(MvcConstants.ViewTab, route);
        }

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(route.Entity).Select(x => x.CopyPageInfos()).ToList(),
                CallBackRoute = route
            };

            var roleContactInfo = new string[] { };
            if (!string.IsNullOrWhiteSpace(route.Url))
                roleContactInfo = route.Url.Split(new[] { WebApplicationConstants.M4PLSeparator }, StringSplitOptions.None);

            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
                if (pageInfo.TabTableName == EntitiesAlias.OrgActSecurityByRole.ToString())
                {
                    if (route.RecordId == 0 || roleContactInfo.Count() == 0 || roleContactInfo[3].ToLong() == 0)
                        pageInfo.DisabledTab = true;
                    else if (roleContactInfo.Count() > 4)
                        pageInfo.TabPageTitle = string.Concat(roleContactInfo[1], " ", pageInfo.TabPageTitle, !string.IsNullOrEmpty(roleContactInfo[4]) ? (" - " + roleContactInfo[4]) : string.Empty);
                }
                else if (roleContactInfo.Count() > 4)
                    pageInfo.Route.SetParent(EntitiesAlias.Organization, roleContactInfo[0].ToLong());

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


    }
}