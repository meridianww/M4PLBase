#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              16/12/2017
//Program Name:                                 Attachment
//Purpose:                                      Contains Actions to render view on Attachment page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Attachment;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Attachment;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Attachment.Controllers
{
    public class AttachmentController : BaseController<AttachmentView>
    {
        protected GridResult<AttachmentView> _attachmentGridResult = new GridResult<AttachmentView>();

        protected static MvcRoute _baseRote;
        protected IAttachmentCommands _attachmentCommands;

        public AttachmentController(IAttachmentCommands attachmentCommands, ICommonCommands commonCommands)
            : base(attachmentCommands)
        {
            _commonCommands = commonCommands;
            _attachmentCommands = attachmentCommands;
            _baseRote = new MvcRoute { Entity = EntitiesAlias.Attachment, Action = MvcConstants.ActionIndex, Area = EntitiesAlias.Attachment.ToString(), EntityName = EntitiesAlias.Attachment.ToString() };
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<AttachmentView, long> attachmentView, string strRoute, string gridName)
        {
            var batchError = new Dictionary<long, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var visibleIndex = WebUtilities.Files.OrderBy(c => c.Key).FirstOrDefault().Key;
            var data = SessionProvider.ViewPagedDataSession[BaseRoute.Entity].PagedDataInfo;
            string parentEntity = data.WhereCondition.Split('\'')[1];
            EntitiesAlias parentEntityInEntityAlias;
            var primaryTableFieldName = string.Empty;

            if (Enum.TryParse(parentEntity, out parentEntityInEntityAlias))
                if (FormViewProvider.AttachmentFieldName.ContainsKey(parentEntityInEntityAlias))
                    primaryTableFieldName = FormViewProvider.AttachmentFieldName[parentEntityInEntityAlias];

            if (!string.IsNullOrWhiteSpace(parentEntity))
            {
                int count = -1;
                foreach (var item in attachmentView.Insert)
                {
                    item.AttPrimaryRecordID = Request.Form["docRefId"] != null ? Convert.ToInt64(Request.Form["docRefId"]) : data.ParentId;
                    item.AttTableName = parentEntity;
                    item.AttTypeId = 1;
                    item.PrimaryTableFieldName = primaryTableFieldName;

                    var messages = ValidateMessages(item, route.Entity, true, false, isNewRecord: true);
                    if (!messages.Any())
                    {
                        var record = _currentEntityCommands.Post(item);
                        if (record.Id > 0)
                            _commonCommands.SaveBytes(new ByteArray { Id = record.Id, FieldName = ByteArrayFields.AttData.ToString(), Type = Entities.SQLDataTypes.varbinary, Entity = EntitiesAlias.Attachment }, WebUtilities.Files[count]);
                    }
                    else
                    {
                        attachmentView.SetErrorText(item, string.Join(",", messages));
                        batchError.Add(-100, "ModelInValid");
                    }
                    count--;
                }

                foreach (var item in attachmentView.Update)
                {
                    item.AttPrimaryRecordID = Request.Form["docRefId"] != null ? Convert.ToInt64(Request.Form["docRefId"]) : data.ParentId;
                    item.AttTableName = parentEntity;
                    item.AttTypeId = 1;
                    var messages = ValidateMessages(item, route.Entity, true, false);
                    if (!messages.Any())
                    {
                        var record = _currentEntityCommands.Put(item);
                        if (record.Id > 0 && WebUtilities.Files.ContainsKey(item.Id) && WebUtilities.Files[item.Id] != null && WebUtilities.Files[item.Id].Length > 0)
                            _commonCommands.SaveBytes(new ByteArray { Id = record.Id, FieldName = ByteArrayFields.AttData.ToString(), Type = Entities.SQLDataTypes.varbinary, Entity = EntitiesAlias.Attachment }, WebUtilities.Files[item.Id]);
                    }
                    else
                    {
                        attachmentView.SetErrorText(item, string.Join(",", messages));
                        batchError.Add(-100, "ModelInValid");
                    }
                }

                if (attachmentView.DeleteKeys.Count > 0)
                {
                    var nonDeletedRecords = _attachmentCommands.DeleteAndUpdateAttachmentCount(attachmentView.DeleteKeys, WebApplicationConstants.ArchieveStatusId, parentEntity, primaryTableFieldName);
                    if (nonDeletedRecords.Count > 0)
                    {
                        if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                            _commonCommands.ResetItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity], data.WhereCondition, attachmentView.DeleteKeys.Except(nonDeletedRecords.Select(c => c.ParentId)).ToList());
                        nonDeletedRecords.ToList().ForEach(c => batchError.Add(c.ParentId, DbConstants.DeleteError));
                    }
                    else
                    {
                        if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                            _commonCommands.ResetItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity], data.WhereCondition, attachmentView.DeleteKeys);
                    }
                }
            }

            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
                //clear the dictionary after
                WebUtilities.Files.Clear();
            }

            base.SetGridResult(route);
            _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);
            ViewData[WebApplicationConstants.AttachmentHeaderText] = string.Concat(EntitiesAlias.Attachment.ToString(), " (", SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount, ")");
            ViewData[WebApplicationConstants.AttachmentMaxItemNumber] = _commonCommands.GetLastItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity]) + 1;//+1 indicates for next item number
            return ProcessCustomBinding(route, MvcConstants.AttachmentGridViewPartial);
        }

        public PartialViewResult DataViewRoundPanel(string strRoute)
        {
            var route = string.IsNullOrEmpty(strRoute) ? BaseRoute : JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return PartialView(MvcConstants.ViewAttachmentDataViewPartial, route);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = string.IsNullOrEmpty(strRoute) ? BaseRoute : JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else if (SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId != route.ParentRecordId)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId = route.ParentRecordId;
            }

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}." + AttachmentColumns.AttTableName.ToString() + " = '{1}' AND {0}.{2}={3} ", route.Entity, route.ParentEntity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId);
            SetGridResult(route);
            _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);
            ViewData[WebApplicationConstants.AttachmentHeaderText] = string.Concat(EntitiesAlias.Attachment.ToString(), " (", SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount, ")");
            ViewData[WebApplicationConstants.AttachmentMaxItemNumber] = _commonCommands.GetLastItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity]) + 1;//+1 indicates for next item number
            return ProcessCustomBinding(route, MvcConstants.AttachmentGridViewPartial);
        }

        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            GetorSetUserGridPageSize(pager.PageSize);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.PageNumber = pager.PageIndex + 1;
            sessionInfo.PagedDataInfo.PageSize = pager.PageSize;
            var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
            viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
            SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            _gridResult.SessionProvider = SessionProvider;

            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo1 = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo1.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo1.PagedDataInfo.ParentId = route.ParentRecordId;
                SessionProvider.ViewPagedDataSession.AddOrUpdate(route.Entity, sessionInfo1);
            }
            else if (SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId != route.ParentRecordId)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId = route.ParentRecordId;
            }
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}." + AttachmentColumns.AttTableName.ToString() + " = '{1}' AND {0}.{2}={3} ", route.Entity, route.ParentEntity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId);
            SetGridResult(route, gridName);
            _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);
            _gridResult.GridViewModel.ApplyPagingState(pager);
            ViewData[WebApplicationConstants.AttachmentHeaderText] = string.Concat(EntitiesAlias.Attachment.ToString(), " (", SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount, ")");
            ViewData[WebApplicationConstants.AttachmentMaxItemNumber] = _commonCommands.GetLastItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity]) + 1;//+1 indicates for next item number
            return ProcessCustomBinding(route, MvcConstants.AttachmentGridViewPartial);
        }

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
            _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);
            ViewData[WebApplicationConstants.AttachmentHeaderText] = string.Concat(EntitiesAlias.Attachment.ToString(), " (", SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount, ")");
            ViewData[WebApplicationConstants.AttachmentMaxItemNumber] = _commonCommands.GetLastItemNumber(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, FormViewProvider.ItemFieldName[route.Entity]) + 1;//+1 indicates for next item number

            return ProcessCustomBinding(route, MvcConstants.AttachmentGridViewPartial);
        }

        public override PartialViewResult ProcessCustomBinding(MvcRoute route, string viewName)
        {
            _gridResult.GridViewModel.ProcessCustomBinding(GetDataRowCount, GetData);
            SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            return PartialView(viewName, _gridResult);
        }

        public ActionResult UploadControlUploadFile()
        {
            var visibleIndex = Convert.ToInt32(Request.Params["hf"]);
            UploadControlExtension.GetUploadedFiles("ucAttFileName", null, (s, e) =>
            {
                var name = e.UploadedFile.FileName;
                e.CallbackData = name;

                if (WebUtilities.Files.ContainsKey(visibleIndex))
                    WebUtilities.Files[visibleIndex] = e.UploadedFile.FileBytes;
                else
                    WebUtilities.Files.Add(visibleIndex, e.UploadedFile.FileBytes);
            });
            return null;
        }

        public void UpdateAttachmentDownloadDate(long recordId, string currentDateTime)
        {
            AttachmentView attachmentView = _currentEntityCommands.Get(recordId);
            if (attachmentView != null)
            {
                SessionProvider.ActiveUser.SetRecordDefaults(attachmentView, currentDateTime);
                attachmentView.AttDownloadedDate = attachmentView.DateChanged;
                attachmentView.AttDownloadedBy = attachmentView.ChangedBy;
                attachmentView.AttData = null;
                _currentEntityCommands.Put(attachmentView);
            }
        }

        public void DownloadAttachment(long recordId)
        {
            try
            {
                AttachmentView attachmentView = _currentEntityCommands.Get(recordId);
                if (attachmentView != null)
                {
                    var stringParts = attachmentView.AttFileName.Split('.');
                    var response = System.Web.HttpContext.Current.Response;
                    response.Clear();
                    response.ClearContent();
                    response.ClearHeaders();
                    response.AddHeader("content-disposition", "attachment; filename=" + attachmentView.AttFileName);
                    response.ContentType = stringParts[1];
                    this.Response.BinaryWrite(attachmentView.AttData);
                    this.Response.End();
                }
            }
            catch (Exception)
            {
            }
        }

        private void GetAttachmentData(GridViewCustomBindingGetDataArgs e)
        {
            e.Data = _attachmentGridResult.Records;
        }


    }
}