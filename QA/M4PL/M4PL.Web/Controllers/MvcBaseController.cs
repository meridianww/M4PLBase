/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Mvc Base Controller
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MvcBase
//Purpose:                                      Contains Actions to handle and maintain generic data required for a page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Controllers
{
    public class MvcBaseController : Controller
    {
        protected ICommonCommands _commonCommands;
        public MvcRoute BaseRoute { get; set; }
        public SessionProvider SessionProvider
        {
            get { return SessionProvider.Instance; }
        }

        #region Private Methods

        private void LeftMenuRoute(LeftMenu leftMenu, MvcRoute defaultRoute)
        {
            leftMenu.Children.ToList().ForEach(mnu =>
            {
                if (!string.IsNullOrEmpty(mnu.MnuTableName) && _commonCommands.Tables.ContainsKey(mnu.MnuTableName.ToEnum<EntitiesAlias>()))// Set route only for controller not for module name
                {
                    var entity = mnu.MnuTableName.ToEnum<EntitiesAlias>();
                    var areaName = _commonCommands.Tables[entity].MainModuleName;
                    var modules = _commonCommands.Tables.Select(c => c.Value).FirstOrDefault(c => c.TblMainModuleId == leftMenu.MnuModuleId);
                    if (modules != null)
                        areaName = modules.MainModuleName;

                    mnu.Route = new MvcRoute
                    {
                        Entity = entity,
                        Action = mnu.MnuExecuteProgram,
                        Area = areaName,
                        EntityName = _commonCommands.Tables[entity].TblLangName,
                        OwnerCbPanel = WebApplicationConstants.AppCbPanel
                    };

                    //if ((mnu.Route.Action == defaultRoute.Action) && (mnu.Route.Entity == defaultRoute.Entity) && (mnu.Route.Area == defaultRoute.Area))
                    //    mnu.StatusId = 5;//Have given 5 because till 4 we already have statuses in DB
                }

                if (mnu.Route == null)
                    mnu.Route = GetPageNotFoundRoute();

                if (mnu.Children.Count > 0)
                    LeftMenuRoute(mnu, defaultRoute);
            });
            if (leftMenu.Children.Count > 0 && leftMenu.Children.FirstOrDefault() != null && leftMenu.Children.FirstOrDefault().Route != null)
                leftMenu.Route = leftMenu.Children.FirstOrDefault().Route == null ? GetPageNotFoundRoute() : new MvcRoute(leftMenu.Children.FirstOrDefault().Route, string.Empty);

        }

        private MvcRoute GetPageNotFoundRoute()
        {
            return new MvcRoute()
            {
                Action = "NotFound",
                Entity = EntitiesAlias.Common,
                Area = string.Empty,
                RecordId = 0
            };
        }


        #endregion Private Methods

        protected MvcRoute GetDefaultRoute(long jobId = 0, string tabName = "")
        {
            SessionProvider.MvcPageAction.Clear();

            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            if (jobId > 0)
            {
                var jobFormRoute = new MvcRoute(new MvcRoute(EntitiesAlias.Job, MvcConstants.ActionForm, EntitiesAlias.Job.ToString()), MvcConstants.ActionForm, jobId, 0, "pnlJobDetail");
                jobFormRoute.RecordId = jobId;
                Session["SpecialJobId"] = true;
                if (!string.IsNullOrEmpty(tabName))
                    Session["tabName"] = tabName.ToLower() == "all" ? JobDocReferenceType.Document.ToString() : tabName;
                return jobFormRoute;
            }

            if (SessionProvider.ActiveUser.LastRoute != null && SessionProvider.MvcPageAction.Count == 0)
                return SessionProvider.ActiveUser.LastRoute;

            if ((WebGlobalVariables.ModuleMenus.Count == 0) || (SessionProvider.ActiveUser.LastRoute == null))
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

            var leftMenus = (from mnu in WebGlobalVariables.ModuleMenus
                             join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
                             where mnu.MnuBreakDownStructure.StartsWith("02")
                             select mnu).ToList();
            SessionProvider.UserSecurities.ToList().ForEach(sec => leftMenus.GetNotAccessibleMenus(sec).ForEach(nmnu => leftMenus.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));
            //Comment this line if want to show on left menu if it has no operations to perform
            leftMenus.RemoveAll(mnu => mnu.Children.Count == 0);

            var defaultModule = leftMenus.LastOrDefault(x => x.MnuModuleId == SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysMainModuleId).ToInt()) ?? leftMenus.FirstOrDefault(x => x.Children.Count > 0);

            LeftMenu defaultMenu = null;
            if (defaultModule != null && defaultModule.Children.Count > 0)
                defaultMenu = defaultModule.Children.FirstOrDefault(m => !string.IsNullOrEmpty(m.MnuTableName) && m.MnuExecuteProgram.EqualsOrdIgnoreCase(SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysDefaultAction))); // because first might be ribbon and select where table/Controller name is not empty or null

            if (leftMenus.Count == 0)
            {
                return new MvcRoute { };
            }

            if (defaultMenu == null || string.IsNullOrEmpty(defaultMenu.MnuExecuteProgram) || !Enum.IsDefined(typeof(EntitiesAlias), defaultMenu.MnuTableName))
                defaultMenu = leftMenus.FirstOrDefault(x => x.Children.Count > 0).Children.FirstOrDefault(m => !string.IsNullOrEmpty(m.MnuTableName));

            var entity = defaultMenu.MnuTableName.ToEnum<EntitiesAlias>();
            var areaName = _commonCommands.Tables[entity].MainModuleName;
            var modules = _commonCommands.Tables.Select(c => c.Value).FirstOrDefault(c => c.TblMainModuleId == defaultMenu.MnuModuleId);
            if (modules != null)
                areaName = modules.MainModuleName;


            defaultMenu.Route = new MvcRoute
            {
                Entity = defaultMenu.MnuTableName.ToEnum<EntitiesAlias>(),
                Action = defaultMenu.MnuExecuteProgram,
                Area = areaName,// !string.IsNullOrEmpty(defaultMenu.MnuTableName) && _commonCommands.Tables.ContainsKey(defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()) ? _commonCommands.Tables[defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()].MainModuleName : BaseRoute.Area,
                EntityName = !string.IsNullOrEmpty(defaultMenu.MnuTableName) && _commonCommands.Tables.ContainsKey(defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()) ? _commonCommands.Tables[defaultMenu.MnuTableName.ToEnum<EntitiesAlias>()].TblLangName : BaseRoute.EntityName,
            };

            defaultMenu.Route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            ViewData[MvcConstants.DefaultRoute] = defaultMenu.Route;
            return defaultMenu.Route;
        }

        public virtual ActionResult Index(string errorMsg = null, long jobId = 0, string tabName = "")
        {
            if (SessionProvider == null || SessionProvider.ActiveUser == null || !SessionProvider.ActiveUser.IsAuthenticated)
            {
                UpdateAccessToken(null, false);
                if (jobId > 0)
                    return RedirectToAction(MvcConstants.ActionIndex, "Account", new { Area = string.Empty, jobId = jobId, tabName = tabName });
                return RedirectToAction(MvcConstants.ActionIndex, "Account", new { Area = string.Empty });
            }
            else
            {
                UpdateAccessToken(SessionProvider.ActiveUser, true);
            }
            if (SessionProvider.MvcPageAction != null && SessionProvider.MvcPageAction.Count > 0 && SessionProvider.MvcPageAction.FirstOrDefault().Key > 0)
            {
                var route = new MvcRoute(EntitiesAlias.Common, SessionProvider.MvcPageAction.FirstOrDefault().Value, string.Empty);
                route.RecordId = SessionProvider.MvcPageAction.FirstOrDefault().Key;
                SessionProvider.MvcPageAction.Clear();
                return View(route);
            }
            var defaultRoute = GetDefaultRoute(jobId, tabName);
            if (string.IsNullOrWhiteSpace(defaultRoute.Area))
            {
                var errorMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.NoSecuredModule).Description;
                Session.Abandon();
                return RedirectToAction(MvcConstants.ActionIndex, "Account", new { Area = string.Empty, errorMsg = errorMessage });
            }
            else
                return View(defaultRoute);
        }

        public ActionResult CallbackPanelPartial(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute) ?? GetDefaultRoute();

            //start- Not Found logic

            var controllerFullName = string.Format("M4PL.Web.Areas.{0}.Controllers.{1}Controller", route.Area, route.Entity.ToString());
            var cont = Assembly.GetExecutingAssembly().GetType(controllerFullName);
            if (!string.IsNullOrEmpty(route.Area) && (cont == null || cont.GetMethod(route.Action) == null))
            {
                var errorLog = new ErrorLog
                {
                    ErrRelatedTo = WebApplicationConstants.NotFoundError,
                    ErrInnerException = "Controller or action not found", // should be from database
                    ErrMessage = "Controller or action not found", // should be from database
                    ErrSource = route.Entity.ToString(),
                    ErrStackTrace = WebApplicationConstants.NotFoundError,
                    ErrAdditionalMessage = JsonConvert.SerializeObject(route)
                };
                var mvcPageAction = SessionProvider.MvcPageAction;
                mvcPageAction.Add(_commonCommands.GetOrInsErrorLog(errorLog).Id, MvcConstants.ActionNotFound);
                SessionProvider.MvcPageAction = mvcPageAction;
                route = new MvcRoute(EntitiesAlias.Common, SessionProvider.MvcPageAction.FirstOrDefault().Value, string.Empty);
                route.RecordId = SessionProvider.MvcPageAction.FirstOrDefault().Key;
            }
            SessionProvider.MvcPageAction.Clear();
            //End
            SessionProvider.ActiveUser.LastRoute = route;
            //if (DevExpress.Web.Mvc.DevExpressHelper.IsCallback)
            //    System.Threading.Thread.Sleep(100);

            //Below is to send saved grouped grid layout with request form
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity] != null
                && SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout != null)
            {
                PropertyInfo isreadonly = typeof(System.Collections.Specialized.NameValueCollection).GetProperty("IsReadOnly", BindingFlags.Instance | BindingFlags.NonPublic);
                isreadonly.SetValue(System.Web.HttpContext.Current.Request.Form, false, null);
                System.Web.HttpContext.Current.Request.Form.Add(WebUtilities.GetGridName(route), SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout);
            }

            return PartialView(MvcConstants.CallBackPanelPartial, route);
        }

        public ActionResult InnerCallbackPanelPartial(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //if (route.Action == "VocReportViewer")
            //{
            //     route = JsonConvert.DeserializeObject<Entities.Job.JobVOCReportRequest>(strRoute);
            //}

            if (route.Action.Equals(MvcConstants.ActionRibbonMenu) && route.Entity == EntitiesAlias.Common)
            {
                var arbValue = route.OwnerCbPanel;
                route = new MvcRoute(GetDefaultRoute());
                route.OwnerCbPanel = arbValue;
            }
            //if (DevExpress.Web.Mvc.DevExpressHelper.IsCallback)
            //    System.Threading.Thread.Sleep(100);

            return PartialView(MvcConstants.ViewInnerCallBackPanelPartial, route);
        }
        //public ActionResult InnerReportCallbackPanelPartial(string strRoute, List<string> Location = null,
        //    DateTime? StartDate = null, DateTime? EndDate = null, bool IsPBSReport = false)
        //{
        //    var routeObjects = JsonConvert.DeserializeObject<M4PL.Web.Models.ReportResult<M4PL.APIClient.ViewModels.Job.JobReportView>>(strRoute);           

        //    return PartialView(MvcConstants.ViewInnerReportCallBackPanelPartial, routeObjects);
        //}
        public ActionResult LeftMenu()
        {
            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }

            if (WebGlobalVariables.ModuleMenus.Count == 0 || (SessionProvider.ActiveUser.LastRoute == null))
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

            var leftMenus = (from mnu in WebGlobalVariables.ModuleMenus
                             join sec in SessionProvider.UserSecurities on mnu.MnuModuleId equals sec.SecMainModuleId
                             where mnu.MnuBreakDownStructure.StartsWith("02")
                             select mnu).ToList();

            if (!SessionProvider.ActiveUser.IsSysAdmin)
                SessionProvider.UserSecurities.ToList().ForEach(sec => leftMenus.GetNotAccessibleMenus(sec).ForEach(nmnu => leftMenus.FirstOrDefault(mnu => mnu.MnuModuleId == sec.SecMainModuleId).Children.Remove(nmnu)));
            //Comment this line if want to show on left menu if it has no operations to perform
            leftMenus.RemoveAll(mnu => mnu.Children.Count == 0);
            leftMenus.ForEach(r => LeftMenuRoute(r, GetDefaultRoute()));

            return PartialView(MvcConstants.ViewLeftMenu, leftMenus);
        }

        public virtual ActionResult RibbonMenu(string strRoute)
        {
            if (_commonCommands == null)
            {
                _commonCommands = new CommonCommands();
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.Filters != null)
            {
                if (route.Filters.FieldName == "ToggleFilter" && route.Entity == EntitiesAlias.Job)
                    route.Action = "TreeView";
            }
            route.OwnerCbPanel = WebApplicationConstants.RibbonCbPanel;

            var ribbonMenus = _commonCommands.GetRibbonMenus().ToList();

            if (WebGlobalVariables.ModuleMenus.Count == 0 || (SessionProvider.ActiveUser.LastRoute == null))
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
            ribbonMenus.ForEach(r => r.RibbonRoute(route, ribbonMenus.IndexOf(r), BaseRoute, _commonCommands, SessionProvider));
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            return PartialView(MvcConstants.ViewRibbonMenu, ribbonMenus);
        }

        public int GetorSetUserGridPageSize(int? pageSize = null)
        {
            var sysPageSize = SessionProvider.UserSettings.Settings.GetSettingByEntityAndName(_commonCommands.GetSystemSetting().Settings, EntitiesAlias.System, WebApplicationConstants.SysPageSize).ToInt();
            if (pageSize == null)
                return sysPageSize;
            else
            {
                if (pageSize != sysPageSize)
                {
                    SessionProvider.UserSettings.Settings.SetSettingByEnitityAndName(EntitiesAlias.System, WebApplicationConstants.SysPageSize, pageSize.Value.ToString());
                    _commonCommands.UpdateUserSystemSettings(SessionProvider.UserSettings);
                }
                return pageSize.Value;
            }
        }

        public virtual ActionResult ShowMessage(string strDisplayMessage)
        {
            var displayMessage = JsonConvert.DeserializeObject<DisplayMessage>(strDisplayMessage);
            var messageType = (MessageTypeEnum)Enum.Parse(typeof(MessageTypeEnum), displayMessage.MessageType);
            displayMessage.HeaderIcon = _commonCommands.GetDisplayMessageByCode(messageType, displayMessage.Code).HeaderIcon;

            return PartialView(MvcConstants.DisplayMessagePartial, displayMessage);
        }

        protected UserColumnSettings RestoreUserColumnSettings(MvcRoute route)
        {
            var currentUserSetting = new UserColumnSettings();

            var allColumnSettings = _commonCommands.GetColumnSettings(route.Entity).OrderByDescending(x => x.ColIsGroupBy);

            foreach (var singleColumnSetting in allColumnSettings)
            {
                currentUserSetting.ColTableName = singleColumnSetting.ColTableName;
                currentUserSetting.ColSortOrder += "," + singleColumnSetting.ColColumnName;
                if (!singleColumnSetting.GlobalIsVisible)
                    currentUserSetting.ColNotVisible += "," + singleColumnSetting.ColColumnName;
                if (singleColumnSetting.ColIsDefault)
                    currentUserSetting.ColIsDefault += "," + singleColumnSetting.ColColumnName;
                if (!string.IsNullOrWhiteSpace(singleColumnSetting.GridLayout))
                    currentUserSetting.ColGridLayout += "," + singleColumnSetting.GridLayout;
                if (singleColumnSetting.ColIsGroupBy)
                    currentUserSetting.ColGroupBy += "," + singleColumnSetting.ColColumnName;
            }
            currentUserSetting.ColSortOrder = (!string.IsNullOrWhiteSpace(currentUserSetting.ColSortOrder)) ? currentUserSetting.ColSortOrder.Substring(1) : currentUserSetting.ColSortOrder;
            currentUserSetting.ColNotVisible = (!string.IsNullOrWhiteSpace(currentUserSetting.ColNotVisible)) ? currentUserSetting.ColNotVisible.Substring(1) : currentUserSetting.ColNotVisible;
            currentUserSetting.ColIsDefault = (!string.IsNullOrWhiteSpace(currentUserSetting.ColIsDefault)) ? currentUserSetting.ColIsDefault.Substring(1) : currentUserSetting.ColIsDefault;
            currentUserSetting.ColGroupBy = (!string.IsNullOrWhiteSpace(currentUserSetting.ColGroupBy)) ? currentUserSetting.ColGroupBy.Substring(1) : currentUserSetting.ColGroupBy;
            currentUserSetting.ColGridLayout = (!string.IsNullOrWhiteSpace(currentUserSetting.ColGridLayout)) ? currentUserSetting.ColGridLayout.Substring(1) : currentUserSetting.ColGridLayout;

            return currentUserSetting;
        }

        #region Validation Messages

        public List<string> ValidateMessages<TView>(TView viewRecord, EntitiesAlias? currentEntity = null, bool fromBatchUpdate = false, bool isFormView = true, long? parentId = null, List<string> escapeRequiredFields = null, List<string> escapeRegexField = null, bool isNewRecord = false)
        {
            var recordId = (currentEntity != null && currentEntity.HasValue && currentEntity.Value == EntitiesAlias.SystemReference) ? (viewRecord as APIClient.ViewModels.Administration.SystemReferenceView).Id : (viewRecord as SysRefModel).Id;
            var entity = currentEntity ?? BaseRoute.Entity;
            var errorMessages = new Dictionary<string, string>();
            var props = viewRecord.GetType().GetProperties();
            var propNames = props.Select(c => c.Name).ToList();
            var columnSettings = _commonCommands.GetColumnSettings(entity).ToList();

            if (entity == EntitiesAlias.JobGateway)
                columnSettings = columnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();

            if (entity == EntitiesAlias.Contact && props[propNames.IndexOf("JobSiteCode")].GetValue(viewRecord) != null)
            {
                var result = _commonCommands.IsValidJobSiteCode(Convert.ToString(props[propNames.IndexOf("JobSiteCode")].GetValue(viewRecord)), Convert.ToInt64(props[propNames.IndexOf("ParentId")].GetValue(viewRecord)));
                if (!string.IsNullOrEmpty(result))
                {

                    errorMessages.Add("JobSiteCode", result);
                }
            }
            #region For Maskfields

            var allMaskedColumns = columnSettings.Where(x => !string.IsNullOrWhiteSpace(x.ColMask));
            foreach (var maskedColumn in allMaskedColumns)
            {
                var currentFieldValue = propNames.IndexOf(maskedColumn.ColColumnName) > 0 ? props[propNames.IndexOf(maskedColumn.ColColumnName)].GetValue(viewRecord) : null;
                if ((currentFieldValue != null) && (Convert.ToString(currentFieldValue) == WebApplicationConstants.PhoneMaskOnlyLiterals))
                    props[propNames.IndexOf(maskedColumn.ColColumnName)].SetValue(viewRecord, null);
            }
            foreach (var column in columnSettings)
            {
                if (propNames.Contains(column.ColColumnName))
                {
                    var val = props[propNames.IndexOf(column.ColColumnName)].GetValue(viewRecord);
                    if (val != null && val.GetType() == typeof(string) && string.IsNullOrWhiteSpace(Convert.ToString(val)))
                        props[propNames.IndexOf(column.ColColumnName)].SetValue(viewRecord, null);
                    if (val != null && val.GetType() == typeof(string) && !string.IsNullOrWhiteSpace(Convert.ToString(val)))
                        props[propNames.IndexOf(column.ColColumnName)].SetValue(viewRecord, Convert.ToString(val).Trim());

                }

            }

            #endregion For Maskfields

            if (escapeRequiredFields == null)
                escapeRequiredFields = new List<string>();
            if (escapeRegexField == null)
                escapeRegexField = new List<string>();

            var requiredProps = columnSettings.Where(req => req.IsRequired && !escapeRequiredFields.Contains(req.ColColumnName) && propNames.Contains(req.ColColumnName) && props[propNames.IndexOf(req.ColColumnName)].GetValue(viewRecord) == null).ToList();
            requiredProps.ForEach(req =>
            {
                if (!fromBatchUpdate || !req.DataType.EqualsOrdIgnoreCase(SQLDataTypes.Name.ToString()))
                    errorMessages.Add(req.ColColumnName, req.RequiredMessage);
            });

            var uniqueProps = columnSettings.Where(uni => uni.IsUnique && propNames.Contains(uni.ColColumnName) && props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord) != null).ToList();

            uniqueProps.ForEach(uni =>
            {
                var fieldValue = props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord);
                UniqueValidation uniqueValModel = null;
                if (entity == EntitiesAlias.PrgRefGatewayDefault && uni.ColColumnName == "PgdGatewayDefaultForJob")
                {
                    var prgRefGatewayDefault = viewRecord as PrgRefGatewayDefault;
                    uniqueValModel = new UniqueValidation
                    {
                        Entity = entity,
                        FieldName = uni.ColColumnName,
                        FieldValue = string.Format(" AND PgdShipmentType={0} AND PgdOrderType = {1} AND PgdProgramID = {2} AND GatewayTypeId ={3}  AND ID != {4}", "'" + prgRefGatewayDefault.PgdShipmentType + "'", "'" + prgRefGatewayDefault.PgdOrderType + "'", prgRefGatewayDefault.PgdProgramID, prgRefGatewayDefault.GatewayTypeId, recordId),
                        RecordId = recordId,
                        ParentFilter = viewRecord.GetParentFilter(props, entity),
                        ParentId = parentId,
                        isValidate = prgRefGatewayDefault.PgdGatewayDefaultForJob.HasValue ? (bool)prgRefGatewayDefault.PgdGatewayDefaultForJob : false
                    };
                }
                else
                {
                    uniqueValModel = new UniqueValidation { Entity = entity, FieldName = uni.ColColumnName, FieldValue = fieldValue != null ? fieldValue.ToString() : string.Empty, RecordId = recordId, ParentFilter = viewRecord.GetParentFilter(props, entity), ParentId = parentId };
                }
                if (FormViewProvider.CompositUniqueCondition.ContainsKey(entity))
                    uniqueValModel.ParentFilter += viewRecord.GetCompositUniqueFilter(props, entity);
                if (!_commonCommands.GetIsFieldUnique(uniqueValModel))
                {
                    if (errorMessages.ContainsKey(uni.ColColumnName))
                        errorMessages[uni.ColColumnName] = string.Concat(errorMessages[uni.ColColumnName], ", ", uni.UniqueMessage);
                    else
                        errorMessages.Add(uni.ColColumnName, uni.UniqueMessage);
                }
            });



            var regExProps = _commonCommands.GetValidationRegExpsByEntityAlias(entity).Where(x => !escapeRegexField.Contains(x.ValFieldName)).ToList();

            if (regExProps.Count > 0)
                foreach (var pInfo in props)
                {
                    var regExProp = regExProps.FirstOrDefault(v => v.ValFieldName == pInfo.Name);
                    if (regExProp != null)
                    {
                        if (entity == EntitiesAlias.MenuDriver && pInfo.Name.Equals(MenuDriverColumns.MnuRibbon.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            var bdsLength = Convert.ToString(props[propNames.IndexOf(MenuDriverColumns.MnuBreakDownStructure.ToString())].GetValue(viewRecord)).Length;
                            var setPropValue = pInfo.GetValue(viewRecord);
                            if (setPropValue.ToBoolean() && bdsLength == 11)
                                setPropValue = null;
                            else if (!setPropValue.ToBoolean() && bdsLength == 8)
                                setPropValue = null;

                            ValidateLogic(viewRecord, props, pInfo.Name, pInfo.PropertyType, setPropValue, ref errorMessages, regExProp);
                        }
                        else
                            ValidateLogic(viewRecord, props, pInfo.Name, pInfo.PropertyType, pInfo.GetValue(viewRecord), ref errorMessages, regExProp);
                    }

                }

            foreach (var errMsg in errorMessages)
                ModelState.UpdateModelError(errMsg.Key, errMsg.Value);

            return errorMessages.Select(err => err.Value).ToList();
        }

        private static bool IsNullableType(Type type)
        {
            return type.IsGenericType && type.GetGenericTypeDefinition().Equals(typeof(Nullable<>));
        }

        protected void ValidateLogic<TView>(TView viewRecord, PropertyInfo[] props, string propertyName, Type propertyType, object propValue, ref Dictionary<string, string> errorMessages, ValidationRegEx regExProp)
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
                            propName = regExValue.ToString();

                            var reV = regExValue.ToString().Split('[');

                            if (reV.Count() > 1)
                                propName = reV[1].Split(']')[0];

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

        public string GetParentFilter<TView>(TView viewRecord, PropertyInfo[] props, EntitiesAlias? currentEntity = null)
        {
            var entity = currentEntity ?? BaseRoute.Entity;
            string parentFilter = null;
            var propNames = props.Select(c => c.Name).ToList();
            switch (entity)
            {
                case EntitiesAlias.PrgRefGatewayDefault:
                    parentFilter = string.Format(" AND PgdProgramID ={0} ", props[propNames.IndexOf("PgdProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgRole:
                    parentFilter = string.Format(" AND ProgramID ={0} ", props[propNames.IndexOf("ProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgBillableRate:
                    parentFilter = string.Format(" AND PbrPrgrmID ={0} ", props[propNames.IndexOf("PbrPrgrmID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgCostRate:
                    parentFilter = string.Format(" AND PcrPrgrmID ={0} ", props[propNames.IndexOf("PcrPrgrmID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgShipStatusReasonCode:
                    parentFilter = string.Format(" AND PscProgramID ={0} ", props[propNames.IndexOf("PscProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgShipApptmtReasonCode:
                    parentFilter = string.Format(" AND PacProgramID ={0} ", props[propNames.IndexOf("PacProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgRefAttributeDefault:
                    parentFilter = string.Format(" AND ProgramID ={0} ", props[propNames.IndexOf("ProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgMvoc:
                    parentFilter = string.Format(" AND VocProgramID ={0} ", props[propNames.IndexOf("VocProgramID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.PrgMvocRefQuestion:
                    parentFilter = string.Format(" AND MVOCID ={0} ", props[propNames.IndexOf("MVOCID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.Customer:
                    parentFilter = string.Format(" AND CustOrgId ={0} ", props[propNames.IndexOf("OrganizationId")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.CustBusinessTerm:
                    parentFilter = string.Format(" AND CbtCustomerId ={0} ", props[propNames.IndexOf("CbtCustomerId")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.CustFinancialCalendar:
                    parentFilter = string.Format(" AND CustID ={0} ", props[propNames.IndexOf("CustID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.CustContact:
                    parentFilter = string.Format(" AND ConPrimaryRecordId ={0} ", props[propNames.IndexOf("ConPrimaryRecordId")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.CustDcLocation:
                    parentFilter = string.Format(" AND CdcCustomerID ={0} ", props[propNames.IndexOf("CdcCustomerID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.CustDocReference:
                    parentFilter = string.Format(" AND CdrCustomerID ={0} ", props[propNames.IndexOf("CdrCustomerID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.Vendor:
                    parentFilter = string.Format(" AND VendOrgID ={0} ", props[propNames.IndexOf("OrganizationId")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.VendBusinessTerm:
                    parentFilter = string.Format(" AND VbtVendorID ={0} ", props[propNames.IndexOf("VbtVendorID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.VendFinancialCalendar:
                    parentFilter = string.Format(" AND VendID ={0} ", props[propNames.IndexOf("VendID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.VendContact:
                    parentFilter = string.Format(" AND ConPrimaryRecordId ={0} ", props[propNames.IndexOf("ConPrimaryRecordId")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.VendDcLocation:
                    parentFilter = string.Format(" AND VdcVendorID ={0} ", props[propNames.IndexOf("VdcVendorID")].GetValue(viewRecord).ToString());
                    break;

                case EntitiesAlias.VendDocReference:
                    parentFilter = string.Format(" AND VdrVendorID ={0} ", props[propNames.IndexOf("VdrVendorID")].GetValue(viewRecord).ToString());
                    break;
            }

            return parentFilter;
        }

        #endregion Validation Messages

        public ActionResult CallBackError(string DXCallbackErrorMessage)
        {
            if (SessionProvider != null)
            {
                var errorLog = new ErrorLog
                {
                    ErrRelatedTo = WebApplicationConstants.DXCallBackError,
                    ErrInnerException = DXCallbackErrorMessage,
                    ErrMessage = "Devexpress call back issue",
                    ErrSource = SessionProvider.ActiveUser.LastRoute != null ? SessionProvider.ActiveUser.LastRoute.Entity.ToString() : "CallBack Issue",
                    ErrStackTrace = DXCallbackErrorMessage,
                    ErrAdditionalMessage = SessionProvider.ActiveUser.LastRoute != null ? JsonConvert.SerializeObject(SessionProvider.ActiveUser.LastRoute) : string.Empty
                };
                _commonCommands = _commonCommands ?? new CommonCommands { ActiveUser = SessionProvider.ActiveUser };
                var mvcPageAction = SessionProvider.MvcPageAction;
                mvcPageAction.Add(_commonCommands.GetOrInsErrorLog(errorLog).Id, MvcConstants.ActionNotFound);
                SessionProvider.MvcPageAction = mvcPageAction;
            }
            return RedirectToAction("Index");
        }

        protected ActionResult BaseNotFound(MvcRoute route, string errMessage)
        {
            var errorLog = new ErrorLog
            {
                ErrRelatedTo = WebApplicationConstants.NotFoundError,
                ErrInnerException = "Controller or action not found", // should be from database
                ErrMessage = errMessage,
                ErrSource = route.Entity.ToString(),
                ErrStackTrace = WebApplicationConstants.NotFoundError,
                ErrAdditionalMessage = JsonConvert.SerializeObject(route)
            };
            _commonCommands = _commonCommands ?? new CommonCommands { ActiveUser = SessionProvider.ActiveUser };
            return PartialView(MvcConstants.ViewNotFound, _commonCommands.GetOrInsErrorLog(errorLog));

        }

        public List<string> GetPrimaryKeyColumns()
        {
            return new List<string>() {
                CommonColumns.Id.ToString(),
                ScannerTablesPrimaryColumnName.OSDID.ToString(),
                ScannerTablesPrimaryColumnName.ReasonID.ToString(),
                ScannerTablesPrimaryColumnName.RequirementID.ToString(),
                ScannerTablesPrimaryColumnName.ServiceID.ToString(),
                ScannerTablesPrimaryColumnName.ReturnReasonID.ToString(),
            };
        }

        public List<string> GetDateColumns()
        {
            return new List<string>() {
                CommonColumns.DateEntered.ToString(),
                CommonColumns.EnteredBy.ToString(),
                CommonColumns.DateChanged.ToString(),
                CommonColumns.ChangedBy.ToString()
            };
        }


        protected void UpdateAccessToken(ActiveUser activeUser, bool status)
        {
            var authTokenCookie = HttpContext.Response?.Cookies;
            if (authTokenCookie[WebApplicationConstants.AuthTokenCookie] != null)
                authTokenCookie.Remove(WebApplicationConstants.AuthTokenCookie);
            if (status  && activeUser != null)
                authTokenCookie.Add(new HttpCookie(WebApplicationConstants.AuthTokenCookie, activeUser.AuthToken));
        }

    }
}