﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 WebExtension
//Purpose:                                      Provides extension methods to be used throughout the application
//====================================================================================================================================================*/

using DevExpress.Data.Filtering;
using DevExpress.DirectX.Common.Direct2D;
using DevExpress.Web.Mvc;
using DevExpress.XtraReports.UI;
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.APIClient.ViewModels.Job;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace M4PL.Web
{
    public static class WebExtension
    {
        public static void SetupFormResult<TView>(this Models.FormResult<TView> formResult, ICommonCommands commonCommands, MvcRoute route)
        {
            if (route.RecordId == 0 && FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
            {
                var pagedDataInfo = formResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo;
                if (FormViewProvider.ParentCondition.ContainsKey(route.Entity) && route.ParentRecordId > 0)
                    pagedDataInfo.WhereCondition += string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId);
                //if (pagedDataInfo.Entity != EntitiesAlias.PrgRefGatewayDefault)
                (formResult.Record as BaseModel).ItemNumber = commonCommands.GetLastItemNumber(pagedDataInfo, FormViewProvider.ItemFieldName[route.Entity]) + 1;//+1 indicates for next item number
            }

            var resultViewSession = formResult.SessionProvider.ResultViewSession;
            var entityRecord = resultViewSession.GetOrAdd(route.Entity, new ConcurrentDictionary<long, ViewResultInfo>());
            formResult.SessionProvider.ResultViewSession = resultViewSession;
            var arbRecordId = !entityRecord.ContainsKey(route.RecordId) && route.RecordId < 1 ? (0 - entityRecord.Keys.Count) : route.RecordId;
            var sessionRecord = entityRecord.GetOrAdd(route.RecordId, new ViewResultInfo
            {
                Id = arbRecordId,
                Route = route,
            });

            //Route is not assigning in above code if the particular record is exist,
            //This causes the parentRecord When the Program SubTabs Form data.
            sessionRecord.Route = route;

            sessionRecord.Route.IsPopup = route.IsPopup;
            route = sessionRecord.Route;

            if (route.RecordId > 0 && (formResult.Record is BaseModel))
            {
            }
            else
            {
                (formResult.Record as SysRefModel).ArbRecordId = arbRecordId;
            }

            formResult.ColumnSettings = WebUtilities.GetUserColumnSettings(commonCommands.GetColumnSettings(route.Entity), formResult.SessionProvider);

            formResult.IsPopUp = route.IsPopup;
            (formResult.Record as SysRefModel).ParentId = route.ParentRecordId;
            (formResult.Record as SysRefModel).CompanyId = route.CompanyId ?? 0;
            formResult.AllowedImageExtensions = commonCommands.GetIdRefLangNames(DbConstants.ImageTypeLookupId).Select(s => s.LangName).ToArray();
            var imageExtensionDisplayMessage = commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.AllowedImageExtension);
            formResult.ImageExtensionWarningMsg = (imageExtensionDisplayMessage != null && imageExtensionDisplayMessage.Description != null) ? imageExtensionDisplayMessage.Description.Replace("''", string.Concat("'", string.Join(",", formResult.AllowedImageExtensions), "'")) : string.Empty;

            formResult.Operations = commonCommands.FormOperations(route);
            if (formResult.SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) &&
                !formResult.SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobCardEntity && route.Entity == EntitiesAlias.Job)
                formResult.Operations[OperationTypeEnum.New].Route.Action = MvcConstants.ActionAddOrEdit;

            formResult.Operations[OperationTypeEnum.Edit].Route.Action = MvcConstants.ActionAddOrEdit;
            formResult.Operations[OperationTypeEnum.Save].Route.Action = MvcConstants.ActionAddOrEdit;
            formResult.Operations[OperationTypeEnum.Update].Route.Action = MvcConstants.ActionAddOrEdit;
            formResult.Operations[OperationTypeEnum.Cancel].Route.Action = MvcConstants.ActionDataView;

            switch (route.Entity)
            {
                case EntitiesAlias.Customer:
                case EntitiesAlias.Vendor:
                case EntitiesAlias.Organization:
                case EntitiesAlias.OrgRefRole:
                case EntitiesAlias.Program:
                case EntitiesAlias.Job:
                    formResult.CallBackRoute = new MvcRoute(route);
                    //if (route.IsJobCardEntity)
                    //    formResult.SessionProvider.ViewPagedDataSession[route.Entity].IsJobCardEntity = true;
                    break;

                default:
                    formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);
                    break;
            }

            foreach (var colSetting in formResult.ColumnSettings)
                if (colSetting.ColLookupId > 0)
                {
                    formResult.ComboBoxProvider = formResult.ComboBoxProvider ?? new Dictionary<int, IList<IdRefLangName>>();
                    if (formResult.ComboBoxProvider.ContainsKey(colSetting.ColLookupId))
                        formResult.ComboBoxProvider[colSetting.ColLookupId] = commonCommands.GetIdRefLangNames(colSetting.ColLookupId);
                    else
                        formResult.ComboBoxProvider.Add(colSetting.ColLookupId, commonCommands.GetIdRefLangNames(colSetting.ColLookupId, false).Where(s => s.SysRefId > 0).ToList());
                }
        }

        public static APIClient.ViewModels.Administration.ReportView SetupReportResult<TView>(this ReportResult<TView> reportResult, ICommonCommands commonCommands, MvcRoute route, SessionProvider sessionProvider)
        {
            APIClient.ViewModels.Administration.ReportView reportView = null;
            if (route.RecordId < 1)
            {
                var dropDownData = new DropDownInfo { PageSize = 20, PageNumber = 1, Entity = EntitiesAlias.Report, ParentId = route.ParentRecordId, CompanyId = route.CompanyId };
                var records = commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query());
                if (!(records is IList<APIClient.ViewModels.Administration.ReportView>) || (records as List<APIClient.ViewModels.Administration.ReportView>).Count < 1)
                    return null;
                reportView = (records as List<APIClient.ViewModels.Administration.ReportView>).FirstOrDefault(r => r.RprtIsDefault == true);
                if (reportView == null)
                    reportView = (records as List<APIClient.ViewModels.Administration.ReportView>).FirstOrDefault();
                route.RecordId = reportView?.Id ?? 0;
            }
            reportResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionReportInfo);
            reportResult.ReportRoute = new MvcRoute(route, MvcConstants.ActionReportViewer);
            reportResult.ReportRoute.Url = reportView.RprtName;
            reportResult.ReportRoute.ParentEntity = EntitiesAlias.Common;
            reportResult.ReportRoute.ParentRecordId = 0;
            reportResult.SessionProvider = sessionProvider;
            reportResult.SetEntityAndPermissionInfo(commonCommands, sessionProvider);
            reportResult.ColumnSettings = commonCommands.GetColumnSettings(EntitiesAlias.Report);

            return reportView;
        }

        public static APIClient.ViewModels.Administration.ReportView SetupAdvancedReportResult<TView>(this AditionalReportResult<TView> reportResult, ICommonCommands commonCommands, MvcRoute route, SessionProvider sessionProvider)
        {
            APIClient.ViewModels.Administration.ReportView reportView = null;
            if (route.RecordId < 1)
            {
                var dropDownData = new DropDownInfo { PageSize = 20, PageNumber = 1, Entity = EntitiesAlias.Report, ParentId = route.ParentRecordId, CompanyId = route.CompanyId };
                var records = commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query());
                //records = null;
                if (!(records is IList<APIClient.ViewModels.Administration.ReportView>) || (records as List<APIClient.ViewModels.Administration.ReportView>).Count < 1)
                    return null;
                reportView = (records as List<APIClient.ViewModels.Administration.ReportView>).FirstOrDefault(r => r.RprtIsDefault == true);
                route.RecordId = reportView.Id;
            }
            reportResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionReportInfo);
            reportResult.ReportRoute = new MvcRoute(route, MvcConstants.ActionReportViewer);
            reportResult.ReportRoute.Url = reportView.RprtName;
            reportResult.ReportRoute.ParentEntity = EntitiesAlias.Common;
            reportResult.ReportRoute.ParentRecordId = 0;
            reportResult.SessionProvider = sessionProvider;
            reportResult.SetEntityAndPermissionInfo(commonCommands, sessionProvider);
            reportResult.ColumnSettings = commonCommands.GetColumnSettings(EntitiesAlias.Report);

            foreach (var colSetting in reportResult.ColumnSettings)
                if (colSetting.ColLookupId > 0)
                {
                    reportResult.ComboBoxProvider = reportResult.ComboBoxProvider ?? new Dictionary<int, IList<IdRefLangName>>();
                    if (reportResult.ComboBoxProvider.ContainsKey(colSetting.ColLookupId))
                        reportResult.ComboBoxProvider[colSetting.ColLookupId] = commonCommands.GetIdRefLangNames(colSetting.ColLookupId);
                    else
                        reportResult.ComboBoxProvider.Add(colSetting.ColLookupId, commonCommands.GetIdRefLangNames(colSetting.ColLookupId));
                }
            return reportView;
        }

        public static void SetupJobCardResult<TView>(this CardViewResult<TView> reportResult, ICommonCommands commonCommands, MvcRoute route, SessionProvider sessionProvider)
        {
            if (route.RecordId < 1)
            {
                //var dropDownData = new DropDownInfo { PageSize = 20, PageNumber = 1, Entity = EntitiesAlias.Report, ParentId = route.ParentRecordId, CompanyId = route.CompanyId };
                //var records = commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query());
                route.RecordId = 10;
            }
            reportResult.CallBackRoute = new MvcRoute(route, MvcConstants.ViewJobCardViewDashboard);
            reportResult.ReportRoute = new MvcRoute(route, MvcConstants.ViewJobCardViewDashboard);
            ////reportResult.ReportRoute.Url = reportView.RprtName;
            reportResult.ReportRoute.ParentEntity = EntitiesAlias.Common;
            reportResult.ReportRoute.ParentRecordId = 0;
            reportResult.SessionProvider = sessionProvider;
            reportResult.SetEntityAndPermissionInfo(commonCommands, sessionProvider);
            reportResult.ColumnSettings = commonCommands.GetColumnSettings(EntitiesAlias.JobCard);
        }

        public static void SetupDashboardResult<TView>(this DashboardResult<TView> dashboardResult, ICommonCommands commonCommands, MvcRoute route, SessionProvider sessionProvider)
        {
            if (route.RecordId < 1)
            {
                var dropDownData = new DropDownInfo { PageSize = 20, PageNumber = 1, Entity = EntitiesAlias.AppDashboard, ParentId = route.ParentRecordId, CompanyId = route.CompanyId };
                var records = commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query());
                var dashboard = (records as List<APIClient.ViewModels.AppDashboardView>).FirstOrDefault(r => r.DshIsDefault == true);
                if (dashboard != null)
                    route.RecordId = dashboard.Id;
            }
            dashboardResult.ColumnSettings = WebUtilities.GetUserColumnSettings(commonCommands.GetColumnSettings(EntitiesAlias.AppDashboard), sessionProvider);
            dashboardResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDashboardInfo);
            dashboardResult.DashboardRoute = new MvcRoute(route, MvcConstants.ActionDashboardViewer);
            dashboardResult.SessionProvider = sessionProvider;
            dashboardResult.SetEntityAndPermissionInfo(commonCommands, sessionProvider);
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this GridResult<TView> gridResult, ICommonCommands commonCommands, SessionProvider sessionProvider, EntitiesAlias? parentEntity = null)
        {
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];
                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                gridResult.PageName = !string.IsNullOrWhiteSpace(baseRoute.EntityName) ? String.Join(" ", Regex.Split(baseRoute.EntityName, @"(?<!^)(?=[A-Z])")) : baseRoute.Controller;
                gridResult.Icon = tableRef.TblIcon;
                if (parentEntity.HasValue && (parentEntity.Value != EntitiesAlias.Common))
                    tableRef = commonCommands.Tables[parentEntity.Value];
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);
                if (security == null)
                {
                    gridResult.Permission = Permission.ReadOnly;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    gridResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    string refTableName = tableRef.SysRefName != null ? Convert.ToString(tableRef.SysRefName).ToUpper() : tableRef.SysRefName;
                    //if (tableRef.SysRefName == "Job" && Convert.ToString(security.UserSubSecurities.FirstOrDefault().RefTableName).ToUpper() == "JOBGATEWAY")
                    //    refTableName = security.UserSubSecurities.FirstOrDefault().RefTableName != null ? Convert.ToString(security.UserSubSecurities.FirstOrDefault().RefTableName).ToUpper() : security.UserSubSecurities.FirstOrDefault().RefTableName;

                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName != null && x.RefTableName.ToUpper() == refTableName);
                    gridResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }
                if (tableRef.SysRefName == EntitiesAlias.JobAdvanceReport.ToString()
                 || tableRef.SysRefName == EntitiesAlias.JobCard.ToString())
                {
                    gridResult.Permission = Permission.ReadOnly;
                }
                return baseRoute;
            }
            return null;
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this FormResult<TView> formResult, ICommonCommands commonCommands, SessionProvider sessionProvider, EntitiesAlias? parentEntity = null)
        {
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];

                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                formResult.PageName = baseRoute.EntityName;
                formResult.Icon = tableRef.TblIcon;
                if (formResult.CallBackRoute != null && formResult.CallBackRoute.Entity == EntitiesAlias.Contact
                    && formResult.CallBackRoute.ParentEntity == EntitiesAlias.Job
                    && formResult.CallBackRoute.RecordId == 0
                    && formResult.CallBackRoute.ParentRecordId > 0
                    && formResult.CallBackRoute.PreviousRecordId > 0
                    && formResult.CallBackRoute.OwnerCbPanel == "pnlJobDetail"
                    && formResult.CallBackRoute.Filters != null
                    && !string.IsNullOrEmpty(formResult.CallBackRoute.Filters.FieldName))
                    tableRef = commonCommands.Tables[EntitiesAlias.JobGateway];
                else if (parentEntity.HasValue && (parentEntity.Value != EntitiesAlias.Common))
                    tableRef = commonCommands.Tables[parentEntity.Value];
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);

                if (security == null)
                {
                    formResult.Permission = Permission.ReadOnly;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    formResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
                    formResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }

                return baseRoute;
            }
            return null;
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this ReportResult<TView> reportResult, ICommonCommands commonCommands, SessionProvider sessionProvider)
        {
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];
                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                reportResult.PageName = baseRoute.EntityName;
                reportResult.Icon = tableRef.TblIcon;
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);
                if (security == null)
                {
                    reportResult.Permission = Permission.ReadOnly;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    reportResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
                    reportResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }
                if (baseRoute.Entity == EntitiesAlias.JobReport)
                {
                    reportResult.Permission = Permission.EditAll;
                }
                return baseRoute;
            }
            return null;
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this AditionalReportResult<TView> reportResult, ICommonCommands commonCommands, SessionProvider sessionProvider)
        {
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];
                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                reportResult.PageName = baseRoute.EntityName;
                reportResult.Icon = tableRef.TblIcon;
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);
                if (security == null)
                {
                    reportResult.Permission = Permission.ReadOnly;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    reportResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
                    reportResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }
                if (baseRoute.Entity == EntitiesAlias.JobReport)
                {
                    reportResult.Permission = Permission.EditAll;
                }
                return baseRoute;
            }
            return null;
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this CardViewResult<TView> reportResult, ICommonCommands commonCommands, SessionProvider sessionProvider)
        {
            reportResult.Permission = Permission.EditAll;
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];
                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                reportResult.PageName = baseRoute.EntityName;
                reportResult.Icon = tableRef.TblIcon;
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);
                if (security == null)
                {
                    reportResult.Permission = Permission.EditAll;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    reportResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
                    reportResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }

                if (baseRoute.Entity == EntitiesAlias.JobCard)
                {
                    reportResult.Permission = Permission.EditAll;
                }

                return baseRoute;
            }
            return null;
        }

        public static MvcRoute SetEntityAndPermissionInfo<TView>(this DashboardResult<TView> dashboardResult, ICommonCommands commonCommands, SessionProvider sessionProvider)
        {
            if (commonCommands != null && Enum.IsDefined(typeof(EntitiesAlias), typeof(TView).BaseType.Name) && typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>() != EntitiesAlias.Common)
            {
                var tableRef = commonCommands.Tables[typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>()];
                var baseRoute = new MvcRoute { Entity = typeof(TView).BaseType.Name.ToEnum<EntitiesAlias>(), Action = MvcConstants.ActionIndex, Area = tableRef.MainModuleName, EntityName = tableRef.TblLangName };
                dashboardResult.PageName = baseRoute.EntityName;
                dashboardResult.Icon = tableRef.TblIcon;
                var moduleIdToCompare = (baseRoute.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
                var security = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);
                if (security == null)
                {
                    dashboardResult.Permission = Permission.ReadOnly;
                }
                else if (security?.UserSubSecurities?.Count == null || security.UserSubSecurities.Count == 0)
                {
                    dashboardResult.Permission = security.SecMenuAccessLevelId.ToEnum<Permission>();
                }
                else
                {
                    var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
                    dashboardResult.Permission = subSecurity == null ? security.SecMenuAccessLevelId.ToEnum<Permission>() : subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
                }

                return baseRoute;
            }
            return null;
        }

        public static void SetRecordDefaults<TView>(this ActiveUser activeUser, TView entityView, string dateTime)
        {
            if (entityView is SysRefModel)
            {
                if (string.IsNullOrEmpty(((entityView as SysRefModel).LangCode)))
                    (entityView as SysRefModel).LangCode = activeUser.LangCode;
                (entityView as SysRefModel).RoleCode = activeUser.RoleCode;
            }
            if (entityView is BaseModel && (entityView as BaseModel).Id > 0)
            {
                if (!string.IsNullOrEmpty(dateTime) && dateTime.ToLong() > 0)
                    (entityView as BaseModel).DateChanged = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(Math.Round(dateTime.ToLong() / 1000d));
                (entityView as BaseModel).ChangedBy = activeUser.UserName;
            }
            else if (entityView is BaseModel)
            {
                if (!string.IsNullOrEmpty(dateTime) && dateTime.ToLong() > 0)
                    (entityView as BaseModel).DateEntered = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(Math.Round(dateTime.ToLong() / 1000d));
                (entityView as BaseModel).EnteredBy = activeUser.UserName;
            }
        }

        public static void ClearRecordDefaults<TView>(this ActiveUser activeUser, TView entityView)
        {
            if (entityView is SysRefModel)
            {
                (entityView as SysRefModel).LangCode = null;
                (entityView as SysRefModel).RoleCode = null;
            }
            if (entityView is BaseModel)
            {
                (entityView as BaseModel).DateEntered = null;
                (entityView as BaseModel).EnteredBy = null;
                (entityView as BaseModel).DateChanged = null;
                (entityView as BaseModel).ChangedBy = null;
            }
        }

        public static APIClient.ViewModels.ColumnSetting FirstOrDefault(this IList<APIClient.ViewModels.ColumnSetting> columnSettings, string columnName, object parentColumnName = null)
        {
            var columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnName));

            if (columnSetting == null && columnName.EqualsOrdIgnoreCase(CommonColumns.Id.ToString()))
            {
                if (columnSettings.Any(v => v.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.ScrOsdList.ToString())))
                {
                    columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(WebUtilities.GetKeyFieldName(EntitiesAlias.ScrOsdList, CommonColumns.Id.ToString())));
                    columnSetting.ColColumnName = CommonColumns.Id.ToString();
                }
                if (columnSettings.Any(v => v.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.ScrOsdReasonList.ToString())))
                {
                    columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(WebUtilities.GetKeyFieldName(EntitiesAlias.ScrOsdReasonList, CommonColumns.Id.ToString())));
                    columnSetting.ColColumnName = CommonColumns.Id.ToString();
                }
                if (columnSettings.Any(v => v.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.ScrRequirementList.ToString())))
                {
                    columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(WebUtilities.GetKeyFieldName(EntitiesAlias.ScrRequirementList, CommonColumns.Id.ToString())));
                    columnSetting.ColColumnName = CommonColumns.Id.ToString();
                }
                if (columnSettings.Any(v => v.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.ScrReturnReasonList.ToString())))
                {
                    columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(WebUtilities.GetKeyFieldName(EntitiesAlias.ScrReturnReasonList, CommonColumns.Id.ToString())));
                    columnSetting.ColColumnName = CommonColumns.Id.ToString();
                }
                if (columnSettings.Any(v => v.ColTableName.EqualsOrdIgnoreCase(EntitiesAlias.ScrServiceList.ToString())))
                {
                    columnSetting = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(WebUtilities.GetKeyFieldName(EntitiesAlias.ScrServiceList, CommonColumns.Id.ToString())));
                    columnSetting.ColColumnName = CommonColumns.Id.ToString();
                }
            }

            if (columnSetting == null)
            {
                columnSetting = new APIClient.ViewModels.ColumnSetting
                {
                    ColIsVisible = true,
                    ColColumnName = columnName,
                    //ColAliasName = columnName,
                    ColCaption = columnName,
                    ColDescription = columnName
                };
                if (parentColumnName != null && columnSettings.Any(col => col.ColColumnName.EqualsOrdIgnoreCase(parentColumnName.ToString())))
                {
                    columnSetting.ColAliasName = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(parentColumnName.ToString())).ColAliasName;
                    columnSetting.IsRequired = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(parentColumnName.ToString())).IsRequired;
                    columnSetting.ColIsReadOnly = columnSettings.FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(parentColumnName.ToString())).ColIsReadOnly;
                }
                else
                    columnSetting.ColAliasName = columnName;
            }

            return columnSetting;
        }

        public static IdRefLangName GetDefault(this IList<IdRefLangName> refLangNames)
        {
            if (refLangNames.Count == 0)
                return new IdRefLangName();
            var refLang = refLangNames.FirstOrDefault(col => col.IsDefault);
            if (refLang == null)
                return refLangNames.FirstOrDefault();
            return refLang;
        }

        public static void AddOrUpdate(this ConcurrentDictionary<EntitiesAlias, SessionInfo> dictionary, EntitiesAlias entity, SessionInfo sessionInfo)
        {
            dictionary.AddOrUpdate(entity, sessionInfo, (key, oldValue) => sessionInfo);
        }

        public static PagedDataInfo SetPagedDataInfo(this SysSetting userSetting, MvcRoute route, int pageSizeFromCookie)
        {
            return new PagedDataInfo
            {
                PageNumber = 1,
                RecordId = route.RecordId,
                ParentId = route.ParentRecordId,
                Entity = route.Entity,
                AvailablePageSizes = userSetting.Settings.GetSystemSettingValue(WebApplicationConstants.SysGridViewPageSizes),
                PageSize = pageSizeFromCookie < 10 ? userSetting.Settings.GetSystemSettingValue(WebApplicationConstants.SysPageSize).ToInt() : pageSizeFromCookie
            };
        }

        public static Operation SetRoute(this Operation operation, MvcRoute route, string action, bool isEdit = false)
        {
            route.IsEdit = isEdit;
            operation.Route = new MvcRoute(route, action);
            return operation;
        }

        public static RibbonMenu SetRibbonMenu(this LeftMenu leftMenu)
        {
            var ribbon = new RibbonMenu
            {
                Id = leftMenu.Id,
                MnuModuleId = leftMenu.MnuModuleId,
                MnuTableName = leftMenu.MnuTableName,
                MnuTitle = leftMenu.MnuTitle,
                MnuBreakDownStructure = leftMenu.MnuBreakDownStructure,
                MnuTabOver = leftMenu.MnuTabOver,
                MnuIconVerySmall = leftMenu.MnuIconVerySmall,
                MnuIconMedium = leftMenu.MnuIconMedium,
                MnuExecuteProgram = leftMenu.MnuExecuteProgram,
                MnuAccessLevelId = leftMenu.MnuAccessLevelId,
                MnuOptionLevelId = leftMenu.MnuOptionLevelId,
                StatusId = leftMenu.StatusId,
            };
            leftMenu.Children.ToList().ForEach(c => ribbon.Children.Add(c.SetRibbonMenu()));
            return ribbon;
        }

        public static MvcRoute SetParent(this MvcRoute route, EntitiesAlias parentEntity, long parentRecordId, bool isPopup = false)
        {
            route.ParentEntity = parentEntity;
            route.ParentRecordId = parentRecordId;
            route.IsPopup = isPopup;
            return route;
        }

        public static ByteArray GetVarbinaryByteArray(this long recordId, EntitiesAlias entity, string fieldName)
        {
            return new ByteArray
            {
                Id = recordId,
                FieldName = fieldName,
                Entity = entity,
                Type = SQLDataTypes.varbinary
            };
        }

        public static ByteArray GetNvarcharByteArray(this long recordId, EntitiesAlias entity, string fieldName)
        {
            return new ByteArray
            {
                Id = recordId,
                FieldName = fieldName,
                Entity = entity,
                Type = SQLDataTypes.nvarchar
            };
        }

        public static ByteArray GetImageByteArray(this long recordId, EntitiesAlias entity, string fieldName)
        {
            return new ByteArray
            {
                Id = recordId,
                FieldName = fieldName,
                Entity = entity,
                Type = SQLDataTypes.image
            };
        }

        public static ByteArray GetVarbinaryByteArray(this MvcRoute route, string fieldName)
        {
            return new ByteArray
            {
                Id = route.RecordId,
                FieldName = fieldName,
                Entity = route.Entity,
                IsPopup = route.IsPopup,
                Type = SQLDataTypes.varbinary
            };
        }

        public static ByteArray GetVarbinaryByteArray(this MvcRoute route, long id, string fieldName)
        {
            return new ByteArray
            {
                Id = id,
                FieldName = fieldName,
                Entity = route.Entity,
                IsPopup = route.IsPopup,
                Type = SQLDataTypes.varbinary
            };
        }

        public static ByteArray GetNvarcharByteArray(this MvcRoute route, string fieldName)
        {
            return new ByteArray
            {
                Id = route.RecordId,
                FieldName = fieldName,
                Entity = route.Entity,
                IsPopup = route.IsPopup,
                Type = SQLDataTypes.nvarchar
            };
        }

        public static ByteArray GetImageByteArray(this MvcRoute route, string fieldName)
        {
            return new ByteArray
            {
                Id = route.RecordId,
                FieldName = fieldName,
                Entity = route.Entity,
                IsPopup = route.IsPopup,
                Type = SQLDataTypes.image
            };
        }

        public static PageInfo SetRoute(this PageInfo pageInfo, MvcRoute route, ICommonCommands commonCommands = null)
        {
            pageInfo.Route = new MvcRoute(route);
            pageInfo.Route.Action = pageInfo.TabExecuteProgram;

            if (Enum.IsDefined(typeof(EntitiesAlias), pageInfo.TabTableName) && pageInfo.TabTableName.ToEnum<EntitiesAlias>() != route.Entity)
            {
                pageInfo.Route.Entity = pageInfo.TabTableName.ToEnum<EntitiesAlias>();
                pageInfo.Route.Area = commonCommands != null && commonCommands.Tables.ContainsKey(pageInfo.TabTableName.ToEnum<EntitiesAlias>()) ? commonCommands.Tables[pageInfo.TabTableName.ToEnum<EntitiesAlias>()].MainModuleName : route.Area;
                pageInfo.Route.EntityName = pageInfo.TabPageTitle;
                pageInfo.Route.IsPopup = true;
            }
            if (pageInfo.Route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionDataView))
                pageInfo.Route.RecordId = 0;//No RecordId require for dataview only parent entity and parentId to get filtered view.
            if (route.Entity == EntitiesAlias.JobCard && pageInfo.Route.Entity != EntitiesAlias.JobAttribute && pageInfo.Route.Entity != EntitiesAlias.JobDocReference)
                pageInfo.Route.Entity = EntitiesAlias.JobCard;
            switch (pageInfo.Route.Action)
            {
                case MvcConstants.ActionJobGatewayDataView:
                case MvcConstants.ActionJobGatewayActions:
                case MvcConstants.ActionJobGatewayLog:
                case MvcConstants.ActionJobGatewayAll:
                case MvcConstants.ActionDocumentDataView:
                case MvcConstants.ActionDeliveryPodDataView:
                case MvcConstants.ActionDocDamagedDataView:
                case MvcConstants.ActionDocDeliveryPodDataView:
                case MvcConstants.ActionDocApprovalsDataView:
                case MvcConstants.ActionDocImageDataView:
                case MvcConstants.ActionDocSignatureDataView:
                case MvcConstants.ActionDocDocumentDataView:
                    pageInfo.Route.RecordId = 0;
                    break;
            }

            if (pageInfo.Route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionDataView))

                pageInfo.Route.OwnerCbPanel = string.Concat(pageInfo.UniqueName, "CbPanel");
            return pageInfo;
        }

        public static MvcRoute CopyRoute(this MvcRoute route)
        {
            return new MvcRoute
            {
                Action = route.Action,
                Entity = route.Entity,
                Area = route.Area,
                RecordId = route.RecordId,
                ParentRecordId = route.ParentRecordId,
                Filters = route.Filters,
                IsPopup = route.IsPopup,
                EntityName = route.EntityName,
                OwnerCbPanel = route.OwnerCbPanel,
                ParentEntity = route.ParentEntity,
            };
        }

        public static DropDownInfo Query(this DropDownInfo dropDownData, string selectedValueColumnName = null, object selectedValue = null, Type selectedValueType = null)
        {
            if (FormViewProvider.ComboBoxColumns.ContainsKey(dropDownData.Entity.Value))
                dropDownData.TableFields = string.Concat(dropDownData.Entity.ToString() + "." + string.Join(string.Concat("," + dropDownData.Entity.ToString() + "."), FormViewProvider.ComboBoxColumns[dropDownData.Entity.Value]));
            else if (FormViewProvider.ComboBoxColumnsExtension.ContainsKey(dropDownData.Entity.Value))
            {
                switch (dropDownData.Entity)
                {
                    case EntitiesAlias.ColumnAlias:
                        dropDownData.TableFields = string.Concat(dropDownData.Entity.ToString() + "." + string.Join(string.Concat("," + dropDownData.Entity.ToString() + "."), FormViewProvider.ComboBoxColumnsExtension[dropDownData.Entity.Value]));
                        break;

                    case EntitiesAlias.Lookup:
                        dropDownData.TableFields = string.Concat(dropDownData.Entity.ToString() + "." + string.Join(string.Concat("," + dropDownData.Entity.ToString() + "."), new string[] { "SysLookupId, SysLookupCode" }));
                        break;
                }
            }

            if (dropDownData.ParentId > 0)
            {
                var parentCondition = dropDownData.WhereCondition;
                dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", dropDownData.Entity.ToString(), "{0}", dropDownData.ParentId);
                switch (dropDownData.Entity)
                {
                    case EntitiesAlias.Contact:
                        if (dropDownData.EntityFor.ToString() == EntitiesAlias.JobDriverContactInfo.ToString())
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", dropDownData.Entity.ToString(), ContactColumnNames.ConTypeId.ToString(), Convert.ToInt32(ContactType.Driver));
                        if (dropDownData.EntityFor.ToString() == EntitiesAlias.PPPRoleCodeContact.ToString())
                        {
                            dropDownData.WhereCondition = string.Empty;
                            dropDownData.WhereCondition = parentCondition;
                        }
                        else
                            dropDownData.WhereCondition = string.Empty;
                        break;

                    case EntitiesAlias.State:
                        dropDownData.WhereCondition = string.Empty;
                        break;

                    case EntitiesAlias.Company:
                        dropDownData.WhereCondition = string.Empty;
                        break;

                    case EntitiesAlias.RollUpBillingJob:
                        dropDownData.WhereCondition = string.Empty;
                        break;

                    case EntitiesAlias.OrgRole:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "OrgID");
                        break;

                    case EntitiesAlias.OrgRefRole:
                        if (dropDownData.EntityFor == EntitiesAlias.OrgRolesResp)
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", EntitiesAlias.OrgRefRole.ToString(), "OrgId", dropDownData.ParentId);
                        if (dropDownData.EntityFor == EntitiesAlias.SystemAccount)
                        {
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", EntitiesAlias.OrgRefRole.ToString(), ReservedKeysEnum.StatusId.ToString(), "1");
                        }
                        if (dropDownData.EntityFor == EntitiesAlias.OrgPocContact)
                        {
                            dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "OrgID");
                            dropDownData.WhereCondition += string.Format(" AND {0}.{1} IN ( {2} )", EntitiesAlias.OrgRefRole.ToString(), "RoleTypeId", "95,97,98");
                        }
                        break;

                    case EntitiesAlias.SecurityByRole:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "OrgId");
                        break;

                    case EntitiesAlias.Customer:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "CustOrgId");
                        break;

                    case EntitiesAlias.Vendor:
                        if (dropDownData.ColumnName.Equals("PvlVendorId", StringComparison.OrdinalIgnoreCase)
                            || dropDownData.ColumnName.Equals("PclVendorId", StringComparison.OrdinalIgnoreCase)
                            || dropDownData.ColumnName.Equals("PblVendorId", StringComparison.OrdinalIgnoreCase))
                        {
                            dropDownData.WhereCondition = string.Format(" AND {0}.PvlProgramID = {2} ", EntitiesAlias.PrgVendLocation.ToString(), "{0}", dropDownData.ParentId);
                        }
                        else
                        {
                            dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "VendOrgID");
                        }
                        break;

                    case EntitiesAlias.Program:
                        if (dropDownData.EntityFor == EntitiesAlias.PrgEdiCondition)
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", EntitiesAlias.Program.ToString(), "Id", dropDownData.ParentId);
                        else if (dropDownData.EntityFor == EntitiesAlias.Common)
                            dropDownData.WhereCondition = "";//string.Format(dropDownData.WhereCondition, "PrgCustID");
                        else
                            dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "PrgOrgID");
                        break;

                    case EntitiesAlias.Job:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "ProgramID");
                        break;

                    case EntitiesAlias.PrgVendLocation:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "PvlProgramID");
                        break;

                    case EntitiesAlias.SystemReference:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "SysLookupId");
                        break;

                    case EntitiesAlias.Organization:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "Id");
                        break;

                    case EntitiesAlias.Report:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "RprtMainModuleId");
                        break;

                    case EntitiesAlias.AppDashboard:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "DshMainModuleId");
                        break;

                    case EntitiesAlias.PrgShipApptmtReasonCode:
                        if (dropDownData.EntityFor == EntitiesAlias.Job)
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", EntitiesAlias.Job.ToString(), "Id", dropDownData.ParentId);
                        else
                            dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "PacProgramID");
                        break;

                    case EntitiesAlias.PrgShipStatusReasonCode:
                        if (dropDownData.EntityFor == EntitiesAlias.Job)
                            dropDownData.WhereCondition = string.Format(" AND {0}.{1} = {2} ", EntitiesAlias.Job.ToString(), "Id", dropDownData.ParentId);
                        else
                            dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "PscProgramID");
                        break;

                    case EntitiesAlias.JobCargo:
                    case EntitiesAlias.GwyExceptionCode:
                    case EntitiesAlias.GwyExceptionStatusCode:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "JobID");
                        break;

                    case EntitiesAlias.PrgRefGatewayDefault:
                        dropDownData.WhereCondition = string.Format(dropDownData.WhereCondition, "PgdProgramID");
                        dropDownData.WhereCondition += dropDownData.WhereConditionExtention;
                        break;
                }
            }
            else if (!string.IsNullOrEmpty(dropDownData.WhereCondition))
            {
                switch (dropDownData.Entity)
                {
                    case EntitiesAlias.ColumnAlias:
                        break;
                }
            }

            if (!string.IsNullOrWhiteSpace(selectedValueColumnName) && selectedValue != null)
            {
                var selectedValueToSend = selectedValue.ToString();
                dropDownData.PrimaryKeyName = selectedValueColumnName;
                dropDownData.PrimaryKeyValue = (((selectedValueType.Equals(typeof(Int32)) || selectedValueType.Equals(typeof(Int64))) && (selectedValue.ToLong() > 0)) ||
                    ((selectedValueType.Equals(typeof(String))) && (!string.IsNullOrWhiteSpace(selectedValueToSend)))) ? selectedValueToSend : null;
                if (dropDownData.PrimaryKeyValue == null)
                    dropDownData.PrimaryKeyName = null;
            }
            return dropDownData;
        }

        /// <summary>
        /// Get value.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="session"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static T GetDataFromSession<T>(this HttpSessionStateBase session, string key)
        {
            return (T)session[key];
        }

        /// <summary>
        /// Set value.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="session"></param>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void SetDataToSession<T>(this HttpSessionStateBase session, string key, object value)
        {
            session[key] = value;
        }

        public static string StringConcat(this string value, params string[] strs)
        {
            return string.Concat(value, strs);
        }

        public static string ConvertByteToString(this byte[] imageBytes)
        {
            if ((imageBytes == null) || (imageBytes.Length == 0))
                return string.Empty;

            return "data:image/jpeg;base64," + Convert.ToBase64String(imageBytes);
        }

        public static void UpdateModelError(this System.Web.Mvc.ModelStateDictionary ModelState, string propName, string message)
        {
            ModelState.Remove(propName);
            ModelState.AddModelError(propName, message);
        }

        public static IDictionary<OperationTypeEnum, Operation> GridOperations(this ICommonCommands commonCommands)
        {
            return new Dictionary<OperationTypeEnum, Operation>
            {
                {OperationTypeEnum.New,  commonCommands.GetOperation(OperationTypeEnum.New)},
                {OperationTypeEnum.Delete,  commonCommands.GetOperation(OperationTypeEnum.Delete)},
                {OperationTypeEnum.SaveChanges,  commonCommands.GetOperation(OperationTypeEnum.SaveChanges)},
                {OperationTypeEnum.CancelChanges,  commonCommands.GetOperation(OperationTypeEnum.CancelChanges)},
                {OperationTypeEnum.Download,  commonCommands.GetOperation(OperationTypeEnum.Download)}
            };
        }

        public static IDictionary<OperationTypeEnum, Operation> FormOperations(this ICommonCommands commonCommands, MvcRoute route)
        {
            var operations = new Dictionary<OperationTypeEnum, Operation>
            {
                {OperationTypeEnum.New,  commonCommands.GetOperation(OperationTypeEnum.New).SetRoute(route,route.Action)},
                {OperationTypeEnum.Edit,  commonCommands.GetOperation(OperationTypeEnum.Edit).SetRoute(route, route.Action,route.IsEdit)},
                {OperationTypeEnum.Save,  commonCommands.GetOperation(OperationTypeEnum.Save).SetRoute(route, route.Action)},
                {OperationTypeEnum.Update,  commonCommands.GetOperation(OperationTypeEnum.Update).SetRoute(route, route.Action)},
                {OperationTypeEnum.Cancel,  commonCommands.GetOperation(OperationTypeEnum.Cancel).SetRoute(route, route.Action)},
            };
            return operations;
        }

        public static IDictionary<OperationTypeEnum, Operation> ChooseColumnOperations(this ICommonCommands commonCommands)
        {
            return new Dictionary<OperationTypeEnum, Operation>
            {
                {OperationTypeEnum.AddColumn,  commonCommands.GetOperation(OperationTypeEnum.AddColumn)},
                {OperationTypeEnum.RemoveColumn,  commonCommands.GetOperation(OperationTypeEnum.RemoveColumn)},
                {OperationTypeEnum.Up, commonCommands. GetOperation(OperationTypeEnum.Up)},
                {OperationTypeEnum.Down,commonCommands.GetOperation(OperationTypeEnum.Down)},
                {OperationTypeEnum.Restore, commonCommands. GetOperation(OperationTypeEnum.Restore)},
                {OperationTypeEnum.Freeze,  commonCommands.GetOperation(OperationTypeEnum.Freeze)},
                {OperationTypeEnum.RemoveFreeze,  commonCommands.GetOperation(OperationTypeEnum.RemoveFreeze)},
                {OperationTypeEnum.GroupBy,  commonCommands.GetOperation(OperationTypeEnum.GroupBy)},
                {OperationTypeEnum.RemoveGroupBy,  commonCommands.GetOperation(OperationTypeEnum.RemoveGroupBy)},
                {OperationTypeEnum.New,  commonCommands.GetOperation(OperationTypeEnum.New)},
                {OperationTypeEnum.Delete,  commonCommands.GetOperation(OperationTypeEnum.Delete)},
                {OperationTypeEnum.Save, commonCommands. GetOperation(OperationTypeEnum.Save)},
                {OperationTypeEnum.Cancel,  commonCommands.GetOperation(OperationTypeEnum.Cancel)}
            };
        }

        public static IDictionary<OperationTypeEnum, Operation> TreeOperations(this ICommonCommands commonCommands, MvcRoute mvcRoute)
        {
            return new Dictionary<OperationTypeEnum, Operation>
            {
                {OperationTypeEnum.New,  commonCommands.GetOperation(OperationTypeEnum.New)},
                {OperationTypeEnum.Edit,  commonCommands.GetOperation(OperationTypeEnum.Edit)}
            };
        }

        public static FormNavMenu GetRoute(this FormNavMenu formNavMenu)
        {
            return new FormNavMenu
            {
                Area = formNavMenu.Area,
                Entity = formNavMenu.Entity,
                IsNext = formNavMenu.IsNext,
                IsEnd = formNavMenu.IsEnd,
                IsPopup = formNavMenu.IsPopup,
                Action = formNavMenu.Action,
                RecordId = formNavMenu.RecordId,
                ParentEntity = formNavMenu.ParentEntity,
                ParentRecordId = formNavMenu.ParentRecordId,
                Url = formNavMenu.Url
            };
        }

        public static string BuildGridSortCondition(this DevExpress.Web.Mvc.GridViewColumnState columnState, bool reset, EntitiesAlias entity, ICommonCommands commands)
        {
            string sortColumn = null;
            if (columnState.FieldName != null)
            {
                var colSetting = commands.GetColumnSettings(entity).FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnState.FieldName));

                if (WebUtilities.IsIdNameField(columnState.FieldName) && entity != EntitiesAlias.JobAdvanceReport)
                    sortColumn = columnState.FieldName;
                else
                {
                    if (entity == EntitiesAlias.JobAdvanceReport)
                        sortColumn = colSetting.ColColumnName;
                    else
                    {
                        sortColumn = string.Format(" {0}.{1} ", entity.ToString(), columnState.FieldName);
                        if (columnState.FieldName.ToUpper().EndsWith("IDNAME"))
                            sortColumn = string.Format(" {0}.{1} ", entity.ToString(), columnState.FieldName.Split(new string[] { "Name" }, StringSplitOptions.None)[0]);
                        else if (columnState.FieldName.ToUpper().EndsWith("NAME") && (entity == EntitiesAlias.PrgRefGatewayDefault || entity == EntitiesAlias.JobGateway))//Added because some reference keys do not have IdName Ex:GwyGatewayResponsible and GwyGatewayResponsibleName
                            sortColumn = string.Format(" {0}.{1} ", entity.ToString(), columnState.FieldName.Split(new string[] { "Name" }, StringSplitOptions.None)[0]);
                    }
                }
                switch (columnState.SortOrder)
                {
                    case DevExpress.Data.ColumnSortOrder.Ascending:
                        sortColumn += " ASC ";
                        break;
                    case DevExpress.Data.ColumnSortOrder.Descending:
                        sortColumn += " DESC ";
                        break;
                    default:
                        if (entity == EntitiesAlias.PrgRefGatewayDefault)
                            sortColumn += " ASC ";
                        break;
                }
            }
            return sortColumn;
        }

        //public static string BuildGridSortCondition(this DevExpress.Web.Mvc.GridViewColumnState columnState, bool reset, EntitiesAlias entity, ICommonCommands commands)
        //{
        //    string sortColumn = null;
        //    if (columnState.FieldName != null)
        //    {
        //        var colSetting = commands.GetColumnSettings(entity).FirstOrDefault(col => col.ColColumnName.EqualsOrdIgnoreCase(columnState.FieldName));

        //        if (WebUtilities.IsIdNameField(columnState.FieldName) && entity != EntitiesAlias.JobAdvanceReport)
        //            sortColumn = columnState.FieldName;
        //        else
        //        {
        //            if (entity == EntitiesAlias.JobAdvanceReport)
        //                sortColumn = colSetting.ColColumnName;
        //            else
        //            {
        //                sortColumn = string.Format("{0}.{1}", entity.ToString(), columnState.FieldName);
        //                if (columnState.FieldName.ToUpper().EndsWith("IDNAME"))
        //                    sortColumn = string.Format(" {0}.{1}", entity.ToString(), columnState.FieldName.Split(new string[] { "Name" }, StringSplitOptions.None)[0]);
        //                else if (columnState.FieldName.ToUpper().EndsWith("NAME") && (entity == EntitiesAlias.PrgRefGatewayDefault || entity == EntitiesAlias.JobGateway))//Added because some reference keys do not have IdName Ex:GwyGatewayResponsible and GwyGatewayResponsibleName
        //                    sortColumn = string.Format("{0}.{1}", entity.ToString(), columnState.FieldName.Split(new string[] { "Name" }, StringSplitOptions.None)[0]);
        //            }
        //        }
        //        sortColumn.Trim();
        //        switch (columnState.SortOrder)
        //        {
        //            case DevExpress.Data.ColumnSortOrder.Ascending:
        //                sortColumn += " ASC ";
        //                break;
        //            case DevExpress.Data.ColumnSortOrder.Descending:
        //                sortColumn += " DESC ";
        //                break;
        //        }
        //    }
        //    return sortColumn;
        //}

        public static string BuildGridFilterWhereCondition(this DevExpress.Web.Mvc.GridViewFilteringState filteringState, EntitiesAlias entity, ref Dictionary<string, string> filters, ICommonCommands commands)
        {
            var whereCondition = string.Empty;
            filters = new Dictionary<string, string>();
            if (!string.IsNullOrWhiteSpace(filteringState.FilterExpression))
            {
                var criterias = CriteriaColumnAffinityResolver.SplitByColumns(CriteriaOperator.TryParse(filteringState.FilterExpression));
                var criteriaToUse = new Dictionary<OperandProperty, CriteriaOperator>();

                var allVirtualColumns = new List<string>();
                WebUtilities.VirtualColumns().TryGetValue(entity, out allVirtualColumns);

                foreach (var criteria in criterias)
                {
                    var oldPropertyName = string.Copy(criteria.Key.PropertyName);

                    filters.Add(oldPropertyName, string.Empty);
                    criteria.Key.PropertyName = string.Format("{0}.{1}", entity.ToString(), criteria.Key.PropertyName);

                    if (WebUtilities.IsIdNameField(oldPropertyName))
                    {
                        var criteriaOperands = ((FunctionOperator)criteria.Value).Operands[0];
                        var currentPropertyName = ((OperandProperty)criteriaOperands).PropertyName;
                        var propertyName = currentPropertyName.Substring(0, currentPropertyName.Length - 4);
                        if (entity == EntitiesAlias.OrgRefRole || entity == EntitiesAlias.OrgRolesResp)
                            propertyName = string.Format("{0}.{1}", entity.ToString(), propertyName);
                        ((OperandProperty)criteriaOperands).PropertyName = propertyName;
                        var currentValueOperand = ((FunctionOperator)criteria.Value).Operands[1];
                        var currentValue = ((OperandValue)currentValueOperand).Value;
                        filters[oldPropertyName] = Convert.ToString(currentValue);
                        criteriaToUse.Add(criteria.Key, new BinaryOperator(propertyName, Convert.ToInt64(currentValue), BinaryOperatorType.Equal));

                        var currentCriteria = new BinaryOperator(propertyName, Convert.ToInt64(currentValue), BinaryOperatorType.Equal);
                        var updatedCriterias = CriteriaOperator.And(currentCriteria);
                        var sqlCondition = CriteriaToWhereClauseHelper.GetMsSqlWhere(updatedCriterias).Replace("\"", "");
                        whereCondition += string.Concat(" AND ", sqlCondition, " ");
                    }
                    else
                    {
                        filters[oldPropertyName] = criteria.Value.GetCriteriaOperatorValue();

                        if ((allVirtualColumns == null) || !allVirtualColumns.Contains(oldPropertyName))
                        {
                            var item = criteria.Value;

                            if (item is BinaryOperator)
                                ((OperandProperty)((BinaryOperator)item).LeftOperand).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((BinaryOperator)item).LeftOperand).PropertyName);
                            else if (item is UnaryOperator)
                            {
                                if (((UnaryOperator)item).Operand is FunctionOperator)
                                {
                                    ((OperandProperty)((FunctionOperator)((UnaryOperator)item).Operand).Operands[0]).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((FunctionOperator)((UnaryOperator)item).Operand).Operands[0]).PropertyName);
                                }
                                //else if (((UnaryOperator)item).Operand is GroupOperator)
                                //{
                                //    if ((((UnaryOperator)item).Operand).Operands[0] is FunctionOperator)
                                //        ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[0])).Operands[0]).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[0])).Operands[0]).PropertyName);

                                //    ((OperandProperty)((FunctionOperator)((UnaryOperator)item).Operand).Operands[0]).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((FunctionOperator)((UnaryOperator)item).Operand).Operands[0]).PropertyName);
                                //}
                            }
                            else if (item is GroupOperator)
                            {
                                if (((GroupOperator)item).Operands[0] is BinaryOperator)
                                    ((OperandProperty)((BinaryOperator)(((GroupOperator)item).Operands[0])).LeftOperand).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((BinaryOperator)(((GroupOperator)item).Operands[0])).LeftOperand).PropertyName);
                                else if (((GroupOperator)item).Operands[0] is FunctionOperator)
                                    ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[0])).Operands[0]).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[0])).Operands[0]).PropertyName);

                                if (((GroupOperator)item).Operands.Count > 1)
                                {
                                    if (((GroupOperator)item).Operands[1] is BinaryOperator)
                                        ((OperandProperty)((BinaryOperator)(((GroupOperator)item).Operands[1])).LeftOperand).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((BinaryOperator)(((GroupOperator)item).Operands[1])).LeftOperand).PropertyName);
                                    else if (((GroupOperator)item).Operands[1] is FunctionOperator)
                                        ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[1])).Operands[0]).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)((FunctionOperator)(((GroupOperator)item).Operands[1])).Operands[0]).PropertyName);
                                }
                            }
                            else if (item is CriteriaOperator) /*Keep this condition always at last*/
                                ((OperandProperty)(((FunctionOperator)item).Operands[0])).PropertyName = string.Format("{0}.{1}", entity.ToString(), ((OperandProperty)(((FunctionOperator)item).Operands[0])).PropertyName);
                        }

                        criteriaToUse.Add(criteria.Key, criteria.Value);

                        var updatedCriterias = CriteriaOperator.And(criteria.Value);
                        var sqlCondition = CriteriaToWhereClauseHelper.GetMsSqlWhere(updatedCriterias).Replace("\"", "");

                        var allConcatenatedColumns = new List<string>();
                        WebUtilities.ConcatenatedColumns().TryGetValue(oldPropertyName, out allConcatenatedColumns);

                        if ((allConcatenatedColumns == null) || (allConcatenatedColumns.Count == 0))
                        {
                            if ("(" + entity + ".StatusId = 0)" != sqlCondition)
                                whereCondition += string.Concat(" AND ", sqlCondition, " ");
                        }
                        else
                        {
                            var conditionToAssign = ((criteria.Value is UnaryOperator) && (((UnaryOperator)criteria.Value).OperatorType == UnaryOperatorType.Not)) ? " AND " : " OR ";
                            var updatedSqlCondition = " ( ";
                            for (int i = 0; i < allConcatenatedColumns.Count; i++)
                            {
                                updatedSqlCondition += sqlCondition.Replace(oldPropertyName, allConcatenatedColumns[i]);
                                if (i < (allConcatenatedColumns.Count - 1))
                                    updatedSqlCondition += conditionToAssign;
                            }
                            updatedSqlCondition += " ) ";
                            whereCondition += string.Concat(" AND ", updatedSqlCondition, " ");
                        }
                    }
                }
            }
            return whereCondition;
        }

        public static void BuildGridGroupByCondition(this PagedDataInfo pagedDataInfo, string fieldName, EntitiesAlias entity)
        {
            pagedDataInfo.GroupBy = null;
            pagedDataInfo.GroupBy += string.Format("{0}.{1} ", entity.ToString(), fieldName);
        }

        public static void BuildGridGroupByWhereCondition(this PagedDataInfo pagedDataInfo, IList<GridViewGroupInfo> groupInfoList, EntitiesAlias entity)
        {
            foreach (var singleItem in groupInfoList)
            {
                if (!string.IsNullOrWhiteSpace(Convert.ToString(singleItem.KeyValue)))
                    pagedDataInfo.GroupByWhereCondition += string.Format(" AND {0}.{1}='{2}' ", entity.ToString(), singleItem.FieldName, Convert.ToString(singleItem.KeyValue));
                else
                    pagedDataInfo.GroupByWhereCondition += string.Format(" AND {0}.{1} IS NULL ", entity.ToString(), singleItem.FieldName);
            }
        }

        public static void BuildGridGroupByOrderCondition(this PagedDataInfo pagedDataInfo, GridViewCustomBindingGetGroupingInfoArgs groupInfoArgs, EntitiesAlias entity)
        {
            pagedDataInfo.OrderBy = string.Format(" {0}.{1} {2}", entity.ToString(), groupInfoArgs.FieldName, groupInfoArgs.SortOrder == DevExpress.Data.ColumnSortOrder.Ascending ? "ASC" : "DESC");
        }

        public static string GetCriteriaOperatorValue(this CriteriaOperator criteriaOperator)
        {
            string currentValue = string.Empty;
            if (criteriaOperator is FunctionOperator)
            {
                var valueOperand = ((FunctionOperator)criteriaOperator).Operands[1];
                currentValue = Convert.ToString(((OperandValue)valueOperand).Value);
            }
            if (criteriaOperator is BinaryOperator)
            {
                var valueOperand = ((BinaryOperator)criteriaOperator).RightOperand;
                currentValue = Convert.ToString(((OperandValue)valueOperand).Value);
            }
            return currentValue;
        }

        public static void SetupOperationRoute(this Operation operation, MvcRoute currentRoute, string clickEvent = null)
        {
            operation.Route = currentRoute;
            operation.ClickEvent = (clickEvent != null) ? clickEvent : JsConstants.CloseDisplayMessage;
        }

        public static DateTime? GetDefaultDateWithTime(this DateTime? time)
        {
            if (time != null)
                return Convert.ToDateTime(WebApplicationConstants.DefaultDate + " " + time.Value.ToString("hh:mm:ss tt"));
            return time;
        }

        public static List<LeftMenu> GetNotAccessibleMenus(this List<LeftMenu> menus, UserSecurity security)
        {
            if (menus.FirstOrDefault(mnu => mnu.MnuModuleId == security.SecMainModuleId) != null)
                return menus.FirstOrDefault(mnu => mnu.MnuModuleId == security.SecMainModuleId).Children.Where(mnu => mnu.MnuModuleId == security.SecMainModuleId && mnu.MnuOptionLevelId > 0 && security.SecMenuOptionLevelId < mnu.MnuOptionLevelId).ToList();
            return new List<LeftMenu>();
        }

        public static List<RibbonMenu> GetNotAccessibleMenus(this List<RibbonMenu> menus, UserSecurity security)
        {
            var parent = menus.FirstOrDefault(mnu => mnu.MnuModuleId == security.SecMainModuleId);
            if (parent != null)
            {
                var notaccessibleChildren = menus.FirstOrDefault(mnu => mnu.MnuModuleId == security.SecMainModuleId).Children.Where(mnu => mnu.MnuModuleId == security.SecMainModuleId && mnu.MnuOptionLevelId > 0 && security.SecMenuOptionLevelId < mnu.MnuOptionLevelId).ToList();
                parent.Children.ToList().ForEach(chidMenu =>
                {
                    if (parent.Children.FirstOrDefault(childmnu => childmnu.MnuModuleId == security.SecMainModuleId) != null)
                    {
                        var deleteChildren = parent.Children.ToList().GetNotAccessibleMenus(security);
                        deleteChildren.ForEach(nmnu => parent.Children.FirstOrDefault(cmnu => cmnu.MnuModuleId == security.SecMainModuleId).Children.Remove(nmnu));
                    }
                    chidMenu.Children.ToList().RemoveAll(emptyChild => emptyChild.Children.Count == 0);
                });
                return notaccessibleChildren;
            }
            return new List<RibbonMenu>();
        }

        public static List<FormNavMenu> GetFormNavMenus(this MvcRoute route, byte[] entityIcon, Permission permission, string controlSuffix, Operation addOperation, Operation editOperation, SessionProvider currentSessionProvider, string closeClickEvent = null, string uploadNewDocMessage = null, string strDropdownViewModel = null)
        {
            var defaultFormNavMenu = new FormNavMenu
            {
                Action = MvcConstants.ActionPrevNext,
                Entity = route.Entity,
                Area = route.Area,
                RecordId = route.RecordId,
                ParentRecordId = route.ParentRecordId,
                Filters = route.Filters,
                IsPopup = route.IsPopup,
                EntityName = route.EntityName,
                Url = route.Url,
                OwnerCbPanel = route.OwnerCbPanel,
                ParentEntity = route.ParentEntity,
                IsNext = false,
                IsEnd = true,
                IconID = DevExpress.Web.ASPxThemes.IconID.ArrowsDoublefirst16x16gray,
                Align = 1,
                Enabled = true,
                SecondNav = false,
                IsChooseColumn = route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn),
            };

            if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionMapVendorCallback) || route.Action.EqualsOrdIgnoreCase("GatewayComplete"))
                route.RecordId = 0;

            var allNavMenus = new List<FormNavMenu>();

            var headerText = !string.IsNullOrWhiteSpace(route.EntityName) ? route.EntityName : route.Entity.ToString();

            if ((route.Entity == EntitiesAlias.JobGateway) && (route.Filters != null) && (route.Filters.FieldName != "ToggleFilter") && (route.Action != "FormView"))
            {
                string result = "";
                if (route.Filters.Value != null && route.Filters.Value.Contains("-"))
                    result = route.Filters.Value.Substring(0, route.Filters.Value.LastIndexOf('-'));
                else
                    result = route.Filters.Value;
                headerText = string.Format("{0} : {1}", route.Filters.FieldName, result);
                route.ParentRecordId = route.RecordId;
                route.RecordId = 0;
            }
            else if (route.RecordId > 0
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn))
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy))
                && (route.Entity != EntitiesAlias.JobGateway)
                && (route.Entity != EntitiesAlias.JobXcblInfo)
                && (route.Entity != EntitiesAlias.JobHistory)
                && (route.Entity != EntitiesAlias.PrgRefGatewayDefault)
               )
                headerText = string.Format("{0} {1}", editOperation.LangName.Replace(string.Format(" {0}", EntitiesAlias.Contact.ToString()), ""), headerText);

            if (route.RecordId > 0
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn))
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionContactCardForm))
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionGetOpenDialog))
                && (!route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy))
                && (route.Entity != EntitiesAlias.JobGateway)
                && (route.Entity != EntitiesAlias.JobXcblInfo)
                && (route.Entity != EntitiesAlias.JobHistory)
                && (route.Entity != EntitiesAlias.PrgRefGatewayDefault)
                && (route.Entity != EntitiesAlias.NavRate && route.Action != MvcConstants.ActionForm)
                && (route.Entity != EntitiesAlias.Gateway && route.Action != MvcConstants.ActionForm)
                && (route.Entity != EntitiesAlias.VendorProfile && route.Action != MvcConstants.ActionForm)
                && (route.Entity != EntitiesAlias.JobAdvanceReport && route.Action != MvcConstants.ActionForm)
                && (route.Entity != EntitiesAlias.NavRemittance && route.Action != MvcConstants.ActionForm))
            {
                var navMenuEnabled = true;
                if ((currentSessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) && currentSessionProvider.ViewPagedDataSession[route.Entity] != null) && (currentSessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null))
                {
                    if (!route.IsPopup)
                        navMenuEnabled = ((currentSessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount > 1) || ((currentSessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount == 1) && ((route.PreviousRecordId != null) && (route.PreviousRecordId == 0))));
                    else
                        navMenuEnabled = (currentSessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.TotalCount > 1);
                }

                defaultFormNavMenu.Enabled = navMenuEnabled;
                allNavMenus = new List<FormNavMenu> {
                           defaultFormNavMenu,
                           new FormNavMenu ( defaultFormNavMenu, false, false, DevExpress.Web.ASPxThemes.IconID.ArrowsDoubleprev16x16gray, 1, enabled:navMenuEnabled),
                           new FormNavMenu ( defaultFormNavMenu, true, false, DevExpress.Web.ASPxThemes.IconID.ArrowsDoublenext16x16gray,2, enabled:navMenuEnabled),
                           new FormNavMenu ( defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ArrowsDoublelast16x16gray,2, enabled:navMenuEnabled),
                           new FormNavMenu ( defaultFormNavMenu, true, true, WebExtension.ConvertByteToString(entityIcon), 1, headerText, enabled:false, isEntityIcon:true),
                            };
            }
            else
            {
                allNavMenus = new List<FormNavMenu> {
                          new FormNavMenu ( defaultFormNavMenu, true, true, WebExtension.ConvertByteToString(entityIcon), 1, headerText, enabled:false, isEntityIcon:true),
                           };
            }

            if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionGetOpenDialog))
            {
                allNavMenus[0].Action = MvcConstants.ActionGetOpenDialog;
                allNavMenus[0].Text = (!string.IsNullOrWhiteSpace(uploadNewDocMessage)) ? uploadNewDocMessage : "Upload New Document";
            }

            if (route.IsPopup || route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn) || route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy))
            {
                if ((route.Entity == EntitiesAlias.PrgVendLocation || route.Entity == EntitiesAlias.PrgBillableLocation
                        || route.Entity == EntitiesAlias.PrgCostLocation)
                    && route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionMapVendorCallback))
                    closeClickEvent = string.Format(JsConstants.MapVendorCloseEvent, route.OwnerCbPanel);
                if ((route.Entity == EntitiesAlias.Program) && route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy))
                    closeClickEvent = string.Format(JsConstants.ProgramCopyCloseEvent, route.OwnerCbPanel);
                if ((route.Entity == EntitiesAlias.Job && route.Action == "ImportOrder") || route.Entity == EntitiesAlias.NavRemittance)
                    closeClickEvent = string.Format(JsConstants.RecordPopupCancelClick);

                allNavMenus.Add(new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsClose16x16, 2, secondNav: true, itemClick: (!string.IsNullOrWhiteSpace(closeClickEvent)) ? closeClickEvent : JsConstants.RecordPopupCancelClick));

                var saveMenu = new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsSave16x16devav, 2, secondNav: true, itemClick: string.Format(JsConstants.RecordPopupSubmitClick, string.Concat(route.Controller, "Form"), controlSuffix, JsonConvert.SerializeObject(route), false, strDropdownViewModel), cssClass: WebApplicationConstants.SaveButtonCssClass);//This is the standard FormName using in FormResult

                if (route.Action.EqualsOrdIgnoreCase("GatewayComplete"))
                {
                    var ctrlSuffix = WebApplicationConstants.PopupSuffix + route.Action.ToString();
                    saveMenu = new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsSave16x16devav, 2, secondNav: true, itemClick: string.Format(JsConstants.JobGatewayCompleteRecordPopupSubmitClick, string.Concat(route.Action, route.Controller, "Form"), ctrlSuffix, JsonConvert.SerializeObject(route), false), cssClass: WebApplicationConstants.SaveButtonCssClass);
                }

                if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy) && route.Entity == EntitiesAlias.PrgEdiHeader)
                {
                    var ctrlSuffix = WebApplicationConstants.PopupSuffix + route.Action.ToString();
                    saveMenu = new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsSave16x16devav,
                        2, secondNav: true, itemClick: string.Format(JsConstants.CopyPasteProgram, route.RecordId,
                        route.Controller + "ProgramCopySource", route.Controller + "ProgramCopyDestination"),
                        cssClass: WebApplicationConstants.SaveButtonCssClass);//This is the standard FormName using in FormResult
                }

                if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionCopy) && route.Entity == EntitiesAlias.Program)
                {
                    var ctrlSuffix = WebApplicationConstants.PopupSuffix + route.Action.ToString();
                    saveMenu = new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsSave16x16devav,
                        2, secondNav: true, itemClick: string.Format(JsConstants.CopyProgramModel, route.RecordId,
                        route.Controller + "ProgramCopySource", route.Controller + "ProgramCopyDestination"),
                        cssClass: WebApplicationConstants.SaveButtonCssClass);//This is the standard FormName using in FormResult
                }

                if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn))
                {
                    if (route.Entity == EntitiesAlias.SecurityByRole || route.Entity == EntitiesAlias.SubSecurityByRole
                        || route.Entity == EntitiesAlias.PrgMvocRefQuestion || route.Entity == EntitiesAlias.CustDcLocationContact
                        || route.Entity == EntitiesAlias.VendDcLocationContact || route.Entity == EntitiesAlias.PrgBillableRate || route.Entity == EntitiesAlias.PrgCostRate)
                    {
                        if (string.IsNullOrEmpty(route.Url))
                        {
                            var currentRoute = route;
                            saveMenu.ItemClick = string.Format(JsConstants.ChooseColumnSubmitClick, WebApplicationConstants.ChooseColumnFormId, JsonConvert.SerializeObject(currentRoute), currentRoute.OwnerCbPanel, MvcConstants.ActionDataView);
                        }
                        else
                        {
                            var callbackRoute = JsonConvert.DeserializeObject<MvcRoute>(route.Url);
                            callbackRoute.RecordId = route.ParentRecordId;
                            saveMenu.ItemClick = string.Format(JsConstants.ChooseColumnSubmitClick, WebApplicationConstants.ChooseColumnFormId, JsonConvert.SerializeObject(callbackRoute), route.OwnerCbPanel, MvcConstants.ActionDataView);
                        }
                    }
                    else
                    {
                        var defaultRoute = route;
                        saveMenu.ItemClick = string.Format(JsConstants.ChooseColumnSubmitClick, WebApplicationConstants.ChooseColumnFormId, JsonConvert.SerializeObject(defaultRoute), defaultRoute.OwnerCbPanel, MvcConstants.ActionDataView);
                    }
                }
                if (!(permission < Permission.EditActuals)
                    && !route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionMapVendorCallback)
                    && route.Action != "ImportOrder")
                    allNavMenus.Add(saveMenu);

                if (allNavMenus != null && !allNavMenus.Any(x => x.IconID == "actions_save_16x16devav") && route.Action.EqualsOrdIgnoreCase("GatewayActionFormView"))
                {
                    allNavMenus.Add(saveMenu);
                }

                if (currentSessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                    && !route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn)
                    && currentSessionProvider.ViewPagedDataSession[route.Entity].IsActionPanel
                    && route.IsEdit
                    && route.Entity == EntitiesAlias.JobGateway
                    && (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanel"
                    || (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayAll1AllCbPanel"))
                    )
                {
                    allNavMenus.Remove(saveMenu);
                }
                if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionContactCardForm) && !(permission < Permission.AddEdit))
                {
                    allNavMenus.Add(new FormNavMenu(defaultFormNavMenu, true, true, DevExpress.Web.ASPxThemes.IconID.ActionsAddfile16x16office2013, 2, secondNav: true, itemClick: string.Format(JsConstants.RecordPopupSubmitClick, string.Concat(route.Controller, "Form"), controlSuffix, JsonConvert.SerializeObject(route), true, strDropdownViewModel)));
                }

                if ((route.Entity == EntitiesAlias.JobXcblInfo && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.JobHistory && route.Action == MvcConstants.ActionDataView)
                    || (route.Entity == EntitiesAlias.NavRate && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.Gateway && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.VendorProfile && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.JobAdvanceReport && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.NavRemittance && route.Action == MvcConstants.ActionForm)
                    || (route.Entity == EntitiesAlias.JobGateway && (route.Action == "AddMultiAction" || route.Action == "AddMultiGateway")))
                    allNavMenus.Remove(saveMenu);
            }

            if (currentSessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && !route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionChooseColumn))
            {
                if ((route.Entity == EntitiesAlias.JobGateway) && (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayLog4LogCbPanel") && allNavMenus.LongCount() > 0)
                {
                    allNavMenus[0].Text = "Job Comment";
                }
                if ((currentSessionProvider.ViewPagedDataSession[route.Entity].IsCommentPanel)
                    && (route.Entity == EntitiesAlias.JobGateway)
                    && (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayLog4LogCbPanel" || (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayAll1AllCbPanel")))
                {
                    currentSessionProvider.ViewPagedDataSession[route.Entity].IsCommentPanel = false;
                    allNavMenus[0].Text = "Edit Comment";
                }
                if ((currentSessionProvider.ViewPagedDataSession[route.Entity].IsGatewayEditPanel) && (route.Entity == EntitiesAlias.JobGateway))
                {
                    currentSessionProvider.ViewPagedDataSession[route.Entity].IsGatewayEditPanel = false;
                    allNavMenus[0].Text = "Edit Job Gateway";
                }
                if ((currentSessionProvider.ViewPagedDataSession[route.Entity].IsGatewayPanel)
                    && (route.Entity == EntitiesAlias.JobGateway))
                {
                    currentSessionProvider.ViewPagedDataSession[route.Entity].IsGatewayPanel = false;
                    allNavMenus[0].Text = "Job Gateway";
                }
                if ((currentSessionProvider.ViewPagedDataSession[route.Entity].IsActionPanel)
                              && (route.Entity == EntitiesAlias.JobGateway)
                              && (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayActions3ActionsCbPanel"
                              || (route.OwnerCbPanel == "JobGatewayJobGatewayJobGatewayAll1AllCbPanel")))
                {
                    currentSessionProvider.ViewPagedDataSession[route.Entity].IsActionPanel = false;
                    allNavMenus[0].Text = currentSessionProvider.ViewPagedDataSession[route.Entity].ActionTitle;
                }
                foreach (var item in allNavMenus)
                {
                    item.MaxID = currentSessionProvider.ViewPagedDataSession[route.Entity].MaxID;
                    item.MinID = currentSessionProvider.ViewPagedDataSession[route.Entity].MinID;
                }
            }

            if (route.Entity == EntitiesAlias.JobGateway && route.Action == "GatewayActionFormView")
            {
                if (route.Filters != null && !string.IsNullOrEmpty(route.Filters.Value))
                {
                    if (route.Filters.Value.Contains("-"))
                        allNavMenus[0].Text = route.Filters.Value.Substring(0, route.Filters.Value.LastIndexOf('-'));
                    else
                        allNavMenus[0].Text = route.Filters.Value;
                }
            }

            if (!route.IsEdit && route.Entity == EntitiesAlias.JobGateway && route.Action == "FormView" && route.Filters != null)
            {
                allNavMenus[0].Text = "Job Gateway";
            }

            if (route.Entity == EntitiesAlias.Job && route.Action == "ImportOrder")
            {
                allNavMenus[0].Text = "Import Order";
            }

            if (route.Entity == EntitiesAlias.NavRate && route.Action == "FormView")
            {
                var appendText = string.Empty;
                if (route.Location != null && route.Location.Count == 1)
                    appendText = route.Location[0];
                allNavMenus[0].Text = string.IsNullOrEmpty(appendText) ? "Import Template" : "Import " + appendText;
            }

            if (route.Entity == EntitiesAlias.Gateway && route.Action == "FormView")
            {
                allNavMenus[0].Text = "Import Gateway/Action";
            }

            if (route.Entity == EntitiesAlias.VendorProfile && route.Action == "FormView")
            {
                allNavMenus[0].Text = "Import Vendor Profile";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocumentDataView1AllCbPanel")
            {
                allNavMenus[0].Text = "All Job Document";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocApprovalsDataView2ApprovalsCbPanel")
            {
                allNavMenus[0].Text = "Approvals";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocDamagedDataView3DamagedCbPanel")
            {
                allNavMenus[0].Text = "Damaged";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocImageDataView5ImageCbPanel")
            {
                allNavMenus[0].Text = "Image";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocDeliveryPodDataView6PODCbPanel")
            {
                allNavMenus[0].Text = "Proof Of Delivery";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocSignatureDataView7SignatureCbPanel")
            {
                allNavMenus[0].Text = "Signature";
            }

            if (route.Entity == EntitiesAlias.JobDocReference && route.OwnerCbPanel == "JobDocReferenceJobDocReferenceDocDocumentDataView4DocumentCbPanel")
            {
                allNavMenus[0].Text = "Document";
            }
            if (route.Entity == EntitiesAlias.NavRemittance)
            {
                allNavMenus[0].Text = "Retrieve Posted Invoice";
            }

            if (route.Entity == EntitiesAlias.JobAdvanceReport && route.Action == "FormView")
            {
                allNavMenus[0].Text = (route.ParentRecordId == 3316 || route.Location.FirstOrDefault() == "Driver Scrub Report") ? "Import Scrub Driver Details"
                     : ((route.ParentRecordId == 3318 || route.Location.FirstOrDefault() == "Capacity Report") ? "Import Projected Capacity" : "Import report");
            }
            if (route.Entity == EntitiesAlias.JobGateway && route.Action == "AddMultiAction")
            {
                allNavMenus[0].Text = "Action";
            }
            return allNavMenus;
        }

        public static DateTime? SubstractFrom(this DateTime? date, double duration, JobGatewayUnit gatewayUnit)
        {
            if (!date.HasValue)
                return date;

            switch (gatewayUnit)
            {
                case JobGatewayUnit.Hours:
                    date = date.Value.AddHours(duration);
                    break;

                case JobGatewayUnit.Days:
                    date = date.Value.AddDays(duration);
                    break;

                case JobGatewayUnit.Weeks:
                    date = date.Value.AddHours(duration);
                    break;

                case JobGatewayUnit.Months:
                    date = date.Value.AddHours(duration);
                    break;
            }

            return date;
        }

        public static PagedDataInfo GetPageDataInfoWithNav(this PagedDataInfo pagedDataInfo, FormNavMenu formNavMenu)
        {
            return pagedDataInfo = new PagedDataInfo
            {
                RecordId = formNavMenu.RecordId,
                ParentId = formNavMenu.ParentRecordId,
                IsNext = formNavMenu.IsNext,
                IsEnd = formNavMenu.IsEnd,
                PageId = pagedDataInfo.PageId,
                PageSize = pagedDataInfo.PageSize,
                PageNumber = pagedDataInfo.PageNumber,
                AvailablePageSizes = pagedDataInfo.AvailablePageSizes,
                Entity = pagedDataInfo.Entity,
                Contains = pagedDataInfo.Contains,
                WhereCondition = pagedDataInfo.WhereCondition,
                TableFields = pagedDataInfo.TableFields,
                OrderBy = pagedDataInfo.OrderBy,
                TotalCount = pagedDataInfo.TotalCount
            };
        }

        public static void RibbonRoute(this RibbonMenu ribbonMenu, MvcRoute route, int index, MvcRoute baseRoute, ICommonCommands commonCommands, SessionProvider sessionProvider)
        {
            ribbonMenu.Children.ToList().ForEach(mnu =>
            {
                mnu.StatusId = 1;

                if (string.IsNullOrEmpty(mnu.MnuTableName) && mnu.MnuModuleId == 0 && index == 0) // File Ribbon
                {
                    mnu.Route = new MvcRoute
                    {
                        Entity = baseRoute.Entity,
                        Action = mnu.MnuExecuteProgram,
                        Area = baseRoute.Area,
                        RecordId = route.RecordId,
                        ParentRecordId = route.ParentRecordId,
                        ParentEntity = route.ParentEntity,
                        CompanyId = route.CompanyId,
                        OwnerCbPanel = route.OwnerCbPanel,
                        EntityName = baseRoute.Entity == EntitiesAlias.Common ? baseRoute.Entity.ToString()
                        : commonCommands.Tables[baseRoute.Entity].TblLangName,
                        IsJobParentEntityUpdated = route.IsJobParentEntityUpdated,
                    };

                    if (mnu.MnuTitle == "Records" && mnu.Children.Any() &&
                       mnu.Route != null && mnu.Route.Area == "Job"
                       && (mnu.Route.Controller == "Job" || mnu.Route.Entity == EntitiesAlias.JobAdvanceReport || mnu.Route.Entity == EntitiesAlias.JobCard))
                    {
                        if (mnu.Children != null && mnu.Children.Any(obj => obj.Route != null && obj.Route.Action != null && obj.Route.Action.ToLower() == "save"))
                        {
                            var jobroute = mnu.Children.Where(obj => obj.Route.Action.ToLower() == "save").FirstOrDefault().Route;
                            jobroute.Action = "OnAddOrEdit";
                            jobroute.Entity = EntitiesAlias.Job;
                            jobroute.EntityName = "Job";
                            jobroute.Url = "Job/Job/Save";
                            mnu.Children.Where(obj => obj.Route.Action == "OnAddOrEdit").FirstOrDefault().StatusId = 1;
                        }
                    }

                    if (!string.IsNullOrEmpty(mnu.MnuExecuteProgram))
                    {
                        mnu.Route.IsPopup = mnu.MnuExecuteProgram.Equals(MvcConstants.ActionChooseColumn);

                        if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionReport)
                        || route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionDashboard)
                        || route.Entity == EntitiesAlias.Report
                        || route.Entity == EntitiesAlias.AppDashboard ||
                        (mnu.MnuTitle == "New" && route.Action == MvcConstants.ActionForm && route.Entity == EntitiesAlias.Job))
                        {
                            mnu.StatusId = 3;
                            if (route.OwnerCbPanel == "RibbonCbPanel" && route.ParentEntity == EntitiesAlias.Program)
                                mnu.StatusId = 1;
                            if ((mnu.MnuExecuteProgram.EqualsOrdIgnoreCase(MvcConstants.ActionForm) || mnu.MnuExecuteProgram.EqualsOrdIgnoreCase(MvcConstants.ActionPasteForm))
                            && route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionDataView) &&
                            route.Area.EqualsOrdIgnoreCase("Administration") ||
                            ((mnu.MnuTitle == "Save" || mnu.MnuTitle == "Refresh All") &&
                            route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionReport) &&
                            sessionProvider.ActiveUser.LastRoute.Action == "Report" &&
                            (sessionProvider.ActiveUser.LastRoute.Entity == EntitiesAlias.JobCard) &&
                            (sessionProvider.ActiveUser.CurrentRoute != null &&
                            (sessionProvider.ActiveUser.CurrentRoute.Action == MvcConstants.ActionForm &&
                            sessionProvider.ActiveUser.CurrentRoute.Entity == EntitiesAlias.Job))))
                                mnu.StatusId = 1;
                            if ((route.Entity == EntitiesAlias.AppDashboard) && mnu.MnuExecuteProgram.EqualsOrdIgnoreCase(MvcConstants.ActionForm))
                                mnu.Route.Action = MvcConstants.ActionDashboard;
                        }
                        else if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionTreeView))
                        {
                            mnu.StatusId = route.Entity == EntitiesAlias.Job
                            && sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                            //&& !sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity
                            && (mnu.MnuTitle == "Save" || mnu.MnuTitle == "New" || mnu.MnuTitle == "Form View") ? 1 : 3;
                            if (route.Entity == EntitiesAlias.Program || route.Entity == EntitiesAlias.Job
                            || route.Entity == EntitiesAlias.PrgEdiHeader)
                            {
                                switch (mnu.MnuExecuteProgram)
                                {
                                    case MvcConstants.ActionRefreshAll:
                                    case MvcConstants.ActionReplace:
                                        mnu.StatusId = 1;

                                        break;

                                    case MvcConstants.ActionCreate:
                                    case MvcConstants.ActionCopy:

                                        break;

                                    default:
                                        break;
                                }
                            }
                        }
                        else
                        {
                            switch (mnu.MnuExecuteProgram)
                            {
                                case MvcConstants.ActionForm:
                                case MvcConstants.ActionPasteForm:
                                case MvcConstants.ActionDelete:
                                case MvcConstants.ActionClearFilter:
                                case MvcConstants.ActionSortAsc:
                                case MvcConstants.ActionSortDesc:
                                case MvcConstants.ActionRemoveSort:
                                case MvcConstants.ActionAdvancedSortFilter:
                                case MvcConstants.ActionToggleFilter:
                                case MvcConstants.ActionFind:
                                case MvcConstants.ActionReplace:
                                case MvcConstants.ActionGoToRecord:
                                case MvcConstants.ActionSelect:
                                case MvcConstants.ActionExportExcel:
                                case MvcConstants.ActionExportEmail:
                                case MvcConstants.ActionExportPdf:
                                    if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionForm) || route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionPasteForm))
                                        mnu.StatusId = 3;
                                    if (mnu.MnuExecuteProgram.EqualsOrdIgnoreCase(MvcConstants.ActionForm) || mnu.MnuExecuteProgram.EqualsOrdIgnoreCase(MvcConstants.ActionPasteForm))
                                        mnu.Route.RecordId = 0;
                                    break;

                                case MvcConstants.ActionDataView:
                                    if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionDataView))
                                    {
                                        mnu.StatusId = 3;
                                        mnu.Route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
                                    }
                                    break;

                                case MvcConstants.ActionChooseColumn:
                                    mnu.Route.IsPopup = false; //given false here because this choose column will always be used for main data view not for tabbed data view
                                    if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionTreeView) && route.Entity == EntitiesAlias.Program)
                                        mnu.StatusId = 3;
                                    if (route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionForm) || route.Action.EqualsOrdIgnoreCase(MvcConstants.ActionPasteForm))
                                        mnu.StatusId = 3;
                                    break;

                                case MvcConstants.ActionCreate:
                                    if (route.Entity == EntitiesAlias.OrgRolesResp)
                                        mnu.StatusId = 3;
                                    break;
                            }
                        }
                    }

                    //Special case for 'StatusLog' Table
                    if (route.Entity == EntitiesAlias.StatusLog && !string.IsNullOrWhiteSpace(mnu.MnuExecuteProgram) && mnu.MnuExecuteProgram != MvcConstants.ActionChooseColumn)
                        mnu.StatusId = 3;

                    //Special case for 'Ref role' because In Ref role tab we cannot create new record
                    if (route.Entity == EntitiesAlias.OrgRolesResp
                    && !string.IsNullOrWhiteSpace(mnu.MnuExecuteProgram)
                    && ((mnu.MnuExecuteProgram == MvcConstants.ActionForm) || (mnu.MnuExecuteProgram == MvcConstants.ActionPasteForm))
                    && (sessionProvider.ViewPagedDataSession[EntitiesAlias.OrgRolesResp] != null)
                    && (sessionProvider.ViewPagedDataSession[EntitiesAlias.OrgRolesResp].PagedDataInfo != null)
                    && (sessionProvider.ViewPagedDataSession[EntitiesAlias.OrgRolesResp].PagedDataInfo.TotalCount == 0))
                        mnu.StatusId = 3;
                    else if ((route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.Program || route.Entity == EntitiesAlias.Customer ||
                    route.Entity == EntitiesAlias.Vendor || route.Entity == EntitiesAlias.Contact) && (mnu.MnuTitle == "Save" || mnu.MnuTitle == "New"))
                    {
                        //mnu.Route.IsDataView = route.IsDataView;
                        var currentSecurity = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == commonCommands.Tables[route.Entity].TblMainModuleId);
                        if (!sessionProvider.ActiveUser.IsSysAdmin && (currentSecurity == null || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.ReadOnly
                        || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals))
                        {

                            if (mnu.MnuTitle == "Save" && route.Action == "FormView" && route.Entity == EntitiesAlias.Job)
                                mnu.StatusId = 3;
                            else if (mnu.MnuTitle == "Save" && route.Action == "FormView")
                                mnu.StatusId = 1;
                            else if (mnu.MnuTitle == "Save" && route.Action == "TreeView" && route.Entity == EntitiesAlias.Program)
                                mnu.StatusId = 1;
                            else if (mnu.MnuTitle == "Save" && route.Action == "TreeView" && route.Entity == EntitiesAlias.Job && route.RecordId > 0 && route.ParentRecordId > 0)
                                mnu.StatusId = 1;
                            else
                                mnu.StatusId = 3;
                        }
                        if ((currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.All))
                        {

                            if (mnu.MnuTitle == "New" && (route.Action == "TreeView" || route.IsJobParentEntityUpdated))
                            {
                                mnu.StatusId = 3;
                            }
                            else mnu.StatusId = 1;
                        }
                    }
                }
                else
                {
                    mnu.Route = new MvcRoute
                    {
                        Entity = !string.IsNullOrEmpty(mnu.MnuTableName) ? mnu.MnuTableName.ToEnum<EntitiesAlias>() : EntitiesAlias.Common,
                        Action = mnu.MnuExecuteProgram,
                        Area = !string.IsNullOrEmpty(mnu.MnuTableName) && commonCommands.Tables.ContainsKey(mnu.MnuTableName.ToEnum<EntitiesAlias>()) ? commonCommands.Tables[mnu.MnuTableName.ToEnum<EntitiesAlias>()].MainModuleName : string.Empty,
                        EntityName = !string.IsNullOrEmpty(mnu.MnuTableName) && commonCommands.Tables.ContainsKey(mnu.MnuTableName.ToEnum<EntitiesAlias>()) ? commonCommands.Tables[mnu.MnuTableName.ToEnum<EntitiesAlias>()].TblLangName : mnu.MnuTitle,
                    };
                }

                string cointainResult = "File,Form View,Grid View,Paste,Cut,Copy,Clear Filter,Ascending,Descending,Remove Sort,Choose Columns,Advanced,Toggle Filter,Refresh All,New,Save,Find,Replace,Go To,Select,Create Excel,Create Email,Create PDF,Alias Columns,System Settings,Change Session,Themes,Notepad,Calculator,Download Executor,Paste Record";
                if (route.Controller == EntitiesAlias.JobCard.ToString()
                && route.Action == "DataView"
                && cointainResult.Contains(mnu.MnuTitle.ToString()))
                {
                    mnu.StatusId = 3;
                }

                if (mnu.MnuTitle == "Create/Update Order in NAV")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job && route.RecordId > 0)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "Import Template" || mnu.MnuTitle == "Gateway/Action")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Program && route.RecordId > 0)
                    {
                        mnu.Route.RecordId = route.RecordId;
                        mnu.StatusId = 1;
                        mnu.Route.IsPopup = true;
                    }
                }

                if (mnu.MnuTitle == "Vendor Profile")
                {
                    mnu.StatusId = 3;
                    if (sessionProvider.ActiveUser.IsSysAdmin)
                    {
                        mnu.Route.RecordId = route.RecordId;
                        mnu.StatusId = 1;
                        mnu.Route.IsPopup = true;
                    }
                }

                if (mnu.MnuTitle == "Download All")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "Data Grid")
                {
                    mnu.StatusId = 3;
                    if ((route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    && route.RecordId > 0 && route.Action != "DataView")
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "BOL")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "POD")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "Tracking" && mnu.MnuExecuteProgram != "TrackingOrder")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "Job History")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        mnu.StatusId = 1;
                    }
                }

                if (mnu.MnuTitle == "Est.Price Code")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        if (sessionProvider.UserSecurities != null)
                        {
                            var currentSecurity = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == commonCommands.Tables[route.Entity].TblMainModuleId);
                            UserSubSecurity childSecurity = null;
                            if (currentSecurity.UserSubSecurities != null)
                                childSecurity = currentSecurity.UserSubSecurities.Any(obj => obj.RefTableName == EntitiesAlias.JobBillableSheet.ToString()) ? currentSecurity.UserSubSecurities.Where(obj => obj.RefTableName == EntitiesAlias.JobBillableSheet.ToString()).FirstOrDefault() : null;
                            if (sessionProvider.ActiveUser.IsSysAdmin || (currentSecurity != null
                          || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.All) &&
                             ((currentSecurity.UserSubSecurities == null && childSecurity == null) ||
                             (currentSecurity.UserSubSecurities != null && currentSecurity.UserSubSecurities.Count() == 0 && childSecurity == null) ||
                             (childSecurity != null && (childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.All ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit)
                             )))
                            {
                                mnu.StatusId = 1;
                            }
                        }
                    }
                }
                if (mnu.MnuTitle == "Price Charges")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        if (sessionProvider.UserSecurities != null)
                        {
                            var currentSecurity = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == commonCommands.Tables[route.Entity].TblMainModuleId);
                            UserSubSecurity childSecurity = null;
                            if (currentSecurity.UserSubSecurities != null)
                                childSecurity = currentSecurity.UserSubSecurities.Any(obj => obj.RefTableName == EntitiesAlias.JobBillableSheet.ToString()) ? currentSecurity.UserSubSecurities.Where(obj => obj.RefTableName == EntitiesAlias.JobBillableSheet.ToString()).FirstOrDefault() : null;
                            if (sessionProvider.ActiveUser.IsSysAdmin || (currentSecurity != null
                          || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.All) &&
                             ((currentSecurity.UserSubSecurities == null && childSecurity == null) ||
                             (currentSecurity.UserSubSecurities != null && currentSecurity.UserSubSecurities.Count() == 0 && childSecurity == null) ||
                             (childSecurity != null && (childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.All ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit)
                             )))
                            {
                                mnu.StatusId = 1;
                                if (route.Action == "FormView")
                                {
                                    mnu.Route.RecordId = route.RecordId;
                                }
                            }
                        }
                    }
                }

                if (mnu.MnuTitle == "Cost Charges")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        if (sessionProvider.UserSecurities != null)
                        {
                            var currentSecurity = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == commonCommands.Tables[route.Entity].TblMainModuleId);
                            UserSubSecurity childSecurity = null;
                            if (currentSecurity.UserSubSecurities != null)
                                childSecurity = currentSecurity.UserSubSecurities.Any(obj => obj.RefTableName == EntitiesAlias.JobCostSheet.ToString()) ? currentSecurity.UserSubSecurities.Where(obj => obj.RefTableName == EntitiesAlias.JobCostSheet.ToString()).FirstOrDefault() : null;
                            if (sessionProvider.ActiveUser.IsSysAdmin || (currentSecurity != null
                          || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit ||
                             currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.All) &&
                             ((currentSecurity.UserSubSecurities == null && childSecurity == null) ||
                             (currentSecurity.UserSubSecurities != null && currentSecurity.UserSubSecurities.Count() == 0 && childSecurity == null) ||
                             (childSecurity != null && (childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.All ||
                             childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit)
                             )))
                            {
                                mnu.StatusId = 1;
                                if (route.Action == "FormView")
                                {
                                    mnu.Route.RecordId = route.RecordId;
                                }
                            }
                        }
                    }
                }
                if (mnu.MnuTitle == "Est.Cost Code")
                {
                    mnu.StatusId = 3;
                    if (route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard || route.Entity == EntitiesAlias.JobAdvanceReport)
                    {
                        if (sessionProvider.UserSecurities != null)
                        {
                            var currentSecurity = sessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == commonCommands.Tables[route.Entity].TblMainModuleId);
                            UserSubSecurity childSecurity = null;
                            if (currentSecurity.UserSubSecurities != null)
                                childSecurity = currentSecurity.UserSubSecurities.Any(obj => obj.RefTableName == EntitiesAlias.JobCostSheet.ToString()) ? currentSecurity.UserSubSecurities.Where(obj => obj.RefTableName == EntitiesAlias.JobCostSheet.ToString()).FirstOrDefault() : null;
                            if (sessionProvider.ActiveUser.IsSysAdmin || (currentSecurity != null
                            || currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                               currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                               currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit ||
                               currentSecurity.SecMenuAccessLevelId.ToEnum<Permission>() == Permission.All) &&
                               ((currentSecurity.UserSubSecurities == null && childSecurity == null) ||
                               (currentSecurity.UserSubSecurities != null && currentSecurity.UserSubSecurities.Count() == 0 && childSecurity == null) ||
                               (childSecurity != null && (childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditAll ||
                               childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.EditActuals ||
                               childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.AddEdit ||
                               childSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.All)
                               )))
                            {
                                mnu.StatusId = 1;
                            }
                        }
                    }
                }

                if (route.Entity == EntitiesAlias.Job
                && (sessionProvider.ViewPagedDataSession.Count() > 0
                && sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && (sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobCardEntity
                || sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity))
                && route.Action == "FormView" && mnu.MnuTitle == "New")
                    mnu.StatusId = 3;
                if ((route.Entity == EntitiesAlias.JobCard
                    || route.Entity == EntitiesAlias.JobAdvanceReport
                    || route.Entity == EntitiesAlias.Organization)
                    && mnu.MnuTitle == "New")
                    mnu.StatusId = 3;
                if (route.Entity == EntitiesAlias.JobReport)
                    mnu.StatusId = 3;
                if ((route.Entity == EntitiesAlias.JobAdvanceReport || route.Entity == EntitiesAlias.JobCard || (route.Entity == EntitiesAlias.Job && route.Action == MvcConstants.ActionDataView))
                && (mnu.MnuTitle == "Copy" || mnu.MnuTitle == "Paste"))
                    mnu.StatusId = 1;
                if ((route.Entity == EntitiesAlias.JobAdvanceReport || (route.Entity == EntitiesAlias.Job && route.Action == MvcConstants.ActionDataView))
               && (mnu.MnuTitle == "Advanced"))
                    mnu.StatusId = 1;
                if (mnu.Children.Count > 0)
                    RibbonRoute(mnu, route, index, baseRoute, commonCommands, sessionProvider);

                if (route.ParentEntity == EntitiesAlias.Common
                && (route.Entity == EntitiesAlias.JobCard
                    || route.Entity == EntitiesAlias.JobAdvanceReport
                    || route.Entity == EntitiesAlias.Job) && route.Action == MvcConstants.ActionForm && mnu.MnuTitle == "New")
                    mnu.StatusId = 3;
                if (mnu.MnuTitle == "Retrieve Invoices")
                {
                    mnu.StatusId = 3;
                    if (sessionProvider != null && sessionProvider.ActiveUser != null)
                    {
                        if (sessionProvider.ActiveUser.IsSysAdmin
                        || (sessionProvider.ActiveUser.ConTypeId == (int)ContactType.Vendor)
                        || (sessionProvider.ActiveUser.ConTypeId == (int)ContactType.Employee))
                        {
                            mnu.StatusId = 1;
                        }
                    }
                }
                if ((route.Entity == EntitiesAlias.JobCard
                    || route.Entity == EntitiesAlias.JobAdvanceReport
                    || route.Entity == EntitiesAlias.Job) && mnu.MnuTitle == "Tracking")
                    mnu.StatusId = 1;
            });
        }

        public static int GetTabExecuteProgramIndex(this MvcRoute route, SessionProvider currentSessionProvider, ICommonCommands _commonCommands, MainModule currentModule, string tabExecuteProgram)
        {
            var pageControlResult = route.GetPageControlResult(currentSessionProvider, _commonCommands, currentModule);
            var tabIndex = -1;

            if (pageControlResult.PageInfos.Count > 0)
            {
                for (int i = 0; i < pageControlResult.PageInfos.Count; i++)
                {
                    if (pageControlResult.PageInfos[i].TabExecuteProgram == tabExecuteProgram)
                        tabIndex = i;
                }
            }
            return tabIndex;
        }

        public static PageControlResult GetPageControlResult(this MvcRoute route, SessionProvider currentSessionProvider, ICommonCommands _commonCommands, MainModule currentModule)
        {
            route.Entity = route.Entity == EntitiesAlias.JobCard ? EntitiesAlias.Job : route.Entity;
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(route.Entity).Select(x => x.CopyPageInfos()).ToList(),
                CallBackRoute = route,
                SelectedTabIndex = route.TabIndex
            };

            var customerSecurityByRole = currentSessionProvider.UserSecurities.FirstOrDefault(x => x.SecMainModuleId.ToEnum<MainModule>() == currentModule);
            if (customerSecurityByRole.Id > 0 && customerSecurityByRole.UserSubSecurities != null)
            {
                foreach (var subSecurity in customerSecurityByRole.UserSubSecurities)
                {
                    if ((subSecurity.SubsMenuOptionLevelId.ToEnum<MenuOptionLevelEnum>() < MenuOptionLevelEnum.Screens) || (subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.NoAccess))
                        pageControlResult.PageInfos = pageControlResult.PageInfos.Where(x => x.TabTableName != subSecurity.RefTableName).ToList();
                    else
                    {
                        var currentPageInfo = pageControlResult.PageInfos.FirstOrDefault(x => x.TabTableName == subSecurity.RefTableName);
                        if (currentPageInfo != null)
                            currentPageInfo.SubSecurity = subSecurity;
                    }
                }
            }

            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                if (Enum.IsDefined(typeof(EntitiesAlias), pageInfo.TabTableName) && pageInfo.TabTableName.ToEnum<EntitiesAlias>() == EntitiesAlias.OrgRefRole)
                {
                    var actRoleRoute = new MvcRoute(route);
                    actRoleRoute.IsPopup = true;
                    pageInfo.SetRoute(actRoleRoute, _commonCommands);
                }
                else
                    pageInfo.SetRoute(route, _commonCommands);
            }

            return pageControlResult;
        }

        public static PageInfo CopyPageInfos(this PageInfo currentPageInfo)
        {
            return new PageInfo
            {
                RefTableName = currentPageInfo.RefTableName,
                TabSortOrder = currentPageInfo.TabSortOrder,
                TabTableName = currentPageInfo.TabTableName,
                TabPageTitle = currentPageInfo.TabPageTitle,
                StatusId = currentPageInfo.StatusId,
                TabExecuteProgram = currentPageInfo.TabExecuteProgram,
                TabPageIcon = currentPageInfo.TabPageIcon,
                Route = currentPageInfo.Route,
                DisabledTab = currentPageInfo.DisabledTab,
                SubSecurity = currentPageInfo.SubSecurity
            };
        }

        public static void ResetPagedDataInfo(this PagedDataInfo pagedDataInfo, MvcRoute route)
        {
            pagedDataInfo.PageNumber = 1;

            if (route.Entity != EntitiesAlias.Job && route.Entity != EntitiesAlias.JobCard)
            {
                pagedDataInfo.WhereCondition = null;
                pagedDataInfo.Contains = string.Empty;
            }
            pagedDataInfo.ParentId = route.ParentRecordId;
        }

        public static void GridRouteSessionSetup<TView>(this MvcRoute route, SessionProvider sessionProvider, GridResult<TView> gridResult, int userGridPageSize, ViewDataDictionary viewData, bool shouldUpdatePageSize = true) where TView : class, new()
        {
            if (!sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = sessionProvider.UserSettings.SetPagedDataInfo(route, userGridPageSize) };
                var viewPagedDataSession = sessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                sessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            else
            {
                sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = userGridPageSize;
            }

            if (string.IsNullOrWhiteSpace(sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy) && FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
                sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = string.Format("{0}.{1}", route.Entity, FormViewProvider.ItemFieldName[route.Entity]);

            //Added: If parentId is changing for same entity then grid records are not coming. So, On parentId change, resetting the PageNumber to 1 (Example: OrgRefRole) AND resetting the WhereCondition to null
            if (route.ParentRecordId != sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId)
            {
                sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ResetPagedDataInfo(route);
                //viewData[WebApplicationConstants.ClearFilterManually] = true;
                sessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter = false;
                sessionProvider.ViewPagedDataSession[route.Entity].Filters = null;
                gridResult.FocusedRowId = route.RecordId;
            }

            //Added: AppPanelRoute in Session becuase while doing AppPanel callback needed strRoute otherwise AppPanel was always redirecting to default first Page(for operations like ToggleFilter)
            //sessionProvider.ViewPagedDataSession[route.Entity].AppPanelRoute = JsonConvert.SerializeObject(route);

            //Added : Assign page number, max pageNumber is less than when pagesize changes by user(This is for scenario: If user selects last page from page size 10 then changing the page size to 30 then was getting issue related to PageNumber)
            if (shouldUpdatePageSize && sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var pagedDataInfo = sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo;
                var maxPageNumber = (pagedDataInfo.TotalCount / pagedDataInfo.PageSize);
                if ((pagedDataInfo.TotalCount % pagedDataInfo.PageSize > 0) || (pagedDataInfo.TotalCount == 0))
                    maxPageNumber += 1;

                if (pagedDataInfo.PageNumber > maxPageNumber)
                    sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = maxPageNumber;
            }

            viewData[WebApplicationConstants.GridFilters] = sessionProvider.ViewPagedDataSession[route.Entity].Filters ?? new Dictionary<string, string>();

            if (route.Entity == EntitiesAlias.PrgRefGatewayDefault && route.Action == MvcConstants.ActionDataView && (!string.IsNullOrWhiteSpace(sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy)) && sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim() == route.Entity.ToString() + "." + WebApplicationConstants.ProgGtwyDefaultOldSort)
            {
                sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = WebUtilities.CreateOrderByWithMultipleColForPrgGty(route.Action, sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim(), route.Entity.ToString());
            }
            if (route.Entity == EntitiesAlias.PrgRefGatewayDefault && route.Action == MvcConstants.ActionGridSortingView)
            {
                //sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy ?? "";
                sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = WebUtilities.CreateOrderByWithMultipleColForPrgGty(route.Action, sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim(), route.Entity.ToString());
            }

            gridResult.SessionProvider = sessionProvider;
        }

        //public static void GridRouteSessionSetup<TView>(this MvcRoute route, SessionProvider sessionProvider, GridResult<TView> gridResult, int userGridPageSize, ViewDataDictionary viewData, bool shouldUpdatePageSize = true) where TView : class, new()
        //{
        //    if (!sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
        //    {
        //        var sessionInfo = new SessionInfo { PagedDataInfo = sessionProvider.UserSettings.SetPagedDataInfo(route, userGridPageSize) };
        //        var viewPagedDataSession = sessionProvider.ViewPagedDataSession;
        //        viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
        //        sessionProvider.ViewPagedDataSession = viewPagedDataSession;
        //    }
        //    else
        //    {
        //        sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageSize = userGridPageSize;
        //    }

        //    if (string.IsNullOrWhiteSpace(sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy) && FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
        //        sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = string.Format("{0}.{1} ASC", route.Entity, FormViewProvider.ItemFieldName[route.Entity]);

        //    //Added: If parentId is changing for same entity then grid records are not coming. So, On parentId change, resetting the PageNumber to 1 (Example: OrgRefRole) AND resetting the WhereCondition to null
        //    if (route.ParentRecordId != sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ParentId)
        //    {
        //        sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.ResetPagedDataInfo(route);
        //        //viewData[WebApplicationConstants.ClearFilterManually] = true;
        //        sessionProvider.ViewPagedDataSession[route.Entity].ToggleFilter = false;
        //        sessionProvider.ViewPagedDataSession[route.Entity].Filters = null;
        //    }

        //    //Added: AppPanelRoute in Session becuase while doing AppPanel callback needed strRoute otherwise AppPanel was always redirecting to default first Page(for operations like ToggleFilter)
        //    //sessionProvider.ViewPagedDataSession[route.Entity].AppPanelRoute = JsonConvert.SerializeObject(route);

        //    //Added : Assign page number, max pageNumber is less than when pagesize changes by user(This is for scenario: If user selects last page from page size 10 then changing the page size to 30 then was getting issue related to PageNumber)
        //    if (shouldUpdatePageSize && sessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
        //    {
        //        var pagedDataInfo = sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo;
        //        var maxPageNumber = (pagedDataInfo.TotalCount / pagedDataInfo.PageSize);
        //        if ((pagedDataInfo.TotalCount % pagedDataInfo.PageSize > 0) || (pagedDataInfo.TotalCount == 0))
        //            maxPageNumber += 1;

        //        if (pagedDataInfo.PageNumber > maxPageNumber)
        //            sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = maxPageNumber;
        //    }

        //    viewData[WebApplicationConstants.GridFilters] = sessionProvider.ViewPagedDataSession[route.Entity].Filters ?? new Dictionary<string, string>();

        //    if (route.Entity == EntitiesAlias.PrgRefGatewayDefault && route.Action == MvcConstants.ActionDataView && (!string.IsNullOrWhiteSpace(sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy)) && sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim() == route.Entity.ToString() + "." + WebApplicationConstants.ProgGtwyDefaultOldSort)
        //    {
        //        sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = WebUtilities.CreateOrderByWithMultipleColForPrgGty(route.Action, sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim(), route.Entity.ToString());
        //    }
        //    if (route.Entity == EntitiesAlias.PrgRefGatewayDefault && route.Action == MvcConstants.ActionGridSortingView)
        //    {
        //        //sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy ?? "";
        //        sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy = WebUtilities.CreateOrderByWithMultipleColForPrgGty(route.Action, sessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.OrderBy.Trim(), route.Entity.ToString());
        //    }

        //    gridResult.SessionProvider = sessionProvider;
        //}

        public static object GetFilterValue<TView>(this IList<TView> records, EntitiesAlias entity, string columnName = null)
        {
            string value = string.Empty;
            switch (entity)
            {
                case EntitiesAlias.SecurityByRole:
                    value = (records as List<APIClient.ViewModels.Administration.SecurityByRoleView>).FirstOrDefault().OrgIdName;
                    break;

                case EntitiesAlias.OrgCredential:
                    value = (records as List<APIClient.ViewModels.Organization.OrgCredentialView>).FirstOrDefault().OrgIDName;
                    break;

                case EntitiesAlias.OrgPocContact:
                    value = (records as List<APIClient.ViewModels.Organization.OrgPocContactView>).FirstOrDefault().ConOrgIdName;
                    break;

                case EntitiesAlias.Customer:
                    value = (records as List<APIClient.ViewModels.Customer.CustomerView>).FirstOrDefault().CustOrgIdName;
                    break;

                case EntitiesAlias.Vendor:
                    value = (records as List<APIClient.ViewModels.Vendor.VendorView>).FirstOrDefault().VendOrgIDName;
                    break;

                case EntitiesAlias.CustContact:
                    value = (records as List<APIClient.ViewModels.Customer.CustContactView>).FirstOrDefault().ConPrimaryRecordIdName;
                    break;

                case EntitiesAlias.CustDcLocation:
                    value = (records as List<APIClient.ViewModels.Customer.CustDcLocationView>).FirstOrDefault().CdcCustomerIDName;
                    break;

                case EntitiesAlias.PrgMvocRefQuestion:
                    value = (records as List<APIClient.ViewModels.Program.PrgMvocRefQuestionView>).FirstOrDefault().MVOCIDName;
                    break;

                case EntitiesAlias.CustBusinessTerm:
                    if (columnName == OrgColumnNames.CbtOrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustBusinessTermView>).FirstOrDefault().CbtOrgIDName;
                    else if (columnName == CustColumnNames.CbtCustomerId.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustBusinessTermView>).FirstOrDefault().CbtCustomerIdName;
                    break;

                case EntitiesAlias.CustFinancialCalendar:
                    if (columnName == OrgColumnNames.OrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustFinancialCalendarView>).FirstOrDefault().OrgIDName;
                    else if (columnName == CustColumnNames.CustID.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustFinancialCalendarView>).FirstOrDefault().CustIDName;
                    break;

                case EntitiesAlias.CustDocReference:
                    if (columnName == OrgColumnNames.CdrOrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustDocReferenceView>).FirstOrDefault().CdrOrgIDName;
                    else if (columnName == CustColumnNames.CdrCustomerID.ToString())
                        value = (records as List<APIClient.ViewModels.Customer.CustDocReferenceView>).FirstOrDefault().CdrCustomerIDName;
                    break;

                case EntitiesAlias.VendContact:
                    value = (records as List<APIClient.ViewModels.Vendor.VendContactView>).FirstOrDefault().ConPrimaryRecordIdName;
                    break;

                case EntitiesAlias.VendDcLocation:
                    value = (records as List<APIClient.ViewModels.Vendor.VendDcLocationView>).FirstOrDefault().VdcVendorIDName;
                    break;

                case EntitiesAlias.VendBusinessTerm:
                    if (columnName == OrgColumnNames.VbtOrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendBusinessTermView>).FirstOrDefault().VbtOrgIDName;
                    else if (columnName == VendColumnNames.VbtVendorID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendBusinessTermView>).FirstOrDefault().VbtVendorIDName;
                    break;

                case EntitiesAlias.VendFinancialCalendar:
                    if (columnName == OrgColumnNames.OrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendFinancialCalendarView>).FirstOrDefault().OrgIDName;
                    else if (columnName == VendColumnNames.VendID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendFinancialCalendarView>).FirstOrDefault().VendIDName;
                    break;

                case EntitiesAlias.VendDocReference:
                    if (columnName == OrgColumnNames.VdrOrgID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendDocReferenceView>).FirstOrDefault().VdrOrgIDName;
                    else if (columnName == VendColumnNames.VdrVendorID.ToString())
                        value = (records as List<APIClient.ViewModels.Vendor.VendDocReferenceView>).FirstOrDefault().VdrVendorIDName;
                    break;

                case EntitiesAlias.SystemAccount:
                    if (columnName == OrgColumnNames.SysOrgId.ToString())
                        value = (records as List<APIClient.ViewModels.Administration.SystemAccountView>).FirstOrDefault().SysOrgIdName;
                    break;

                case EntitiesAlias.DeliveryStatus:
                    if (columnName == OrgColumnNames.OrganizationId.ToString())
                        value = (records as List<APIClient.ViewModels.Administration.DeliveryStatusView>).FirstOrDefault().OrganizationIdName;
                    break;
            }

            return value;
        }

        public static object GetValueFromObject<TView>(this TView record, string propertyName)
        {
            if (!string.IsNullOrEmpty(propertyName) && record != null)
            {
                var recordProperties = record.GetType().GetProperty(propertyName);
                if (recordProperties != null)
                {
                    return recordProperties.GetValue(record, null);
                }
            }

            return null;
        }

        public static IList<IdRefLangName> UpdateComboBoxToEditor(this IList<IdRefLangName> refOptions, int lookupId, EntitiesAlias entity)
        {
            switch (entity)
            {
                case EntitiesAlias.JobDocReference:
                    if (lookupId == Convert.ToInt32(LookupEnums.JobDocReferenceType))
                    {
                        return refOptions.Where(x => x.SysRefId == Convert.ToInt32(JobDocReferenceType.POD)).ToList();
                    }
                    break;

                case EntitiesAlias.CustDcLocationContact:
                    if (lookupId == Convert.ToInt32(LookupEnums.ContactType))
                    {
                        return refOptions.Where(x => x.SysRefId == Convert.ToInt32(ContactType.Customer)).ToList();
                    }
                    break;

                case EntitiesAlias.VendDcLocationContact:
                    if (lookupId == Convert.ToInt32(LookupEnums.ContactType))
                    {
                        return refOptions.Where(x => x.SysRefId == Convert.ToInt32(ContactType.Vendor)).ToList();
                    }
                    break;

                case EntitiesAlias.JobDriverContactInfo:
                    if (lookupId == Convert.ToInt32(LookupEnums.ContactType))
                    {
                        return refOptions.Where(x => x.SysRefId == Convert.ToInt32(ContactType.Driver)).ToList();
                    }
                    break;
            }
            return refOptions;
        }

        public static List<string> GetDateColumns()
        {
            return new List<string>() {
                CommonColumns.DateEntered.ToString(),
                CommonColumns.EnteredBy.ToString(),
                CommonColumns.DateChanged.ToString(),
                CommonColumns.ChangedBy.ToString()
            };
        }

        public static bool UpdateToggleFilterRouteForChildGrid(this MvcRoute route, SessionProvider sessionProvider, ViewDataDictionary ViewData)
        {
            switch (route.Entity)
            {
                case EntitiesAlias.CustDcLocationContact:
                    var currentCustomerId = sessionProvider.ViewPagedDataSession[EntitiesAlias.CustDcLocation].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.CustDcLocation;
                    route.SetParent(EntitiesAlias.Customer, currentCustomerId, route.IsPopup);
                    return true;

                case EntitiesAlias.VendDcLocationContact:
                    var currentVendorId = sessionProvider.ViewPagedDataSession[EntitiesAlias.VendDcLocation].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.VendDcLocation;
                    route.SetParent(EntitiesAlias.Vendor, currentVendorId, route.IsPopup);
                    return true;

                case EntitiesAlias.PrgBillableRate:
                    var parentId = sessionProvider.ViewPagedDataSession[EntitiesAlias.PrgBillableLocation].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.PrgBillableLocation;
                    route.SetParent(EntitiesAlias.Program, parentId, route.IsPopup);
                    return true;

                case EntitiesAlias.PrgCostRate:
                    var costParentId = sessionProvider.ViewPagedDataSession[EntitiesAlias.PrgCostLocation].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.PrgCostLocation;
                    route.SetParent(EntitiesAlias.Program, costParentId, route.IsPopup);
                    return true;

                case EntitiesAlias.PrgMvocRefQuestion:
                    var currentProgramId = sessionProvider.ViewPagedDataSession[EntitiesAlias.PrgMvoc].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.PrgMvoc;
                    route.SetParent(EntitiesAlias.Program, currentProgramId, route.IsPopup);
                    return true;

                case EntitiesAlias.PrgEdiHeader:
                    var currentPrgId = sessionProvider.ViewPagedDataSession[EntitiesAlias.PrgEdiHeader].PagedDataInfo.ParentId;
                    route.Url = route.ParentRecordId.ToString();
                    route.Entity = EntitiesAlias.PrgEdiHeader;
                    route.SetParent(EntitiesAlias.Program, currentPrgId, route.IsPopup);
                    return true;
            }
            return false;
        }

        public static string GetSettingByEntityAndName(this IList<RefSetting> userSettings, IList<RefSetting> refSettings, EntitiesAlias entity, string settingName)
        {
            var refSetting = refSettings.FirstOrDefault(s => s.Name.Equals(settingName) && s.EntityName.Equals(entity.ToString()));
            if (refSetting != null && !refSetting.IsOverWritable)
                return refSetting.Value;
            var userSetting = userSettings.FirstOrDefault(s => s.Name.Equals(settingName) && s.EntityName.Equals(entity.ToString()));
            if (userSetting != null)
                return userSetting.Value;
            return string.Empty;
        }

        public static void SetSettingByEnitityAndName(this IList<RefSetting> userSettings, EntitiesAlias entity, string settingName, string newValue)
        {
            var userSetting = userSettings.FirstOrDefault(s => s.Name.Equals(settingName) && s.EntityName.Equals(EntitiesAlias.System.ToString(), StringComparison.OrdinalIgnoreCase));
            if (userSetting == null)
                userSettings.Add(new RefSetting { Entity = entity, Name = settingName, Value = newValue });
            if (string.IsNullOrEmpty(userSetting.Value) || !(userSetting.Value).Equals(newValue))
                userSetting.Value = newValue;
        }

        public static string GetSystemSettingValue(this IList<RefSetting> userSettings, string settingName)
        {
            var userSetting = userSettings.FirstOrDefault(s => s.Name.Equals(settingName) && s.EntityName.Equals(EntitiesAlias.System.ToString(), StringComparison.OrdinalIgnoreCase));
            if (userSetting != null)
                return userSetting.Value;
            return string.Empty;
        }

        public static SysSetting UpdateActiveUserSettings(this ICommonCommands _commonCommands, ActiveUser activeUser = null)
        {
            IList<RefSetting> sysRefSettings = _commonCommands.GetSystemSetting(activeUser: activeUser).Settings;
            SysSetting userSettings = _commonCommands.GetUserSysSettings(activeUser: activeUser);
            if (!string.IsNullOrEmpty(userSettings.SysJsonSetting) && (userSettings.Settings == null || !userSettings.Settings.Any()))
                userSettings.Settings = JsonConvert.DeserializeObject<IList<RefSetting>>(userSettings.SysJsonSetting);
            else
                userSettings.Settings = new List<RefSetting>();
            userSettings.SysJsonSetting = string.Empty; // To save storage in cache as going to use only Model not json.
            foreach (var setting in sysRefSettings)
            {
                if (!setting.IsSysAdmin)
                {
                    var userSetting = userSettings.Settings.FirstOrDefault(s => s.Name.Equals(setting.Name) && s.Entity == setting.Entity);
                    if (userSetting == null)
                    {
                        userSettings.Settings.Add(setting);
                        continue;
                    }
                    if (string.IsNullOrEmpty(userSetting.Value) || !setting.IsOverWritable)
                    {

                        userSetting.Value = setting.Value;
                    }
                    if (userSetting.Name == "SysStatusesIn" && userSetting.EntityName == "System")
                        userSetting.Value = "1,2,3";

                }
            }

            SysSetting copySysSetting = new SysSetting { Settings = userSettings.Settings };
            _commonCommands.UpdateUserSystemSettings(copySysSetting, activeUser);

            return userSettings;
        }

        public static M4PL.APIClient.ViewModels.Job.JobGatewayView JobGatewayActionFormSetting(this M4PL.APIClient.ViewModels.Job.JobGatewayView jobGatewayView, WebUtilities.JobGatewayActions actionEnumToCompare, out List<string> escapeRequiredFields)
        {
            escapeRequiredFields = new List<string>();
            switch (actionEnumToCompare)
            {
                case WebUtilities.JobGatewayActions.Canceled:
                    jobGatewayView.GwyCompleted = jobGatewayView.CancelOrder;
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateCancelled;
                    if (jobGatewayView.GwyCompleted && (jobGatewayView.GwyGatewayACD == null))
                        jobGatewayView.GwyGatewayACD = jobGatewayView.DateChanged;
                    if ((jobGatewayView.GwyGatewayACD != null) && !jobGatewayView.GwyCompleted)
                        jobGatewayView.GwyCompleted = true;
                    if (jobGatewayView.GwyDDPNew == null)
                        jobGatewayView.GwyDDPNew = Utilities.TimeUtility.GetPacificDateTime();
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPCurrent.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString(),
                                            //JobGatewayColumns.GwyExceptionStatusId.ToString(),
                                            });
                    break;

                case WebUtilities.JobGatewayActions.DeliveryWindow:
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString(),
                                            });
                    break;

                case WebUtilities.JobGatewayActions.Comment:
                case WebUtilities.JobGatewayActions.LeftMessage:
                case WebUtilities.JobGatewayActions.Contacted:
                case WebUtilities.JobGatewayActions.Anonymous:
                    jobGatewayView.GwyDDPCurrent = Utilities.TimeUtility.GetPacificDateTime();
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateComment ?? jobGatewayView.DateChanged;
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;

                case WebUtilities.JobGatewayActions.Exception:
                    jobGatewayView.GwyDDPCurrent = Utilities.TimeUtility.GetPacificDateTime();
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateComment ?? jobGatewayView.DateChanged;
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString(),
                                            //JobGatewayColumns.GwyExceptionStatusId.ToString(),
                                            //JobGatewayColumns.GwyExceptionTitleId.ToString(),
                                            });
                    break;

                case WebUtilities.JobGatewayActions.EMail:
                    jobGatewayView.GwyGatewayACD = jobGatewayView.DateEmail ?? jobGatewayView.DateEmail;
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyDDPCurrent.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString(),
                                            });
                    break;

                case WebUtilities.JobGatewayActions.Schedule:
                case WebUtilities.JobGatewayActions.Reschedule:
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString()
                                            });
                    break;

                case WebUtilities.JobGatewayActions.ThreePL:
                case WebUtilities.JobGatewayActions.SchedulePickUp:
                    escapeRequiredFields.AddRange(new List<string> {
                                            JobGatewayColumns.DateCancelled.ToString(),
                                            JobGatewayColumns.DateComment.ToString(),
                                            JobGatewayColumns.DateEmail.ToString(),
                                            JobGatewayColumns.GwyUprDate.ToString(),
                                            JobGatewayColumns.GwyLwrDate.ToString(),
                                            JobGatewayColumns.GwyDDPNew.ToString(),
                                            });
                    break;
            }

            return jobGatewayView;
        }

        public static List<ContactComboBox> UpdateContactComboboxDeletedSelected(this List<ContactComboBox> comboboxItems, long selectedId)
        {
            if (!comboboxItems.Any(t => t.Id == selectedId) && comboboxItems.Count() > 0)
            {
                comboboxItems.Add(new M4PL.Entities.Support.ContactComboBox
                {
                    Id = selectedId,
                    ConFileAs = "Unassigned",
                    ConFullName = "Unassigned",
                    ConJobTitle = "Unassigned",
                    StatusId = 3
                });
            }
            return comboboxItems;
        }

        public static XRTable GetReportRecordFromJobVocReportRecord(this IList<JobVocReport> vocReports, bool isDefaultVOC = false)
        {
            XRTable xrtable = new XRTable();

            if (vocReports == null || vocReports.Count() == 0)
            { xrtable.EndInit(); return xrtable; }

            string tableColumns = "Location,ContractNumber,DriverId,DeliverySatisfaction,CSRProfessionalism,AdvanceDeliveryTime,"
                + "DriverProfessionalism,DeliveryTeamHelpfulness,OverallScore,DateEntered";
            string[] tableColumnsArray = tableColumns.Split(',');

            var record = vocReports;

            if (record == null || record.Count() == 0)
            { xrtable.EndInit(); return xrtable; }

            xrtable.BeginInit();
            xrtable.Width = 900;

            float rowHeight = 50f;
            float cellWidth = 88f;
            string strLocation = string.Empty;

            List<string> insLocation = new List<string>();
            List<string> insCustomer = new List<string>();
            List<string> insContractNumbers = new List<string>();
            List<string> feedBack = new List<string>();

            var recordGroupByCustomer = record.GroupBy(c => new
            {
                c.CustCode,
                c.LocationCode
            });

            //var recordGroupByLocation = record.GroupBy(t => t.LocationCode);
            foreach (var reco in recordGroupByCustomer)
            {
                var overallScoreTotal = 0;
                var overallScoreCount = 0;
                XRTableRow row = new XRTableRow();
                foreach (var item in reco)
                {
                    row = new XRTableRow();

                    if (!string.IsNullOrEmpty(item.CustCode) && (insCustomer.Count == 0) || (!insCustomer.Any(c => c == Convert.ToString(item.CustCode))))
                    {
                        insCustomer.Add(item.CustCode);
                        insLocation = new List<string>();
                        XRTableCell cell = new XRTableCell();
                        cell.HeightF = rowHeight;
                        cell.WidthF = cellWidth;
                        cell.Text = item.CustCode;
                        cell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
                        cell.Font = new Font(xrtable.Font.FontFamily, 9, FontStyle.Bold);
                        cell.Borders = DevExpress.XtraPrinting.BorderSide.Top;
                        row.Cells.Add(cell);
                        xrtable.Rows.Add(row);
                        row = new XRTableRow();
                    }
                    if (!string.IsNullOrEmpty(item.LocationCode) && (insLocation.Count == 0) || (!insLocation.Any(c => c == Convert.ToString(item.LocationCode))))
                    {
                        XRTableCell cell = new XRTableCell();
                        cell.HeightF = rowHeight;
                        cell.WidthF = cellWidth;
                        cell.Text = item.LocationCode;
                        cell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
                        insLocation.Add(item.LocationCode);
                        feedBack = new List<string>();
                        cell.BackColor = System.Drawing.Color.Gainsboro;
                        cell.Borders = DevExpress.XtraPrinting.BorderSide.All;
                        cell.BorderColor = Color.White;
                        row.Cells.Add(cell);
                        xrtable.Rows.Add(row);
                        row = new XRTableRow();
                        xrtable.Rows.Add(row);
                        row = new XRTableRow();
                    }

                    for (int i = 0; i < tableColumnsArray.Count(); i++)
                    {
                        XRTableCell cell = new XRTableCell();
                        cell.HeightF = rowHeight;

                        string cellValue = string.Empty;
                        var cellBackColor = System.Drawing.Color.White;
                        switch (tableColumnsArray[i])
                        {
                            case "Location":
                                if (!string.IsNullOrEmpty(item.LocationCode) && (insLocation.Count == 0) || (!insLocation.Any(c => c == Convert.ToString(item.LocationCode))))
                                {
                                    insContractNumbers = new List<string>();
                                    //cellValue = item.LocationCode;
                                    //insLocation.Add(item.LocationCode);
                                }
                                cell.WidthF = 60f;
                                break;

                            case "ContractNumber":
                                if (!string.IsNullOrEmpty(item.ContractNumber) && (insContractNumbers.Count == 0) || (!insContractNumbers.Any(c => c == Convert.ToString(item.ContractNumber))))
                                {
                                    cellValue = Convert.ToString(item.ContractNumber);
                                    insContractNumbers.Add(cellValue);
                                }
                                cell.WidthF = cellWidth;
                                break;

                            case "DriverId":
                                cellValue = Convert.ToString(item.DriverId);
                                cell.WidthF = 70f;
                                break;

                            case "DeliverySatisfaction":
                                cellValue = Convert.ToString(item.DeliverySatisfaction);
                                cell.WidthF = 76f;
                                break;

                            case "CSRProfessionalism":
                                cellValue = Convert.ToString(item.CSRProfessionalism);
                                cell.WidthF = 86f;
                                break;

                            case "AdvanceDeliveryTime":
                                cellValue = Convert.ToString(item.AdvanceDeliveryTime);
                                cell.WidthF = 86f;
                                break;

                            case "DriverProfessionalism":
                                cellValue = Convert.ToString(item.DriverProfessionalism);
                                cell.WidthF = 86f;
                                break;

                            case "DeliveryTeamHelpfulness":
                                cellValue = Convert.ToString(item.DeliveryTeamHelpfulness);
                                cell.WidthF = 88f;
                                break;

                            case "OverallScore":
                                overallScoreTotal += item.OverallScore;
                                overallScoreCount++;
                                cellValue = Convert.ToString(item.OverallScore);
                                cell.WidthF = 66f;
                                break;

                            case "DateEntered":
                                cellValue = Convert.ToString(item.DateEntered);
                                cell.WidthF = 132f;
                                break;
                        }
                        cell.Text = cellValue;
                        cell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
                        if (tableColumnsArray[i] == "ContractNumber" || tableColumnsArray[i] == "Location"
                            || tableColumnsArray[i] == "DriverId" || tableColumnsArray[i] == "DateEntered")
                            cellBackColor = Color.White;
                        else if (!string.IsNullOrEmpty(cellValue) && tableColumnsArray[i] == "OverallScore")
                            cellBackColor = GetVocColorCode(Convert.ToInt32(cellValue));
                        else if (!string.IsNullOrEmpty(cellValue) && tableColumnsArray[i] != "OverallScore")
                            cellBackColor = GetQnsVocColorCode(Convert.ToInt32(cellValue));

                        cell.BackColor = cellBackColor;
                        cell.Borders = DevExpress.XtraPrinting.BorderSide.All;
                        cell.BorderColor = Color.White;
                        row.Cells.Add(cell);
                    }
                    xrtable.Rows.Add(row);

                    if (!string.IsNullOrEmpty(item.Feedback)
                        && (feedBack.Count == 0)
                        || (!feedBack.Any(c => c == Convert.ToString(item.Feedback))))
                    {
                        row = new XRTableRow();
                        feedBack.Add(item.Feedback);
                        XRTableCell cell = new XRTableCell();
                        cell.HeightF = 100f;
                        cell.WidthF = 31f;
                        row.Cells.Add(cell);
                        cell = new XRTableCell();
                        cell.WidthF = 88f;
                        cell.Text = item.Feedback;
                        cell.BackColor = Color.White;
                        cell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
                        row.Cells.Add(cell);
                        xrtable.Rows.Add(row);
                        row = new XRTableRow();
                    }

                    row = new XRTableRow();
                    xrtable.Rows.Add(row);

                    #region overralScoreAvg

                    row = new XRTableRow();
                    XRTableCell cellAvg = new XRTableCell();
                    cellAvg.HeightF = 100f;
                    cellAvg.WidthF = 4f;
                    cellAvg.Text = "Total Count: " + Convert.ToString(overallScoreCount);
                    cellAvg.Font = new Font(xrtable.Font.FontFamily, 9, FontStyle.Bold);
                    cellAvg.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
                    row.Cells.Add(cellAvg);

                    cellAvg = new XRTableCell();
                    cellAvg.WidthF = 5f;
                    cellAvg.Text = "Avg. Scrore: " + Convert.ToString(overallScoreTotal / overallScoreCount);
                    cellAvg.BackColor = Color.White;
                    cellAvg.Font = new Font(xrtable.Font.FontFamily, 9, FontStyle.Bold);
                    cellAvg.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
                    row.Cells.Add(cellAvg);

                    cellAvg = new XRTableCell();
                    cellAvg.WidthF = 2f;
                    row.Cells.Add(cellAvg);

                    #endregion overralScoreAvg
                }
                xrtable.Rows.Add(row);
                row = new XRTableRow();
            }

            xrtable.EndInit();
            return xrtable;
        }

        public static XRTable CreateReportHeaderBand()
        {
            XRTable xrtable = new XRTable();
            xrtable.BeginInit();
            xrtable.Width = 900;
            xrtable.HeightF = 30f;

            var path = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/fm_meridian_branding_logo_filled_small_v1.png");

            XRTableRow pageHearder = new XRTableRow();

            var pb = new XRPictureBox
            {
                ImageSource = new DevExpress.XtraPrinting.Drawing.ImageSource(new Bitmap(path)),
                Sizing = DevExpress.XtraPrinting.ImageSizeMode.AutoSize,
                BackColor = Color.White,
                BorderColor = Color.White
            };
            XRTableCell pageHeaderCell1 = new XRTableCell();
            pageHeaderCell1.HeightF = 30f;
            pageHeaderCell1.WidthF = 300f;
            pageHeaderCell1.Controls.Add(pb);
            pageHearder.Cells.Add(pageHeaderCell1);

            XRTableCell pageHeaderCell = new XRTableCell();
            pageHeaderCell.Text = "VOC Survey Report";
            pageHeaderCell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            pageHeaderCell.HeightF = 30f;
            pageHeaderCell.WidthF = 300f;
            pageHeaderCell.Font = new Font("Tahoma", 15, FontStyle.Bold);
            pageHearder.Cells.Add(pageHeaderCell);

            DateTime dt = Utilities.TimeUtility.GetPacificDateTime();
            XRTableCell pageHeaderCell2 = new XRTableCell();
            pageHeaderCell2.Text = dt.ToString();
            pageHeaderCell2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            pageHeaderCell2.HeightF = 30f;
            pageHeaderCell2.WidthF = 300f;
            pageHeaderCell2.BackColor = Color.White;
            pageHearder.Cells.Add(pageHeaderCell2);

            xrtable.Rows.Add(pageHearder);
            xrtable.EndInit();
            return xrtable;
        }

        public static XRTable CreateReportHearderAndTableHearder()
        {
            XRTable xrtable = new XRTable();
            xrtable.BeginInit();
            xrtable.Width = 900;
            xrtable.HeightF = 60f;

            #region page header details

            var path = System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/fm_meridian_branding_logo_filled_small_v1.png");

            XRTableRow pageHearder = new XRTableRow();
            pageHearder = new XRTableRow();
            pageHearder.HeightF = 30f;
            xrtable.Rows.Add(pageHearder);

            var pb = new XRPictureBox
            {
                ImageSource = new DevExpress.XtraPrinting.Drawing.ImageSource(new Bitmap(path)),
                Sizing = DevExpress.XtraPrinting.ImageSizeMode.AutoSize,
                BackColor = Color.White,
                BorderColor = Color.White
            };
            XRTableCell pageHeaderCell1 = new XRTableCell();
            pageHeaderCell1.HeightF = 30f;
            pageHeaderCell1.WidthF = 300f;
            pageHeaderCell1.Controls.Add(pb);
            pageHearder.Cells.Add(pageHeaderCell1);

            XRTableCell pageHeaderCell = new XRTableCell();
            pageHeaderCell.Text = "VOC Survey Report";
            pageHeaderCell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            pageHeaderCell.HeightF = 30f;
            pageHeaderCell.WidthF = 300f;
            pageHeaderCell.BackColor = Color.White;
            pageHeaderCell.Font = new Font("Tahoma", 15, FontStyle.Bold);
            pageHearder.Cells.Add(pageHeaderCell);

            DateTime dt = Utilities.TimeUtility.GetPacificDateTime();
            XRTableCell pageHeaderCell2 = new XRTableCell();
            pageHeaderCell2.Text = dt.ToString();
            pageHeaderCell2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            pageHeaderCell2.HeightF = 30f;
            pageHeaderCell2.WidthF = 300f;
            pageHeaderCell2.BackColor = Color.White;
            pageHearder.Cells.Add(pageHeaderCell2);
            xrtable.Rows.Add(pageHearder);

            #endregion page header details

            float rowHeight = 28f;
            float cellWidth = 88f;
            float srtcellWidth = 70f;
            string tableColumns = "Location,ContractNumber,Driver,DeliverySatisfaction,CSRProfessionalism,AdvanceDeliveryTime,DriverProfessionalism,DeliveryTeamHelpfulness,OverallScore,DateEntered";//,Feedback";
            string[] tableColumnsArray = tableColumns.Split(',');

            XRTableRow rowHeader = new XRTableRow();

            for (int i = 0; i < tableColumnsArray.Count(); i++)
            {
                XRTableCell headerCell = new XRTableCell();
                headerCell.HeightF = rowHeight;
                headerCell.Font = new Font(xrtable.Font.FontFamily, 9, FontStyle.Bold);
                string cellValue = string.Empty;
                var cellBackColor = System.Drawing.Color.White;
                switch (tableColumnsArray[i])
                {
                    case "Location":
                        cellValue = "Location";
                        headerCell.WidthF = 60f;
                        break;

                    case "ContractNumber":
                        cellValue = "Contract Number";
                        headerCell.WidthF = cellWidth;
                        break;

                    case "Driver":
                        cellValue = "Driver";
                        headerCell.WidthF = srtcellWidth;
                        break;

                    case "DeliverySatisfaction":
                        cellValue = "Del Satisfaction";
                        headerCell.WidthF = 76f;
                        break;

                    case "CSRProfessionalism":
                        cellValue = "CSR Professionalism";
                        headerCell.WidthF = 86f;
                        break;

                    case "AdvanceDeliveryTime":
                        cellValue = "Adv Delivery Time";
                        headerCell.WidthF = 86f;
                        break;

                    case "DriverProfessionalism":
                        cellValue = "Drvr Professionalism";
                        headerCell.WidthF = 86f;
                        break;

                    case "DeliveryTeamHelpfulness":
                        cellValue = "Del Team Helpfulness";
                        headerCell.WidthF = 88f;
                        break;

                    case "OverallScore":
                        cellValue = "Overall Score";
                        headerCell.WidthF = 64f;
                        break;

                    case "DateEntered":
                        cellValue = "Date Entered";
                        headerCell.WidthF = 132f;
                        break;
                        //case "Feedback":
                        //    headerCell.WidthF = cellWidth;
                        //    break;
                }
                headerCell.Text = cellValue;
                if (tableColumnsArray[i] == "Location")
                    headerCell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
                else
                    headerCell.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
                //headerCell.BackColor = Color.White;
                //headerCell.Borders = DevExpress.XtraPrinting.BorderSide.All;
                //headerCell.BorderColor = Color.White;
                //headerCell.Borders = DevExpress.XtraPrinting.BorderSide.Bottom;
                rowHeader.Cells.Add(headerCell);
            }
            xrtable.Rows.Add(rowHeader);
            xrtable.EndInit();
            return xrtable;
        }

        public static string GetAdvanceWhereCondition(M4PL.Entities.Job.JobAdvanceReportRequest jobAdvanceReportRequest, PagedDataInfo pageDataInfo)
        {
            string where = string.Empty;
            //if (jobAdvanceReportRequest == null)
            //{
            //    where = string.Format(" AND CAST(JobAdvanceReport.DateEntered AS DATE) = '{0}' ", DateTime.Now.Date);
            //    return where;
            //}
            if (jobAdvanceReportRequest.CustomerId > 0)
                where = string.Format("AND prg.PrgCustID = {0}", jobAdvanceReportRequest.CustomerId);
            if (jobAdvanceReportRequest.ProgramId != null && jobAdvanceReportRequest.ProgramId.Count > 0 && !jobAdvanceReportRequest.ProgramId.Contains(0))
                where += string.Format(" AND prg.Id IN ({0})", string.Join(", ", jobAdvanceReportRequest.ProgramId.OfType<long>()));

            if (jobAdvanceReportRequest.Origin != null && jobAdvanceReportRequest.Origin.Count > 0 && !jobAdvanceReportRequest.Origin.Contains("ALL"))
                where += string.Format(" AND JobAdvanceReport.PlantIDCode IN ('{0}')", string.Join("','", jobAdvanceReportRequest.Origin.OfType<string>()));

            if (jobAdvanceReportRequest.Destination != null && jobAdvanceReportRequest.Destination.Count > 0 && !jobAdvanceReportRequest.Destination.Contains("ALL"))

                where += string.Format(" AND JobAdvanceReport.JobSiteCode IN ('{0}')", string.Join("','", jobAdvanceReportRequest.Destination.OfType<string>()));

            if (jobAdvanceReportRequest.Brand != null && jobAdvanceReportRequest.Brand.Count > 0 && !jobAdvanceReportRequest.Brand.Contains("ALL"))
                where += string.Format(" AND JobAdvanceReport.JobCarrierContract IN ('{0}')", string.Join("','", jobAdvanceReportRequest.Brand.OfType<string>()));

            if (jobAdvanceReportRequest.ServiceMode != null && jobAdvanceReportRequest.ServiceMode.Count > 0 && !jobAdvanceReportRequest.ServiceMode.Contains("ALL"))
                where += string.Format(" AND JobAdvanceReport.JobServiceMode IN ('{0}')", string.Join("','", jobAdvanceReportRequest.ServiceMode.OfType<string>()));

            if (jobAdvanceReportRequest.ProductType != null && jobAdvanceReportRequest.ProductType.Count > 0 && !jobAdvanceReportRequest.ProductType.Contains("ALL"))
                where += string.Format(" AND JobAdvanceReport.JobProductType IN ('{0}')", string.Join("','", jobAdvanceReportRequest.ProductType.OfType<string>()));

            if (jobAdvanceReportRequest.Channel != null && jobAdvanceReportRequest.Channel.Count > 0 && !jobAdvanceReportRequest.Channel.Contains("ALL"))
                where += string.Format(" AND JobAdvanceReport.JobChannel IN ('{0}')", string.Join("','", jobAdvanceReportRequest.Channel.OfType<string>()));

            string starteDate, endDate = string.Empty;
            starteDate = jobAdvanceReportRequest.StartDate.HasValue ? jobAdvanceReportRequest.StartDate.Value.Date.ToShortDateString() : string.Empty;
            endDate = jobAdvanceReportRequest.EndDate.HasValue
                ? jobAdvanceReportRequest.EndDate.Value.Date.ToShortDateString() : string.Empty;

            if (!string.IsNullOrEmpty(jobAdvanceReportRequest.DateTypeName) && !string.IsNullOrWhiteSpace(jobAdvanceReportRequest.DateTypeName) && !string.IsNullOrEmpty(starteDate) && !string.IsNullOrEmpty(endDate))
            {
                if (jobAdvanceReportRequest.DateTypeName == "Order Date")
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
               ? "" : string.Format(" AND JobAdvanceReport.JobOrderedDate IS NOT NULL  AND CAST(JobAdvanceReport.JobOrderedDate AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobOrderedDate AS DATE) <= '{1}' ",
               Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                else if (jobAdvanceReportRequest.DateTypeName == "Delivered Date")
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
               ? "" : string.Format(" AND JobAdvanceReport.JobDeliveryDateTimeActual IS NOT NULL  AND CAST (JobAdvanceReport.JobDeliveryDateTimeActual AS DATE)>= '{0}' AND CAST (JobAdvanceReport.JobDeliveryDateTimeActual AS DATE) <= '{1}' ",
               Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                else if (jobAdvanceReportRequest.DateTypeName == "Shipment Date")
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
               ? "" : string.Format(" AND JobAdvanceReport.JobShipmentDate IS NOT NULL  AND CAST(JobAdvanceReport.JobShipmentDate AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobShipmentDate AS DATE) <= '{1}' ",
               Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                else if (jobAdvanceReportRequest.DateTypeName == "Receive Date")
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
               ? "" : string.Format(" AND JobAdvanceReport.JobOriginDateTimePlanned  IS NOT NULL  AND CAST(JobAdvanceReport.JobOriginDateTimePlanned AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobOriginDateTimePlanned AS DATE) <= '{1}'",
               Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                else if (jobAdvanceReportRequest.DateTypeName == "Schedule Date")
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
               ? "" : string.Format(" AND JobAdvanceReport.JobDeliveryDateTimePlanned  IS NOT NULL  AND CAST(JobAdvanceReport.JobDeliveryDateTimePlanned AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobDeliveryDateTimePlanned AS DATE) <= '{1}'",
               Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
            }
            else
            {
                if (jobAdvanceReportRequest.FileName == "Pride Metric Report" || jobAdvanceReportRequest.ReportType == 3317)
                {
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
                  ? "" : string.Format(" AND JobAdvanceReport.JobDeliveryDateTimeActual  IS NOT NULL  AND CAST(JobAdvanceReport.JobDeliveryDateTimeActual AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobDeliveryDateTimeActual AS DATE) <= '{1}' ",
                  Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                }
                else if ((jobAdvanceReportRequest.FileName != "Job Advance Report" && jobAdvanceReportRequest.FileName != "Manifest Report" && jobAdvanceReportRequest.FileName != "OSD Report" && jobAdvanceReportRequest.FileName != "Price Charge"
                && jobAdvanceReportRequest.FileName != "Cost Charge" && jobAdvanceReportRequest.FileName != "Transaction Summary" && jobAdvanceReportRequest.FileName != "Transaction Locations" && jobAdvanceReportRequest.FileName != "Transaction Jobs")
                || (jobAdvanceReportRequest.FileName == null))
                {
                    where += (string.IsNullOrEmpty(starteDate) && string.IsNullOrEmpty(endDate))
                   ? "" : string.Format(" AND JobAdvanceReport.JobDeliveryDateTimePlanned  IS NOT NULL  AND CAST(JobAdvanceReport.JobDeliveryDateTimePlanned AS DATE) >= '{0}' AND CAST(JobAdvanceReport.JobDeliveryDateTimePlanned AS DATE) <= '{1}' ",
                   Convert.ToDateTime(starteDate).Date.ToShortDateString(), Convert.ToDateTime(endDate).Date.ToShortDateString());
                }
            }

            where += string.IsNullOrEmpty(jobAdvanceReportRequest.Search) ? "" :
                     string.Format(" AND (cust.CustTitle  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobBOL LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobCustomerSalesOrder  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobManifestNo LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.PlantIDCode LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobSellerSiteName LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliverySiteName  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliverySitePOC  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobCarrierContract  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobSiteCode  LIKE '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliverySiteName like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryStreetAddress like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryStreetAddress2 like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryStreetAddress3 like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryStreetAddress4 like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryCity like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryState like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliveryPostalCode like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliverySitePOCPhone like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobDeliverySitePOCEmail like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobBOLMaster like '%{0}%'", jobAdvanceReportRequest.Search)
                     + string.Format(" OR JobAdvanceReport.JobCustomerPurchaseOrder like '%{0}%')", jobAdvanceReportRequest.Search);

            return where;
        }

        public static string GetJobCardWhereCondition(List<string> destionations)
        {
            string where = string.Empty;
            if (destionations != null && destionations.Count > 0 && !destionations.Contains("ALL") && !destionations.Contains(null))
                where += string.Format(" AND PVL.VendDCLocationId IN ({0}) ", string.Join(",", destionations.OfType<String>()));
            return where;
        }

        private static Color GetVocColorCode(int score)
        {
            if (score < 90)
                return Color.Red;
            else if (score >= 100)
                return Color.Green;
            else
                return Color.Yellow;
        }

        private static Color GetQnsVocColorCode(int score)
        {
            if (score <= 15)
                return Color.Red;
            else if (score > 16)
                return Color.Green;
            else
                return Color.Yellow;
        }

        public static IList<APIClient.ViewModels.Job.JobCardViewView> GetCardViewViews(this IList<JobCardTileDetail> jobCardTiles, long custId = 0)
        {
            var views = new List<APIClient.ViewModels.Job.JobCardViewView>();
            var requestRout = new MvcRoute(EntitiesAlias.JobCard, "DataView", "Job");
            requestRout.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            requestRout.Area = "Job";
            requestRout.TabIndex = 1;
            requestRout.Entity = EntitiesAlias.JobCard;

            if (jobCardTiles != null && jobCardTiles.Count > 0)
            {
                foreach (var jobCardTile in jobCardTiles)
                {
                    var jobCardTitleView = new APIClient.ViewModels.Job.JobCardViewView
                    {
                        Id = jobCardTile.DashboardCategoryRelationId,
                        Name = jobCardTile.DashboardSubCategoryDisplayName,
                        CardCount = jobCardTile.RecordCount,
                        CardType = jobCardTile.SortOrder + jobCardTile.DashboardCategoryDisplayName,
                        CustomerId = custId,
                        BackGroundColor = jobCardTile.BackGroundColor,
                        FontColor = jobCardTile.FontColor,
                        DashboardSubCategoryName = jobCardTile.DashboardSubCategoryName,
                        DashboardCategoryName = jobCardTile.DashboardCategoryName
                    };
                    views.Add(jobCardTitleView);
                }
            }
            return views;
        }

        public static M4PL.Entities.Job.JobCardRequest GetJobCard(this IList<APIClient.ViewModels.Job.JobCardViewView> recordData, string strRoute, long filterId = 0)
        {
            var jobCard = new M4PL.Entities.Job.JobCardRequest();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (filterId > 0)
            {
                jobCard.DashboardCategoryRelationId = filterId;
                var data = recordData.Where(x => x.Id == filterId).FirstOrDefault();
                if (data != null)
                {
                    jobCard.BackGroundColor = data.CardBackgroupColor;
                    jobCard.CardType = data.CardType;
                    jobCard.CardName = data.Name;
                }
            }
            return jobCard;
        }

        public static MvcRoute GetJobHistoryRoute(this long jobId, long parentId)
        {
            return new MvcRoute
            {
                Entity = EntitiesAlias.JobHistory,
                Area = EntitiesAlias.Job.ToString(),
                Action = MvcConstants.ActionDataView,
                OwnerCbPanel = "RecordPopupControl",
                RecordId = jobId,
                ParentRecordId = parentId,
                IsPopup = true,
            };
        }

        public static IList<JobHistory> JobHistorySorting(this IList<JobHistory> entity, string order)
        {
            if (entity == null || !entity.Any() || string.IsNullOrEmpty(order))
            {
                return entity;
            }
            string columnName = order.Split('.')[1].Split(' ')[0];
            string orderBy = order.Split('.')[1].Split(' ')[1];
            switch (columnName)
            {
                case "ChangedBy":
                    if (orderBy == "ASC")
                        return entity.OrderBy(t => t.ChangedBy).ToList();
                    else if (orderBy == "DESC")
                        return entity.OrderByDescending(t => t.ChangedBy).ToList();
                    break;

                case "ChangedDate":
                    if (orderBy == "ASC")
                        return entity.OrderBy(t => t.ChangedDate).ToList();
                    else if (orderBy == "DESC")
                        return entity.OrderByDescending(t => t.ChangedDate).ToList();
                    break;
            }
            return entity;
        }

        public static GridResult<TView> AddActionsInActionContextMenu<TView>(this GridResult<TView> _gridResult,
            MvcRoute currentRoute, ICommonCommands _commonCommands, EntitiesAlias entitiyAlias, bool isParentEntity)
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

            if (actionContextMenuAvailable && !isParentEntity)
            {
                bool? isScheduleAciton = null;
                if (route.Entity == EntitiesAlias.Job)
                {
                    route.ParentRecordId = 0;
                    var record = (IList<JobView>)_gridResult.Records;
                    if (record != null && route.JobIds != null && route.JobIds.Count() > 0)
                    {
                        var locationIds = route.JobIds.Select(long.Parse).ToList();
                        var entity = record.Where(t => locationIds.Contains(t.Id));

                        if (entity.GroupBy(t => t.ShipmentType).Count() == 1 && entity.GroupBy(t => t.JobType).Count() == 1)
                        {
                            if (entity.All(t => t.JobIsSchedule == true))
                                isScheduleAciton = true;
                            else if (entity.All(t => t.JobIsSchedule == false))
                                isScheduleAciton = false;
                            if (isScheduleAciton != null)
                                route.ParentRecordId = locationIds.FirstOrDefault();
                            else
                                route.ParentRecordId = 0;
                        }
                        else
                        {
                            route.ParentRecordId = 0;
                        }
                    }
                    else if (record != null && _gridResult.FocusedRowId > 0)
                    {
                        var entity = record.FirstOrDefault(t => t.Id == _gridResult.FocusedRowId);
                        isScheduleAciton = entity != null && entity.JobIsSchedule;
                        route.ParentRecordId = _gridResult.FocusedRowId;
                    }
                }
                if (route.Entity == EntitiesAlias.JobCard)
                {
                    route.ParentRecordId = 0;
                    var record = (IList<JobCardView>)_gridResult.Records;
                    if (record != null && route.JobIds != null && route.JobIds.Count() > 0)
                    {
                        var locationIds = route.JobIds.Select(long.Parse).ToList();
                        var entity = record.Where(t => locationIds.Contains(t.Id));

                        if (entity.GroupBy(t => t.ShipmentType).Count() == 1
                            && entity.GroupBy(t => t.JobType).Count() == 1
                            && entity.GroupBy(t => t.ProgramID).Count() == 1)
                        {
                            if (entity.All(t => t.JobIsSchedule == true))
                                isScheduleAciton = true;
                            else if (entity.All(t => t.JobIsSchedule == false))
                                isScheduleAciton = false;
                            if (isScheduleAciton != null)
                                route.ParentRecordId = locationIds.FirstOrDefault();
                            else
                                route.ParentRecordId = 0;
                        }
                        else
                            route.ParentRecordId = 0;
                    }
                    else if (record != null && _gridResult.FocusedRowId > 0)
                    {
                        var entity = record.FirstOrDefault(t => t.Id == _gridResult.FocusedRowId);
                        isScheduleAciton = entity != null && entity.JobIsSchedule;
                        route.ParentRecordId = _gridResult.FocusedRowId;
                    }
                }
                if (route.ParentRecordId > 0)
                {
                    var allActions = _commonCommands.GetJobAction(route.ParentRecordId, route.Entity.ToString(), isScheduleAciton);
                    _gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations = new List<Operation>();

                    var routeToAssign = new MvcRoute(currentRoute);
                    routeToAssign.Entity = EntitiesAlias.JobGateway;
                    routeToAssign.Action = MvcConstants.ActionGatewayActionForm;
                    routeToAssign.IsPopup = true;
                    routeToAssign.RecordId = _gridResult.FocusedRowId;
                    routeToAssign.IsPBSReport = currentRoute.Entity != EntitiesAlias.JobGateway;

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
                                newRoute.Filters.Value = String.Format("{0}-{1}", newChildOperation.LangName, singleReasonCode.PgdGatewayCode.Substring(singleReasonCode.PgdGatewayCode.IndexOf('-') + 1));

                                #region Add Contact

                                //if (singleReasonCode.GatewayCode == "Add Contact")
                                //{
                                //    var contactRoute = new M4PL.Entities.Support.MvcRoute(M4PL.Entities.EntitiesAlias.Contact, MvcConstants.ActionContactCardForm, M4PL.Entities.EntitiesAlias.Contact.ToString());
                                //    contactRoute.EntityName = (!string.IsNullOrWhiteSpace(contactRoute.EntityName)) ? contactRoute.EntityName : contactRoute.Entity.ToString();
                                //    contactRoute.IsPopup = true;
                                //    contactRoute.RecordId = 0;
                                //    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.EntityFor
                                //        = M4PL.Entities.EntitiesAlias.Contact.ToString();
                                //    contactRoute.OwnerCbPanel = "pnlJobDetail";
                                //    contactRoute.CompanyId = newRoute.CompanyId;
                                //    contactRoute.ParentEntity = EntitiesAlias.Job;
                                //    if (route.Filters != null)
                                //    {
                                //        var isValidCode = _commonCommands.IsValidJobSiteCode(Convert.ToString(route.Filters.FieldName), Convert.ToInt64(newRoute.Url));
                                //        if (string.IsNullOrEmpty(isValidCode))
                                //        {
                                //            contactRoute.Filters = new Entities.Support.Filter();
                                //            contactRoute.Filters = route.Filters;
                                //            contactRoute.PreviousRecordId = route.ParentRecordId; //Job Id
                                //            //contactRoute.IsJobParentEntity = route.IsJobParentEntity;
                                //        }
                                //    }

                                //    contactRoute.ParentRecordId = Convert.ToInt32(newRoute.Url);
                                //    if (SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity)
                                //        contactRoute.ParentRecordId = ContactAction.ProgramId;
                                //    newChildOperation.Route = contactRoute;

                                //}
                                //else

                                #endregion Add Contact

                                newChildOperation.Route = newRoute;
                                newOperation.ChildOperations.Add(newChildOperation);
                            }
                            _gridResult.GridSetting.ContextMenu[actionContextMenuIndex].ChildOperations.Add(newOperation);
                        }
                    }
                    else
                    {
                        if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                            && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Actions"))
                        {
                            var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Actions");
                            if (context != null)
                                _gridResult.GridSetting.ContextMenu.Remove(context);
                        }
                    }
                }
                else
                {
                    if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                        && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Actions"))
                    {
                        var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Actions");
                        if (context != null)
                            _gridResult.GridSetting.ContextMenu.Remove(context);
                    }
                }
            }
            else
            {
                if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                    && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Actions"))
                {
                    var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Actions");
                    if (context != null)
                        _gridResult.GridSetting.ContextMenu.Remove(context);
                }
            }

            return _gridResult;
        }

        public static GridResult<TView> AddGatewayInGatewayContextMenu<TView>(this GridResult<TView> _gridResult,
           MvcRoute currentRoute, ICommonCommands _commonCommands, bool isParentEntity)
        {
            var route = currentRoute;
            var gatewaysContextMenu = _commonCommands.GetOperation(OperationTypeEnum.Gateways);

            var gatewaysContextMenuAvailable = false;
            var gatewaysContextMenuIndex = -1;

            if (_gridResult.GridSetting.ContextMenu.Count > 0)
            {
                for (var i = 0; i < _gridResult.GridSetting.ContextMenu.Count; i++)
                {
                    if (_gridResult.GridSetting.ContextMenu[i].SysRefName.EqualsOrdIgnoreCase(gatewaysContextMenu.SysRefName))
                    {
                        gatewaysContextMenuAvailable = true;
                        gatewaysContextMenuIndex = i;
                        break;
                    }
                }
            }
            if (gatewaysContextMenuAvailable && !isParentEntity)
            {
                if (route.Entity == EntitiesAlias.Job && _gridResult.Records is IList<JobView>)
                {
                    route.IsPBSReport = true;
                    route.ParentRecordId = 0;
                    IList<JobView> record = (IList<JobView>)_gridResult.Records;
                    if (record != null && route.JobIds != null && route.JobIds.Count() > 0)
                    {
                        var jobIds = route.JobIds.Select(long.Parse).ToList();
                        var entity = record.Where(t => jobIds.Contains(t.Id));

                        if (entity.GroupBy(t => t.ShipmentType).Count() == 1
                           && entity.GroupBy(t => t.JobType).Count() == 1
                           && entity.GroupBy(t => t.JobGatewayStatus).Count() == 1)
                        {
                            route.ParentRecordId = jobIds.FirstOrDefault();
                        }
                        else
                        {
                            route.ParentRecordId = 0;
                        }
                    }
                    else if (record != null && _gridResult.FocusedRowId > 0)
                        route.ParentRecordId = _gridResult.FocusedRowId;
                }
                if (route.ParentRecordId > 0)
                {
                    var allGateways = _commonCommands.GetJobGateway((long)route.ParentRecordId);
                    _gridResult.GridSetting.ContextMenu[gatewaysContextMenuIndex].ChildOperations = new List<Operation>();

                    var routeToAssign = new MvcRoute(route);
                    routeToAssign.Entity = EntitiesAlias.JobGateway;
                    routeToAssign.Action = MvcConstants.ActionForm;
                    routeToAssign.IsPopup = true;
                    routeToAssign.RecordId = 0;
                    routeToAssign.IsPBSReport = route.IsPBSReport;

                    if (allGateways.Count > 0)
                    {
                        var groupedGateways = allGateways.GroupBy(x => x.GatewayCode);
                        foreach (var singleApptCode in groupedGateways)
                        {
                            var newOperation = new Operation();
                            var newRoute = new MvcRoute(routeToAssign);
                            newOperation.LangName = singleApptCode.First().GatewayCode; // "Add Gateway";
                            newRoute.Filters = new Entities.Support.Filter();
                            newRoute.Filters.FieldName = singleApptCode.First().GatewayCode;
                            newRoute.Filters.Value = singleApptCode.First().GwyGatewayTitle;

                            newOperation.Route = newRoute;
                            newOperation.Route.IsPBSReport = route.IsPBSReport;
                            _gridResult.GridSetting.ContextMenu[gatewaysContextMenuIndex].ChildOperations.Add(newOperation);
                        }
                    }
                    else
                    {
                        if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                            && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Gateways"))
                        {
                            var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Gateways");
                            if (context != null)
                                _gridResult.GridSetting.ContextMenu.Remove(context);
                        }
                    }
                }
                else
                {
                    if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                        && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Gateways"))
                    {
                        var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Gateways");
                        if (context != null)
                            _gridResult.GridSetting.ContextMenu.Remove(context);
                    }
                }
            }
            else
            {
                if (_gridResult.GridSetting.ContextMenu != null && _gridResult.GridSetting.ContextMenu.Count() > 0
                    && _gridResult.GridSetting.ContextMenu.Any(t => t.SysRefName == "Gateways"))
                {
                    var context = _gridResult.GridSetting.ContextMenu.FirstOrDefault(t => t.SysRefName == "Gateways");
                    if (context != null)
                        _gridResult.GridSetting.ContextMenu.Remove(context);
                }
            }

            return _gridResult;
        }

        public static DisplayMessage UploadCSVNavRate(this DisplayMessage displayMessage, long programId, DataTable csvDataTable, string[] arraynavRateUploadColumns,
            INavRateCommands navRateCommands, ICommonCommands commonCommands)
        {
            string[] columnNames = (from dc in csvDataTable.Columns.Cast<DataColumn>()
                                    select dc.ColumnName).ToArray();
            if (!arraynavRateUploadColumns.Where(p => columnNames.All(p2 => !p2.Equals(p, StringComparison.OrdinalIgnoreCase))).Any())
            {
                List<NavRateView> navRateList = Extension.ConvertDataTableToModel<NavRateView>(csvDataTable);
                StatusModel statusModel = navRateCommands.GenerateProgramPriceCostCode(navRateList);
                // To Do: Selected ProgramId need to set with the record.
                if (!statusModel.Status.Equals("Success", StringComparison.OrdinalIgnoreCase))
                {
                    displayMessage = commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCostCode);
                    displayMessage.Description = statusModel.AdditionalDetail;
                    return displayMessage;
                }
                else
                {
                    displayMessage = commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavPriceCode);
                    return displayMessage;
                }
            }
            else
            {
                displayMessage = commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCostCode);
                displayMessage.Description = "Selected file columns does not match with the standard column list, please select a valid CSV file.";
                return displayMessage;
            }
        }

        public static List<AWCDriverScrubReportRawData> GetObjectByAWCDriverScrubReportDatatable(this DataTable datatable)
        {
            try
            {
                if (datatable != null && datatable.Rows.Count > 0)
                    return datatable.AsEnumerable().Select(row => new AWCDriverScrubReportRawData()
                    {
                        QMSShippedOn = row.Field<string>("QMS ShippedOn"),
                        QMSPSDisposition = row.Field<string>("QMAPSDisposition"),
                        QMSStatusDescription = row.Field<string>("QMSStatusDescription"),
                        FouthParty = row.Field<string>("4P"),
                        ThirdParty = row.Field<string>("3P"),
                        ActualControlId = row.Field<string>("Original ControlID"),
                        QMSControlId = row.Field<string>("QMS ControlID"),
                        QRCGrouping = row.Field<string>("QRC Grouping"),
                        QRCDescription = row.Field<string>("QRC Description"),
                        ProductCategory = row.Field<string>("ProductCategory"),
                        ProductSubCategory = row.Field<string>("ProductSubCategory"),
                        ProductSubCategory2 = row.Field<string>("ProductSubCategory2"),
                        ModelName = row.Field<string>("ModelName"),
                        CustomerBusinessType = row.Field<string>("CustomerBusinessType"),
                        ChannelCD = row.Field<string>("ChannelCD"),
                        NationalAccountName = row.Field<string>("NationalAccountName"),
                        CustomerName = row.Field<string>("CustomerName"),
                        ShipFromLocation = row.Field<string>("Ship From Location"),
                        QMSRemark = row.Field<string>("QMS Remarks"),
                        DaysToAccept = row.Field<string>("Days Between Original Delivered to QMS Accepted"),
                        QMSTotalUnit = row.Field<string>("Sum of QMSUnits"),
                        QMSTotalPrice = row.Field<string>("Sum of QMSDollars"),
                    }).ToList();
                else
                    throw new Exception("There is no record present in the selected file, please select a valid CSV.");
            }
            catch (Exception ex)
            {
                throw new Exception("Incorrect format of CSV, Error: " + ex.Message);
            }
        }

        public static List<CommonDriverScrubReportRawData> GetObjectByCommonDriverScrubReportDatatable(this DataTable datatable)
        {
            try
            {
                if (datatable != null && datatable.Rows.Count > 0)
                    return datatable.AsEnumerable().Select(row => new CommonDriverScrubReportRawData()
                    {
                        QMSShippedOn = row.Field<string>("QMS ShippedOn"),
                        QMSPSDisposition = row.Field<string>("QMAPSDisposition"),
                        QMSStatusDescription = row.Field<string>("QMSStatusDescription"),
                        FouthParty = row.Field<string>("4P"),
                        ThirdParty = row.Field<string>("3P"),
                        ActualControlId = row.Field<string>("Original ControlID"),
                        QMSControlId = row.Field<string>("QMS ControlID"),
                        QRCGrouping = row.Field<string>("QRC Grouping"),
                        QRCDescription = row.Field<string>("QRC Description"),
                        ProductCategory = row.Field<string>("ProductCategory"),
                        ProductSubCategory = row.Field<string>("ProductSubCategory"),
                        ProductSubCategory2 = row.Field<string>("ProductSubCategory2"),
                        ModelName = row.Field<string>("ModelName"),
                        CustomerBusinessType = row.Field<string>("CustomerBusinessType"),
                        ChannelCD = row.Field<string>("ChannelCD"),
                        NationalAccountName = row.Field<string>("NationalAccountName"),
                        CustomerName = row.Field<string>("CustomerName"),
                        ShipFromLocation = row.Field<string>("Ship From Location"),
                        QMSRemark = row.Field<string>("QMS Remarks"),
                        DaysToAccept = row.Field<string>("Days Between Original Delivered to QMS Accepted"),
                        QMSTotalUnit = row.Field<string>("Sum of QMSUnits"),
                        QMSTotalPrice = row.Field<string>("Sum of QMSDollars"),
                    }).ToList();
                else
                    throw new Exception("There is no record present in the selected file, please select a valid CSV.");
            }
            catch (Exception ex)
            {
                throw new Exception("Incorrect format of CSV, Error: " + ex.Message);
            }
        }

        public static List<ProjectedCapacityRawData> GetObjectByProjectedCapacityReportDatatable(this DataTable datatable)
        {
            List<ProjectedCapacityRawData> rawData = null;
            int projectedYear = 0;
            try
            {
                if (datatable == null || (datatable != null && datatable.Rows == null) || (datatable != null && datatable.Rows != null && datatable.Rows.Count == 0))
                {
                    throw new Exception("There is no record present in the selected file, please select a valid CSV.");
                }
                else if (datatable != null && datatable.Columns != null && datatable.Columns.Count > 1 && !Int32.TryParse(datatable.Columns[1].ToString(), out projectedYear))
                {
                    throw new Exception("Please select a valid CSV file for upload.");
                }
                else if (datatable != null && datatable.Rows.Count > 0)
                {
                    rawData = new List<ProjectedCapacityRawData>();
                    for (int i = 0; i < datatable.Rows.Count; i++)
                    {
                        rawData.Add(new ProjectedCapacityRawData() { Year = projectedYear, Location = datatable.Rows[i][0].ToString(), ProjectedCapacity = datatable.Rows[i][1].ToString(), Size = Convert.ToInt64(datatable.Rows[i][2]) });
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Incorrect format of CSV, Error: " + ex.Message);
            }

            return rawData;
        }

        public static DisplayMessage ImportCSVToProgram(DisplayMessage displayMessage, byte[] uploadedFileData,
            string type, string uploadColumns, long _ProgramId, INavRateCommands _navRateStaticCommand,
            ICommonCommands _commonStaticCommands, DevExpress.Web.FileUploadCompleteEventArgs e)
        {
            if (string.IsNullOrEmpty(uploadColumns))
                displayMessage.Description = "CSV column list config key is missing, please add the config key in web.config.";

            string[] arrayUploadColumns = uploadColumns.Split(new string[] { "," }, StringSplitOptions.None);
            using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArray(uploadedFileData))
            {
                if (csvDataTable != null && csvDataTable.Rows.Count > 0)
                {
                    string[] columnNames = (from dc in csvDataTable.Columns.Cast<DataColumn>()
                                            select dc.ColumnName).ToArray();
                    if (!arrayUploadColumns.Where(p => columnNames.All(p2 => !p2.Equals(p, StringComparison.OrdinalIgnoreCase))).Any())
                    {
                        StatusModel statusModel = new StatusModel();
                        if (type == "Price/Cost Code")
                        {
                            List<NavRateView> navRateList = Extension.ConvertDataTableToModel<NavRateView>(csvDataTable);
                            navRateList.ForEach(x => x.ProgramId = _ProgramId);
                            statusModel = _navRateStaticCommand.GenerateProgramPriceCostCode(navRateList);
                        }
                        else if (type == "Reason Code")
                        {
                            List<PrgShipStatusReasonCodeView> reasonCodeList = Extension.ConvertDataTableToModel<PrgShipStatusReasonCodeView>(csvDataTable);
                            reasonCodeList.ForEach(x => x.PscProgramID = _ProgramId);
                            statusModel = _commonStaticCommands.GenerateReasoneCode(reasonCodeList);
                        }
                        else if (type == "Appointment Code")
                        {
                            List<PrgShipApptmtReasonCodeView> appointmentCodeList = Extension.ConvertDataTableToModel<PrgShipApptmtReasonCodeView>(csvDataTable);
                            appointmentCodeList.ForEach(x => x.PacProgramID = _ProgramId);
                            statusModel = _commonStaticCommands.GenerateAppointmentCode(appointmentCodeList);
                        }

                        // To Do: Selected ProgramId need to set with the record.
                        if (!statusModel.Status.Equals("Success", StringComparison.OrdinalIgnoreCase))
                            displayMessage.Description = statusModel.AdditionalDetail;
                        else
                            displayMessage.Description = "Records has been uploaded from the selected CSV file.";
                        e.IsValid = true;
                    }
                    else
                        displayMessage.Description = "Selected file columns does not match with the standard column list, please select a valid CSV file.";
                }
                else
                    displayMessage.Description = "There is no record present in the selected file, please select a valid CSV.";
            }
            return displayMessage;
        }
    }
}