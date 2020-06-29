/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AppDashboardController
//Purpose:                                      Contains Actions to render view on Vendor's AppDashboard page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Vendor.Controllers
{
    public class AppDashboardController : BaseDashboardController
    {
        protected GridResult<AppDashboardView> _gridResult = new GridResult<AppDashboardView>();
        public AppDashboardController(IAppDashboardCommands appDashboardCommands, ICommonCommands commonCommands)
            : base(DashboardConfig.VendAppDashboardConfigurator(commonCommands, commonCommands.Tables[EntitiesAlias.Vendor].TblMainModuleId))
        {
            _appDashboardCommands = appDashboardCommands;
            _commonCommands = commonCommands;
        }

        public ActionResult Dashboard(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Vendor, _commonCommands.Tables[EntitiesAlias.Vendor].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            _dashboardResult.SetupDashboardResult(_commonCommands, route, SessionProvider);
            if (_dashboardResult.DashboardRoute.RecordId > 0)
                return PartialView(MvcConstants.ViewDashboard, _dashboardResult);
            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoDashboard));
        }

        public ActionResult DashboardViewer(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Vendor, _commonCommands.Tables[EntitiesAlias.Vendor].TblMainModuleId);
            _dashboardResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDashboardInfo);
            _dashboardResult.DashboardRoute = new MvcRoute(route, MvcConstants.ActionDashboardViewer);
            return PartialView(MvcConstants.ViewDashboardViewer, _dashboardResult);
        }

        public ActionResult RibbonMenu(string strRoute)
        {
            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.OwnerCbPanel = WebApplicationConstants.RibbonCbPanel;

            var ribbonMenus = _commonCommands.GetRibbonMenus().ToList();

            if (WebGlobalVariables.ModuleMenus.Count == 0)
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

            var mainModuleRibbons = (from mnu in WebGlobalVariables.ModuleMenus
                                     join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
                                     where mnu.MnuBreakDownStructure.StartsWith("01")
                                     select mnu.SetRibbonMenu()).ToList();

            SessionProvider.UserSecurities.ToList().ForEach(sec => mainModuleRibbons.GetNotAccessibleMenus(sec).ForEach(nmnu => mainModuleRibbons.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));

            //Comment this line if want to show on ribbon if it has no operations to perform
            mainModuleRibbons.RemoveAll(mnu => mnu.Children.Count == 0);

            ribbonMenus.AddRange(mainModuleRibbons);
            ViewData[MvcConstants.LastActiveTabRoute] = route;
            ribbonMenus.ForEach(r => r.RibbonRoute(route, ribbonMenus.IndexOf(r), new MvcRoute { Entity = EntitiesAlias.AppDashboard, Area = "Administration" }, _commonCommands, SessionProvider));
            return PartialView(MvcConstants.ViewRibbonMenu, ribbonMenus);
        }

        protected void SetGridResult(MvcRoute route, string gridName = "")
        {
            var currentGridViewModel = GridViewExtension.GetViewModel(!string.IsNullOrWhiteSpace(gridName) ? gridName : WebUtilities.GetGridName(route));
            _gridResult.GridViewModel = (currentGridViewModel != null) ? currentGridViewModel : new GridViewModel();
            _gridResult.GridViewModel.KeyFieldName = WebApplicationConstants.KeyFieldName;
            route.GridRouteSessionSetup(SessionProvider, _gridResult, GetorSetUserGridPageSize(), ViewData);
            _gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
            _gridResult.Records = _appDashboardCommands.GetPagedData(_gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo);
            _gridResult.GridSetting = WebUtilities.GetGridSetting(_commonCommands, route, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo, _gridResult.Records.Count > 0, _gridResult.Permission, this.Url);
            if (!string.IsNullOrWhiteSpace(gridName))
                _gridResult.GridSetting.GridName = gridName;
            _gridResult.GridSetting.ShowFilterRow = SessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter;
            _gridResult.GridSetting.ShowAdanceFilter = SessionProvider.ViewPagedDataSession[route.Entity].AdvanceFilter;
            _gridResult.Operations = _commonCommands.GridOperations();
            _gridResult.GridSetting.DataRowType = typeof(AppDashboardView);
            if (SessionProvider.UserColumnSetting == null || string.IsNullOrEmpty(SessionProvider.UserColumnSetting.ColTableName)
                   || !SessionProvider.UserColumnSetting.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.AppDashboard.ToString()))
            {
                SessionProvider.UserColumnSetting = _commonCommands.GetUserColumnSettings(EntitiesAlias.AppDashboard);
            }
            _gridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.AppDashboard), SessionProvider);
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;

            _gridResult.GridViewModel.Pager.PageSize = _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize;
            _gridResult.GridViewModel.Pager.PageIndex = _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber - 1;


            //reset the pageindex when Filter applied and pageing is opted

            if ((ViewData[WebApplicationConstants.ViewDataFilterPageNo] != null) && ((double)_gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount / _gridResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize >= (int)ViewData[WebApplicationConstants.ViewDataFilterPageNo]))
                _gridResult.GridViewModel.Pager.PageIndex = ((int)ViewData[WebApplicationConstants.ViewDataFilterPageNo] - 1);

            _gridResult.GridViewModel.ProcessCustomBinding(GetDataRowCount, GetData);
        }

        #region Data View

        public PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;
            SetGridResult(route, gridName);
            if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
                return PartialView(MvcConstants.ViewDetailGridViewPartial, _gridResult);
            return PartialView(_gridResult);
        }

        public void GetDataRowCount(GridViewCustomBindingGetDataRowCountArgs e)
        {
            e.DataRowCount = SessionProvider.ViewPagedDataSession[EntitiesAlias.AppDashboard].PagedDataInfo.TotalCount;
        }

        public void GetData(GridViewCustomBindingGetDataArgs e)
        {
            e.Data = _gridResult.Records;
            if (SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnState != null)
                _gridResult.GridViewModel.ApplySortingState(SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnState as GridViewColumnState, SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewColumnStateReset);
            if (SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewFilteringState != null)
                _gridResult.GridViewModel.ApplyFilteringState(SessionProvider.ViewPagedDataSession[_gridResult.GridSetting.CallBackRoute.Entity].GridViewFilteringState as GridViewFilteringState);
        }

        #region Paging

        public PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
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
            SetGridResult(route);
            _gridResult.GridViewModel.ApplyPagingState(pager);
            return PartialView(MvcConstants.GridViewPartial, _gridResult);
        }

        #endregion Paging

        #region Batch Update

        public Dictionary<long, string> BatchUpdate(MVCxGridViewBatchUpdateValues<AppDashboardView, long> batchEdit, MvcRoute route, string gridName)
        {
            _appDashboardCommands.ActiveUser = SessionProvider.ActiveUser;
            var batchError = new Dictionary<long, string>();
            foreach (var item in batchEdit.Insert)
            {
                var messages = ValidateMessages(item, route.Entity, true, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);

                    if (!(_appDashboardCommands.Post(item) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
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
                var messages = ValidateMessages(item, route.Entity, true, false, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);
                    if (!(_appDashboardCommands.Put(item) is SysRefModel) && route.Entity != EntitiesAlias.SystemReference)
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
                var nonDeletedRecords = _appDashboardCommands.Delete(batchEdit.DeleteKeys, WebApplicationConstants.ArchieveStatusId);

                if (nonDeletedRecords.Count > 0)
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId), batchEdit.DeleteKeys.Except(nonDeletedRecords.Select(c => c.ParentId)).ToList());
                    nonDeletedRecords.ToList().ForEach(c => batchError.Add(c.ParentId, DbConstants.DeleteError));
                }
                else
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId), batchEdit.DeleteKeys);
                }
            }

            return batchError;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<AppDashboardView, long> dashboardView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            dashboardView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            dashboardView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(dashboardView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return PartialView(MvcConstants.GridViewPartial, _gridResult);
        }

        #endregion Batch Update

        #region Filtering & Sorting

        public PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;

            if (sessionInfo.Filters == null)
                sessionInfo.Filters = new Dictionary<string, string>();

            //used to reset page index of the grid when Filter applied and pageing is opted
            ViewData[WebApplicationConstants.ViewDataFilterPageNo] = sessionInfo.PagedDataInfo.PageNumber;

            sessionInfo.PagedDataInfo.WhereCondition = filteringState.BuildGridFilterWhereCondition(route.Entity, ref filters, _commonCommands);
            if (sessionInfo.Filters != null && filters.Count > 0 && sessionInfo.Filters.Count != filters.Count)//Have to search from starting if setup filter means from page 1
                sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.Filters = filters;
            sessionInfo.GridViewFilteringState = filteringState;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            _gridResult.SessionProvider = SessionProvider;
            SetGridResult(route, gridName);
            return PartialView(MvcConstants.GridViewPartial, _gridResult);
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
            return PartialView(MvcConstants.GridViewPartial, _gridResult);
        }

        #endregion Filtering & Sorting

        #endregion Data View

        #region Validation Messages

        public List<string> ValidateMessages(AppDashboardView viewRecord, EntitiesAlias? currentEntity = null, bool fromBatchUpdate = false, bool isFormView = true, long? parentId = null)
        {
            var recordId = (viewRecord as SysRefModel).Id;
            var entity = currentEntity ?? EntitiesAlias.AppDashboard;
            var errorMessages = new Dictionary<string, string>();
            var props = viewRecord.GetType().GetProperties();
            var propNames = props.Select(c => c.Name).ToList();
            var columnSettings = _commonCommands.GetColumnSettings(entity).ToList();

            var requiredProps = columnSettings.Where(req => req.IsRequired && propNames.Contains(req.ColColumnName) && props[propNames.IndexOf(req.ColColumnName)].GetValue(viewRecord) == null).ToList();
            requiredProps.ForEach(req =>
            {
                if (!fromBatchUpdate || !req.DataType.EqualsOrdIgnoreCase(SQLDataTypes.Name.ToString()))
                    errorMessages.Add(req.ColColumnName, req.RequiredMessage);
            });

            var uniqueProps = columnSettings.Where(uni => uni.IsUnique && propNames.Contains(uni.ColColumnName) && props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord) != null).ToList();

            uniqueProps.ForEach(uni =>
            {
                var fieldValue = props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord);
                if (!_commonCommands.GetIsFieldUnique(new UniqueValidation { Entity = entity, FieldName = uni.ColColumnName, FieldValue = fieldValue != null ? fieldValue.ToString() : string.Empty, RecordId = recordId, ParentFilter = viewRecord.GetParentFilter(props, entity), ParentId = parentId }))
                {
                    if (errorMessages.ContainsKey(uni.ColColumnName))
                        errorMessages[uni.ColColumnName] = string.Concat(errorMessages[uni.ColColumnName], ", ", uni.UniqueMessage);
                    else
                        errorMessages.Add(uni.ColColumnName, uni.UniqueMessage);
                }
            });

            var regExProps = _commonCommands.GetValidationRegExpsByEntityAlias(entity);

            if (regExProps.Count > 0)
                foreach (var pInfo in props)
                {
                    var regExProp = regExProps.FirstOrDefault(v => v.ValFieldName == pInfo.Name);
                    if (regExProp != null)
                        ValidateLogic(viewRecord, props, pInfo.Name, pInfo.PropertyType, pInfo.GetValue(viewRecord), ref errorMessages, regExProp);
                }

            foreach (var errMsg in errorMessages)
                ModelState.UpdateModelError(errMsg.Key, errMsg.Value);

            if (!isFormView)
            {
                var allInvisibleColumns = new List<string>();
                var userColumnSettings = _commonCommands.GetUserColumnSettings(entity);
                if (userColumnSettings != null)
                    allInvisibleColumns = userColumnSettings.ColNotVisible.SplitComma().ToList();
                var allFields = columnSettings.Where(col => propNames.Contains(col.ColColumnName) && props[propNames.IndexOf(col.ColColumnName)].GetValue(viewRecord) == null).ToList();
                allFields.ForEach(field =>
                {
                    if (((userColumnSettings != null) && (allInvisibleColumns.Count > 0)) ? (allInvisibleColumns.IndexOf(field.ColColumnName) < 0) : columnSettings.Where(col => col.ColColumnName == field.ColColumnName).FirstOrDefault().ColIsVisible)
                    {
                        if (!field.DataType.EqualsOrdIgnoreCase(SQLDataTypes.Name.ToString()))
                        {
                            var currentDataType = SQLDataTypes.nvarchar;
                            Enum.TryParse(field.DataType, out currentDataType);
                            switch (currentDataType)
                            {
                                case SQLDataTypes.bigint:
                                    props[propNames.IndexOf(field.ColColumnName)].SetValue(viewRecord, -100);
                                    break;
                                case SQLDataTypes.Int:
                                    props[propNames.IndexOf(field.ColColumnName)].SetValue(viewRecord, -100);
                                    break;
                                case SQLDataTypes.Decimal:
                                    props[propNames.IndexOf(field.ColColumnName)].SetValue(viewRecord, -100.00);
                                    break;
                                case SQLDataTypes.nvarchar:
                                case SQLDataTypes.varchar:
                                    props[propNames.IndexOf(field.ColColumnName)].SetValue(viewRecord, WebApplicationConstants.M4PLSeparator);
                                    break;
                                case SQLDataTypes.datetime2:
                                    props[propNames.IndexOf(field.ColColumnName)].SetValue(viewRecord, Convert.ToDateTime(WebApplicationConstants.DummyDate));
                                    break;
                            }
                        }
                    }
                });
            }

            return errorMessages.Select(err => err.Value).ToList();
        }

        protected void ValidateLogic(AppDashboardView viewRecord, PropertyInfo[] props, string propertyName, Type propertyType, object propValue, ref Dictionary<string, string> errorMessages, ValidationRegEx regExProp)
        {
            var propNames = props.Select(c => c.Name).ToList();

            var strRegexLogic = "ValRegExLogic";
            var strRegexValue = "ValRegEx";
            var strRegExMessage = "ValRegExMessage";

            for (var i = 0; i < 5; i++)
            {
                var regExLogic = GetPropertyValue(regExProp, strRegexLogic + i);
                var regExValue = GetPropertyValue(regExProp, strRegexValue + (i + 1));
                var regExMessage = GetPropertyValue(regExProp, strRegExMessage + (i + 1));

                //check regex validation
                if (regExLogic == null && regExValue != null)
                {
                    var rgx = new Regex(regExValue.ToString().Trim());

                    if (propValue != null)
                    {
                        if (!rgx.IsMatch(propValue.ToString().Trim()))
                        {
                            AddError(propertyName, regExMessage.ToString(), ref errorMessages);
                            break;
                        }
                    }
                }
                else if (regExLogic != null && regExValue != null)
                {
                    try
                    {
                        var relationalOperator = GetOperator(regExLogic.ToInt());
                        var propName = regExValue.ToString().Trim();

                        #region relation condition checks

                        if (relationalOperator != null && propValue != null)
                        {
                            if (propNames.Any(c => c.Contains(propName)))
                            {
                                var propertyInfo = props[propNames.IndexOf(propName)];
                                object propertyValue = null;
                                if (propertyInfo != null)
                                    propertyValue = propertyInfo.GetValue(viewRecord);

                                //check operator depend -- start
                                if ((propertyValue != null) && (relationalOperator != null))
                                    switch (relationalOperator)
                                    {
                                        case RelationalOperator.Equal:
                                            if (!(TypeCast(propertyType, propValue) == TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;

                                        case RelationalOperator.NotEqual:
                                            if (!(TypeCast(propertyType, propValue) != TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;

                                        case RelationalOperator.GreaterThan:
                                            if (!(TypeCast(propertyType, propValue) > TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;

                                        case RelationalOperator.GreaterThanEqual:
                                            if (!(TypeCast(propertyType, propValue) >= TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;

                                        case RelationalOperator.LessThan:
                                            if (!(TypeCast(propertyType, propValue) < TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;

                                        case RelationalOperator.LessThanEqual:
                                            if (!(TypeCast(propertyType, propValue) <= TypeCast(propertyInfo.PropertyType, propertyValue)))
                                                AddError(propertyInfo.Name, regExMessage.ToString(), ref errorMessages);
                                            break;
                                    }
                                //end
                                else if (propertyValue == null)
                                    continue;
                            }
                        }

                        #endregion relation condition checks

                        #region check for remaining fields

                        else
                        {
                            propName = regExValue.ToString().Split('[')[1].Split(']')[0];

                            if (propValue == null && regExLogic != null && GetOperator(regExLogic.ToInt()) == RelationalOperator.Or)
                                if (propNames.Any(c => c.Contains(propName)))
                                {
                                    //get row based on field name
                                    var propertyInformation = props[propNames.IndexOf(propName)];

                                    if (propertyInformation != null)
                                    {
                                        var propertyInformationValue = propertyInformation.GetValue(viewRecord);
                                        if (propertyInformationValue == null)
                                            AddError(propertyName, regExMessage.ToString(), ref errorMessages);
                                        else
                                        {
                                            RemoveError(propertyName, ref errorMessages);
                                            break;
                                        }
                                    }
                                }
                        }

                        #endregion check for remaining fields
                    }
                    catch
                    {
                    }
                    //end
                }
            }
        }

        public RelationalOperator? GetOperator(int refId)
        {
            switch (refId)
            {
                case 167:
                    return RelationalOperator.Or;

                case 168:
                    return RelationalOperator.And;

                case 169:
                    return RelationalOperator.Not;

                case 170:
                    return RelationalOperator.Equal;

                case 171:
                    return RelationalOperator.NotEqual;

                case 172:
                    return RelationalOperator.GreaterThan;

                case 173:
                    return RelationalOperator.LessThan;

                case 174:
                    return RelationalOperator.GreaterThanEqual;

                case 175:
                    return RelationalOperator.LessThanEqual;

                default:
                    return null;
            }
        }

        public object GetPropertyValue<T>(T entity, string strRegexLogic)
        {
            var dataMemberPropertiess =
                entity.GetType().GetProperties().Where(c => c.Name == strRegexLogic).FirstOrDefault();
            var memberValue = dataMemberPropertiess.GetValue(entity);

            return memberValue;
        }

        private void RemoveError(string fieldName, ref Dictionary<string, string> errorMessages)
        {
            errorMessages.Remove(fieldName);
        }

        private void AddError(string fieldName, string errorMesssge, ref Dictionary<string, string> errorMessages)
        {
            if (errorMessages.ContainsKey(fieldName))
            {
                if (!errorMessages[fieldName].Contains(errorMesssge))
                    errorMessages[fieldName] = string.Concat(errorMessages[fieldName], ", ", errorMesssge);
            }
            else
                errorMessages.Add(fieldName, errorMesssge);
        }

        public dynamic TypeCast(Type type, object value)
        {
            try
            {
                if (type == typeof(int))
                    return Convert.ToInt32(value);
                if (type == typeof(DateTime) || type == typeof(DateTime?))
                    return Convert.ToDateTime(value);
                if (type == typeof(double) || type == typeof(double?))
                    return Convert.ToDouble(value);
                if (type == typeof(decimal) || type == typeof(decimal?))
                    return Convert.ToDecimal(value);
                if (type == typeof(long))
                    return Convert.ToInt64(value);
                return value.ToString();
            }
            catch
            {
                return value.ToString();
            }
        }

        #endregion Validation Messages
    }
}