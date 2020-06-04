/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CommonCommands
Purpose:                                      Client to consume M4PL API called CommonController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Attachment;
using M4PL.APIClient.ViewModels.Contact;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.MasterTables;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Common
{
    public class CommonCommands : ICommonCommands
    {
        private readonly string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
        public ActiveUser ActiveUser { get; set; }

        private readonly RestClient _restClient;

        public string RouteSuffix = "Commons";

        public CommonCommands()
        {
            _restClient = new RestClient(new Uri(_baseUri));
        }

        #region Cached Result

        public IDictionary<EntitiesAlias, TableReference> Tables
        {
            get
            {
                if (CoreCache.Tables.Count == 0)
                {
                    CoreCache.Tables.Clear();
                    var tables = GetTablesFromApi().ToList();
                    tables.ForEach(tab =>
                    {
                        if (Enum.IsDefined(typeof(EntitiesAlias), tab.SysRefName) && tab.SysRefName.ToEnum<EntitiesAlias>() != 0)
                            CoreCache.Tables.Add(tab.SysRefName.ToEnum<EntitiesAlias>(), tab);
                    });
                }
                return CoreCache.Tables;
            }
        }

        /// <summary>
        /// Route to call AppMenus
        /// </summary>
        /// <param name="lookupId"></param>
        /// <returns></returns>
        public IList<IdRefLangName> GetIdRefLangNames(int lookupId, bool forceUpdate = false)
        {
            if (!CoreCache.IdRefLangNames.ContainsKey(ActiveUser.LangCode))
                CoreCache.IdRefLangNames.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<int, IList<IdRefLangName>>());
            if (!CoreCache.IdRefLangNames[ActiveUser.LangCode].ContainsKey(lookupId))
                CoreCache.IdRefLangNames[ActiveUser.LangCode].GetOrAdd(lookupId, new List<IdRefLangName>());
            if (!CoreCache.IdRefLangNames[ActiveUser.LangCode][lookupId].Any() || forceUpdate)
                CoreCache.IdRefLangNames[ActiveUser.LangCode].AddOrUpdate(lookupId, GetIdRefLangNamesFromApi(lookupId, forceUpdate));
            return CoreCache.IdRefLangNames[ActiveUser.LangCode][lookupId];
        }

        /// <summary>
        /// Route to call RefLanguagesNames
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>

        public IList<PageInfo> GetPageInfos(EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!CoreCache.PageInfos.ContainsKey(ActiveUser.LangCode))
                CoreCache.PageInfos.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>());
            if (!CoreCache.PageInfos[ActiveUser.LangCode].ContainsKey(entity))
                CoreCache.PageInfos[ActiveUser.LangCode].GetOrAdd(entity, new List<PageInfo>());
            if (!CoreCache.PageInfos[ActiveUser.LangCode][entity].Any() || forceUpdate)
                CoreCache.PageInfos[ActiveUser.LangCode].AddOrUpdate(entity, GetPageInfosFromApi(entity, forceUpdate));
            return CoreCache.PageInfos[ActiveUser.LangCode][entity];
        }

        /// <summary>
        /// Route to call Operation
        /// </summary>
        /// <param name="operationType"></param>
        /// <returns></returns>

        public Operation GetOperation(OperationTypeEnum operationType, bool forceUpdate = false)
        {
            if (!CoreCache.Operations.ContainsKey(ActiveUser.LangCode) || !CoreCache.Operations[ActiveUser.LangCode].ContainsKey(LookupEnums.OperationType))
                GetOperations(LookupEnums.OperationType);
            var operation = CoreCache.Operations[ActiveUser.LangCode][LookupEnums.OperationType].FirstOrDefault(op => op.SysRefName.Equals(operationType.ToString()));
            if (operation != null) operation.IsPopup = false;
            return operation;
        }

        /// <summary>
        /// Functio to get Page Information
        /// </summary>
        /// <param name="messageType"></param>
        /// <param name="messageCode"></param>
        /// <returns></returns>

        public DisplayMessage GetDisplayMessageByCode(MessageTypeEnum messageType, string messageCode, bool forceUpdate = false)
        {
            if (!CoreCache.DisplayMessages.ContainsKey(ActiveUser.LangCode))
                CoreCache.DisplayMessages.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<string, DisplayMessage>());
            if (!CoreCache.DisplayMessages[ActiveUser.LangCode].ContainsKey(messageCode))
                CoreCache.DisplayMessages[ActiveUser.LangCode].GetOrAdd(messageCode, GetDisplayMessageFromApi(messageType, messageCode, forceUpdate));
            else if (CoreCache.DisplayMessages[ActiveUser.LangCode][messageCode] == null || forceUpdate)
                CoreCache.DisplayMessages[ActiveUser.LangCode].AddOrUpdate(messageCode, GetDisplayMessageFromApi(messageType, messageCode, forceUpdate));
            return CoreCache.DisplayMessages[ActiveUser.LangCode][messageCode];
        }

        /// <summary>
        /// Route to call Display Message based on Message Code
        /// </summary>
        /// <returns></returns>

        public IList<RibbonMenu> GetRibbonMenus(bool forceUpdate = false)
        {
            if (!CoreCache.RibbonMenus.ContainsKey(ActiveUser.LangCode))
                CoreCache.RibbonMenus.GetOrAdd(ActiveUser.LangCode, new List<RibbonMenu>());
            if (!CoreCache.RibbonMenus[ActiveUser.LangCode].Any() || forceUpdate)
                CoreCache.RibbonMenus.AddOrUpdate(ActiveUser.LangCode, GetRibbonMenusFromApi(forceUpdate));
            return CoreCache.RibbonMenus[ActiveUser.LangCode];
        }

        public virtual IList<ViewModels.ColumnSetting> GetColumnSettings(EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!CoreCache.ColumnSettings.ContainsKey(ActiveUser.LangCode))
                CoreCache.ColumnSettings.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<EntitiesAlias, IList<ViewModels.ColumnSetting>>());

            if (!CoreCache.ColumnSettings[ActiveUser.LangCode].ContainsKey(entity))
                CoreCache.ColumnSettings[ActiveUser.LangCode].GetOrAdd(entity, GetColumnSettingsFromApi(entity, forceUpdate));
            else if (!CoreCache.ColumnSettings[ActiveUser.LangCode][entity].Any() || forceUpdate)
            {
                var columnSettings = GetColumnSettingsFromApi(entity, forceUpdate);
                CoreCache.ColumnSettings[ActiveUser.LangCode].AddOrUpdate(entity, columnSettings, (key, oldValue) => columnSettings);
            }
            return CoreCache.ColumnSettings[ActiveUser.LangCode][entity];
        }

        public virtual IList<ViewModels.ColumnSetting> GetGridColumnSettings(EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false)
        {
            if (!CoreCache.GridColumnSettings.ContainsKey(ActiveUser.LangCode))
                CoreCache.GridColumnSettings.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<EntitiesAlias, IList<ViewModels.ColumnSetting>>());

            if (!CoreCache.GridColumnSettings[ActiveUser.LangCode].ContainsKey(entity))
                CoreCache.GridColumnSettings[ActiveUser.LangCode].GetOrAdd(entity, GetGridColumnSettingsFromApi(entity, forceUpdate, isGridSetting));
            else if (!CoreCache.GridColumnSettings[ActiveUser.LangCode][entity].Any() || forceUpdate)
            {
                var columnSettings = GetGridColumnSettingsFromApi(entity, forceUpdate, isGridSetting);
                CoreCache.GridColumnSettings[ActiveUser.LangCode].AddOrUpdate(entity, columnSettings, (key, oldValue) => columnSettings);
            }
            return CoreCache.GridColumnSettings[ActiveUser.LangCode][entity];
        }

        public virtual IList<ValidationRegEx> GetValidationRegExpsByEntityAlias(EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!CoreCache.ValidationRegExpressions.ContainsKey(ActiveUser.LangCode))
                CoreCache.ValidationRegExpressions.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>());
            if (!CoreCache.ValidationRegExpressions[ActiveUser.LangCode].ContainsKey(entity))
                CoreCache.ValidationRegExpressions[ActiveUser.LangCode].GetOrAdd(entity, GetValidationRegExpsFromApi(entity, forceUpdate));
            else if (!CoreCache.ValidationRegExpressions[ActiveUser.LangCode][entity].Any() || forceUpdate)
                CoreCache.ValidationRegExpressions[ActiveUser.LangCode].AddOrUpdate(entity, GetValidationRegExpsFromApi(entity, forceUpdate));
            return CoreCache.ValidationRegExpressions[ActiveUser.LangCode][entity];
        }

        public void ReloadCacheForAllEntites()
        {
            if (CoreCache.ValidationRegExpressions.ContainsKey(ActiveUser.LangCode))
            {
                foreach (var entity in CoreCache.ValidationRegExpressions[ActiveUser.LangCode])
                {
                    CoreCache.ValidationRegExpressions[ActiveUser.LangCode].AddOrUpdate(entity.Key, GetValidationRegExpsFromApi(entity.Key, true));
                    var columnSettings = GetColumnSettingsFromApi(entity.Key, true);
                    CoreCache.ColumnSettings[ActiveUser.LangCode].AddOrUpdate(entity.Key, columnSettings, (key, oldValue) => columnSettings);
                }
            }
        }

        public object GetMasterTableObject(EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!CoreCache.MasterTables.ContainsKey(ActiveUser.LangCode))
                CoreCache.MasterTables.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<EntitiesAlias, object>());
            if (!CoreCache.MasterTables[ActiveUser.LangCode].ContainsKey(entity))
                CoreCache.MasterTables[ActiveUser.LangCode].GetOrAdd(entity, GetMasterTableObjectFromApi(entity, forceUpdate));
            else if (CoreCache.MasterTables[ActiveUser.LangCode][entity] == null || forceUpdate)
                CoreCache.MasterTables[ActiveUser.LangCode].AddOrUpdate(entity, GetMasterTableObjectFromApi(entity, forceUpdate));
            return CoreCache.MasterTables[ActiveUser.LangCode][entity];
        }

        public IList<ConditionalOperator> GetConditionalOperators(bool forceUpdate = false)
        {
            if (!CoreCache.ConditionalOperators.ContainsKey(ActiveUser.LangCode) || !CoreCache.ConditionalOperators[ActiveUser.LangCode].Any())
            {
                var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ConditionalOperators");
                var conditionalOperators = JsonConvert.DeserializeObject<ApiResult<ConditionalOperator>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)).Content).Results;
                CoreCache.ConditionalOperators.GetOrAdd(ActiveUser.LangCode, conditionalOperators);
            }
            return CoreCache.ConditionalOperators[ActiveUser.LangCode];
        }

        public SysSetting GetSystemSetting(bool forceUpdate = false)
        {
            if (!CoreCache.SysSettings.ContainsKey(ActiveUser.LangCode))
                CoreCache.SysSettings.GetOrAdd(ActiveUser.LangCode, new SysSetting());
            if (CoreCache.SysSettings[ActiveUser.LangCode].Id == 0 || forceUpdate)
                CoreCache.SysSettings[ActiveUser.LangCode] = GetSystemSettingsFromApi(forceUpdate);
            return CoreCache.SysSettings[ActiveUser.LangCode];
        }

        #endregion Cached Result

        public int GetLookupIdByName(string lookupName)
        {
            if (CoreCache.IdRefLangNames.ContainsKey(ActiveUser.LangCode))
            {
                foreach (KeyValuePair<int, IList<IdRefLangName>> lookup in CoreCache.IdRefLangNames[ActiveUser.LangCode])
                {
                    var lookupId = lookup.Value.FirstOrDefault(lk => lk.SysRefName.Equals(lookupName, StringComparison.OrdinalIgnoreCase)).SysRefId;
                    if (lookupId > 0)
                        return lookupId;
                }
            }
            return 0;
        }

        public List<EnumKeyValue> GetContactType(string lookupName)
        {
            List<EnumKeyValue> enumValue = new List<EnumKeyValue>();
            switch (lookupName.ToUpper())
            {
                case "CUSTOMER":
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Customer, Value = ContactType.Customer.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Driver, Value = ContactType.Driver.ToString() });
                    break;
                case "VENDOR":
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Driver, Value = ContactType.Driver.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Vendor, Value = ContactType.Vendor.ToString() });
                    break;
                case "ORGANIZATION":
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Agent, Value = ContactType.Agent.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Consultant, Value = ContactType.Consultant.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Employee, Value = ContactType.Employee.ToString() });
                    break;
                default:
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Agent, Value = ContactType.Agent.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Consultant, Value = ContactType.Consultant.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Customer, Value = ContactType.Customer.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Driver, Value = ContactType.Driver.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Employee, Value = ContactType.Employee.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Vendor, Value = ContactType.Vendor.ToString() });
                    enumValue.Add(new EnumKeyValue() { Key = (int)ContactType.Other, Value = ContactType.Other.ToString() });
                    break;
            }

            return enumValue;
        }

        /// <summary>
        /// Route to call User Securities
        /// </summary>
        /// <returns></returns>

        public IList<UserSecurity> GetUserSecurities(ActiveUser activeUser)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserSecurities");
            return JsonConvert.DeserializeObject<ApiResult<UserSecurity>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(activeUser)).Content).Results;
        }

        /// <summary>
        /// Route to call Ref role  Securities
        /// </summary>
        /// <returns></returns>

        public IList<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "RefRoleSecurities");
            return JsonConvert.DeserializeObject<ApiResult<UserSecurity>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(activeUser)).Content).Results;
        }

        /// <summary>
        ///  Route to call User SubSecurities
        /// </summary>
        /// <param name="secByRoleId"></param>
        /// <param name="mainModuleId"></param>
        /// <returns></returns>

        public IList<UserSubSecurity> GetUserSubSecurities(long secByRoleId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserSubSecurities");
            return JsonConvert.DeserializeObject<ApiResult<UserSubSecurity>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)
                .AddParameter("secByRoleId", secByRoleId)).Content).Results;
        }

        public IList<LeftMenu> GetModuleMenus()
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ModuleMenus");
            return JsonConvert.DeserializeObject<ApiResult<LeftMenu>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)).Content).Results;
        }

        public virtual UserColumnSettings GetUserColumnSettings(EntitiesAlias entity)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserColumnSettings");
            var userColumnSettings = JsonConvert.DeserializeObject<ApiResult<UserColumnSettings>>(
              _restClient.Execute(
                  HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("entity", entity)).Content).Results.FirstOrDefault();
            return userColumnSettings;
        }

        public SysSetting GetUserSysSettings()
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserSysSettings");
            var userSysSetting = JsonConvert.DeserializeObject<ApiResult<SysSetting>>(
              _restClient.Execute(
                  HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)).Content).Results.FirstOrDefault();
            return userSysSetting;
        }

        public bool GetIsFieldUnique(UniqueValidation uniqueValidation)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "IsUniqueField");
            return JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser)
                .AddJsonBody(uniqueValidation)).Content).Results.First();
        }

        public string IsValidJobSiteCode(string jobSiteCode, long programId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "IsValidJobSiteCode");
            var request = HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser);
            request.AddParameter("jobSiteCode", jobSiteCode);
            request.AddParameter("programId", programId);
            var content = _restClient.Execute(request).Content;
            var result = JsonConvert.DeserializeObject<ApiResult<string>>(content).Results.First();
            return result;

        }
        public long GetVendorIdforSiteCode(string jobSiteCode, long programId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetVendorIdforSiteCode");
            var request = HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser);
            request.AddParameter("jobSiteCode", jobSiteCode);
            request.AddParameter("programId", programId);
            var content = _restClient.Execute(request).Content;
            var result = JsonConvert.DeserializeObject<ApiResult<long>>(content).Results.FirstOrDefault();
            return result;

        }


        public bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UpdSysAccAndConBridgeRole");
            return JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser)
                .AddJsonBody(systemAccount)).Content).Results.First();
        }
        public UserColumnSettings InsAndUpdChooseColumn(UserColumnSettings userColumnSettings)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "InsAndUpdChooseColumn");
            return JsonConvert.DeserializeObject<ApiResult<UserColumnSettings>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser)
                .AddObject(userColumnSettings)).Content).Results.FirstOrDefault();
        }

        #region Private Methods

        public IList<RibbonMenu> GetRibbonMenusFromApi(bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "RibbonMenus");
            return JsonConvert.DeserializeObject<ApiResult<RibbonMenu>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        public IList<TableReference> GetTablesFromApi(bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "Tables");
            return JsonConvert.DeserializeObject<ApiResult<TableReference>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private IList<IdRefLangName> GetIdRefLangNamesFromApi(int lookupId, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "IdRefLangNames");
            return JsonConvert.DeserializeObject<ApiResult<IdRefLangName>>(
                _restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, routeSuffix,
                        ActiveUser).AddParameter("lookupId", lookupId).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private IList<Operation> GetOperations(LookupEnums lookup, bool forceUpdate = false)
        {
            if (!CoreCache.Operations.ContainsKey(ActiveUser.LangCode))
                CoreCache.Operations.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<LookupEnums, IList<Operation>>());
            if (!CoreCache.Operations[ActiveUser.LangCode].ContainsKey(lookup))
                CoreCache.Operations[ActiveUser.LangCode].GetOrAdd(lookup, new List<Operation>());
            if (!CoreCache.Operations[ActiveUser.LangCode][lookup].Any())
                CoreCache.Operations[ActiveUser.LangCode].AddOrUpdate(lookup, GetOperationsFromApi(lookup, forceUpdate));
            return CoreCache.Operations[ActiveUser.LangCode][lookup];
        }

        private IList<Operation> GetOperationsFromApi(LookupEnums lookup, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "Operations");
            return JsonConvert.DeserializeObject<ApiResult<Operation>>(
                _restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, routeSuffix,
                        ActiveUser).AddParameter("lookup", lookup).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private IList<PageInfo> GetPageInfosFromApi(EntitiesAlias entity, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "PageAndTabNames");
            return JsonConvert.DeserializeObject<ApiResult<PageInfo>>(
                _restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, routeSuffix,
                        ActiveUser).AddParameter("entity", entity).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private object GetMasterTableObjectFromApi(EntitiesAlias entity, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "MasterTables");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("entity", entity).AddParameter("forceUpdate", forceUpdate)).Content;
            switch (entity)
            {
                case EntitiesAlias.ChooseColumn:
                    return JsonConvert.DeserializeObject<ApiResult<ChooseColumn>>(content).Results;

                default:
                    break;
            }
            return new object();
        }

        private DisplayMessage GetDisplayMessageFromApi(MessageTypeEnum messageType, string messageCode, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "DisplayMessage");
            return JsonConvert.DeserializeObject<ApiResult<DisplayMessage>>(
                _restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)
                        .AddParameter("messageType", messageType.ToString())
                        .AddParameter("messageCode", messageCode).AddParameter("forceUpdate", forceUpdate)).Content).Results.FirstOrDefault();
        }

        private IList<ValidationRegEx> GetValidationRegExpsFromApi(EntitiesAlias entity, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ValidationRegExps");
            return JsonConvert.DeserializeObject<ApiResult<ValidationRegEx>>(_restClient.Execute(
                      HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("entity", entity).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private IList<ViewModels.ColumnSetting> GetColumnSettingsFromApi(EntitiesAlias entity, bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ColumnSettings");
            return JsonConvert.DeserializeObject<ApiResult<ViewModels.ColumnSetting>>(_restClient.Execute(
                      HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("entity", entity).AddParameter("forceUpdate", forceUpdate)).Content).Results;
        }

        private IList<ViewModels.ColumnSetting> GetGridColumnSettingsFromApi(EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GridColumnSettings");
            return JsonConvert.DeserializeObject<ApiResult<ViewModels.ColumnSetting>>(_restClient.Execute(
                      HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)
                      .AddParameter("entity", entity)
                      .AddParameter("forceUpdate", forceUpdate)
                      .AddParameter("isGridSetting", isGridSetting)).Content).Results;
        }

        #endregion Private Methods

        public int SaveBytes(ByteArray byteArray, byte[] bytes)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "SaveBytes");
            var request = HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser);
            request.AddJsonBody(byteArray);
            request.AddFileBytes("PostedFile", (bytes != null && bytes.Length > 1) ? bytes : new byte[] { }, byteArray.FieldName, "multipart/form-data");
            var result = JsonConvert.DeserializeObject<ApiResult<int>>(_restClient.Execute(request).Content).Results.FirstOrDefault();
            return result;
        }

        public IList<LookupReference> GetRefLookup(EntitiesAlias entitiesAlias)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "RefLookup");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("entitiesAlias", entitiesAlias.ToString())).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");

            return JsonConvert.DeserializeObject<ApiResult<LookupReference>>(content).Results;
        }

        public bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "CheckRecordUsed");
            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(
                _restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("allRecordIds", allRecordIds).AddParameter("entity", entity.ToString())).Content).Results.FirstOrDefault();
            return result;
        }

        public object GetPagedSelectedFieldsByTable(DropDownInfo dropDownDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "PagedSelectedFields");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(dropDownDataInfo)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            switch (dropDownDataInfo.Entity)
            {
                case EntitiesAlias.Contact:
                    return JsonConvert.DeserializeObject<ApiResult<ContactComboBox>>(content).Results;

                case EntitiesAlias.ProgramContact:
                    return JsonConvert.DeserializeObject<ApiResult<ContactView>>(content).Results;

                case EntitiesAlias.Organization:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Organization.OrganizationView>>(content).Results;

                case EntitiesAlias.Customer:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Customer.CustomerView>>(content).Results;

                case EntitiesAlias.SecurityByRole:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.SecurityByRoleView>>(content).Results;

                case EntitiesAlias.Program:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.ProgramView>>(content).Results;

                case EntitiesAlias.Job:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Job.JobView>>(content).Results;

                case EntitiesAlias.VendDcLocation:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Vendor.VendDcLocationView>>(content).Results;

                case EntitiesAlias.Vendor:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Vendor.VendorView>>(content).Results;

                case EntitiesAlias.TableReference:
                case EntitiesAlias.EdiMappingTable:
                    return JsonConvert.DeserializeObject<ApiResult<TableReference>>(content).Results;

                case EntitiesAlias.SystemReference:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.SystemReferenceView>>(content).Results;

                case EntitiesAlias.Validation:
                    return JsonConvert.DeserializeObject<ApiResult<TableReference>>(content).Results;

                case EntitiesAlias.State:
                    return JsonConvert.DeserializeObject<ApiResult<State>>(content).Results;

                case EntitiesAlias.ColumnAlias:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.ColumnAliasView>>(content).Results;

                case EntitiesAlias.OrgRefRole:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Organization.OrgRefRoleView>>(content).Results;

                case EntitiesAlias.PrgVendLocation:
                case EntitiesAlias.PrgVendLocationCodeLookup:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.PrgVendLocationView>>(content).Results;

                case EntitiesAlias.MenuDriver:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.MenuDriverView>>(content).Results;

                case EntitiesAlias.Report:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.ReportView>>(content).Results;

                case EntitiesAlias.AppDashboard:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.AppDashboardView>>(content).Results;

                case EntitiesAlias.Lookup:
                    return JsonConvert.DeserializeObject<ApiResult<IdRefLangName>>(content).Results;

                case EntitiesAlias.PrgRefRole:
                    return JsonConvert.DeserializeObject<ApiResult<OrgRole>>(content).Results;

                case EntitiesAlias.ProgramRole:
                    return JsonConvert.DeserializeObject<ApiResult<ProgramRole>>(content).Results;
                case EntitiesAlias.PrgShipApptmtReasonCode:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.PrgShipApptmtReasonCodeView>>(content).Results;
                case EntitiesAlias.PrgShipStatusReasonCode:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.PrgShipStatusReasonCodeView>>(content).Results;
                case EntitiesAlias.Company:
                    return JsonConvert.DeserializeObject<ApiResult<CompanyComboBox>>(content).Results;
                case EntitiesAlias.RollUpBillingJob:
                    return JsonConvert.DeserializeObject<ApiResult<ProgramRollupBillingJob>>(content).Results;

                case EntitiesAlias.EDISummaryHeader:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Administration.ColumnAliasView>>(content).Results;

                case EntitiesAlias.JobCargo:
                    return JsonConvert.DeserializeObject<ApiResult<CargoComboBox>>(content).Results;
                case EntitiesAlias.GwyExceptionCode:
                    return JsonConvert.DeserializeObject<ApiResult<GwyExceptionCodeComboBox>>(content).Results;
                case EntitiesAlias.GwyExceptionStatusCode:
                    return JsonConvert.DeserializeObject<ApiResult<GwyExceptionStatusCodeComboBox>>(content).Results;
                case EntitiesAlias.PrgRefGatewayDefault:
                    return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.PrgRefGatewayDefaultView>>(content).Results;
            }
            return new object();
        }

        public object GetProgramDescendants(DropDownInfo dropDownDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetProgramDescendants");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(dropDownDataInfo)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            return JsonConvert.DeserializeObject<ApiResult<ViewModels.Program.ProgramView>>(content).Results;


        }
        public ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ByteArrayByIdAndEntity");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(byteArray)).Content;
            return JsonConvert.DeserializeObject<ApiResult<ByteArray>>(content).Results.FirstOrDefault();
        }

        public ContactView GetContactById(long recordId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ContactById");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("recordId", recordId)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            return JsonConvert.DeserializeObject<ApiResult<ContactView>>(content).Results.FirstOrDefault();
        }

        public ContactView GetContactAddressByCompany(long companyId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ContactAddressByCompany");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("companyId", companyId)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            return JsonConvert.DeserializeObject<ApiResult<ContactView>>(content).Results.FirstOrDefault();
        }

        public ContactView ContactCardAddOrEdit(ContactView contactView, string customRouteSuffix = "")
        {
            var routeSuffix = string.Format("{0}/{1}", !string.IsNullOrEmpty(customRouteSuffix) ? customRouteSuffix : RouteSuffix, "ContactCardAddOrEdit");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(contactView)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            return JsonConvert.DeserializeObject<ApiResult<ContactView>>(content).Results.FirstOrDefault();
        }

        public int GetLastItemNumber(PagedDataInfo pagedDataInfo, string fieldName)
        {
            pagedDataInfo.TableFields = fieldName;
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "LastItemNumber");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(pagedDataInfo)).Content;

            return JsonConvert.DeserializeObject<ApiResult<int>>(content).Results.FirstOrDefault();
        }

        public bool ResetItemNumber(PagedDataInfo pagedDataInfo, string fieldName, string whereCondition, List<long> ids)
        {
            pagedDataInfo.WhereCondition = whereCondition;
            pagedDataInfo.TableFields = fieldName;
            pagedDataInfo.Contains = string.Join(",", ids);
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ResetItemNumber");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(pagedDataInfo)).Content;

            return JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results.FirstOrDefault();
        }

        public bool UpdateLineNumberForJobCostSheet(PagedDataInfo pagedDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UpdateLineNumberForJobCostSheet");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("jobId", pagedDataInfo.ParentId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results.FirstOrDefault();
        }

        public bool UpdateLineNumberForJobBillableSheet(PagedDataInfo pagedDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UpdateLineNumberForJobBillableSheet");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("jobId", pagedDataInfo.ParentId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results.FirstOrDefault();
        }

        public int GetPageNumber(EntitiesAlias entitiesAlias)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetPageNumber");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddParameter("entitiesAlias", entitiesAlias)).Content;

            return JsonConvert.DeserializeObject<ApiResult<int>>(content).Results.FirstOrDefault();
        }

        public IList<TreeListModel> GetCustPPPTree(long? custId, long? parentId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "CustPPPTree");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("custId", custId).AddParameter("parentId", parentId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<TreeListModel>>(content).Results;
        }

        public SysSetting GetSystemSettingsFromApi(bool forceUpdate = false)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "SysSettings");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("forceUpdate", forceUpdate)).Content;
            var sysSetting = JsonConvert.DeserializeObject<ApiResult<SysSetting>>(content).Results.FirstOrDefault();

            if (!string.IsNullOrEmpty(sysSetting.SysJsonSetting))
                sysSetting.Settings = JsonConvert.DeserializeObject<List<RefSetting>>(sysSetting.SysJsonSetting);
            sysSetting.SysJsonSetting = string.Empty; // To save storage in cache as going to use only Model not json.
            return sysSetting;
        }

        public ErrorLog GetOrInsErrorLog(ErrorLog errorLog)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "ErrorLog");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(errorLog)).Content;
            return JsonConvert.DeserializeObject<ApiResult<ErrorLog>>(content).Results.FirstOrDefault();
        }

        public IList<AppDashboard> GetUserDashboards(int mainModuleId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserDashboards");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("mainModuleId", mainModuleId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<AppDashboard>>(content).Results;
        }

        public string GetNextBreakDownStrusture(bool ribbon)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "NextBreakDownStructure");

            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("ribbon", ribbon)).Content;

            return JsonConvert.DeserializeObject<ApiResult<string>>(content).Results.FirstOrDefault();
        }

        public bool GetIsJobCompleted(long jobId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "JobIsCompleted");

            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("jobId", jobId)).Content;

            return JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results.FirstOrDefault();
        }

        public IList<Role> GetOrganizationRoleDetails()
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "OrganizationRoleDetail");
            return JsonConvert.DeserializeObject<ApiResult<Role>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)).Content).Results;
        }

        public void UpdateUserSystemSettings(SysSetting userSystemSettings)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UserSystemSettings");
            userSystemSettings.SysJsonSetting = JsonConvert.SerializeObject(userSystemSettings.Settings, Formatting.None);
            _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(userSystemSettings));
        }


        public IList<PreferredLocation> AddorEditPreferedLocations(string locations, int contTypeId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "AddorEditPreferedLocations");

            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("locations", locations).AddParameter("contTypeId", contTypeId)).Content;

            return JsonConvert.DeserializeObject<ApiResult<IList<PreferredLocation>>>(content).Results.FirstOrDefault();
        }

        public IList<PreferredLocation> GetPreferedLocations(int contTypeId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetPreferedLocations");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)
                .AddParameter("contTypeId", contTypeId)).Content;
            var result = JsonConvert.DeserializeObject<ApiResult<IList<PreferredLocation>>>(content).Results.FirstOrDefault();
            return result;
        }

        public int GetUserContactType()
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetUserContactType");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser)).Content;
            return JsonConvert.DeserializeObject<ApiResult<int>>(content).Results.FirstOrDefault();
        }

        public IList<SysRefModel> GetDeleteInfoModules(PagedDataInfo pagedDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetDeleteInfoModules");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(pagedDataInfo)).Content;
            return JsonConvert.DeserializeObject<ApiResult<SysRefModel>>(content).Results;
        }

        public dynamic GetDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetDeleteInfoRecords");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(pagedDataInfo)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");

            switch (pagedDataInfo.Entity)
            {
                case EntitiesAlias.Account:
                    return JsonConvert.DeserializeObject<ApiResult<SystemAccount>>(content).Results;

                case EntitiesAlias.Organization:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Organization.Organization>>(content).Results;
                case EntitiesAlias.OrgPocContact:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Organization.OrgPocContact>>(content).Results;
                case EntitiesAlias.OrgCredential:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Organization.OrgCredential>>(content).Results;
                case EntitiesAlias.OrgFinancialCalendar:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Organization.OrgFinancialCalendar>>(content).Results;
                case EntitiesAlias.OrgRefRole:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Organization.OrgRefRole>>(content).Results;
                case EntitiesAlias.SecurityByRole:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Administration.SecurityByRole>>(content).Results;
                case EntitiesAlias.SubSecurityByRole:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Administration.SubSecurityByRole>>(content).Results;


                case EntitiesAlias.Customer:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.Customer>>(content).Results;
                case EntitiesAlias.CustBusinessTerm:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustBusinessTerm>>(content).Results;
                case EntitiesAlias.CustFinancialCalendar:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustFinancialCalendar>>(content).Results;
                case EntitiesAlias.CustContact:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustContact>>(content).Results;
                case EntitiesAlias.CustDcLocation:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustDcLocation>>(content).Results;
                case EntitiesAlias.CustDcLocationContact:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustDcLocationContact>>(content).Results;
                case EntitiesAlias.CustDocReference:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Customer.CustDocReference>>(content).Results;

                case EntitiesAlias.Vendor:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.Vendor>>(content).Results;
                case EntitiesAlias.VendBusinessTerm:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendBusinessTerm>>(content).Results;
                case EntitiesAlias.VendFinancialCalendar:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendFinancialCalendar>>(content).Results;
                case EntitiesAlias.VendContact:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendContact>>(content).Results;
                case EntitiesAlias.VendDcLocation:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendDcLocation>>(content).Results;
                case EntitiesAlias.VendDcLocationContact:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendDcLocationContact>>(content).Results;
                case EntitiesAlias.VendDocReference:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Vendor.VendDocReference>>(content).Results;



                case EntitiesAlias.Program:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.Program>>(content).Results;
                case EntitiesAlias.PrgRefGatewayDefault:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgRefGatewayDefault>>(content).Results;
                case EntitiesAlias.PrgRole:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgRole>>(content).Results;
                case EntitiesAlias.PrgVendLocation:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgVendLocation>>(content).Results;
                case EntitiesAlias.PrgBillableRate:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgBillableRate>>(content).Results;
                case EntitiesAlias.PrgCostRate:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgCostRate>>(content).Results;
                case EntitiesAlias.PrgMvoc:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgMvoc>>(content).Results;
                case EntitiesAlias.PrgMvocRefQuestion:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgMvocRefQuestion>>(content).Results;
                case EntitiesAlias.PrgEdiHeader:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgEdiHeader>>(content).Results;
                case EntitiesAlias.PrgEdiMapping:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgEdiMapping>>(content).Results;
                case EntitiesAlias.PrgBillableLocation:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgBillableLocation>>(content).Results;
                case EntitiesAlias.PrgCostLocation:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Program.PrgCostLocation>>(content).Results;

                case EntitiesAlias.Job:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.Job>>(content).Results;
                case EntitiesAlias.JobGateway:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobGateway>>(content).Results;
                case EntitiesAlias.JobAttribute:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobAttribute>>(content).Results;
                case EntitiesAlias.JobCargo:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobCargo>>(content).Results;
                case EntitiesAlias.JobDocReference:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobDocReference>>(content).Results;
                case EntitiesAlias.JobCostSheet:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobCostSheet>>(content).Results;
                case EntitiesAlias.JobBillableSheet:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Job.JobBillableSheet>>(content).Results;

                case EntitiesAlias.ScrOsdList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrOsdList>>(content).Results;
                case EntitiesAlias.ScrCatalogList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrCatalogList>>(content).Results;
                case EntitiesAlias.ScrOsdReasonList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrOsdReasonList>>(content).Results;
                case EntitiesAlias.ScrRequirementList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrRequirementList>>(content).Results;
                case EntitiesAlias.ScrReturnReasonList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrReturnReasonList>>(content).Results;
                case EntitiesAlias.ScrServiceList:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Scanner.ScrServiceList>>(content).Results;

                case EntitiesAlias.SystemAccount:
                    return JsonConvert.DeserializeObject<ApiResult<Entities.Administration.SystemAccount>>(content).Results;


                default:
                    return new object();
            }
        }

        public void RemoveDeleteInfoRecords(PagedDataInfo pagedDataInfo)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "RemoveDeleteInfoRecords");
            _restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser).AddObject(pagedDataInfo));
        }

        public UserSecurity GetDashboardAccess(string tableName, long dashboardId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetDashboardAccess");

            return JsonConvert.DeserializeObject<ApiResult<UserSecurity>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("tableName", tableName).AddParameter("dashboardId", dashboardId)).Content).Results.FirstOrDefault();

        }

        public CommonIds GetMaxMinRecordsByEntity(string entity, long recordID, long ID)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetMaxMinRecordsByEntity");
            return JsonConvert.DeserializeObject<ApiResult<CommonIds>>(_restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("RecordID", recordID).AddParameter("Entity", entity).AddParameter("ID", ID)).Content).Results.FirstOrDefault();

        }

        public JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetGatewayTypeByJobID");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("jobGatewayateId", jobGatewayateId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<JobGatewayModelforPanel>>(content).Results.FirstOrDefault();
        }

        public CompanyCorpAddress GetCompCorpAddress(int compId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "GetCompCorpAddress");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("compId", compId)).Content;
            return JsonConvert.DeserializeObject<ApiResult<CompanyCorpAddress>>(content).Results.FirstOrDefault();
        }


        public List<AttachmentView> DownloadAll(long  jobId)
        {
            var routeSuffix = string.Format("{0}/{1}", "Attachments", "GetAttachmentsByJobId");
            var content = _restClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("jobId", jobId)).Content;
            var response = JsonConvert.DeserializeObject<ApiResult<List<AttachmentView>>>(content).Results.FirstOrDefault();
            return response;
        }

    }
}