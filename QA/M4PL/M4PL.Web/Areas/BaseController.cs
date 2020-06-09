/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Base
//Purpose:                                      Contains Actions related to navigation, dataview and Formview
//====================================================================================================================================================*/
using DevExpress.Data.Linq.Helpers;
using DevExpress.Web.Mvc;
using DevExpress.Web.Office;
using DevExpress.XtraRichEdit;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using M4PL.APIClient;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web;
using M4PL.Web.Controllers;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web.Areas
{
    public class BaseController<TView> : MvcBaseController where TView : class, new()
    {
        protected IBaseCommands<TView> _currentEntityCommands;

        protected GridResult<TView> _gridResult = new GridResult<TView>();

        protected FormResult<TView> _formResult = new FormResult<TView>();

        protected Dictionary<string, Dictionary<string, object>> RowHashes { get; set; }

        public BaseController(IBaseCommands<TView> currentEntityCommands)
        {
            _currentEntityCommands = currentEntityCommands;
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (SessionProvider == null || SessionProvider.ActiveUser == null)
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", MvcConstants.ActionIndex }, { "area", string.Empty } });
            else
            {
                _currentEntityCommands.ActiveUser = SessionProvider.ActiveUser;
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
                BaseRoute = _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
                BaseRoute = _formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
                if (BaseRoute == null)
                    BaseRoute = GetDefaultRoute();

                if (SessionProvider.UserColumnSetting == null || string.IsNullOrEmpty(SessionProvider.UserColumnSetting.ColTableName)
                    || !SessionProvider.UserColumnSetting.ColTableName.EqualsOrdIgnoreCase(BaseRoute.Entity.ToString()))
                {
                    SessionProvider.UserColumnSetting = _commonCommands.GetUserColumnSettings(BaseRoute.Entity);
                }

                if (SessionProvider.ActiveUser != null && !filterContext.ActionDescriptor.ActionName.Equals("GetLastCallDateTime"))
                    SessionProvider.ActiveUser.LastAccessDateTime = DateTime.Now;
            }

            base.OnActionExecuting(filterContext);
        }

        protected void SetGridResult(MvcRoute route, string gridName = "", bool pageSizeChanged = false, bool isGridSetting = false, object contextChildOptions = null, bool IsJobParentEntity = false)
        {
            isGridSetting = route.Entity == EntitiesAlias.JobCard ? true : isGridSetting;
            var columnSettings = _commonCommands.GetGridColumnSettings(BaseRoute.Entity, false, isGridSetting);
            var isGroupedGrid = columnSettings.Where(x => x.ColIsGroupBy).Count() > 0;
            route.GridRouteSessionSetup(SessionProvider, _gridResult, GetorSetUserGridPageSize(), ViewData, ((isGroupedGrid && pageSizeChanged) || !isGroupedGrid));
            _gridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(columnSettings, SessionProvider);
            _gridResult.GridColumnSettings = _gridResult.ColumnSettings;
            var currentGridViewModel = GridViewExtension.GetViewModel(!string.IsNullOrWhiteSpace(gridName) ? gridName : WebUtilities.GetGridName(route));
            _gridResult.GridViewModel = (currentGridViewModel != null && !(isGroupedGrid && pageSizeChanged)) ? WebUtilities.UpdateGridViewModel(currentGridViewModel, _gridResult.ColumnSettings, route.Entity) : WebUtilities.CreateGridViewModel(_gridResult.ColumnSettings, route.Entity, GetorSetUserGridPageSize());
            var currentPagedDataInfo = _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo;
            if ((route.Action == MvcConstants.ActionGridView || route.Action == MvcConstants.ActionDataView) && route.Entity == EntitiesAlias.Job)
                currentPagedDataInfo.IsJobParentEntity = IsJobParentEntity;
            if (route.Entity == EntitiesAlias.Job && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition != null)

                currentPagedDataInfo.WhereCondition = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition;
            if ((route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.PrgEdiHeader) && route.Filters != null
                && route.Filters.FieldName.Equals(MvcConstants.ActionToggleFilter, StringComparison.OrdinalIgnoreCase))
            {
                if (string.IsNullOrEmpty(currentPagedDataInfo.WhereCondition) || currentPagedDataInfo.WhereCondition.IndexOf("StatusId") == -1)
                    currentPagedDataInfo.WhereCondition = string.Format("{0} AND {1}.{2} = {3}", currentPagedDataInfo.WhereCondition, route.Entity, "StatusId", 1);
            }
            //currentPagedDataInfo.IsJobParentEntity = route.IsJobParentEntity;
            if (route.Entity == EntitiesAlias.JobHistory)
            {
                route.IsPBSReport = false;
                currentPagedDataInfo.RecordId = route.RecordId;
                var result = _currentEntityCommands.GetPagedData(currentPagedDataInfo);
                _gridResult.Records = result;

            }
            else
            {
                _gridResult.Records = _currentEntityCommands.GetPagedData(currentPagedDataInfo);
                if (_gridResult.Records.Count == 0 && currentPagedDataInfo.PageNumber > 1 && currentPagedDataInfo.TotalCount > 0)
                {
                    currentPagedDataInfo.PageNumber--;
                    _gridResult.Records = _currentEntityCommands.GetPagedData(currentPagedDataInfo);
                    _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo = currentPagedDataInfo;
                }
            }

            _gridResult.GridSetting = WebUtilities.GetGridSetting(_commonCommands, route, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, _gridResult.Records.Count > 0, _gridResult.Permission, this.Url, contextChildOptions);
            if (!string.IsNullOrWhiteSpace(gridName))
                _gridResult.GridSetting.GridName = gridName;
            switch (route.Entity)
            {
                case EntitiesAlias.Job:
                case EntitiesAlias.Contact:
                case EntitiesAlias.Vendor:
                case EntitiesAlias.Customer:
                case EntitiesAlias.JobCard:
                case EntitiesAlias.JobAdvanceReport:
                case EntitiesAlias.PrgEdiHeader:
                    _gridResult.GridSetting.ShowFilterRow = true;
                    break;
                default:
                    _gridResult.GridSetting.ShowFilterRow = SessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter;
                    break;
            }

            if (!SessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter && (SessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter != SessionProvider.ViewPagedDataSession[route.Entity].PreviousToggleFilter))
            {
                ViewData[WebApplicationConstants.ClearFilterManually] = true;
                SessionProvider.ViewPagedDataSession[route.Entity].PreviousToggleFilter = false;
            }

            _gridResult.GridSetting.ShowAdanceFilter = SessionProvider.ViewPagedDataSession[route.Entity].AdvanceFilter;
            _gridResult.Operations = _commonCommands.GridOperations();
            _gridResult.GridSetting.DataRowType = typeof(TView);
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            _gridResult.GridViewModel.Pager.PageSize = _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize;
            _gridResult.GridViewModel.Pager.PageIndex = _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber - 1;

            ////reset the pageindex when Filter applied and pageing is opted
            if ((ViewData[WebApplicationConstants.ViewDataFilterPageNo] != null) && ((double)_gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount / _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize >= (int)ViewData[WebApplicationConstants.ViewDataFilterPageNo]))
                _gridResult.GridViewModel.Pager.PageIndex = ((int)ViewData[WebApplicationConstants.ViewDataFilterPageNo] - 1);
        }

        public virtual PartialViewResult ProcessCustomBinding(MvcRoute route, string viewName)
        {
            _gridResult.GridViewModel.ProcessCustomBinding(GetDataRowCount, GetData, GetGroupingInfo);
            try
            {
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            }
            catch (Exception ex)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            }
            return PartialView(viewName, _gridResult);
        }

        #region Data View

        public virtual PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            bool isGridSetting = route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard ? true : false;//User for temporaryly for job
            _gridResult.FocusedRowId = route.RecordId;
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;
            SetGridResult(route, gridName, isGridSetting);
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = true;
            }
            if ((!string.IsNullOrWhiteSpace(route.OwnerCbPanel)
                && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid)))
                // || route.Entity == EntitiesAlias.JobAdvanceReport)
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public virtual void GetDataRowCount(GridViewCustomBindingGetDataRowCountArgs e)
        {

            if (SessionProvider.ViewPagedDataSession.ContainsKey(BaseRoute.Entity))
                e.DataRowCount = SessionProvider.ViewPagedDataSession[BaseRoute.Entity].PagedDataInfo.TotalCount;
            else e.DataRowCount = 0;
        }

        public void GetGroupingInfo(GridViewCustomBindingGetGroupingInfoArgs e)
        {
            var allRecords = new List<GridViewGroupInfo>();
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.BuildGridGroupByCondition(e.FieldName, _gridResult.GridSetting.CallBackRoute.Entity);
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.BuildGridGroupByWhereCondition(e.GroupInfoList, _gridResult.GridSetting.CallBackRoute.Entity);
            var oldOrderBy = _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.OrderBy;
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.BuildGridGroupByOrderCondition(e, _gridResult.GridSetting.CallBackRoute.Entity);
            var result = _currentEntityCommands.GetPagedData(_gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo);

            if (result != null)
            {
                foreach (var singleRecord in result)
                {
                    var currentRecord = singleRecord as SysRefModel;
                    allRecords.Add(new GridViewGroupInfo() { KeyValue = currentRecord.KeyValue, DataRowCount = currentRecord.DataCount });
                }
            }
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.GroupBy = null;
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.GroupByWhereCondition = null;
            _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.OrderBy = oldOrderBy;

            e.Data = allRecords;
        }

        public virtual void GetData(GridViewCustomBindingGetDataArgs e)
        {
            if (e.GroupInfoList.Count > 0)
            {
                var currentPageNumber = _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageNumber;
                var currentPageSize = _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageSize;
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageNumber = e.StartDataRowIndex;
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageSize = e.DataRowCount;
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.BuildGridGroupByWhereCondition(e.GroupInfoList, _gridResult.GridSetting.CallBackRoute.Entity);
                _gridResult.Records = _currentEntityCommands.GetPagedData(_gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo);
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.GroupByWhereCondition = null;
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageNumber = currentPageNumber;
                _gridResult.SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].PagedDataInfo.PageSize = currentPageSize;
                e.Data = _gridResult.Records;
            }
            else
            {
                e.Data = _gridResult.Records;
            }
            if (SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnState != null)
                _gridResult.GridViewModel.ApplySortingState(SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnState as GridViewColumnState, SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnStateReset);
            if (SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewFilteringState != null)
                _gridResult.GridViewModel.ApplyFilteringState(SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewFilteringState as GridViewFilteringState);
            if (SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnGroupingState != null)
                _gridResult.GridViewModel.ApplyGroupingState(SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnGroupingState as GridViewColumnState);
        }

        #region Paging

        public virtual PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            if (TempData["RowHashes"] != null)
                TempData.Keep();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var currentPageSize = GetorSetUserGridPageSize();
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
            SetGridResult(route, gridName, (currentPageSize != pager.PageSize));
            _gridResult.GridViewModel.ApplyPagingState(pager);
            if (route.Entity == EntitiesAlias.JobAdvanceReport)
                _gridResult.Permission = Permission.ReadOnly;
            return ProcessCustomBinding(route, GetCallbackViewName(route.Entity));
        }

        #endregion Paging

        #region Batch Update

        public virtual Dictionary<long, string> BatchUpdate(MVCxGridViewBatchUpdateValues<TView, long> batchEdit, MvcRoute route, string gridName)
        {

            var columnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(route.Entity), SessionProvider);
            var batchError = new Dictionary<long, string>();
            foreach (var item in batchEdit.Insert)
            {
                var messages = ValidateMessages(item, route.Entity, true, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);

                    if (!(_currentEntityCommands.Post(item) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
                        batchError.Add((item as SysRefModel).Id, DbConstants.SaveError);
                }
                else
                {
                    batchEdit.SetErrorText(item, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            foreach (var record in batchEdit.Update)
            {
                Dictionary<string, Dictionary<string, object>> RowHashes = null;
                if (TempData["RowHashes"] != null)
                    RowHashes = (Dictionary<string, Dictionary<string, object>>)TempData["RowHashes"];
                TempData.Keep();
                var properties = record.GetType().GetProperties();
                foreach (var col in columnSettings)
                {
                    if (col.GlobalIsVisible && !col.ColIsVisible && !col.DataType.Equals(SQLDataTypes.image.ToString(), StringComparison.OrdinalIgnoreCase)
                    && !col.DataType.Equals(SQLDataTypes.varbinary.ToString(), StringComparison.OrdinalIgnoreCase) && route.Controller != "SystemReference"
                    || col.ColColumnName == VendColumnNames.VdcContactMSTRID.ToString()
                    || col.ColColumnName == CustColumnNames.CdcContactMSTRID.ToString())
                    {
                        if (RowHashes != null)
                        {

                            var hiddenColumnValue = RowHashes[((record) as SysRefModel).Id.ToString()][col.ColColumnName];
                            if (hiddenColumnValue != null)
                            {
                                var propInfo = properties.FirstOrDefault(p => col.ColColumnName.Equals(p.Name));
                                if (propInfo != null)
                                {
                                    WebUtilities.SetPropertyByType(record, col.ColColumnName, hiddenColumnValue);
                                }
                            }
                        }
                    }
                }
                var messages = ValidateMessages(record, route.Entity, true, false, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(record, Request.Params[WebApplicationConstants.UserDateTime]);
                    if (route.Entity == EntitiesAlias.Customer || route.Entity == EntitiesAlias.Organization || route.Entity == EntitiesAlias.Vendor)
                    {
                        if (!(_currentEntityCommands.Patch(record) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
                            batchError.Add((record as SysRefModel).Id, DbConstants.UpdateError);
                    }
                    else
                    {
                        if (!(_currentEntityCommands.Put(record) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
                            batchError.Add((record as SysRefModel).Id, DbConstants.UpdateError);
                    }
                }
                else
                {
                    batchEdit.SetErrorText(record, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            if (batchEdit.DeleteKeys.Count > 0)
            {
                var nonDeletedRecords = _currentEntityCommands.Delete(batchEdit.DeleteKeys, WebApplicationConstants.ArchieveStatusId);

                if (nonDeletedRecords.Count > 0)
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId), batchEdit.DeleteKeys.Except(nonDeletedRecords.Select(c => c.ParentId)).ToList());
                    nonDeletedRecords.ToList().ForEach(c => batchError.Add(c.ParentId, DbConstants.DeleteError));

                    if (route.Entity == EntitiesAlias.JobBillableSheet)
                    {
                        _commonCommands.UpdateLineNumberForJobBillableSheet(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo));
                    }
                    else if (route.Entity == EntitiesAlias.JobCostSheet)
                    {
                        _commonCommands.UpdateLineNumberForJobCostSheet(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo));
                    }
                }
                else
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], FormViewProvider.ParentCondition.ContainsKey(route.Entity) ? string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId) : string.Empty, batchEdit.DeleteKeys);

                    if (route.Entity == EntitiesAlias.JobBillableSheet)
                    {
                        _commonCommands.UpdateLineNumberForJobBillableSheet(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo));
                    }
                    else if (route.Entity == EntitiesAlias.JobCostSheet)
                    {
                        _commonCommands.UpdateLineNumberForJobCostSheet(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo));
                    }
                }
            }

            return batchError;
        }

        #endregion Batch Update

        #region Filtering & Sorting

        public virtual PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            if (gridName == "JobCostSheetGridView" || gridName == "JobBillableSheetGridView")
                return null;
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var whereCondition = string.Empty;
            if (route.Entity == EntitiesAlias.JobAdvanceReport && gridName == "JobAdvanceReportGridView"
                && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition == null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition =
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition;
            }
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;

            if (sessionInfo.Filters == null)
                sessionInfo.Filters = new Dictionary<string, string>();

            //used to reset page index of the grid when Filter applied and pageing is opted
            ViewData[WebApplicationConstants.ViewDataFilterPageNo] = sessionInfo.PagedDataInfo.PageNumber;
            sessionInfo.PagedDataInfo.WhereCondition = filteringState.BuildGridFilterWhereCondition(route.Entity, ref filters, _commonCommands);
            if (route.Entity == EntitiesAlias.JobAdvanceReport && gridName == "JobAdvanceReportGridView"
               && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                sessionInfo.PagedDataInfo.WhereCondition = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition
                    + sessionInfo.PagedDataInfo.WhereCondition;
            }
            if (sessionInfo.Filters != null && filters.Count > 0 && sessionInfo.Filters.Count != filters.Count)//Have to search from starting if setup filter means from page 1
                sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.Filters = filters;
            sessionInfo.GridViewFilteringState = filteringState;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            _gridResult.SessionProvider = SessionProvider;
            SetGridResult(route, gridName);
            if (route.Entity == EntitiesAlias.SystemReference && _gridResult.ColumnSettings != null && _gridResult.ColumnSettings.Count > 0)
            {
                _gridResult.ColumnSettings.ToList().ForEach(c =>
                {
                    if (c.ColColumnName.Equals(WebApplicationConstants.SysLookupId, System.StringComparison.OrdinalIgnoreCase))
                    {
                        c.ColIsVisible = false;
                    }
                });
            }
            Session["costJobCodeActions"] = null;
            Session["priceJobCodeActions"] = null;

            return ProcessCustomBinding(route, GetCallbackViewName(route.Entity));
        }
        public virtual PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
            sessionInfo.GridViewColumnState = column;
            sessionInfo.GridViewColumnStateReset = reset;
            SetGridResult(route, gridName);
            return ProcessCustomBinding(route, GetCallbackViewName(route.Entity));
        }

        //public virtual PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        //{
        //    var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
        //    var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
        //    sessionInfo.PagedDataInfo.RecordId = route.RecordId;
        //    sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
        //    var sortcolumn = column.BuildGridSortCondition(reset, route.Entity, _commonCommands).Trim();
        //    string oldOrderBy = sessionInfo.PagedDataInfo.OrderBy;

        //    string[] sortcondition = sortcolumn.Split(' ');
        //    if (oldOrderBy.IndexOf(sortcondition[0]) == 0 && (sessionInfo.PagedDataInfo.OrderBy.Length == sortcolumn.Length + 1 || sessionInfo.PagedDataInfo.OrderBy.Length + 1 == sortcolumn.Length || sessionInfo.PagedDataInfo.OrderBy.Length == sortcolumn.Length))
        //    {
        //        sessionInfo.PagedDataInfo.OrderBy = sortcolumn;
        //        goto Cont;

        //    }
        //    else if (oldOrderBy.IndexOf(sortcondition[0]) != -1)
        //    {

        //        string replacement = "";
        //        if (sortcondition[1] == "DESC")
        //        {
        //            if (oldOrderBy.IndexOf(sortcondition[0]) == 0)
        //                replacement = sortcondition[0] + " ASC,";
        //            else
        //                replacement = "," + sortcondition[0] + " ASC";
        //            oldOrderBy = oldOrderBy.Replace(replacement, "");
        //        }
        //        else
        //        {
        //            if (oldOrderBy.IndexOf(sortcondition[0]) == 0)
        //                replacement = sortcondition[0] + " DESC,";
        //            else
        //                replacement = "," + sortcondition[0] + " DESC";
        //            oldOrderBy = oldOrderBy.Replace(replacement, "");
        //        }
        //    }
        //    sessionInfo.PagedDataInfo.OrderBy = sortcolumn;
        //    sessionInfo.PagedDataInfo.OrderBy += "," + oldOrderBy;
        //    Cont:
        //    sessionInfo.GridViewColumnState = column;
        //    //sessionInfo.GridViewColumnStateReset = reset;
        //    SetGridResult(route, gridName);
        //    return ProcessCustomBinding(route, GetCallbackViewName(route.Entity));
        //}


        #endregion Filtering & Sorting

        #region Grouping

        public virtual PartialViewResult GridGroupingView(GridViewColumnState column, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            _gridResult.SessionProvider = SessionProvider;
            SetGridResult(route, gridName);
            sessionInfo.GridViewColumnGroupingState = column;
            _gridResult.GridViewModel.ApplyGroupingState(column);
            return ProcessCustomBinding(route, GetCallbackViewName(route.Entity));
        }

        #endregion Grouping

        #endregion Data View

        #region Form View

        public virtual ActionResult FormView(string strRoute)
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
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new TView();

            _formResult.SetupFormResult(_commonCommands, route);
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }
            if (_formResult.Record is SysRefModel)
            {
                (_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
                    ? new Random().Next(-1000, 0) :
                    (_formResult.Record as SysRefModel).Id;
            }
            return PartialView(_formResult);
        }

        public virtual ActionResult PasteFormView(string strRoute)
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

        internal virtual void CopyRecord(long recordId)
        {
            _formResult.Record = _currentEntityCommands.Get(recordId);
            var requiredOrUniqueProperties = _commonCommands.GetColumnSettings(EntitiesAlias.Contact).Where(x => x.IsRequired || x.IsUnique).Select(x => x.ColColumnName).ToList();
            var properties = _formResult.Record.GetType().GetProperties();
            foreach (var propertyInfo in properties)
            {
                if (requiredOrUniqueProperties.Contains(propertyInfo.Name))
                {
                    if ((propertyInfo.PropertyType == typeof(int)) || (propertyInfo.PropertyType == typeof(float)) || (propertyInfo.PropertyType == typeof(double)) || (propertyInfo.PropertyType == typeof(decimal)))
                        propertyInfo.SetValue(_formResult.Record, 0, null);
                    else
                        propertyInfo.SetValue(_formResult.Record, null, null);
                }
            }
            SessionProvider.ActiveUser.ClearRecordDefaults(_formResult.Record);
        }

        public virtual ActionResult AddOrEdit(TView entityView)
        {
            SessionProvider.ActiveUser.SetRecordDefaults(entityView, Request.Params[WebApplicationConstants.UserDateTime]);
            var viewModel = entityView as SysRefModel;
            viewModel.IsFormView = WebUtilities.IsFormView(entityView);
            var messages = ValidateMessages(entityView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var result = viewModel.Id > 0 ? UpdateForm(entityView) : SaveForm(entityView);
            if (result is SysRefModel)
            {
                var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
                route.PreviousRecordId = viewModel.Id;
                var displayMessage = (result as SysRefModel).Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
                return Json(new { status = true, route = route, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
            }
            else
                return Json(new { status = false }, JsonRequestBehavior.AllowGet);
        }

        public virtual TView SaveForm(TView entityView)
        {
            var result = _currentEntityCommands.Post(entityView);
            return result;
        }

        public virtual TView UpdateForm(TView entityView)
        {
            var result = _currentEntityCommands.Put(entityView);
            return result;
        }

        public virtual ActionResult PrevNext(string strFormNavMenu)
        {
            var formNavMenu = JsonConvert.DeserializeObject<FormNavMenu>(strFormNavMenu);
            formNavMenu.Url = string.Empty;
            SysRefModel record = null;
            TempData["jobCostLoad"] = true;
            TempData["jobPriceLoad"] = true;
            Entities.Administration.SystemReference systemReferenceRecord = null;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(formNavMenu.Entity))
            {
                if (formNavMenu.Entity == EntitiesAlias.PrgRefGatewayDefault)
                    SessionProvider.ViewPagedDataSession[formNavMenu.Entity].PagedDataInfo.OrderBy
                        = "PrgRefGatewayDefault.Id";
                var result =
                    _currentEntityCommands.GetPagedData(SessionProvider.ViewPagedDataSession[formNavMenu.Entity].PagedDataInfo.GetPageDataInfoWithNav(formNavMenu)).FirstOrDefault();
                if (formNavMenu.Entity == EntitiesAlias.PrgRefGatewayDefault)
                    SessionProvider.ViewPagedDataSession[formNavMenu.Entity].PagedDataInfo.OrderBy =
                        "PrgRefGatewayDefault.GatewayTypeId,PrgRefGatewayDefault.PgdOrderType,PrgRefGatewayDefault.PgdShipmentType,PrgRefGatewayDefault.PgdGatewaySortOrder";
                if (result is SysRefModel)
                    record = result as SysRefModel;
                else
                    systemReferenceRecord = result as Entities.Administration.SystemReference;
            }
            var route = new MvcRoute(formNavMenu, MvcConstants.ActionForm, formNavMenu.RecordId);
            if (record != null && record.Id > 0)
                route.RecordId = record.Id;
            if (systemReferenceRecord != null && systemReferenceRecord.Id > 0)
                route.RecordId = systemReferenceRecord.Id;

            return Json(new
            {
                status = true,
                route = route
            }, JsonRequestBehavior.AllowGet);
        }


        #endregion Form View

        #region Choose Column

        public virtual ActionResult ChooseColumns(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.Action = MvcConstants.ActionDataView;
            var sessionInfo = SessionProvider.ViewPagedDataSession.GetOrAdd(route.Entity, new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) });

            var gridResult = new GridResult<Entities.MasterTables.ChooseColumn>();
            gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
            gridResult.GridSetting = WebUtilities.GetGridSetting(_commonCommands, route, sessionInfo.PagedDataInfo, true, gridResult.Permission, this.Url);
            gridResult.Records = (List<Entities.MasterTables.ChooseColumn>)_commonCommands.GetMasterTableObject(EntitiesAlias.ChooseColumn);
            gridResult.Operations = _commonCommands.ChooseColumnOperations();

            var currentUserColumnSettings = _commonCommands.GetUserColumnSettings(route.Entity);
            SessionProvider.UserColumnSetting = (currentUserColumnSettings == null) ? RestoreUserColumnSettings(route) : currentUserColumnSettings;

            var colAlias = route.Entity == EntitiesAlias.Job ? _commonCommands.GetGridColumnSettings(route.Entity, false, true) : _commonCommands.GetColumnSettings(route.Entity);
            if (route.Entity == EntitiesAlias.SystemAccount)
            {
                colAlias.ToList().ForEach(c =>
                {
                    if (c.ColColumnName.Equals(WebApplicationConstants.IsSysAdmin, System.StringComparison.OrdinalIgnoreCase))
                    {
                        c.GlobalIsVisible = SessionProvider.ActiveUser.IsSysAdmin;
                    }
                });
            }
            else if (route.Entity == EntitiesAlias.SystemReference)
            {
                colAlias.ToList().ForEach(c =>
                {
                    if (c.ColColumnName.Equals(WebApplicationConstants.SysLookupId, System.StringComparison.OrdinalIgnoreCase))
                    {
                        c.GlobalIsVisible = false;
                    }
                });
            }

            var columnSettingsFromColumnAlias = colAlias.Where(c => c.GlobalIsVisible && !GetPrimaryKeyColumns().Contains(c.ColColumnName)).Select(x => (APIClient.ViewModels.ColumnSetting)x.Clone()).ToList();
            gridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(columnSettingsFromColumnAlias, SessionProvider).OrderBy(x => x.ColSortOrder).Where(x => !x.DataType.EqualsOrdIgnoreCase("varbinary")).ToList();


            return PartialView(MvcConstants.ChooseColumnPartial, gridResult);
        }

        public virtual ActionResult InsAndUpdChooseColumn()
        {
            WebUtilities.ClearGridLayout(SessionProvider.UserColumnSetting.ColTableName);//To clear the cached Grid layout if changing the column visibility or order
            var result = _commonCommands.InsAndUpdChooseColumn(SessionProvider.UserColumnSetting);
            return Json(new { status = true, recordId = result.ColUserId }, JsonRequestBehavior.AllowGet);
        }

        #endregion Choose Column

        #region RichEdit

        public virtual ActionResult RichEditFormView(ByteArray byteArray)
        {
            var byteArrayRoute = new MvcRoute(byteArray.Entity, MvcConstants.ActionRichEditor, BaseRoute.Area);
            byteArrayRoute.RecordId = byteArray.Id;
            var formResult = new FormResult<ByteArray>
            {
                CallBackRoute = byteArrayRoute,
                Record = byteArray
            };
            formResult.Operations = _commonCommands.FormOperations(byteArrayRoute);
            formResult.Operations[OperationTypeEnum.New].Route.Action = MvcConstants.ActionSaveRichEditor;
            formResult.Operations[OperationTypeEnum.Edit].Route.Action = MvcConstants.ActionSaveRichEditor;
            return PartialView(MvcConstants.ViewRichEditForm, formResult);
        }

        public ActionResult GetOpenDialog(string strByteArray)
        {
            var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
            var byteArrayRoute = new MvcRoute(byteArray.Entity, MvcConstants.ActionRichEditor, BaseRoute.Area);
            byteArrayRoute.RecordId = byteArray.Id;
            var formResult = new FormResult<ByteArray>
            {
                CallBackRoute = new MvcRoute(byteArrayRoute, "RichEditorCustomCallBack"),
                Record = byteArray,
                Operations = _commonCommands.FormOperations(byteArrayRoute)
            };
            return PartialView("_RichEditOpenDialog", formResult);
        }

        public ActionResult RichEditFileUploadCallBack(string strByteArray)
        {
            var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
            var uploadedFile = UploadControlExtension.GetUploadedFiles("RichEditFileUpload").First();
            byteArray.Bytes = uploadedFile.FileBytes;
            Session[byteArray.ControlName] = byteArray;
            return new EmptyResult();
        }

        public virtual ActionResult RichEditor(string strByteArray)
        {
            var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
            var byteArrayRoute = new MvcRoute(byteArray.Entity, MvcConstants.ActionRichEditor, BaseRoute.Area);

            byteArrayRoute.RecordId = byteArray.Id;
            var formResult = new FormResult<ByteArray>
            {
                CallBackRoute = new MvcRoute(byteArrayRoute, MvcConstants.ActionRichEditor),
                Record = byteArray,
                Operations = _commonCommands.FormOperations(byteArrayRoute)
            };
            formResult.CallBackRoute.Action = MvcConstants.ActionRichEditor;
            return PartialView(MvcConstants.ViewRichEditorPartial, formResult);
        }

        public ActionResult RichEditorCustomCallBack(string strByteArray)
        {
            var byteArray = JsonConvert.DeserializeObject<ByteArray>(strByteArray);
            if (Session[byteArray.ControlName] != null && Session[byteArray.ControlName] is ByteArray)
                byteArray = (ByteArray)Session[byteArray.ControlName];
            else
                byteArray.Bytes = RichEditExtension.SaveCopy(byteArray.ControlName, DevExpress.XtraRichEdit.DocumentFormat.OpenXml);
            if (((!string.IsNullOrEmpty(byteArray.FileName) && byteArray.FileName.Equals(WebApplicationConstants.SaveRichEdit)) || (byteArray.FieldName == "GwyComment")) && Request.Params[WebApplicationConstants.ByteArrayRecordId] != null)
            {
                var dbByteArray = new ByteArray(byteArray);
                dbByteArray.Id = Request.Params[WebApplicationConstants.ByteArrayRecordId].ToLong();
                Stream stream = new MemoryStream(byteArray.Bytes);
                RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                richEditDocumentServer.LoadDocument(stream, DevExpress.XtraRichEdit.DocumentFormat.OpenXml);
                dbByteArray.DocumentText = richEditDocumentServer.Text;
                _commonCommands.SaveBytes(dbByteArray, byteArray.Bytes);
            }
            var byteArrayRoute = new MvcRoute(byteArray.Entity, MvcConstants.ActionRichEditor, BaseRoute.Area);
            DocumentManager.CloseDocument(byteArray.DocumentId);
            var formResult = new FormResult<ByteArray>
            {
                CallBackRoute = new MvcRoute(byteArrayRoute),
                Record = byteArray,
            };
            Session.Remove(string.Concat(byteArray.ControlName));
            return PartialView(MvcConstants.ViewRichEditorPartial, formResult);
        }

        #endregion RichEdit

        #region Check Record Used
        [HttpPost]
        public ActionResult CheckRecordUsed(string strRoute, string allRecordIds, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var isRecordUsed = _commonCommands.CheckRecordUsed(allRecordIds, BaseRoute.Entity);
            var currentGridSettings = WebUtilities.GetGridSetting(_commonCommands, route, SessionProvider.ViewPagedDataSession[BaseRoute.Entity].PagedDataInfo, true, Permission.ReadOnly, this.Url);

            if (!string.IsNullOrWhiteSpace(gridName))
                currentGridSettings.GridName = gridName;

            if (!isRecordUsed)
            {
                var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.DeleteWarning);

                var noOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.No.ToString()));
                noOperation.SetupOperationRoute(route);

                var yesOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Yes.ToString()));
                yesOperation.SetupOperationRoute(route, string.Format(JsConstants.DeleteConfirmClick, currentGridSettings.GridName));

                return Json(new { status = true, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.DeleteMoreInfo);

                var deleteOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.DeleteMoreInfo.ToString()));
                var deleteInfoRoute = new MvcRoute()
                {
                    Action = "GetDeleteInfo",
                    Entity = EntitiesAlias.Common,
                    Area = String.Empty,
                    ParentEntity = route.Entity,
                    Url = allRecordIds
                };
                deleteOperation.ClickEvent = string.Format(JsConstants.DeleteMoreInfoEvent, Newtonsoft.Json.JsonConvert.SerializeObject(deleteInfoRoute));
                var cancelOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Cancel.ToString()));
                cancelOperation.SetupOperationRoute(route);

                return Json(new { status = true, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
            }
        }

        #endregion Check Record Used

        #region Insert Update Status Messages

        public JsonResult ErrorMessageForInsertOrUpdate(long recordId, MvcRoute route)
        {
            var errDisplayMessage = recordId > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.SaveError);
            return Json(new { status = false, displayMessage = errDisplayMessage, route = route }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SuccessMessageForInsertOrUpdate(long recordId, MvcRoute route, List<ByteArray> byteArray = null,
              bool reloadApplication = false, long newRecordId = 0, string jobGatewayStatus = null, MvcRoute tabRoute = null)
        {
            var displayMessage = new DisplayMessage();
            displayMessage = recordId > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
            displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));

            if (reloadApplication && route.Entity == EntitiesAlias.Organization)
            {
                displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.NewOrganization);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route, string.Format(JsConstants.NewOrganizationCreated, newRecordId, JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)))));
                displayMessage.CloseType = "";
                reloadApplication = false;
            }

            if (byteArray != null && byteArray.Count > 0)
                return Json(new
                {
                    status = true,
                    route = route,
                    byteArray = byteArray,
                    displayMessage = displayMessage,
                    reloadApplication = reloadApplication,
                    jobGatewayStatus = jobGatewayStatus,
                    tabRoute = tabRoute,
                }, JsonRequestBehavior.AllowGet);
            return Json(new
            {
                status = true,
                route = route,
                displayMessage = displayMessage,
                jobGatewayStatus = jobGatewayStatus,
                tabRoute = tabRoute,
            }, JsonRequestBehavior.AllowGet);
        }

        #endregion Insert Update Status Messages

        #region Ribbon

        #region Clipboard

        public ActionResult Cut(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.RecordIds = new List<long> { route.RecordId };
            sessionInfo.IsCut = true;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public virtual ActionResult Copy(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.RecordIds = new List<long> { route.RecordId };
            sessionInfo.IsCut = false;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Paste(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var currentRecordIds = sessionInfo.RecordIds;
            var isCut = sessionInfo.IsCut;
            sessionInfo.RecordIds = new List<long>();
            sessionInfo.IsCut = false;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        #endregion Clipboard

        #region Sort & Filter

        public ActionResult ClearFilter(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SortAsc(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult SortDesc(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult RemoveSort(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult AdvancedSortFilter(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.AdvanceFilter = !sessionInfo.AdvanceFilter;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            return Json(new { status = true, ownerName = string.Format("{0}{1}", route.Entity.ToString(), MvcConstants.ActionGridView), callbackMethod = MvcConstants.ActionPerformCallBack, route = new MvcRoute(route, MvcConstants.ActionAdvancedSortFilter) }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ToggleFilter(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                ? SessionProvider.ViewPagedDataSession[route.Entity]
                : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PreviousToggleFilter = sessionInfo.ToggleFilter;
            sessionInfo.ToggleFilter = !sessionInfo.ToggleFilter;

            //clearing Filters when toggle filter not applied
            if (!sessionInfo.ToggleFilter)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState = null;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = null;
                SessionProvider.ViewPagedDataSession[route.Entity].Filters = null;
            }

            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            return Json(new { status = true, ownerName = WebApplicationConstants.AppCbPanel, callbackMethod = MvcConstants.ActionPerformCallBack, shouldUpdateCurrentRoute = route.UpdateToggleFilterRouteForChildGrid(SessionProvider, ViewData), route = new MvcRoute(route, MvcConstants.ActionToggleFilter, recordId: 0) }, JsonRequestBehavior.AllowGet);
        }

        #endregion Sort & Filter

        #region Records

        public ActionResult Refresh(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            //var ownerCbPanel = route.Entity == EntitiesAlias.Job ? WebApplicationConstants.JobDetailCbPanel
            //    : WebApplicationConstants.AppCbPanel;
            var routeResult =
                  (SessionProvider.ActiveUser.CurrentRoute != null
                   && SessionProvider.ActiveUser.CurrentRoute.Action == MvcConstants.ActionForm
                   && SessionProvider.ActiveUser.CurrentRoute.Entity == EntitiesAlias.Job
                   && SessionProvider.ActiveUser.CurrentRoute.Action != MvcConstants.ActionTreeView)
                   //&& SessionProvider.ActiveUser.LastRoute.Action != "DataView")
                   ? SessionProvider.ActiveUser.CurrentRoute
                   : SessionProvider.ActiveUser.LastRoute;
            var ownerCbPanel = (route.Entity == EntitiesAlias.JobAdvanceReport
                || route.Entity == EntitiesAlias.JobCard
                || (route.Entity == EntitiesAlias.Job
                && route.ParentEntity != EntitiesAlias.Program
                && SessionProvider.ActiveUser.CurrentRoute != null
                && SessionProvider.ActiveUser.CurrentRoute.Action != MvcConstants.ActionTreeView
                && SessionProvider.ActiveUser.CurrentRoute.Action != MvcConstants.ActionTabViewCallBack))
                ? WebApplicationConstants.AppCbPanel : routeResult.OwnerCbPanel;
            return Json(new
            {
                status = true,
                ownerName = ownerCbPanel,
                callbackMethod = MvcConstants.ActionPerformCallBack,
                route = JsonConvert.SerializeObject(routeResult)
            },
              JsonRequestBehavior.AllowGet);
        }
        public ActionResult Create(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = WebApplicationConstants.AppCbPanel;
            var callbackMethod = MvcConstants.ActionPerformCallBack;
            var routeToSend = route;
            routeToSend.RecordId = 0;
            routeToSend.Action = MvcConstants.ActionForm;
            //if (routeToSend.Entity == EntitiesAlias.OrgRefRole)
            //    routeToSend.Action = MvcConstants.ActionTabView;
            routeToSend.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = JsonConvert.SerializeObject(routeToSend) }, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Save(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var lastRoute = SessionProvider.ActiveUser.LastRoute;
            var ownerName = string.Empty;
            if (SessionProvider.ViewPagedDataSession.Count > 0
                && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView)//if (route.IsDataView == true)
            {
                if (SessionProvider.ActiveUser.LastRoute.RecordId == 1)
                    ownerName = string.Concat("btn", lastRoute.Entity, "Save");
                else
                    ownerName = string.Concat("btnSave", lastRoute.Entity, WebApplicationConstants.GridName);//This is the standard button name using in the GridView
            }

            else if ((lastRoute != null) && (lastRoute.Action.EqualsOrdIgnoreCase(MvcConstants.ActionForm)
                || lastRoute.Action.EqualsOrdIgnoreCase(MvcConstants.ActionPasteForm)
                || lastRoute.Action.EqualsOrdIgnoreCase(MvcConstants.ActionTreeView)
                || lastRoute.Action.EqualsOrdIgnoreCase(MvcConstants.ActionTabView)))
                ownerName = string.Concat("btn", lastRoute.Controller, "Save");//This is the standard button name using in the FormView
            if ((route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.Job ||
                route.Entity == EntitiesAlias.JobAdvanceReport) && route.Action == "Save" &&
                (SessionProvider.ActiveUser.CurrentRoute != null
                && SessionProvider.ActiveUser.CurrentRoute.Action == MvcConstants.ActionForm))
            {
                ownerName = string.Concat("btn", EntitiesAlias.Job.ToString(), "Save");
            }
            return Json(new { status = true, ownerName = ownerName, callbackMethod = MvcConstants.ActionDoClick }, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Delete(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var url = Url.Action(MvcConstants.ActionCheckRecordUsed, route.Controller, new { Area = route.Area, strRoute = JsonConvert.SerializeObject(route) }) + "&allRecordIds=" + route.RecordId;
            return Json(new { status = true, ownerName = string.Empty, callbackMethod = string.Empty, route = route, isCheckRecordUsed = true, checkRecordUsedUrl = url }, JsonRequestBehavior.AllowGet);
        }

        #endregion Records

        #region Find

        public ActionResult Find(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Replace(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GoToRecord(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Select(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        #endregion Find

        #region Export Data

        public void ExportExcel(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.RecordId = 0;
            FileStreamResult currentResult = null;
            GridResult<TView> currentGridResult = new GridResult<TView>();
            route.GridRouteSessionSetup(SessionProvider, currentGridResult, GetorSetUserGridPageSize(), ViewData);
            var sessionInfo = currentGridResult.SessionProvider.ViewPagedDataSession[route.Entity];
            var previousPageNumber = sessionInfo.PagedDataInfo.PageNumber;
            var previousPageSize = sessionInfo.PagedDataInfo.PageSize;
            sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.PagedDataInfo.PageSize = sessionInfo.PagedDataInfo.TotalCount;
            currentGridResult.Records = _currentEntityCommands.GetPagedData(sessionInfo.PagedDataInfo);
            sessionInfo.PagedDataInfo.PageNumber = previousPageNumber;
            sessionInfo.PagedDataInfo.PageSize = previousPageSize;
            if (SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState != null)
                currentGridResult.GridViewModel.ApplyFilteringState(sessionInfo.GridViewFilteringState as GridViewFilteringState);
            currentGridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(BaseRoute.Entity), SessionProvider);
            var gridSettings = WebUtilities.CreateExportGridViewSettings(currentGridResult, _commonCommands);
            gridSettings.SettingsExport.Landscape = true;
            currentResult = (FileStreamResult)GridViewExtension.ExportToXlsx(gridSettings, currentGridResult.Records);
            var response = System.Web.HttpContext.Current.Response;
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.AddHeader("content-disposition", "attachment; filename=" + currentResult.FileDownloadName);
            response.ContentType = currentResult.ContentType;
            this.Response.BinaryWrite(((MemoryStream)currentResult.FileStream).ToArray());
            this.Response.End();
        }

        public ActionResult ExportEmail(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            var ownerName = string.Empty;
            var callbackMethod = string.Empty;
            var routeToSend = string.Empty;
            return Json(new { status = true, ownerName = ownerName, callbackMethod = callbackMethod, route = routeToSend }, JsonRequestBehavior.AllowGet);
        }

        public void ExportPdf(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.RecordId = 0;
            FileStreamResult currentResult = null;
            GridResult<TView> currentGridResult = new GridResult<TView>();
            route.GridRouteSessionSetup(SessionProvider, currentGridResult, GetorSetUserGridPageSize(), ViewData);
            var sessionInfo = currentGridResult.SessionProvider.ViewPagedDataSession[route.Entity];
            var previousPageNumber = sessionInfo.PagedDataInfo.PageNumber;
            var previousPageSize = sessionInfo.PagedDataInfo.PageSize;
            sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.PagedDataInfo.PageSize = sessionInfo.PagedDataInfo.TotalCount;
            currentGridResult.Records = _currentEntityCommands.GetPagedData(sessionInfo.PagedDataInfo);
            sessionInfo.PagedDataInfo.PageNumber = previousPageNumber;
            sessionInfo.PagedDataInfo.PageSize = previousPageSize;
            if (SessionProvider.ViewPagedDataSession[route.Entity].GridViewFilteringState != null)
                currentGridResult.GridViewModel.ApplyFilteringState(sessionInfo.GridViewFilteringState as GridViewFilteringState);
            currentGridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(BaseRoute.Entity), SessionProvider);
            var gridSettings = WebUtilities.CreateExportGridViewSettings(currentGridResult, _commonCommands, 800);
            gridSettings.SettingsExport.Landscape = true;
            var pdfExportOptions = new DevExpress.XtraPrinting.PdfExportOptions();
            currentResult = (FileStreamResult)GridViewExtension.ExportToPdf(gridSettings, currentGridResult.Records, pdfExportOptions);
            var response = System.Web.HttpContext.Current.Response;
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.AddHeader("content-disposition", "attachment; filename=" + currentResult.FileDownloadName);
            response.ContentType = currentResult.ContentType;
            this.Response.BinaryWrite(((MemoryStream)currentResult.FileStream).ToArray());
            this.Response.End();
        }

        #endregion Export Data

        #region Attachments
        public FileResult DownloadAll(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            try
            {
                var attachmentViewList = _commonCommands.DownloadAll(route.RecordId);

                if (attachmentViewList?.Count > 0)
                {
                    string fileName = attachmentViewList[0].AttTitle;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (var archive = new System.IO.Compression.ZipArchive(ms, ZipArchiveMode.Create, true))
                        {
                            foreach (var file in attachmentViewList)
                            {
                                var entry = archive.CreateEntry(file.AttFileName, CompressionLevel.Fastest);
                                using (var zipStream = entry.Open())
                                {
                                    zipStream.Write(file.AttData, 0, file.AttData.Length);
                                }
                            }
						}

						return File(ms.ToArray(), "application/zip", fileName + ".zip");
					}
				}
				return null;
                        }
			catch (Exception ex)
			{
				return null;
			}

		}

		public FileResult DownloadBOL(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			try
			{
				var bolDocument = _commonCommands.DownloadBOL(route.RecordId);

				if (bolDocument != null && !string.IsNullOrEmpty(bolDocument.DocumentHtml))
				{
					string fileName = "BOL_" + bolDocument.DocumentName;
					using (MemoryStream stream = new System.IO.MemoryStream())
					{
						StringReader sr = new StringReader(bolDocument.DocumentHtml);
						Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 100f, 0f);
						PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
						pdfDoc.Open();
						XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
						pdfDoc.Close();
						return File(stream.ToArray(), "application/pdf", fileName);
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

		public FileResult DownloadTracking(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			try
			{
				var bolDocument = _commonCommands.DownloadTracking(route.RecordId);

				if (bolDocument != null && !string.IsNullOrEmpty(bolDocument.DocumentHtml))
				{
					string fileName = "Tracking_" + bolDocument.DocumentName;
					using (MemoryStream stream = new System.IO.MemoryStream())
					{
						StringReader sr = new StringReader(bolDocument.DocumentHtml);
						Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 100f, 0f);
						PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
						pdfDoc.Open();
						XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
						pdfDoc.Close();
						return File(stream.ToArray(), "application/pdf", fileName);
					}
				}

				return null;
			}
			catch (Exception ex)
			{
				return null;
			}

		}

		public FileResult DownloadPriceReport(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			try
			{
				var priceReportDocument = _commonCommands.GetPriceCodeReportByJobId(route.RecordId);

				if (priceReportDocument != null && !string.IsNullOrEmpty(priceReportDocument.DocumentName))
				{
					string fileName = "PriceReport_" + priceReportDocument.DocumentName;
					return File(priceReportDocument.DocumentContent, "text/csv", fileName);
				}

				return null;
			}
			catch (Exception ex)
			{
				return null;
			}

		}

		#endregion Attachments
		#endregion Ribbon
		private string GetCallbackViewName(EntitiesAlias entity)
        {
            string callbackDataViewName = MvcConstants.GridViewPartial;
            switch (entity)
            {
                case EntitiesAlias.MenuDriver:
                    callbackDataViewName = MvcConstants.ViewMenuGridViewPartial;
                    break;
                case EntitiesAlias.JobGateway:
                case EntitiesAlias.SystemAccount:
                case EntitiesAlias.Job:
                case EntitiesAlias.JobCargo:
                case EntitiesAlias.PrgEdiHeader:
                case EntitiesAlias.DeliveryStatus:
                case EntitiesAlias.StatusLog:
                case EntitiesAlias.CustBusinessTerm:
                case EntitiesAlias.CustContact:
                case EntitiesAlias.CustDcLocation:
                case EntitiesAlias.CustDcLocationContact:
                case EntitiesAlias.CustFinancialCalendar:
                case EntitiesAlias.VendBusinessTerm:
                case EntitiesAlias.VendContact:
                case EntitiesAlias.VendDcLocation:
                case EntitiesAlias.VendDcLocationContact:
                case EntitiesAlias.VendFinancialCalendar:
                case EntitiesAlias.PrgRefGatewayDefault:
                case EntitiesAlias.ScrCatalogList:
                case EntitiesAlias.ScnCargoBCPhoto:
                case EntitiesAlias.PrgEdiMapping:
                case EntitiesAlias.MenuOptionLevel:
                case EntitiesAlias.SubSecurityByRole:
                case EntitiesAlias.Contact:
                case EntitiesAlias.Validation:
                case EntitiesAlias.JobDocReference:
                case EntitiesAlias.PrgBillableRate:
                case EntitiesAlias.PrgCostRate:
                case EntitiesAlias.PrgCostLocation:
                case EntitiesAlias.PrgBillableLocation:
                case EntitiesAlias.JobHistory:
                case EntitiesAlias.JobAdvanceReport:
                    callbackDataViewName = MvcConstants.ActionDataView;
                    break;
                case EntitiesAlias.OrgRolesResp:
                    callbackDataViewName = MvcConstants.GridView;
                    break;
                    //case EntitiesAlias.JobAdvanceReport:
                    //    callbackDataViewName = MvcConstants.ViewDetailGridViewPartial;
                    //    break;
            }
            return callbackDataViewName;
        }

        #region Report 
        public virtual ActionResult ExportReportViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            var report = new XtraReportProvider();
            if (byteArray.Bytes != null && byteArray.Bytes.Length > 100)
            {
                report = new XtraReportProvider();
                using (MemoryStream ms = new MemoryStream(byteArray.Bytes))
                    report.LoadLayoutFromXml(ms);
            }

            return DocumentViewerExtension.ExportTo(report);
        }
        #endregion

        #region Copy/Paste Record

        public void CopyRecord(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if ((route.RecordId > 0) && (SessionProvider != null) && (SessionProvider.ActiveUser != null))
                SessionProvider.ActiveUser.CopiedRecord = new MvcRoute { RecordIdToCopy = route.RecordId, Entity = route.Entity, OwnerCbPanel = route.OwnerCbPanel };
        }

        public ActionResult PasteRecord(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if ((SessionProvider != null) && (SessionProvider.ActiveUser != null) && (SessionProvider.ActiveUser.CopiedRecord != null) && (SessionProvider.ActiveUser.CopiedRecord.Entity == route.Entity))
                return Json(new { status = true, ownerName = WebApplicationConstants.AppCbPanel, callbackMethod = MvcConstants.ActionPerformCallBack, route = JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionPasteForm, recordId: 0, recordIdToCopy: SessionProvider.ActiveUser.CopiedRecord.RecordIdToCopy, ownerCbPanel: SessionProvider.ActiveUser.CopiedRecord.OwnerCbPanel)) }, JsonRequestBehavior.AllowGet);
            else
                return Json(new { status = false }, JsonRequestBehavior.AllowGet);
        }

        #endregion Copy/Paste Record
    }
}