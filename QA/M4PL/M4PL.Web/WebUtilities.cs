/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 WebUtilities
//Purpose:                                      Provides web utilities method to be used throughout the application
//====================================================================================================================================================*/

using DevExpress.Data.Filtering.Helpers;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace M4PL.Web
{
    public class WebUtilities
    {
        public static void SetPropertyByType(object inputObject, string propertyName, object propertyVal)
        {
            //find out the type
            Type type = inputObject.GetType();

            //get the property information based on the type
            System.Reflection.PropertyInfo propertyInfo = type.GetProperty(propertyName);

            //find the property type
            Type propertyType = propertyInfo.PropertyType;

            //Convert.ChangeType does not handle conversion to nullable types
            //if the property type is nullable, we need to get the underlying type of the property
            var targetType = IsNullableType(propertyType) ? Nullable.GetUnderlyingType(propertyType) : propertyType;

            //Returns an System.Object with the specified System.Type and whose value is
            //equivalent to the specified object.
            propertyVal = Convert.ChangeType(propertyVal, targetType);

            //Set the value of the property
            propertyInfo.SetValue(inputObject, propertyVal, null);

        }
        private static bool IsNullableType(Type type)
        {
            return type.IsGenericType && type.GetGenericTypeDefinition().Equals(typeof(Nullable<>));
        }
        public static GridSetting GetGridSetting(ICommonCommands commonCommands, MvcRoute route, PagedDataInfo pagedDataInfo, bool hasRecords, Permission currentPermission, UrlHelper urlHelper, object contextChildOptions = null)
        {
            if (route.Entity == EntitiesAlias.PrgCostRate || route.Entity == EntitiesAlias.PrgBillableRate)
            {
                route.IsPopup = true;
            }
            if (route.Entity == EntitiesAlias.JobCard)
                currentPermission = Permission.EditAll;

            var gridViewSetting = new GridSetting
            {
                GridName = GetGridName(route),
                Mode = GridViewEditingMode.Batch,
                AvailablePageSizes = pagedDataInfo.AvailablePageSizes.Split(','),
                PageSize = pagedDataInfo.PageSize,
                IsJobCardEntity = pagedDataInfo.IsJobCardEntity,
                IsJobParentEntity = pagedDataInfo.IsJobParentEntity,

                CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView),
                PagingCallBackRoute = new MvcRoute(route, MvcConstants.ActionGridPagingView),
                SortingCallBackRoute = new MvcRoute(route, MvcConstants.ActionGridSortingView),
                GroupingCallBackRoute = new MvcRoute(route, MvcConstants.ActionGridGroupingView),
                FilteringCallBackRoute = new MvcRoute(route, MvcConstants.ActionGridFilteringView),
                BatchUpdateCallBackRoute = new MvcRoute(route, MvcConstants.ActionBatchUpdate)
            };

            var addOperation = commonCommands.GetOperation(OperationTypeEnum.New).SetRoute(route, MvcConstants.ActionForm);
            addOperation.LangName = addOperation.LangName.Replace(string.Format(" {0}", EntitiesAlias.Contact.ToString()), "");
            addOperation.Route.RecordId = -1;
            var editOperation = commonCommands.GetOperation(OperationTypeEnum.Edit).SetRoute(route, MvcConstants.ActionForm, true);
            editOperation.LangName = editOperation.LangName.Replace(string.Format(" {0}", EntitiesAlias.Contact.ToString()), "");
            var copyOperation = commonCommands.GetOperation(OperationTypeEnum.Copy).SetRoute(route, MvcConstants.ActionCopyRecord);
            var Copy = commonCommands.GetOperation(OperationTypeEnum.Copy).SetRoute(route, MvcConstants.ActionCopy);
            var Cut = commonCommands.GetOperation(OperationTypeEnum.Cut).SetRoute(route, MvcConstants.ActionCut);
            var Paste = commonCommands.GetOperation(OperationTypeEnum.Paste).SetRoute(route, MvcConstants.ActionPaste);
            var toggleOperation = commonCommands.GetOperation(OperationTypeEnum.ToggleFilter).SetRoute(route, MvcConstants.ActionToggleFilter);
            toggleOperation.Route.Url = urlHelper.Action(MvcConstants.ActionToggleFilter, route.Controller, new { Area = route.Area });
            var chooseColumnOperation = commonCommands.GetOperation(OperationTypeEnum.ChooseColumn).SetRoute(route, MvcConstants.ActionChooseColumn);
            chooseColumnOperation.Route.IsPopup = route.IsPopup;
            var actionsContextMenu = commonCommands.GetOperation(OperationTypeEnum.Actions);
            var costActionsContextMenu = commonCommands.GetOperation(OperationTypeEnum.NewCharge);
            var billableActionsContextMenu = commonCommands.GetOperation(OperationTypeEnum.NewCharge);
            var gatewaysContextMenu = commonCommands.GetOperation(OperationTypeEnum.Gateways);
            var gridRefresh = commonCommands.GetOperation(OperationTypeEnum.Refresh).SetRoute(route, MvcConstants.ActionDataView);

            switch (route.Entity)
            {
                //Master Detail Grid Settings
                case EntitiesAlias.SecurityByRole:
                    gridViewSetting.ChildGridRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.SubSecurityByRole;
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong());
                    gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.PrgEdiCondition:
                    gridViewSetting.GridName = GetGridName(route);
                    gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.PrgBillableLocation:
                    gridViewSetting.ChildGridRoute = new MvcRoute(EntitiesAlias.PrgBillableRate, MvcConstants.ActionDataView, EntitiesAlias.Program.ToString());
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong());
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.PrgBillableRate;
                    //gridViewSetting.ShowNewButton = true;
                    if (currentPermission > Permission.ReadOnly)
                    {
                        var mapVendorOperation = commonCommands.GetOperation(OperationTypeEnum.AssignVendor).SetRoute(route, MvcConstants.ActionMapVendorCallback);
                        mapVendorOperation.Route.IsPopup = true;
                        gridViewSetting.ContextMenu.Add(mapVendorOperation);
                    }

                    break;
                case EntitiesAlias.PrgCostLocation:
                    gridViewSetting.ChildGridRoute = new MvcRoute(EntitiesAlias.PrgCostRate, MvcConstants.ActionDataView, EntitiesAlias.Program.ToString());
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong());
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.PrgCostRate;
                    if (currentPermission > Permission.ReadOnly)
                    {
                        var mapVendorOperation = commonCommands.GetOperation(OperationTypeEnum.AssignVendor).SetRoute(route, MvcConstants.ActionMapVendorCallback);
                        mapVendorOperation.Route.IsPopup = true;
                        gridViewSetting.ContextMenu.Add(mapVendorOperation);
                    }

                    //gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.PrgMvoc:
                    gridViewSetting.ChildGridRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.PrgMvocRefQuestion;
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong(), true);
                    break;
                case EntitiesAlias.PrgEdiHeader:
                    gridViewSetting.ChildGridRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.PrgEdiMapping;
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong(), true);
                    break;
                case EntitiesAlias.SubSecurityByRole:
                    gridViewSetting.GridName = GetGridName(route);
                    gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.PrgMvocRefQuestion:
                case EntitiesAlias.JobCargoDetail:
                    gridViewSetting.GridName = GetGridName(route);
                    break;
                case EntitiesAlias.CustDcLocationContact:
                case EntitiesAlias.VendDcLocationContact:
                    addOperation.LangName = string.Format("{0} {1}", "Add", EntitiesAlias.Contact.ToString());
                    editOperation.LangName = string.Format("{0} {1}", editOperation.LangName, EntitiesAlias.Contact.ToString());
                    gridViewSetting.GridName = GetGridName(route);
                    break;
                case EntitiesAlias.PrgEdiMapping:
                    gridViewSetting.GridName = GetGridName(route);
                    gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.CustDcLocation:
                    gridViewSetting.ChildGridRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.CustDcLocationContact;
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong(), true);
                    break;
                case EntitiesAlias.VendDcLocation:
                    gridViewSetting.ChildGridRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    gridViewSetting.ChildGridRoute.Entity = EntitiesAlias.VendDcLocationContact;
                    gridViewSetting.ChildGridRoute.SetParent(route.Entity, route.Url.ToLong(), true);
                    break;
                //End Master Detail Grid Settings

                case EntitiesAlias.PrgVendLocation:
                    if (currentPermission > Permission.ReadOnly)
                    {
                        var mapVendorOperation = commonCommands.GetOperation(OperationTypeEnum.MapVendor).SetRoute(route, MvcConstants.ActionMapVendorCallback);
                        mapVendorOperation.Route.IsPopup = true;
                        gridViewSetting.ContextMenu.Add(mapVendorOperation);
                    }
                    break;

                case EntitiesAlias.AppDashboard:
                    gridViewSetting.ShowNewButton = true;
                    addOperation.Route.Action = MvcConstants.ActionDashboard;
                    if (hasRecords)
                    {
                        editOperation.Route.Action = MvcConstants.ActionDashboard;
                        gridViewSetting.ContextMenu.Add(editOperation);
                    }
                    break;
                case EntitiesAlias.Report:
                    gridViewSetting.ShowNewButton = true;
                    if (hasRecords)
                        gridViewSetting.ContextMenu.Add(editOperation);
                    break;

                case EntitiesAlias.Attachment:
                    gridViewSetting.ShowNewButton = true;
                    break;
                case EntitiesAlias.JobGateway:
                case EntitiesAlias.JobDocReference:
                case EntitiesAlias.JobCostSheet:
                case EntitiesAlias.JobBillableSheet:
                    gridViewSetting.CallBackRoute.Action = route.Action;
                    break;
                case EntitiesAlias.ColumnAlias:
                    gridViewSetting.CallBackRoute.Action = MvcConstants.ActionColAliasDataViewCallback;
                    break;

                case EntitiesAlias.JobAdvanceReport:
                    gridViewSetting.EnableClientSideExportAPI = true;
                    gridViewSetting.Mode = GridViewEditingMode.Inline;
                    gridViewSetting.CallBackRoute.Action = route.Action;
                    break;
                case EntitiesAlias.JobCard:
                    gridViewSetting.Mode = GridViewEditingMode.Inline;
                    gridViewSetting.ContextMenu.Add(gridRefresh);
                    break;
                default:
                    break;
            }
            if (!gridViewSetting.ShowNewButton && !(currentPermission < Permission.AddEdit) && route.Entity != EntitiesAlias.StatusLog && route.Entity != EntitiesAlias.MenuAccessLevel && route.Entity != EntitiesAlias.MenuOptionLevel && route.Entity != EntitiesAlias.SecurityByRole)
            {
                if (route.Entity != EntitiesAlias.PrgVendLocation && route.Entity != EntitiesAlias.PrgCostLocation
                    && route.Entity != EntitiesAlias.PrgBillableLocation && route.Entity != EntitiesAlias.Organization
                    && route.Entity != EntitiesAlias.OrgRolesResp
                    && route.Entity != EntitiesAlias.JobHistory
                    && !(route.Entity == EntitiesAlias.Job
                    && gridViewSetting.IsJobParentEntity)
                    && route.Action.ToLower() != "jobgatewayactions"
                    && route.Entity != EntitiesAlias.JobAdvanceReport && route.Entity != EntitiesAlias.JobCard
                    && !gridViewSetting.IsJobCardEntity)
                    // route.Action.ToLower() != "jobgatewayactions" Job gateway action tab new will not come
                    gridViewSetting.ContextMenu.Add(addOperation);
                if (hasRecords && route.Entity == EntitiesAlias.JobCard)
                {
                    editOperation.Route.Entity = EntitiesAlias.Job;
                    editOperation.Route.EntityName = "Job";
                    gridViewSetting.IsJobCardEntity = true;
                    //editOperation.Route.IsJobCardEntity = true;
                    gridViewSetting.ContextMenu.Add(editOperation);
                }
                else if (hasRecords
                    && route.Entity != EntitiesAlias.PrgCostLocation
                    && route.Entity != EntitiesAlias.PrgBillableLocation
                    && route.Entity != EntitiesAlias.JobAdvanceReport
                    && route.Entity != EntitiesAlias.JobHistory
                    )
                {
                    gridViewSetting.ContextMenu.Add(editOperation);
                    if (route.Entity == EntitiesAlias.Contact) //Right now only for Contact module this feature is available.So, Have given this condition temporarily
                        gridViewSetting.ContextMenu.Add(copyOperation);

                    if (route.Entity == EntitiesAlias.JobGateway) //action context menu should come after new and edit. So, Have added this here
                    {
                        gridViewSetting.ContextMenu.Add(actionsContextMenu);
                        gridViewSetting.ContextMenu.Add(gatewaysContextMenu);
                    }
                }
                else if (!hasRecords && (route.Entity == EntitiesAlias.JobGateway) && !gridViewSetting.IsJobCardEntity)
                {
                    gridViewSetting.ContextMenu.Add(actionsContextMenu);
                    gridViewSetting.ContextMenu.Add(gatewaysContextMenu);
                }

                if (route.Entity == EntitiesAlias.JobCostSheet && contextChildOptions != null) //action context menu should come after new and edit. So, Have added this here
                {
                    var contextChildOptionsData = (List<JobCostCodeAction>)contextChildOptions;
                    if (contextChildOptionsData != null && contextChildOptionsData.Count > 0)
                    {
                        costActionsContextMenu.ChildOperations = new List<Operation>();
                        var routeToAssign = new MvcRoute(route);
                        routeToAssign.Entity = EntitiesAlias.JobCostSheet;
                        routeToAssign.Action = MvcConstants.ActionForm;
                        routeToAssign.IsPopup = true;
                        routeToAssign.RecordId = 0;
                        var groupedActions = contextChildOptionsData.GroupBy(x => x.CostActionCode);
                        foreach (var singleApptCode in groupedActions)
                        {
                            var newOperation = new Operation();
                            newOperation.LangName = singleApptCode.Key;
                            foreach (var singleReasonCode in singleApptCode)
                            {
                                routeToAssign.Filters = new Entities.Support.Filter();
                                routeToAssign.Filters.FieldName = singleReasonCode.CostCode;
                                var newChildOperation = new Operation();
                                var newRoute = new MvcRoute(routeToAssign);

                                newChildOperation.LangName = singleReasonCode.CostTitle;
                                newRoute.Filters = new Entities.Support.Filter();
                                newRoute.Filters.FieldName = singleReasonCode.CostCode;
                                newRoute.Filters.Value = singleReasonCode.CostCodeId.ToString(); ////String.Format("{0}-{1}", newChildOperation.LangName, singleReasonCode.PcrCode);
                                newChildOperation.Route = newRoute;
                                newOperation.ChildOperations.Add(newChildOperation);

                            }

                            costActionsContextMenu.ChildOperations.Add(newOperation);
                        }

                        gridViewSetting.ContextMenu.Add(costActionsContextMenu);
                    }
                }

                if (route.Entity == EntitiesAlias.JobBillableSheet && contextChildOptions != null)
                {
                    var contextChildOptionsData = (List<JobPriceCodeAction>)contextChildOptions;
                    if (contextChildOptionsData != null && contextChildOptionsData.Count > 0)
                    {
                        billableActionsContextMenu.ChildOperations = new List<Operation>();
                        var routeToAssign = new MvcRoute(route);
                        routeToAssign.Entity = EntitiesAlias.JobBillableSheet;
                        routeToAssign.Action = MvcConstants.ActionForm;
                        routeToAssign.IsPopup = true;
                        routeToAssign.RecordId = 0;
                        var groupedActions = contextChildOptionsData.GroupBy(x => x.PriceActionCode);
                        foreach (var singleApptCode in groupedActions)
                        {
                            var newOperation = new Operation();
                            newOperation.LangName = singleApptCode.Key;
                            foreach (var singleReasonCode in singleApptCode)
                            {
                                routeToAssign.Filters = new Entities.Support.Filter();
                                routeToAssign.Filters.FieldName = singleReasonCode.PriceCode;
                                var newChildOperation = new Operation();
                                var newRoute = new MvcRoute(routeToAssign);

                                newChildOperation.LangName = singleReasonCode.PriceTitle;
                                newRoute.Filters = new Entities.Support.Filter();
                                newRoute.Filters.FieldName = singleReasonCode.PriceCode;
                                newRoute.Filters.Value = singleReasonCode.PriceCodeId.ToString();
                                newChildOperation.Route = newRoute;
                                newOperation.ChildOperations.Add(newChildOperation);

                            }

                            billableActionsContextMenu.ChildOperations.Add(newOperation);
                        }

                        gridViewSetting.ContextMenu.Add(billableActionsContextMenu);
                    }
                }
            }

            else if (!gridViewSetting.ShowNewButton
                //&& currentPermission == Permission.EditAll 
                && route.Entity != EntitiesAlias.StatusLog
                && route.Entity != EntitiesAlias.MenuAccessLevel && route.Entity != EntitiesAlias.MenuOptionLevel && route.Entity != EntitiesAlias.JobCard
                 && route.Entity != EntitiesAlias.MenuOptionLevel && route.Entity != EntitiesAlias.SecurityByRole && editOperation != null
                 && pagedDataInfo != null && pagedDataInfo.TotalCount > 0)
            {
                gridViewSetting.ContextMenu.Add(editOperation);
            }
            else if (!gridViewSetting.ShowNewButton
                //&& currentPermission == Permission.EditAll 
                && (route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.Job)
                 && editOperation != null && pagedDataInfo != null && pagedDataInfo.TotalCount > 0)
            {
                editOperation.Route.Entity = EntitiesAlias.Job;
                editOperation.Route.EntityName = "Job";
                if (route.Entity == EntitiesAlias.JobCard)
                    gridViewSetting.IsJobCardEntity = true;
                //editOperation.Route.IsJobCardEntity = true;
                gridViewSetting.ContextMenu.Add(editOperation);
            }
            if (route.Entity != EntitiesAlias.JobHistory)
                gridViewSetting.ContextMenu.Add(chooseColumnOperation);
            if (route.Entity == EntitiesAlias.JobBillableSheet || route.Entity == EntitiesAlias.JobCostSheet
                || (route.Entity == EntitiesAlias.JobGateway &&
                (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayAll1AllCbPanel" || route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayDataView2GatewaysCbPanel")))
            {
                gridViewSetting.ContextMenu.Remove(addOperation);
            }

            if ((route.Entity == EntitiesAlias.JobGateway && route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanel")
                || (route.Entity == EntitiesAlias.JobCard && route.OwnerCbPanel == "AppCbPanel") || (route.Entity == EntitiesAlias.JobAdvanceReport))
            {
                gridViewSetting.ContextMenu.Remove(editOperation);
            }
            if (!hasRecords && gridViewSetting.ShowFilterRow)     //if no records set filter row false.        
                gridViewSetting.ShowFilterRow = false;

            if (route.IsPopup && hasRecords && route.Entity != EntitiesAlias.JobHistory)
            {
                gridViewSetting.ContextMenu.Add(toggleOperation);
                toggleOperation.Route.Action = MvcConstants.ActionToggleFilter;
            }
            else if (!hasRecords && route.Action == "JobGatewayActions")
                toggleOperation.Route.Action = MvcConstants.ActionToggleFilter;

            gridViewSetting.ContextMenu.Add(Copy);
            gridViewSetting.ContextMenu.Add(Cut);
            gridViewSetting.ContextMenu.Add(Paste);

            return gridViewSetting;
        }

        public static string GetGridName(MvcRoute route)
        {
            var gridName = string.Concat(route.Entity, WebApplicationConstants.GridName);
            switch (route.Entity)
            {
                case EntitiesAlias.SubSecurityByRole:
                case EntitiesAlias.PrgMvocRefQuestion:
                case EntitiesAlias.JobCargoDetail:
                case EntitiesAlias.PrgEdiMapping:
                case EntitiesAlias.CustDcLocationContact:
                case EntitiesAlias.VendDcLocationContact:
                case EntitiesAlias.PrgBillableRate:
                case EntitiesAlias.PrgCostRate:
                    return string.Concat(gridName, route.ParentRecordId);
                case EntitiesAlias.JobDocReference:
                    if (route.Action == MvcConstants.ActionDocumentDataView)
                        gridName = string.Format("DocumentPod_{0}", gridName);
                    else if (route.Action == MvcConstants.ActionDocDeliveryPodDataView)
                        gridName = string.Format("DocDeliveryPod_{0}", gridName);
                    else if (route.Action == MvcConstants.ActionDocDamagedDataView)
                        gridName = string.Format("DocDamagedDataView_{0}", gridName);
                    return gridName;
                default:
                    return gridName;
            }
        }

        public static void SetupOperationDisplayMessage(Operation operation, MvcRoute defaultRoute)
        {
            var actionControllerData = new MvcRoute(defaultRoute);
            MessageOperationTypeEnum msgOpTypeEnum;
            if (Enum.TryParse(operation.SysRefName, out msgOpTypeEnum))
            {
                switch (msgOpTypeEnum)
                {
                    case MessageOperationTypeEnum.Yes:
                        break;

                    case MessageOperationTypeEnum.No:
                        break;

                    case MessageOperationTypeEnum.Ok:
                        actionControllerData.Action = MvcConstants.ActionDataView;
                        break;

                    case MessageOperationTypeEnum.Cancel:
                        break;

                    default:
                        break;
                }
            }

            operation.Route = actionControllerData;
        }

        public static IList<APIClient.ViewModels.ColumnSetting> GetUserColumnSettings(IList<APIClient.ViewModels.ColumnSetting> columnSettings, SessionProvider sessionProvider)
        {
            var columnSets = columnSettings.Select(x => x.DeepCopy()).OrderBy(x => x.ColSortOrder).ToList();

            if ((sessionProvider.UserColumnSetting != null) && (sessionProvider.UserColumnSetting.ColIsFreezed != null) && (sessionProvider.UserColumnSetting.ColNotVisible != null) && (sessionProvider.UserColumnSetting.ColSortOrder != null))
            {
                var colNotVisible = sessionProvider.UserColumnSetting.ColNotVisible.SplitComma().ToList();
                var sortOrders = sessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
                var colIsFreezed = sessionProvider.UserColumnSetting.ColIsFreezed.SplitComma().ToList();
                var colsGroupBy = sessionProvider.UserColumnSetting.ColGroupBy.SplitComma().ToList();
                columnSets.ToList().ForEach(colSetting => colSetting.ColSortOrder = columnSettings.Count);//Reset to last
                columnSets.ToList().ForEach(entity => UpdateColumnAliasesByUserSettings(entity, colNotVisible, sortOrders, colIsFreezed, colsGroupBy));
            }
            else
            {
                int currentOrder = 1;
                var allGroupedColumns = columnSettings.Where(x => x.ColIsGroupBy).ToList();
                if (allGroupedColumns.Count > 0)
                {
                    foreach (var singleColumn in columnSettings.Where(x => x.ColIsGroupBy).OrderBy(x => x.ColSortOrder))
                    {
                        singleColumn.ColSortOrder = currentOrder;
                        currentOrder += 1;
                    }

                    foreach (var singleColumn in columnSettings.Where(x => !x.ColIsGroupBy))
                        singleColumn.ColSortOrder = singleColumn.ColSortOrder + allGroupedColumns.Count();
                }
            }

            columnSets = columnSets.OrderBy(x => x.ColSortOrder).ToList();
            UpdateScannerRelationEntity(columnSets);
            UpdateOrganizationColumnSettings(columnSets, sessionProvider);
            UpdateOrgCredentialColumnSettings(columnSets);
            return columnSets.OrderBy(x => x.ColSortOrder).ToList();
        }

        public static void UpdateColumnAliasesByUserSettings(APIClient.ViewModels.ColumnSetting columnSetting, List<string> colNotVisible, List<string> sortOrders, List<string> colIsFreezed, List<string> colsGroupBy)
        {
            columnSetting.ColIsVisible = !colNotVisible.Contains(columnSetting.ColColumnName);
            columnSetting.ColIsFreezed = colIsFreezed.Contains(columnSetting.ColColumnName);
            columnSetting.ColIsGroupBy = colsGroupBy.Contains(columnSetting.ColColumnName);
            if (sortOrders.Contains(columnSetting.ColColumnName))
                columnSetting.ColSortOrder = sortOrders.IndexOf(columnSetting.ColColumnName);
        }

        public static Dictionary<long, byte[]> Files
        {
            get
            {
                if (HttpContext.Current.Session["files"] == null)
                    HttpContext.Current.Session["files"] = new Dictionary<long, byte[]>();
                return HttpContext.Current.Session["files"] as Dictionary<long, byte[]>;
            }
            set
            {
                HttpContext.Current.Session["files"] = value;
            }
        }

        public static int GetPixel(APIClient.ViewModels.ColumnSetting columnSetting)
        {
            if (!string.IsNullOrWhiteSpace(columnSetting.DataType))
            {
                if (!Enum.IsDefined(typeof(SQLDataTypes), columnSetting.DataType))
                    switch (columnSetting.DataType)
                    {
                        case "decimal":
                            return columnSetting.MaxLength * 5;

                        case "int":
                            return 80;

                        case "name":
                            return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                        case "char":
                            return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : columnSetting.MaxLength < 51 ? 220 : 270;
                    }
                else
                {
                    var sqlDataType = columnSetting.DataType.ToEnum<SQLDataTypes>();
                    switch (sqlDataType)
                    {
                        case SQLDataTypes.bigint:
                            return 160;

                        case SQLDataTypes.dropdown:
                            return columnSetting.MaxLength * 30 > 119 ? 120 : 100;

                        case SQLDataTypes.image:
                            return columnSetting.MaxLength * 30;

                        case SQLDataTypes.bit:
                            return 80;

                        case SQLDataTypes.Name:
                            return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                        case SQLDataTypes.ntext:
                            return 150;

                        case SQLDataTypes.nvarchar:
                        case SQLDataTypes.varchar:
                            if (columnSetting.ColColumnName == "JobDeliveryState")
                                return columnSetting.MaxLength < 11 ? 30 : columnSetting.MaxLength < 50 ? 170 : 270;
                            return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : 270;
                        case SQLDataTypes.datetime2:
                            return columnSetting.MaxLength < 11 ? 150 : columnSetting.MaxLength < 26 ? 170 : 270;
                    }
                }
            }
            return 80;
        }

        public static int SetJobGridPixel(APIClient.ViewModels.ColumnSetting columnSetting)
        {
            switch (columnSetting.ColColumnName)
            {
                case "Id":
                    return columnSetting.MaxLength = 60;
                case "JobMITJobID":
                    return columnSetting.MaxLength = 120;
                case "JobSiteCode":
                    return columnSetting.MaxLength = 120;
                case "JobCustomerSalesOrder":
                    return columnSetting.MaxLength = 120;
                case "JobCustomerPurchaseOrder":
                    return columnSetting.MaxLength = 120;
                case "JobCarrierContract":
                    return columnSetting.MaxLength = 120;
                case "JobGatewayStatus":
                    return columnSetting.MaxLength = 100;
                case "StatusId":
                    return columnSetting.MaxLength = 60;
                case "JobDeliverySitePOC":
                    return columnSetting.MaxLength = 270;
                case "JobDeliverySitePOCPhone":
                    return columnSetting.MaxLength = 120;
                case "JobDeliverySitePOCEmail":
                    return columnSetting.MaxLength = 160;
                case "JobDeliverySiteName":
                    return columnSetting.MaxLength = 220;
                case "JobDeliveryStreetAddress":
                    return columnSetting.MaxLength = 220;
                case "JobDeliveryStreetAddress2":
                    return columnSetting.MaxLength = 220;
                case "JobDeliveryCity":
                    return columnSetting.MaxLength = 120;
                case "JobDeliveryState":
                    return columnSetting.MaxLength = 60;
                case "JobDeliveryPostalCode":
                    return columnSetting.MaxLength = 80;
                case "JobDeliveryDateTimePlanned":
                    return columnSetting.MaxLength = 150;
                case "JobDeliveryDateTimeActual":
                    return columnSetting.MaxLength = 150;
                case "JobOriginDateTimePlanned":
                    return columnSetting.MaxLength = 150;
                case "JobOriginDateTimeActual":
                    return columnSetting.MaxLength = 150;
                case "JobSellerSiteName":
                    return columnSetting.MaxLength = 270;
                case "JobDeliverySitePOCPhone2":
                    return columnSetting.MaxLength = 120;
                case "JobManifestNo":
                    return columnSetting.MaxLength = 120;
                case "PlantIDCode":
                    return columnSetting.MaxLength = 60;
                case "JobBOL":
                    return columnSetting.MaxLength = 220;
                case "JobQtyActual":
                    return columnSetting.MaxLength = 60;
                case "JobPartsActual":
                    return columnSetting.MaxLength = 60;
                case "JobTotalCubes":
                    return columnSetting.MaxLength = 60;
                case "JobServiceMode":
                    return columnSetting.MaxLength = 120;
                case "JobOrderedDate":
                    return columnSetting.MaxLength = 150;
            }

            if (!string.IsNullOrWhiteSpace(columnSetting.DataType))
            {
                if (!Enum.IsDefined(typeof(SQLDataTypes), columnSetting.DataType))
                    switch (columnSetting.DataType)
                    {
                        case "decimal":
                            return columnSetting.MaxLength * 5;

                        case "int":
                            return 80;

                        case "name":
                            return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                        case "char":
                            return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : columnSetting.MaxLength < 51 ? 220 : 270;
                    }
                else
                {
                    var sqlDataType = columnSetting.DataType.ToEnum<SQLDataTypes>();
                    switch (sqlDataType)
                    {
                        case SQLDataTypes.bigint:
                            return 160;

                        case SQLDataTypes.dropdown:
                            return columnSetting.MaxLength * 30 > 119 ? 120 : 100;

                        case SQLDataTypes.image:
                            return columnSetting.MaxLength * 30;

                        case SQLDataTypes.bit:
                            return 80;

                        case SQLDataTypes.Name:
                            return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                        case SQLDataTypes.ntext:
                            return 150;

                        case SQLDataTypes.nvarchar:
                        case SQLDataTypes.varchar:
                            return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : 270;
                    }
                }
            }
            return 80;
        }

        public static string ShouldRenderDetailGrid(object dataItem, ICommonCommands commonCommands, ref MvcRoute currentChildRoute)
        {
            switch (currentChildRoute.Entity)
            {
                case EntitiesAlias.SubSecurityByRole:
                    var mainModuleId = Convert.ToInt32(DataBinder.Eval(dataItem, WebApplicationConstants.SecMainModuleId));
                    currentChildRoute.ParentRecordId = Convert.ToInt32(DataBinder.Eval(dataItem, CommonColumns.Id.ToString()));
                    currentChildRoute.Filters = new Entities.Support.Filter() { Value = mainModuleId.ToString() };
                    var currentModuleMenu = WebGlobalVariables.ModuleMenus.FirstOrDefault(x => x.MnuModuleId == mainModuleId && !x.MnuBreakDownStructure.StartsWith(WebApplicationConstants.RibbonBreakdownStructurePrefix));
                    if ((currentModuleMenu != null) && !string.IsNullOrWhiteSpace(currentModuleMenu.MnuExecuteProgram) && Enum.IsDefined(typeof(EntitiesAlias), currentModuleMenu.MnuExecuteProgram))
                        return commonCommands.GetPageInfos((EntitiesAlias)Enum.Parse(typeof(EntitiesAlias), currentModuleMenu.MnuExecuteProgram)).Where(x => x.TabTableName != x.RefTableName).Count() > 0 ? string.Empty : "No data available.";
                    else
                        return "No data available.";
                case EntitiesAlias.PrgEdiMapping:
                    if (currentChildRoute.Filters == null)
                        currentChildRoute.Filters = new Entities.Support.Filter();
                    currentChildRoute.Filters.CustomFilter = Convert.ToBoolean(DataBinder.Eval(dataItem, WebApplicationConstants.PehSendReceive));
                    return string.Empty;
                case EntitiesAlias.PrgBillableRate:
                    if (currentChildRoute.ParentEntity == EntitiesAlias.PrgBillableLocation) //TODO: Remove this condition later when starts get and set child grid from database
                        return string.Empty;
                    if (currentChildRoute.Filters == null)
                        currentChildRoute.Filters = new Entities.Support.Filter();
                    currentChildRoute.Filters.FieldName = CustColumnNames.CdcLocationCode.ToString();
                    currentChildRoute.Filters.Value = Convert.ToString(DataBinder.Eval(dataItem, CustColumnNames.CdcLocationCode.ToString()));
                    return string.Empty;
                case EntitiesAlias.PrgCostRate:
                    if (currentChildRoute.ParentEntity == EntitiesAlias.PrgCostLocation)//TODO: Remove this condition later when starts get and set child grid from database
                        return string.Empty;
                    if (currentChildRoute.Filters == null)
                        currentChildRoute.Filters = new Entities.Support.Filter();
                    currentChildRoute.Filters.FieldName = VendColumnNames.VdcLocationCode.ToString();
                    currentChildRoute.Filters.Value = Convert.ToString(DataBinder.Eval(dataItem, VendColumnNames.VdcLocationCode.ToString()));
                    return string.Empty;
            }
            return string.Empty;
        }

        public static TreeListResult SetupTreeResult(ICommonCommands commonCommands, MvcRoute route)
        {
            var treeListResult = new TreeListResult
            {
                CommonCommands = commonCommands,
                KeyFieldName = WebApplicationConstants.KeyFieldName,
                ParentFieldName = WebApplicationConstants.ParentFieldName,
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionTreeListCallBack),
                DragAndDropRoute = new MvcRoute(route, MvcConstants.ActionTreeListMoveNode),
                ContentRouteCallBack = new MvcRoute(route, MvcConstants.ActionDataView),
                TreeListSettings = new M4PL.Web.Models.TreeListSettings()
            };
            switch (route.Entity)
            {
                case EntitiesAlias.Job:
                    treeListResult.ContentRouteCallBack.OwnerCbPanel = string.Concat(treeListResult.ContentRouteCallBack.Entity, MvcConstants.ActionDataView, "CbPanel");
                    break;
                case EntitiesAlias.PrgEdiHeader:
                    treeListResult.ContentRouteCallBack.OwnerCbPanel = string.Concat(treeListResult.ContentRouteCallBack.Entity, MvcConstants.ActionDataView, "CbPanel");
                    break;
                default:
                    break;
            }
            return treeListResult;
        }

        public static GridViewSettings CreateExportGridViewSettings<TView>(GridResult<TView> gridResult, ICommonCommands commonCommands, int maxPageSize = 0) where TView : class, new()
        {
            GridViewSettings settings = new GridViewSettings();

            settings.Name = gridResult.GridSetting.GridName;
            settings.KeyFieldName = gridResult.GridViewModel.KeyFieldName;
            settings.Styles.Header.Wrap = DefaultBoolean.True;
            settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
            settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Visible;
            settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
            //settings.Settings.VerticalScrollableHeight = 300;
            settings.Settings.ShowFilterRow = gridResult.GridSetting.ShowFilterRow;
            settings.Settings.ShowFilterRowMenu = gridResult.GridSetting.ShowFilterRow;
            settings.Settings.ShowFilterBar = GridViewStatusBarMode.Auto;
            settings.SettingsBehavior.AllowFocusedRow = true;
            settings.ControlStyle.Paddings.Padding = System.Web.UI.WebControls.Unit.Pixel(0);
            settings.ControlStyle.Border.BorderWidth = System.Web.UI.WebControls.Unit.Pixel(1);

            settings.CallbackRouteValues = new { Action = gridResult.GridSetting.CallBackRoute.Action, Controller = gridResult.GridSetting.CallBackRoute.Controller, Area = gridResult.GridSetting.CallBackRoute.Area, strRoute = Newtonsoft.Json.JsonConvert.SerializeObject(gridResult.GridSetting.CallBackRoute) };
            settings.CustomBindingRouteValuesCollection.Add(GridViewOperationType.Paging, new { Action = gridResult.GridSetting.PagingCallBackRoute.Action, Controller = gridResult.GridSetting.PagingCallBackRoute.Controller, Area = gridResult.GridSetting.PagingCallBackRoute.Area, strRoute = Newtonsoft.Json.JsonConvert.SerializeObject(gridResult.GridSetting.PagingCallBackRoute), gridName = gridResult.GridSetting.GridName });
            settings.CustomBindingRouteValuesCollection.Add(GridViewOperationType.Filtering, new { Action = gridResult.GridSetting.FilteringCallBackRoute.Action, Controller = gridResult.GridSetting.FilteringCallBackRoute.Controller, Area = gridResult.GridSetting.FilteringCallBackRoute.Area, strRoute = Newtonsoft.Json.JsonConvert.SerializeObject(gridResult.GridSetting.FilteringCallBackRoute), gridName = gridResult.GridSetting.GridName });
            settings.CustomBindingRouteValuesCollection.Add(GridViewOperationType.Sorting, new { Action = gridResult.GridSetting.SortingCallBackRoute.Action, Controller = gridResult.GridSetting.SortingCallBackRoute.Controller, Area = gridResult.GridSetting.SortingCallBackRoute.Area, strRoute = Newtonsoft.Json.JsonConvert.SerializeObject(gridResult.GridSetting.SortingCallBackRoute), gridName = gridResult.GridSetting.GridName });

            settings.SettingsResizing.ColumnResizeMode = ColumnResizeMode.Control;
            settings.SettingsResizing.Visualization = ResizingMode.Live;

            settings.SettingsPager.EnableAdaptivity = true;
            settings.SettingsPager.PageSize = gridResult.GridSetting.PageSize;
            settings.SettingsPager.Position = System.Web.UI.WebControls.PagerPosition.TopAndBottom;
            settings.SettingsPager.FirstPageButton.Visible = true;
            settings.SettingsPager.LastPageButton.Visible = true;
            settings.SettingsPager.PageSizeItemSettings.Visible = true;
            settings.SettingsPager.PageSizeItemSettings.Items = gridResult.GridSetting.AvailablePageSizes;

            settings.SettingsEditing.Mode = gridResult.GridSetting.Mode;
            settings.Columns.Clear();

            var countOfAllColumnsToShow = gridResult.ColumnSettings.Where(col => col.ColIsVisible && !col.ColColumnName.Equals(settings.KeyFieldName, StringComparison.OrdinalIgnoreCase)
                && !col.DataType.Equals(SQLDataTypes.image.ToString(), StringComparison.OrdinalIgnoreCase)
                && !col.DataType.Equals(SQLDataTypes.varbinary.ToString(), StringComparison.OrdinalIgnoreCase)).Count();

            foreach (var col in gridResult.ColumnSettings)
            {
                if (col.ColIsVisible && !col.ColColumnName.Equals(settings.KeyFieldName, StringComparison.OrdinalIgnoreCase)
                && !col.DataType.Equals(SQLDataTypes.image.ToString(), StringComparison.OrdinalIgnoreCase)
                && !col.DataType.Equals(SQLDataTypes.varbinary.ToString(), StringComparison.OrdinalIgnoreCase))
                {
                    settings.Columns.Add(column =>
                    {
                        column.FieldName = col.ColColumnName;
                        column.Caption = col.ColAliasName;
                        column.ToolTip = col.ColCaption;
                        column.ReadOnly = col.ColIsReadOnly;
                        column.Visible = col.ColIsVisible;
                        column.Width = System.Web.UI.WebControls.Unit.Pixel(WebUtilities.GetPixel(col));
                        if (maxPageSize > 0)
                            column.ExportWidth = maxPageSize / countOfAllColumnsToShow;
                        column.FixedStyle = (col.ColIsFreezed) ? GridViewColumnFixedStyle.Left : GridViewColumnFixedStyle.None;
                        if (col.ColColumnName.EndsWith(WebApplicationConstants.ItemNumber) || col.ColColumnName.EndsWith(WebApplicationConstants.SortOrder))
                        {
                            column.ReadOnly = true;
                        }

                        if (col.DataType.Equals(SQLDataTypes.Name.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            column.FieldName = string.Concat(col.ColColumnName, SQLDataTypes.Name.ToString());
                            column.ColumnType = MVCxGridViewColumnType.ComboBox;
                            column.ReadOnly = true;
                            column.EditorProperties().TextBox(txtBox =>
                            {
                                txtBox.MaxLength = col.MaxLength;
                                if (column.ReadOnly)
                                    column.CellStyle.CssClass = CssConstants.ReadOnlyBackgroundColor;
                            });
                        }

                        else if (col.DataType.Equals(SQLDataTypes.bit.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            column.EditorProperties().CheckBox(chckBx =>
                            {
                                if (column.ReadOnly)
                                    column.CellStyle.CssClass = CssConstants.ReadOnlyBackgroundColor;
                            });
                        }
                        else if (commonCommands != null && col.ColLookupId > 0)
                        {
                            column.EditorProperties().ComboBox(cs =>
                            {
                                cs.ClientInstanceName = col.ColColumnName;
                                cs.TextField = "LangName";
                                cs.ValueField = "SysRefId";
                                cs.ValueType = typeof(int);
                                cs.DataSource = commonCommands.GetIdRefLangNames(col.ColLookupId);
                            });
                        }
                        else if (col.DataType.Equals(SQLDataTypes.Char.ToString(), StringComparison.OrdinalIgnoreCase) || col.DataType.Equals(SQLDataTypes.nvarchar.ToString(), StringComparison.OrdinalIgnoreCase)
                    || col.DataType.Equals(SQLDataTypes.varchar.ToString(), StringComparison.OrdinalIgnoreCase) || col.DataType.Equals(SQLDataTypes.Name.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            column.EditorProperties().TextBox(txtBox =>
                            {
                                txtBox.MaxLength = col.MaxLength;
                                if (column.ReadOnly)
                                    column.CellStyle.CssClass = CssConstants.ReadOnlyBackgroundColor;
                            });
                        }
                        else if (col.DataType.Equals(SQLDataTypes.Int.ToString(), StringComparison.OrdinalIgnoreCase) || col.DataType.Equals(SQLDataTypes.bigint.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            column.EditorProperties().SpinEdit(spn =>
                            {
                                spn.NumberType = SpinEditNumberType.Integer;
                                spn.Style.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Right;
                                if (column.ReadOnly)
                                {
                                    column.CellStyle.CssClass = CssConstants.ReadOnlyBackgroundColor;
                                    spn.SpinButtons.ClientVisible = false;
                                }
                            });
                        }
                    });
                }
            }

            settings.SettingsContextMenu.Enabled = true;
            settings.Init += (s, e) =>
            {
                var grid = (MVCxGridView)s;
                grid.ForceDataRowType(gridResult.GridSetting.DataRowType);
            };

            settings.CustomColumnDisplayText = (s, e) =>
            {
                if (e.Column.FieldName == "SysPassword")
                {
                    e.DisplayText = "**********";
                }
            };

            return settings;
        }

        public static SysSetting GetSystemSettings(string langCode)
        {
            return APIClient.CoreCache.SysSettings[langCode];
        }

        public static string GetOrSetGridLayout(string entityName, string layout)
        {
            var gridCookie = HttpContext.Current.Request.Cookies[entityName];
            if (gridCookie == null)
            {
                gridCookie = new HttpCookie(entityName);
                gridCookie.Expires = DateTime.Now.AddDays(14);

            }
            if (!string.IsNullOrEmpty(layout))
            {
                gridCookie.Value = layout;
                HttpContext.Current.Request.Cookies.Set(gridCookie);
            }
            return gridCookie.Value;
        }

        public static string GetOrSetPageInfoCookie(string entityName, string layout)
        {
            var cookieId = entityName + "PageSize";
            var gridCookie = HttpContext.Current.Request.Cookies[cookieId];
            if (gridCookie == null)
            {
                gridCookie = new HttpCookie(cookieId);
                gridCookie.Expires = DateTime.Now.AddDays(14);

            }
            if (!string.IsNullOrEmpty(layout))
            {
                gridCookie.Value = layout;
                HttpContext.Current.Request.Cookies.Set(gridCookie);
            }
            return gridCookie.Value;
        }

        public static void ClearGridLayout(string entityName)
        {
            var gridCookie = HttpContext.Current.Request.Cookies[entityName];
            if (gridCookie != null)
                HttpContext.Current.Request.Cookies.Remove(entityName);
        }

        public static MvcRoute EmptyResult(MvcRoute route)
        {
            route.Action = MvcConstants.ActionEmptyResult;
            route.Entity = EntitiesAlias.Common;
            route.Area = string.Empty;
            return route;
        }

        public static string GetNullText(string controlCaption)
        {
            return string.Format("Select {0}", controlCaption);
        }

        public static void ChangeFilterControlOperationVisibility(MVCxGridViewColumn currentColumn, FilterControlOperationVisibilityEventArgs e)
        {
            if (e.PropertyInfo.PropertyName.ToUpper().EndsWith("IDNAME") && e.Operation != ClauseType.Equals)
                e.Visible = false;
            else
            {
                switch (currentColumn.ColumnType)
                {
                    case MVCxGridViewColumnType.TextBox:
                        switch (e.Operation)
                        {
                            case ClauseType.BeginsWith:
                            case ClauseType.Contains:
                            case ClauseType.DoesNotContain:
                            case ClauseType.EndsWith:
                            case ClauseType.Equals:
                            case ClauseType.DoesNotEqual:
                                e.Visible = true;
                                break;
                            default:
                                e.Visible = false;
                                break;
                        }
                        break;
                    case MVCxGridViewColumnType.SpinEdit:
                        switch (e.Operation)
                        {
                            case ClauseType.Equals:
                            case ClauseType.DoesNotEqual:
                            case ClauseType.Less:
                            case ClauseType.LessOrEqual:
                            case ClauseType.Greater:
                            case ClauseType.GreaterOrEqual:
                                e.Visible = true;
                                break;
                            default:
                                e.Visible = false;
                                break;
                        }
                        break;

                }
            }
        }

        public static string GetKeyFieldName(EntitiesAlias entity, string keyFieldName)
        {
            switch (entity)
            {
                case EntitiesAlias.ScrOsdList:
                    keyFieldName = ScannerTablesPrimaryColumnName.OSDID.ToString();
                    break;
                case EntitiesAlias.ScrOsdReasonList:
                    keyFieldName = ScannerTablesPrimaryColumnName.ReasonID.ToString();
                    break;
                case EntitiesAlias.ScrRequirementList:
                    keyFieldName = ScannerTablesPrimaryColumnName.RequirementID.ToString();
                    break;
                case EntitiesAlias.ScrServiceList:
                    keyFieldName = ScannerTablesPrimaryColumnName.ServiceID.ToString();
                    break;
                case EntitiesAlias.ScrReturnReasonList:
                    keyFieldName = ScannerTablesPrimaryColumnName.ReturnReasonID.ToString();
                    break;
            }
            return keyFieldName;
        }

        private static void UpdateScannerRelationEntity(IList<APIClient.ViewModels.ColumnSetting> columnSettings)
        {
            var columnName = string.Empty;
            switch (columnSettings[0].ColTableName.ToEnum<EntitiesAlias>())
            {
                case EntitiesAlias.ScrOsdList:
                case EntitiesAlias.ScrOsdReasonList:
                case EntitiesAlias.ScrRequirementList:
                case EntitiesAlias.ScrReturnReasonList:
                case EntitiesAlias.ScrServiceList:
                    columnName = ScrCommonColumns.ProgramID.ToString();
                    break;
                case EntitiesAlias.Contact:
                    columnName = CompColumnNames.ConCompanyId.ToString();
                    break;
            }
            if (!string.IsNullOrWhiteSpace(columnName))
            {
                columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnName)).DataType = "name";
                if (columnSettings[0].ColTableName == EntitiesAlias.Contact.ToString())
                {
                    columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnName)).RelationalEntity = EntitiesAlias.Company.ToString();
                }
                else
                {
                    columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnName)).RelationalEntity = EntitiesAlias.Program.ToString();
                }
            }
        }

        private static void UpdateOrganizationColumnSettings(IList<APIClient.ViewModels.ColumnSetting> columnSettings, SessionProvider sessionProvider)
        {
            if ((columnSettings[0].ColTableName.ToEnum<EntitiesAlias>() == EntitiesAlias.Organization) && !sessionProvider.ActiveUser.IsSysAdmin)
                columnSettings.Where(x => x.ColColumnName == ReservedKeysEnum.StatusId.ToString()).ToList().ForEach(x => x.ColIsReadOnly = true);
        }

        private static void UpdateOrgCredentialColumnSettings(IList<APIClient.ViewModels.ColumnSetting> columnSettings)
        {
            if (columnSettings[0].ColTableName.ToEnum<EntitiesAlias>() == EntitiesAlias.OrgCredential)
            {
                var attachmentCountColumn = columnSettings.FirstOrDefault(x => x.ColColumnName == OrgCredentialVirtualColumns.AttachmentCount.ToString());
                if (attachmentCountColumn != null)
                    attachmentCountColumn.DataType = SQLDataTypes.Int.ToString();
            }
        }

        public static GridViewModel CreateGridViewModel(IList<APIClient.ViewModels.ColumnSetting> columnSettings, EntitiesAlias currentEntity, int currentPageSize)
        {
            GridViewModel gridViewModel = new GridViewModel();
            gridViewModel.KeyFieldName = WebApplicationConstants.KeyFieldName;
            gridViewModel.Pager.PageSize = 10;
            int currentGroupIndex = 0;
            foreach (var colSetting in columnSettings)
            {
                if (colSetting.ColIsVisible && !colSetting.ColColumnName.Equals(WebUtilities.GetKeyFieldName(currentEntity, WebApplicationConstants.KeyFieldName), StringComparison.OrdinalIgnoreCase)

                    && !colSetting.DataType.Equals(SQLDataTypes.image.ToString(), StringComparison.OrdinalIgnoreCase)
                    && !colSetting.DataType.Equals(SQLDataTypes.varbinary.ToString(), StringComparison.OrdinalIgnoreCase))
                {
                    var columnNameToAdd = colSetting.DataType.Equals(SQLDataTypes.Name.ToString(), StringComparison.OrdinalIgnoreCase) ? string.Concat(colSetting.ColColumnName, SQLDataTypes.Name.ToString()) : colSetting.ColColumnName;
                    gridViewModel.Columns.Add(columnNameToAdd);
                    if (colSetting.ColIsGroupBy)
                    {
                        gridViewModel.Columns[columnNameToAdd].GroupIndex = currentGroupIndex;
                        currentGroupIndex += 1;
                    }
                    else
                        gridViewModel.Columns[columnNameToAdd].GroupIndex = -1;
                }
            }
            gridViewModel.Pager.PageSize = currentPageSize;
            return gridViewModel;
        }

        public static GridViewModel UpdateGridViewModel(GridViewModel gridViewModel, IList<APIClient.ViewModels.ColumnSetting> columnSettings, EntitiesAlias currentEntity)
        {
            int currentGroupIndex = 0;
            foreach (var colSetting in columnSettings)
            {
                if (colSetting.ColIsVisible && !colSetting.ColColumnName.Equals(WebUtilities.GetKeyFieldName(currentEntity, WebApplicationConstants.KeyFieldName), StringComparison.OrdinalIgnoreCase)

                    && !colSetting.DataType.Equals(SQLDataTypes.image.ToString(), StringComparison.OrdinalIgnoreCase)
                    && !colSetting.DataType.Equals(SQLDataTypes.varbinary.ToString(), StringComparison.OrdinalIgnoreCase))
                {
                    var columnNameToAdd = colSetting.DataType.Equals(SQLDataTypes.Name.ToString(), StringComparison.OrdinalIgnoreCase) ? string.Concat(colSetting.ColColumnName, SQLDataTypes.Name.ToString()) : colSetting.ColColumnName;
                    if (gridViewModel.Columns[columnNameToAdd] == null)
                        gridViewModel.Columns.Add(columnNameToAdd);
                    if (colSetting.ColIsGroupBy)
                    {
                        gridViewModel.Columns[columnNameToAdd].GroupIndex = currentGroupIndex;
                        currentGroupIndex += 1;
                    }
                    else
                        gridViewModel.Columns[columnNameToAdd].GroupIndex = -1;
                }
            }
            return gridViewModel;
        }

        public static void SaveActiveTab(EntitiesAlias currentEntity, int currentTabIndex, SessionProvider currentSessionProvider)
        {
            if (currentSessionProvider.ViewPagedDataSession.ContainsKey(currentEntity) && currentSessionProvider.ViewPagedDataSession[currentEntity] != null)
            {
                if (string.IsNullOrWhiteSpace(currentSessionProvider.ViewPagedDataSession[currentEntity].OpenedTabs))
                    currentSessionProvider.ViewPagedDataSession[currentEntity].OpenedTabs = string.Format("{0},", currentTabIndex.ToString());
                else
                {
                    var allSavedActivatedTabs = currentSessionProvider.ViewPagedDataSession[currentEntity].OpenedTabs.SplitComma().ToList();
                    if (allSavedActivatedTabs.IndexOf(currentTabIndex.ToString()) < 0)
                        currentSessionProvider.ViewPagedDataSession[currentEntity].OpenedTabs += string.Format("{0},", currentTabIndex.ToString());
                }
            }
        }

        public static string CreateOrderByWithMultipleColForPrgGty(string action, string orderByClause, string entity)
        {
            string orderBy = " ";
            switch (action)
            {
                case MvcConstants.ActionDataView:

                    foreach (string col in PrgGatewayDefaultSortOrderColumns())
                    {
                        orderBy = orderBy + entity + "." + col + ",";
                    }
                    return orderBy.TrimEnd(',') + " ";

                case MvcConstants.ActionGridSortingView:
                    if (orderByClause.Split(' ')[0] == entity + "." + PrgRefGatewayDefaultWhereColms.PgdOrderType.ToString())
                        orderBy = orderByClause + "," + entity + "." + PrgRefGatewayDefaultWhereColms.GatewayTypeId.ToString() + " " + orderByClause.Split(' ')[2] + "," + entity + "." + WebApplicationConstants.PrgGtwyDefaultSortColm4 + " " + orderByClause.Split(' ')[2];
                    if (orderByClause.Split(' ')[0] == entity + "." + PrgRefGatewayDefaultWhereColms.GatewayTypeId.ToString())
                        orderBy = orderByClause + "," + entity + "." + WebApplicationConstants.PrgGtwyDefaultSortColm4 + " " + orderByClause.Split(' ')[2];
                    if (orderByClause.Split(' ')[0] == entity + "." + WebApplicationConstants.PrgGtwyDefaultSortColm4)
                        orderBy = orderByClause + "," + entity + "." + PrgRefGatewayDefaultWhereColms.GatewayTypeId.ToString() + " " + orderByClause.Split(' ')[2];
                    if (orderByClause.Split(' ')[0] == entity + "." + PrgRefGatewayDefaultWhereColms.PgdShipmentType.ToString())
                        orderBy = orderByClause + "," + entity + "." + PrgRefGatewayDefaultWhereColms.GatewayTypeId.ToString() + " " + orderByClause.Split(' ')[2]
                            + "," + entity + "." + PrgRefGatewayDefaultWhereColms.PgdOrderType.ToString() + " " + orderByClause.Split(' ')[2]
                            + "," + entity + "." + WebApplicationConstants.PrgGtwyDefaultSortColm4 + " " + orderByClause.Split(' ')[2];

                    if (String.IsNullOrEmpty(orderBy.Trim()))
                        orderBy = orderByClause;
                    return " " + orderBy + " ";
                default:
                    return orderByClause;
            }
        }

        public static List<EntitiesAlias> GroupingAllowedEntities()
        {
            return new List<EntitiesAlias>()
            {

            };
        }

        public static List<string> GatewayActionVirtualColumns()
        {
            return new List<string>()
            {
                JobGatewayColumns.CancelOrder.ToString(),
                JobGatewayColumns.DateCancelled.ToString(),
                JobGatewayColumns.DateComment.ToString(),
                JobGatewayColumns.DateEmail.ToString(),
                JobGatewayColumns.StatusCode.ToString(),
            };
        }

        public static List<string> GatewayActionOnlyColumns()
        {
            return new List<string>()
            {
                JobGatewayColumns.GwyPerson.ToString(),
                JobGatewayColumns.GwyPhone.ToString(),
                JobGatewayColumns.GwyEmail.ToString(),
                JobGatewayColumns.GwyTitle.ToString(),
                JobGatewayColumns.GwyDDPCurrent.ToString(),
                JobGatewayColumns.GwyDDPNew.ToString(),
                JobGatewayColumns.GwyUprWindow.ToString(),
                JobGatewayColumns.GwyLwrWindow.ToString(),
                JobGatewayColumns.GwyUprDate.ToString(),
                JobGatewayColumns.GwyLwrDate.ToString(),
            };
        }

        public static List<string> PrgGatewayDefaultSortOrderColumns()
        {
            return new List<string>() {
                PrgRefGatewayDefaultWhereColms.GatewayTypeId.ToString(),
                PrgRefGatewayDefaultWhereColms.PgdOrderType.ToString(),
                PrgRefGatewayDefaultWhereColms.PgdShipmentType.ToString(),
                WebApplicationConstants.PrgGtwyDefaultSortColm4,
            };
        }

        public enum JobGatewayActions
        {
            Anonymous,
            Schedule,
            Reschedule,
            Canceled,
            LeftMessage,
            Contacted,
            DeliveryWindow,
            EMail,
            Comment,
            Exception,
            NotAction,
            ThreePL,
        }

        public static List<string> ContactColumnsUsedAsVirtualInOtherEntities()
        {
            return new List<string>
                    {
                        ContactVirtualColumnNames.ConJobTitle.ToString(),
                        ContactVirtualColumnNames.ConEmailAddress.ToString(),
                        ContactVirtualColumnNames.ConMobilePhone.ToString(),
                        ContactVirtualColumnNames.ConBusinessPhone.ToString(),
                        ContactVirtualColumnNames.ConBusinessAddress1.ToString(),
                        ContactVirtualColumnNames.ConBusinessAddress2.ToString(),
                        ContactVirtualColumnNames.ConBusinessCity.ToString(),
                        ContactVirtualColumnNames.ConBusinessZipPostal.ToString(),
                        ContactVirtualColumnNames.ConBusinessStateIdName.ToString(),
                        ContactVirtualColumnNames.ConBusinessCountryIdName.ToString(),
                        ContactVirtualColumnNames.ConBusinessFullAddress.ToString(),
                    };
        }

        public static Dictionary<EntitiesAlias, List<string>> VirtualColumns()
        {
            return new Dictionary<EntitiesAlias, List<string>>
            {
                {
                    EntitiesAlias.CustContact,
                    ContactColumnsUsedAsVirtualInOtherEntities()
                },
                {
                    EntitiesAlias.CustDcLocation,
                    ContactColumnsUsedAsVirtualInOtherEntities()
                },
                {
                    EntitiesAlias.CustDcLocationContact,
                    new List<string>
                    {
                        ContactVirtualColumnNames.ConBusinessPhone.ToString(),
                        ContactVirtualColumnNames.ConBusinessPhoneExt.ToString(),
                        ContactVirtualColumnNames.ConMobilePhone.ToString(),
                        DcLocationContactVirtualColumns.CustomerType.ToString()
                    }
                },
                {
                    EntitiesAlias.VendContact,
                    ContactColumnsUsedAsVirtualInOtherEntities()
                },
                {
                    EntitiesAlias.VendDcLocation,
                    ContactColumnsUsedAsVirtualInOtherEntities()
                },
                {
                    EntitiesAlias.VendDcLocationContact,
                    new List<string>
                    {
                        ContactVirtualColumnNames.ConBusinessPhone.ToString(),
                        ContactVirtualColumnNames.ConBusinessPhoneExt.ToString(),
                        ContactVirtualColumnNames.ConMobilePhone.ToString(),
                        DcLocationContactVirtualColumns.VendorType.ToString()
                    }
                },
                {
                    EntitiesAlias.OrgCredential,
                    new List<string>
                    {
                        OrgCredentialVirtualColumns.AttachmentCount.ToString()
                    }
                }
            };
        }

        public static Dictionary<string, List<string>> ConcatenatedColumns()
        {
            return new Dictionary<string, List<string>>
            {
                {
                    ContactVirtualColumnNames.ConBusinessFullAddress.ToString(),
                    new List<string>
                    {
                        "( coalesce(cont.[ConBusinessAddress1], '') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '') + coalesce(CHAR(13) + cont.[ConBusinessCity], '') + "
                        +"CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '') <> '') OR (coalesce(cont.[ConBusinessAddress2], '') <> '') OR (coalesce(cont.[ConBusinessCity], '') <> ''))"
                        +"THEN coalesce(', ' + sts.[StateAbbr], '') ELSE coalesce('' + sts.[StateAbbr], '') END + coalesce(', ' + cont.[ConBusinessZipPostal], '') + coalesce(CHAR(13) + sysRef.[SysOptionName], '') )"
                    }
                },
                {
                        DcLocationContactVirtualColumns.CustomerType.ToString(),
                        new List<string>
                        {
                            DcLocationContactActualColumns.SysOptionName.ToString()
                        }
                },
                {
                        DcLocationContactVirtualColumns.VendorType.ToString(),
                        new List<string>
                        {
                            DcLocationContactActualColumns.SysOptionName.ToString()
                        }
                },
                {
                        OrgCredentialVirtualColumns.AttachmentCount.ToString(),
                        new List<string>
                        {
                            string.Format("[dbo].[fnGetAttachmentTableRowCount]('{0}', {1}.Id)", EntitiesAlias.OrgCredential.ToString(), EntitiesAlias.OrgCredential.ToString())
                        }
                }
            };
        }

        public static bool IsIdNameField(string fieldName)
        {
            return ((fieldName.Length > 6) && (fieldName.Substring(fieldName.Length - 6).Equals("IdName", StringComparison.OrdinalIgnoreCase))) ? true :
                (fieldName.Equals(PrgRefGatewayContactNameColumns.PgdGatewayResponsibleName.ToString(), StringComparison.OrdinalIgnoreCase)) ? true :
                (fieldName.Equals(PrgRefGatewayContactNameColumns.PgdGatewayAnalystName.ToString(), StringComparison.OrdinalIgnoreCase)) ? true :
                (fieldName.Equals(JobGatewayContactNameColumns.GwyGatewayAnalystName.ToString(), StringComparison.OrdinalIgnoreCase)) ? true :
                (fieldName.Equals(JobGatewayContactNameColumns.GwyGatewayResponsibleName.ToString(), StringComparison.OrdinalIgnoreCase)) ? true :
                false;
        }

        public static bool ShouldMakeIdTextFieldReadOnlyTextBox(string columnName)
        {
            if (columnName.EqualsOrdIgnoreCase(OrgColumnNames.CustOrgId.ToString()) || columnName.EqualsOrdIgnoreCase(OrgColumnNames.VendOrgID.ToString()) ||
                columnName.EqualsOrdIgnoreCase(OrgColumnNames.CdrOrgID.ToString()) || columnName.EqualsOrdIgnoreCase(CustColumnNames.CdrCustomerID.ToString()) ||
                columnName.EqualsOrdIgnoreCase(OrgColumnNames.VdrOrgID.ToString()) || columnName.EqualsOrdIgnoreCase(VendColumnNames.VdrVendorID.ToString()) ||
                columnName.EqualsOrdIgnoreCase(OrgColumnNames.OrgID.ToString()) || columnName.EqualsOrdIgnoreCase(MvocRefQuestionColumns.MVOCID.ToString()) ||
                columnName.EqualsOrdIgnoreCase(OrgColumnNames.SysOrgId.ToString()) || columnName.EqualsOrdIgnoreCase(OrgColumnNames.OrganizationId.ToString()) ||
                columnName.EqualsOrdIgnoreCase(CompColumnNames.ConCompanyId.ToString()))
            {
                return true;
            }

            return false;
        }

        public static bool IsFormView<TView>(TView entity)
        {
            if (entity == null) return false;

            string[] type = entity.GetType().ToString().Split('.');
            return Enum.IsDefined(typeof(FormView), type[type.Length - 1]);
        }

        public static string GetBundlingVersion()
        {
            if (WebGlobalVariables.IsBundlingEnable > 0)
                return "?v=" + SingleInstance.BundleConfigKey;
            return string.Empty;
        }

        public enum FormView
        {
            MenuAccessLevelView,
            MenuOptionLevelView,
            SecurityByRoleView,
            SubSecurityByRoleView,
            SystemMessageView
        }
    }
}