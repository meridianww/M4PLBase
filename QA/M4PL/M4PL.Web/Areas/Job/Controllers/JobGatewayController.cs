/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobGateway
//Purpose:                                      Contains Actions to render view on Job's Gateway page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobGatewayController : BaseController<JobGatewayView>
    {
        private readonly IJobGatewayCommands _jobGatewayCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Job's gateway details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="jobGatewayCommands"></param>
        /// <param name="commonCommands"></param>
        public JobGatewayController(IJobGatewayCommands jobGatewayCommands, ICommonCommands commonCommands)
            : base(jobGatewayCommands)
        {
            _commonCommands = commonCommands;
            _jobGatewayCommands = jobGatewayCommands;
        }

        public override ActionResult AddOrEdit(JobGatewayView jobGatewayView)
        {
            jobGatewayView.IsFormView = true;
            var escapeRequiredFields = new List<string>();
            var escapeRegexField = new List<string>();
            SessionProvider.ActiveUser.SetRecordDefaults(jobGatewayView, Request.Params[WebApplicationConstants.UserDateTime]);

            escapeRequiredFields.AddRange(new List<string> {
                    JobGatewayColumns.GwyPerson.ToString(),
                    JobGatewayColumns.DateCancelled.ToString(),
                    JobGatewayColumns.DateComment.ToString(),
                    JobGatewayColumns.DateEmail.ToString(),
                    JobGatewayColumns.GwyDDPCurrent.ToString(),
                    JobGatewayColumns.GwyDDPNew.ToString(),
                    JobGatewayColumns.GwyUprWindow.ToString(),
                    JobGatewayColumns.GwyLwrWindow.ToString(),
                    JobGatewayColumns.GwyUprDate.ToString(),
                    JobGatewayColumns.GwyLwrDate.ToString()
                });

            escapeRegexField.AddRange(new List<string> { JobGatewayColumns.GwyEmail.ToString(), JobGatewayColumns.GwyPhone.ToString() });

            if (!jobGatewayView.ClosedByContactExist && !string.IsNullOrWhiteSpace(jobGatewayView.GwyClosedBy))
            {
                var index = jobGatewayView.GwyClosedBy.IndexOf(WebApplicationConstants.Deleted);
                if (index > 0)
                    jobGatewayView.GwyClosedBy = jobGatewayView.GwyClosedBy.Remove(index, WebApplicationConstants.Deleted.Length);
            }

            var descriptionByteArray = jobGatewayView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobGateway, ByteArrayFields.GwyGatewayDescription.ToString());
            var commentByteArray = jobGatewayView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobGateway, ByteArrayFields.GwyComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray,commentByteArray
            };

            var messages = ValidateMessages(jobGatewayView, escapeRequiredFields: escapeRequiredFields, escapeRegexField: escapeRegexField);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            //if (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanel" || route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayLog4LogCbPanel")
            //{

            //}

            var result = jobGatewayView.Id > 0 ? _jobGatewayCommands.PutWithSettings(jobGatewayView) : _jobGatewayCommands.PostWithSettings(jobGatewayView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(jobGatewayView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(jobGatewayView.Id, route);
        }

        public ActionResult JobActionAddOrEdit(JobGatewayView jobGatewayView)
        {
            jobGatewayView.IsFormView = true;
            var escapeRequiredFields = new List<string>();
            var escapeRegexField = new List<string>();

            SessionProvider.ActiveUser.SetRecordDefaults(jobGatewayView, Request.Params[WebApplicationConstants.UserDateTime]);

            var actionToCompare = Regex.Replace(jobGatewayView.CurrentAction, @"\s+", "");
            var actionEnumToCompare = WebUtilities.JobGatewayActions.Anonymous;
            Enum.TryParse(actionToCompare, true, out actionEnumToCompare);

            //jobGatewayView.GwyGatewayCode = "Comment";

            switch (actionEnumToCompare)
            {

                case WebUtilities.JobGatewayActions.Cancelled:
                    jobGatewayView.GwyCompleted = jobGatewayView.CancelOrder;
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateCancelled;
                    if (jobGatewayView.GwyCompleted && (jobGatewayView.GwyGatewayACD == null))
                        jobGatewayView.GwyGatewayACD = jobGatewayView.DateChanged;
                    if ((jobGatewayView.GwyGatewayACD != null) && !jobGatewayView.GwyCompleted)
                        jobGatewayView.GwyCompleted = true;

                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPCurrent.ToString(),
                                            JobGatewayColumns.GwyUprWindow.ToString(),
                                            JobGatewayColumns.GwyLwrWindow.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;
                case WebUtilities.JobGatewayActions.DeliveryWindow:
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            });
                    break;
                case WebUtilities.JobGatewayActions.Comment:
                case WebUtilities.JobGatewayActions.Anonymous:
                    jobGatewayView.GwyDDPCurrent = DateTime.UtcNow;
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateComment ?? jobGatewayView.DateChanged;
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprWindow.ToString(),
                                            JobGatewayColumns.GwyLwrWindow.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;
                case WebUtilities.JobGatewayActions.EmailCommunication:
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateEmail ?? jobGatewayView.DateEmail;
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprWindow.ToString(),
                                            JobGatewayColumns.GwyLwrWindow.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;
                case WebUtilities.JobGatewayActions.Schedule:
                case WebUtilities.JobGatewayActions.Reschedule:
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyUprWindow.ToString(),
                                            JobGatewayColumns.GwyLwrWindow.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;
            }

            if (!jobGatewayView.ClosedByContactExist && !string.IsNullOrWhiteSpace(jobGatewayView.GwyClosedBy))
            {
                var index = jobGatewayView.GwyClosedBy.IndexOf(WebApplicationConstants.Deleted);
                if (index > 0)
                    jobGatewayView.GwyClosedBy = jobGatewayView.GwyClosedBy.Remove(index, WebApplicationConstants.Deleted.Length);
            }

            var descriptionByteArray = jobGatewayView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobGateway, ByteArrayFields.GwyGatewayDescription.ToString());
            var commentByteArray = jobGatewayView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.JobGateway, ByteArrayFields.GwyComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray,commentByteArray
            };

            var messages = ValidateMessages(jobGatewayView, escapeRequiredFields: escapeRequiredFields, escapeRegexField: escapeRegexField);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            jobGatewayView.isScheduleReschedule = false;
            if ((jobGatewayView.CurrentAction == "Reschedule") || (jobGatewayView.CurrentAction == "Schedule"))
            {
                jobGatewayView.isScheduleReschedule = true;
            }
            var result = new JobGatewayView();
            JobGatewayView jobGatewayViewAction = new JobGatewayView();

            jobGatewayViewAction.Id = jobGatewayView.Id;
            jobGatewayViewAction.JobID = jobGatewayView.JobID;
            jobGatewayViewAction.ProgramID = jobGatewayView.ProgramID;
            jobGatewayViewAction.GwyTitle = jobGatewayView.GwyTitle;
            jobGatewayViewAction.GwyGatewayCode = jobGatewayView.GwyGatewayCode;
            jobGatewayViewAction.StatusId = jobGatewayView.StatusId;
            jobGatewayViewAction.GwyPhone = jobGatewayView.GwyPhone;
            jobGatewayViewAction.GwyEmail = jobGatewayView.GwyEmail;
            jobGatewayViewAction.GwyGatewayTitle = jobGatewayView.GwyGatewayTitle;
            jobGatewayViewAction.GwyDDPNew = jobGatewayView.GwyDDPNew;
            jobGatewayViewAction.GwyDDPCurrent = jobGatewayView.GwyDDPCurrent;
            jobGatewayViewAction.GatewayTypeId = jobGatewayView.GatewayTypeId;// (int)JobGatewayType.Action;
            jobGatewayViewAction.GwyLwrDate = jobGatewayView.GwyLwrDate;
            jobGatewayViewAction.GwyUprDate = jobGatewayView.GwyUprDate;
            jobGatewayViewAction.GwyUprWindow = jobGatewayView.GwyUprWindow;
            jobGatewayViewAction.GwyLwrWindow = jobGatewayView.GwyLwrWindow;
            jobGatewayViewAction.GwyPerson = jobGatewayView.GwyPerson;
            jobGatewayViewAction.IsAction = jobGatewayView.IsAction;
            jobGatewayViewAction.GwyGatewayACD = DateTime.UtcNow;

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            
            if(Session["isEdit"] != null)
            {
                result = (bool)Session["isEdit"] == true ? _jobGatewayCommands.PutJobAction(jobGatewayViewAction) : _jobGatewayCommands.PostWithSettings(jobGatewayViewAction);
            }
            //if (jobGatewayView.GatewayTypeId == (int)JobGatewayType.Comment)
            //    result = jobGatewayView.Id > 0 ? _jobGatewayCommands.PutJobAction(jobGatewayViewAction) : _jobGatewayCommands.PostWithSettings(jobGatewayViewAction);
            //if (jobGatewayView.GatewayTypeId == (int)JobGatewayType.Action)
            //    result = _jobGatewayCommands.PostWithSettings(jobGatewayViewAction);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(jobGatewayView.Id, route, byteArray, false, 0, result.GwyDDPNew);
            }

            return ErrorMessageForInsertOrUpdate(jobGatewayView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobGatewayView, long> jobGatewayView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            jobGatewayView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobGatewayView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(jobGatewayView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            _gridResult.GridSetting.GridName = gridName;
            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();

            AddActionsInActionContextMenu(route);//To Add Actions Operation in ContextMenu

            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override Dictionary<long, string> BatchUpdate(MVCxGridViewBatchUpdateValues<JobGatewayView, long> batchEdit, MvcRoute route, string gridName)
        {
            var batchError = new Dictionary<long, string>();
            foreach (var item in batchEdit.Insert)
            {
                var messages = ValidateMessages(item, route.Entity, true, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);
                    if (!(_jobGatewayCommands.PostWithSettings(item) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
                        batchError.Add((item as SysRefModel).Id, DbConstants.SaveError);
                }
                else
                {
                    batchEdit.SetErrorText(item, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            foreach (var item in batchEdit.Update)
            {
                var escapeRequiredField = new List<string>
                {
                    JobGatewayColumns.GwyPerson.ToString(),
                    JobGatewayColumns.DateCancelled.ToString(),
                    JobGatewayColumns.DateComment.ToString(),
                    JobGatewayColumns.DateEmail.ToString(),
                    JobGatewayColumns.GwyDDPCurrent.ToString(),
                    JobGatewayColumns.GwyDDPNew.ToString(),
                    JobGatewayColumns.GwyUprWindow.ToString(),
                    JobGatewayColumns.GwyLwrWindow.ToString(),
                    JobGatewayColumns.GwyUprDate.ToString(),
                    JobGatewayColumns.GwyLwrDate.ToString()
                };

                var escapeRegexField = new List<string> { JobGatewayColumns.GwyEmail.ToString(), JobGatewayColumns.GwyPhone.ToString() };

                var messages = ValidateMessages(item, route.Entity, true, false, parentId: route.ParentRecordId, escapeRequiredFields: escapeRequiredField, escapeRegexField: escapeRegexField);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);
                    if (!(_jobGatewayCommands.PutWithSettings(item) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
                        batchError.Add((item as SysRefModel).Id, DbConstants.UpdateError);
                }
                else
                {
                    batchEdit.SetErrorText(item, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            if (batchEdit.DeleteKeys.Count > 0)
            {
                var nonDeletedRecords = _currentEntityCommands.Delete(batchEdit.DeleteKeys, WebApplicationConstants.ArchieveStatusId);

                if (nonDeletedRecords.Count > 0)
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId), batchEdit.DeleteKeys.Except(nonDeletedRecords.Select(c => c.ParentId)).ToList());
                    nonDeletedRecords.ToList().ForEach(c => batchError.Add(c.ParentId, DbConstants.DeleteError));
                }
                else
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], FormViewProvider.ParentCondition.ContainsKey(route.Entity) ? string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId) : string.Empty, batchEdit.DeleteKeys);
                }
            }

            return batchError;
        }

        #region Paging

        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return base.GridPagingView(pager, strRoute, gridName);
        }

        #endregion Paging

        #region Filtering & Sorting

        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return base.GridFilteringView(filteringState, strRoute, gridName);
        }

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return base.GridSortingView(column, reset, strRoute, gridName);
        }

        #endregion Filtering & Sorting

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.GwyGatewayDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.GwyGatewayDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.GwyComment.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.GwyComment.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public ActionResult TabView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobGateway),
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionTabView),
                ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobDelivery.ToString()),
                EnableTabClick = true
            };
            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
            }
            return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
        }

        public PartialViewResult JobGatewayDataView(string strRoute, long selectedId = 0)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            route.RecordId = 0;
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.RecordId = route.RecordId;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId = route.ParentRecordId;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();
            }

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}." + JobGatewayDefaultWhereColms.GatewayTypeId.ToString() + "={1}", route.Entity, (int)JobGatewayType.Gateway) + " AND JobGateway.isActionAdded = 0";

            var currentGridName = string.Format("Gateways_{0}", WebUtilities.GetGridName(route));

            base.DataView(strRoute, currentGridName);
            if (selectedId > 0)
                _gridResult.FocusedRowId = selectedId;
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }

            //To Add Actions Operation in ContextMenu
            AddActionsInActionContextMenu(route);

            _gridResult.GridSetting.GridName = currentGridName;

            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();

            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;

            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }

        public PartialViewResult JobGatewayActions(string strRoute, long selectedId = 0)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.RecordId = 0;
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = " AND JobGateway.isActionAdded = 1";
            var currentGridName = string.Format("Actions_{0}", WebUtilities.GetGridName(route));

            base.DataView(strRoute, currentGridName);
            if (selectedId > 0)
                _gridResult.FocusedRowId = selectedId;
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }

            //To Add Actions Operation in ContextMenu
            AddActionsInActionContextMenu(route);

            _gridResult.GridSetting.GridName = currentGridName;
            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }

        private void AddActionsInActionContextMenu(MvcRoute currentRoute)
        {
            var route = currentRoute;
            var actionsContextMenu = _commonCommands.GetOperation(OperationTypeEnum.Actions);

            var actionContextMenuAvailable = false;
            var actionContextMenuIndex = -1;

            if (_gridResult.GridSetting.ContextMenu.Count > 0)
            {
                for (var i = 0; i < _gridResult.GridSetting.ContextMenu.Count; i++)
                {
                    if (_gridResult.GridSetting.ContextMenu[i].SysRefName.EqualsOrdIgnoreCase(actionsContextMenu.SysRefName))
                    {
                        actionContextMenuAvailable = true;
                        actionContextMenuIndex = i;
                        break;
                    }
                }
            }

            if (actionContextMenuAvailable)
            {
                var allActions = _jobGatewayCommands.GetJobAction(route.ParentRecordId);
                _gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations = new List<Operation>();

                var routeToAssign = new MvcRoute(currentRoute);
                routeToAssign.Entity = EntitiesAlias.JobGateway;
                routeToAssign.Action = MvcConstants.ActionGatewayActionForm;
                routeToAssign.IsPopup = true;
                routeToAssign.RecordId = 0;

                if (allActions.Count > 0)
                {
                    var groupedActions = allActions.GroupBy(x => x.GatewayCode);

                    foreach (var singleApptCode in groupedActions)
                    {
                        var newOperation = new Operation();
                        newOperation.LangName = singleApptCode.First().GatewayCode;
                        foreach (var singleReasonCode in singleApptCode)
                        {
                            routeToAssign.Filters = new Entities.Support.Filter();
                            routeToAssign.Filters.FieldName = singleReasonCode.GatewayCode;

                            var newChildOperation = new Operation();
                            var newRoute = new MvcRoute(routeToAssign);

                            newChildOperation.LangName = singleReasonCode.PgdGatewayTitle;
                            newRoute.Filters = new Entities.Support.Filter();
                            newRoute.Filters.FieldName = singleReasonCode.GatewayCode;
                            newRoute.Filters.Value = String.Format("{0}-{1}", newChildOperation.LangName, singleReasonCode.PacApptReasonCode);
                            newChildOperation.Route = newRoute;
                            newOperation.ChildOperations.Add(newChildOperation);

                        }
                        _gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations.Add(newOperation);
                    }
                }
            }
        }

        public PartialViewResult JobGatewayLog(string strRoute, long selectedId = 0)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.RecordId = 0;
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = " AND JobGateway.isActionAdded = 0 " + string.Format(" AND  {0}." + JobGatewayDefaultWhereColms.GatewayTypeId.ToString() + "={1} ", route.Entity, (int)JobGatewayType.Comment);

            var currentGridName = string.Format("Logs_{0}", WebUtilities.GetGridName(route));
            base.DataView(strRoute, currentGridName);
            if (selectedId > 0)
                _gridResult.FocusedRowId = selectedId;
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }
            //To Add Actions Operation in ContextMenu
            AddActionsInActionContextMenu(route);
            _gridResult.GridSetting.GridName = currentGridName;
            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }

        public PartialViewResult JobGatewayAll(string strRoute, long selectedId = 0)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.RecordId = 0;
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = GetorSetUserGridPageSize();

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = null;

            base.DataView(strRoute);
            if (selectedId > 0)
                _gridResult.FocusedRowId = selectedId;
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }
            //To Add Actions Operation in ContextMenu
            AddActionsInActionContextMenu(route);
            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();
            ViewData[MvcConstants.ProgramID] = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId).ProgramID;
            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            Session["isEdit"] = route.IsEdit;
            //_gridResult.FocusedRowId = route.RecordId;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = _jobGatewayCommands.GetGatewayWithParent(route.RecordId, route.ParentRecordId) ?? new JobGatewayView();
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.CallBackRoute.TabIndex = route.TabIndex;
            if (route.RecordId == 0)
            {
                var dateRefLookupId = _formResult.ColumnSettings.FirstOrDefault(c => c.ColColumnName == "GwyDateRefTypeId").ColLookupId;
                var dateReferenceId = _formResult.ComboBoxProvider[dateRefLookupId].GetDefault().SysRefId;
                var unitLookupId = _formResult.ColumnSettings.FirstOrDefault(c => c.ColColumnName == "GatewayUnitId").ColLookupId;
                var unitSysRefId = _formResult.ComboBoxProvider[unitLookupId].GetDefault().SysRefId;

                JobGatewayUnit unitType = (JobGatewayUnit)unitSysRefId;

                if (_formResult.Record.JobDeliveryDateTimeBaseline.HasValue && _formResult.Record.JobOriginDateTimeBaseline.HasValue)
                {
                    var duration = Duration(_formResult.Record.JobDeliveryDateTimeBaseline.Value, _formResult.Record.JobOriginDateTimeBaseline.Value, unitType);
                    _formResult.Record.GwyGatewayDuration = duration.ToDecimal();

                    if (dateReferenceId == (int)JobGatewayDateRef.PickupDate)

                    {
                        _formResult.Record.GwyGatewayECD = _formResult.Record.JobOriginDateTimeBaseline.SubstractFrom(duration, unitType);
                        _formResult.Record.GwyGatewayPCD = _formResult.Record.JobOriginDateTimePlanned.SubstractFrom(duration, unitType);
                        _formResult.Record.GwyGatewayACD = _formResult.Record.JobOriginDateTimeActual.SubstractFrom(duration, unitType);
                    }
                    else if (dateReferenceId == (int)JobGatewayDateRef.DeliveryDate)
                    {
                        _formResult.Record.GwyGatewayECD = _formResult.Record.JobDeliveryDateTimeBaseline.SubstractFrom(duration, unitType);
                        _formResult.Record.GwyGatewayPCD = _formResult.Record.JobDeliveryDateTimePlanned.SubstractFrom(duration, unitType);
                        _formResult.Record.GwyGatewayACD = _formResult.Record.JobDeliveryDateTimeActual.SubstractFrom(duration, unitType);
                    }
                }
            }
            if (_formResult.Record.Id > 0 && _formResult.Record.GatewayTypeId == (int)JobGatewayType.Action)
            {
                _formResult.Record.IsAction = true;
                _formResult.Record.CancelOrder = _formResult.Record.GwyCompleted;
                _formResult.Record.GwyGatewayACD = DateTime.Now;
                _formResult.Record.DateCancelled = _formResult.Record.GwyGatewayACD == null
                    ? DateTime.UtcNow : _formResult.Record.GwyGatewayACD;

                _formResult.Record.DateComment = _formResult.Record.GwyGatewayACD == null
                    ? DateTime.UtcNow : _formResult.Record.GwyGatewayACD;

                _formResult.Record.GwyDDPCurrent = _formResult.Record.GwyDDPCurrent == null
                    ? DateTime.UtcNow : _formResult.Record.GwyDDPCurrent;

                _formResult.Record.DateEmail = _formResult.Record.GwyGatewayACD;

                _formResult.Record.CurrentAction = "Reschedule"; //set route for 1st level action

                return PartialView(MvcConstants.ViewGatewayAction, _formResult);
            }
            if (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayLog4LogCbPanel"
                || (_formResult.Record.Id > 0 && _formResult.Record.GatewayTypeId == (int)JobGatewayType.Comment))
            {
                _formResult.Record.IsAction = true;
                _formResult.Record.CancelOrder = _formResult.Record.GwyCompleted;
                _formResult.Record.GwyGatewayACD = DateTime.Now;
                _formResult.Record.DateCancelled = _formResult.Record.GwyGatewayACD == null ? DateTime.UtcNow : _formResult.Record.GwyGatewayACD;
                _formResult.Record.DateComment = _formResult.Record.GwyGatewayACD == null ? DateTime.UtcNow : _formResult.Record.GwyGatewayACD;
                _formResult.Record.GwyDDPCurrent = _formResult.Record.GwyDDPCurrent == null ? DateTime.UtcNow : _formResult.Record.GwyDDPCurrent;
                _formResult.Record.DateEmail = _formResult.Record.GwyGatewayACD;

                _formResult.Record.CurrentAction = "Comment";
                _formResult.Record.GwyGatewayCode = "Comment";
                _formResult.Record.GwyDDPCurrent = DateTime.UtcNow;
                return PartialView(MvcConstants.ViewGatewayComment, _formResult);
            }

            return PartialView(_formResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            base.DataView(strRoute, gridName);

            _gridResult.ColumnSettings = _gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();

            if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public JsonResult OnUnitChange(int unitType, JobGatewayView jobGateway)
        {
            if (unitType > 0)
            {
                var duration = Duration(jobGateway.JobDeliveryDateTimeBaseline.Value, jobGateway.JobOriginDateTimeBaseline.Value, unitType.ToEnum<JobGatewayUnit>()).ToDouble();

                var jobGatewayNew = new JobGatewayView();
                SetGatewayDates(jobGateway, ref jobGatewayNew, duration, unitType.ToEnum<JobGatewayUnit>(), jobGateway.GwyDateRefTypeId.ToInt());
                return Json(new { status = true, record = jobGatewayNew }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { status = false }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult OnDateRefChange(int dateRef, JobGatewayView jobGateway)
        {
            if (dateRef > 0)
            {
                var unitType = jobGateway.GatewayUnitId.ToInt().ToEnum<JobGatewayUnit>();
                var duration = Duration(jobGateway.JobDeliveryDateTimeBaseline.Value, jobGateway.JobOriginDateTimeBaseline.Value, unitType).ToDouble();

                var jobGatewayNew = new JobGatewayView();
                SetGatewayDates(jobGateway, ref jobGatewayNew, duration, unitType, dateRef);

                return Json(new { status = true, record = jobGatewayNew }, JsonRequestBehavior.AllowGet);
            }

            return Json(new { status = false }, JsonRequestBehavior.AllowGet);
        }

        private void SetGatewayDates(JobGatewayView jobGateway, ref JobGatewayView jobGatewayNew, double duration, JobGatewayUnit unitType, int dateRef)
        {
            jobGatewayNew.GwyGatewayDuration = duration.ToDecimal();
            if (dateRef == (int)JobGatewayDateRef.PickupDate)
            {
                jobGatewayNew.GwyGatewayECD = jobGateway.JobOriginDateTimeBaseline.SubstractFrom(duration, unitType);
                jobGatewayNew.GwyGatewayPCD = jobGateway.JobOriginDateTimePlanned.SubstractFrom(duration, unitType);
                jobGatewayNew.GwyGatewayACD = jobGateway.JobOriginDateTimeActual.SubstractFrom(duration, unitType);
            }
            else if (dateRef == (int)JobGatewayDateRef.DeliveryDate)
            {
                jobGatewayNew.GwyGatewayECD = jobGateway.JobDeliveryDateTimeBaseline.SubstractFrom(duration, unitType);
                jobGatewayNew.GwyGatewayPCD = jobGateway.JobDeliveryDateTimePlanned.SubstractFrom(duration, unitType);
                jobGatewayNew.GwyGatewayACD = jobGateway.JobDeliveryDateTimeActual.SubstractFrom(duration, unitType);
            }
        }

        private double Duration(DateTime deliveryDate, DateTime pickUpDate, JobGatewayUnit unitType)
        {
            switch (unitType)
            {
                case JobGatewayUnit.Hours:
                    return (deliveryDate - pickUpDate).TotalHours;

                case JobGatewayUnit.Days:
                    return (deliveryDate - pickUpDate).TotalDays;

                case JobGatewayUnit.Weeks:
                    return ((deliveryDate - pickUpDate).TotalDays) / 7;

                case JobGatewayUnit.Months:
                    return ((deliveryDate - pickUpDate).TotalDays) / (365.25 / 12);
            }

            return (deliveryDate - pickUpDate).TotalHours;
        }

        public PartialViewResult GatewayComplete(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var formResult = new FormResult<JobGatewayComplete>();
            formResult.Permission = _formResult.Permission;
            formResult.CallBackRoute = route;
            formResult.SessionProvider = SessionProvider;
            formResult.FormId = "GatewayComplete" + formResult.FormId;
            formResult.Record = _jobGatewayCommands.GetJobGatewayComplete(route.RecordId, route.ParentRecordId) ?? new JobGatewayComplete();
            formResult.SetupFormResult(_commonCommands, route);
            formResult.CallBackRoute = route;
            ViewData[MvcConstants.OkLangName] = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess).Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Ok.ToString())).LangName;
            return PartialView("Complete", formResult);
        }

        public JsonResult UpdateJobGatewayComplete(JobGatewayComplete jobGateway)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(jobGateway, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobGateway);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = _jobGatewayCommands.PutJobGatewayComplete(jobGateway);

            return Json(new { status = true, record = result, ownerCbPanel = jobGateway.SysRefName }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult IsScheduled(long id, long parentId)
        {
            //return Json(new { isScheduled = _jobGatewayCommands.GetGatewayWithParent(id, parentId).isScheduled, actionSchedule = GatewayActionType.Schedule.ToString() }, JsonRequestBehavior.AllowGet);
            return Json(new { isScheduled = false, actionSchedule = WebUtilities.JobGatewayActions.Schedule.ToString() }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GatewayActionFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            FormView(strRoute);
            _formResult.Record.IsAction = true;
            _formResult.Record.CancelOrder = _formResult.Record.GwyCompleted;
            _formResult.Record.GwyGatewayACD = DateTime.Now;
            _formResult.Record.DateCancelled = _formResult.Record.GwyGatewayACD;
            _formResult.Record.DateComment = _formResult.Record.GwyGatewayACD;
            _formResult.Record.DateEmail = _formResult.Record.GwyGatewayACD;


            if (_formResult.Record.GwyTitle == null)
                _formResult.Record.GwyTitle = route.Filters.Value.Split('-')[0];

            if (route.Filters != null)
            {
                _formResult.Record.CurrentAction = route.Filters.FieldName;
                _formResult.Record.StatusCode = route.Filters.Value.Substring(route.Filters.Value.LastIndexOf('-') + 1);
                _formResult.Record.GwyShipApptmtReasonCode = _formResult.Record.StatusCode;
            }

            return PartialView(MvcConstants.ViewGatewayAction, _formResult);
        }

        public ActionResult GatewayCommentFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            FormView(strRoute);
            _formResult.Record.IsAction = false;
            _formResult.Record.CancelOrder = _formResult.Record.GwyCompleted;
            _formResult.Record.GwyGatewayACD = DateTime.Now;
            _formResult.Record.DateCancelled = _formResult.Record.GwyGatewayACD;
            _formResult.Record.DateComment = _formResult.Record.GwyGatewayACD;
            _formResult.Record.DateEmail = _formResult.Record.GwyGatewayACD;


            if (_formResult.Record.GwyTitle == null)
                _formResult.Record.GwyTitle = route.Filters.Value.Split('-')[0];

            if (route.Filters != null)
            {
                _formResult.Record.CurrentAction = route.Filters.FieldName;
                _formResult.Record.StatusCode = route.Filters.Value.Substring(route.Filters.Value.LastIndexOf('-') + 1);
                _formResult.Record.GwyShipApptmtReasonCode = _formResult.Record.StatusCode;
            }

            return PartialView(MvcConstants.ViewGatewayComment, _formResult);
        }
    }
}