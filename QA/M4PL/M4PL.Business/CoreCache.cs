/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 CacheCommands
Purpose:
===================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Entities.Support;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.CacheCommands;
using _salesOrderCommands = M4PL.Business.Finance.SalesOrder.NavSalesOrderHelper;

namespace M4PL.Business
{
    public static class CoreCache
    {
        public static ConcurrentDictionary<string, SysSetting> SysSettings { get; private set; }

        /// <summary>
        /// To hold language Key with available Menus
        /// </summary>
        public static ConcurrentDictionary<string, IList<RibbonMenu>> RibbonMenus { get; private set; }

        /// <summary>
        /// To hold DimensionValues with available Values
        /// </summary>
        public static ConcurrentDictionary<string, NavSalesOrderDimensionResponse> DimensionValues { get; private set; }

        /// <summary>
        /// To hold NAVOrderItemResponse with available Values
        /// </summary>
        public static ConcurrentDictionary<string, NAVOrderItemResponse> NAVOrderItemResponse { get; private set; }

        /// <summary>
        /// To hold language Key with lookups list data
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<int, IList<IdRefLangName>>> IdRefLangNames { get; private set; }

        /// <summary>
        /// To hold language Key with entities ref page and tab names
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>> PageInfos { get; private set; }

        /// <summary>
        /// To hold language Key with entities ref page and tab names
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, object>> MasterTables { get; private set; }

        /// <summary>
        /// To hold language Key with operations lookup list data
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<LookupEnums, IList<Operation>>> Operations { get; private set; }

        /// <summary>
        /// To hold language Key with operations lookup list data
        /// </summary>
        public static ConcurrentDictionary<string, IList<ConditionalOperator>> ConditionalOperators { get; private set; }

        /// <summary>
        ///     To hold Display messages list with code as key to show CRUD messages with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<string, DisplayMessage>> DisplayMessages
        {
            get; private set;
        }

        /// <summary>
        ///     To hold Column Aliases list with table name as key based on passed Aliases Entities with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>> ColumnSettings
        {
            get;
            private set;
        }

        /// <summary>
        ///     To hold grid Column Aliases list with table name as key based on passed Aliases Entities with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>> GridColumnSettings
        {
            get;
            private set;
        }

        /// <summary>
        ///     To hold Valiation list with table name as key based on passed Aliases Entities with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>> ValidationRegExpressions
        {
            get;
            private set;
        }

        /// <summary>
        ///     To hold all tables
        /// </summary>
        public static IList<TableReference> Tables
        {
            get;
            private set;
        }

        static CoreCache()
        {
            Tables = new List<TableReference>();
            RibbonMenus = new ConcurrentDictionary<string, IList<RibbonMenu>>();
            IdRefLangNames = new ConcurrentDictionary<string, ConcurrentDictionary<int, IList<IdRefLangName>>>();
            PageInfos = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>>();
            Operations = new ConcurrentDictionary<string, ConcurrentDictionary<LookupEnums, IList<Operation>>>();
            DisplayMessages = new ConcurrentDictionary<string, ConcurrentDictionary<string, DisplayMessage>>();
            ColumnSettings = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>>();
            GridColumnSettings = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>>();
            ValidationRegExpressions = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>>();
            MasterTables = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, object>>();
            ConditionalOperators = new ConcurrentDictionary<string, IList<ConditionalOperator>>();
            SysSettings = new ConcurrentDictionary<string, SysSetting>();
            DimensionValues = new ConcurrentDictionary<string, NavSalesOrderDimensionResponse>();
            NAVOrderItemResponse = new ConcurrentDictionary<string, NAVOrderItemResponse>();
        }

        /// <summary>
        ///     To start English version of it on Application start
        /// </summary>
        /// <param name="langCode">1 for EN</param>
        public static void Initialize(string langCode)
        {
            RibbonMenus.GetOrAdd(langCode, new List<RibbonMenu>());
            IdRefLangNames.GetOrAdd(langCode, new ConcurrentDictionary<int, IList<IdRefLangName>>());
            PageInfos.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>());
            Operations.GetOrAdd(langCode, new ConcurrentDictionary<LookupEnums, IList<Operation>>());
            DisplayMessages.GetOrAdd(langCode, new ConcurrentDictionary<string, DisplayMessage>());
            ColumnSettings.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>());
            GridColumnSettings.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>());
            ValidationRegExpressions.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>());
            MasterTables.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, object>());
            ConditionalOperators.GetOrAdd(langCode, new List<ConditionalOperator>());
            DimensionValues.GetOrAdd(langCode, new NavSalesOrderDimensionResponse());
            NAVOrderItemResponse.GetOrAdd(langCode, new NAVOrderItemResponse());
            GetRibbonMenus(langCode);
            GetTables();
            InitializerOperations(langCode);
            GetSystemSettings(langCode);
            GetNavSalesOrderDimensionValues(langCode);
        }

        private static void InitializerOperations(string langCode)
        {
            GetOperations(langCode, LookupEnums.OperationType);
            GetDisplayMessageByCode(langCode, DbConstants.SaveSuccess);
            GetDisplayMessageByCode(langCode, DbConstants.DeleteSuccess);
            GetDisplayMessageByCode(langCode, DbConstants.UpdateSuccess);
            GetDisplayMessageByCode(langCode, DbConstants.SaveError);
            GetDisplayMessageByCode(langCode, DbConstants.DeleteError);
            GetDisplayMessageByCode(langCode, DbConstants.UpdateError);

            if (!ConditionalOperators.ContainsKey(langCode))
                ConditionalOperators.GetOrAdd(langCode, new List<ConditionalOperator>());
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.And, SysRefName = "&&", LangName = "And" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.Or, SysRefName = "||", LangName = "Or" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.GreaterThan, SysRefName = ">", LangName = "Greater Than" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.GreaterThanEqual, SysRefName = ">=", LangName = "Greater Than Equal to" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.LessThan, SysRefName = "<", LangName = "Less Than" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.LessThanEqual, SysRefName = "<=", LangName = "Less Than Equal to" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.Equal, SysRefName = "==", LangName = "Equals to" });
            ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.NotEqual, SysRefName = "!=", LangName = "Not Equals to" });
        }

        public static IList<TableReference> GetTables(bool forceUpdate = false)
        {
            if (Tables.Count == 0 || forceUpdate)
                Tables = _commands.GetTables();
            return Tables;
        }

        public static IList<RibbonMenu> GetRibbonMenus(string langCode, bool forceUpdate = false)
        {
            if (!RibbonMenus.ContainsKey(langCode))
                RibbonMenus.GetOrAdd(langCode, new List<RibbonMenu>());
            if (!RibbonMenus[langCode].Any() || forceUpdate)
                RibbonMenus.AddOrUpdate(langCode, _commands.GetRibbonMenus(langCode));
            return RibbonMenus[langCode];
        }

        public static NavSalesOrderDimensionResponse GetNavSalesOrderDimensionValues(string langCode, bool forceUpdate = false)
        {
            if (!DimensionValues.ContainsKey(langCode))
                DimensionValues.GetOrAdd(langCode, new NavSalesOrderDimensionResponse());
            if ((DimensionValues[langCode].NavSalesOrderDimensionValues == null) || forceUpdate)
                DimensionValues.AddOrUpdate(langCode, _salesOrderCommands.GetNavSalesOrderDimension());
            return DimensionValues[langCode];
        }

        public static NAVOrderItemResponse GetNAVOrderItemResponse(string langCode, bool forceUpdate = false)
        {
            if (!NAVOrderItemResponse.ContainsKey(langCode))
                NAVOrderItemResponse.GetOrAdd(langCode, new NAVOrderItemResponse());
            if ((NAVOrderItemResponse[langCode].OrderItemList == null) || forceUpdate)
                NAVOrderItemResponse.AddOrUpdate(langCode, _salesOrderCommands.GetNavNAVOrderItemResponse());
            return NAVOrderItemResponse[langCode];
        }

        public static IList<IdRefLangName> GetIdRefLangNames(string langCode, int lookupId, bool forceUpdate = false)
        {
            if (!IdRefLangNames.ContainsKey(langCode))
                IdRefLangNames.GetOrAdd(langCode, new ConcurrentDictionary<int, IList<IdRefLangName>>());
            if (!IdRefLangNames[langCode].ContainsKey(lookupId))
                IdRefLangNames[langCode].GetOrAdd(lookupId, _commands.GetIdRefLangNames(langCode, lookupId));
            else if (!IdRefLangNames[langCode][lookupId].Any() || forceUpdate)
                IdRefLangNames[langCode].AddOrUpdate(lookupId, _commands.GetIdRefLangNames(langCode, lookupId));
            return IdRefLangNames[langCode][lookupId];
        }

        public static IList<PageInfo> GetPageInfos(string langCode, EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!PageInfos.ContainsKey(langCode))
                PageInfos.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>());
            if (!PageInfos[langCode].ContainsKey(entity))
                PageInfos[langCode].GetOrAdd(entity, _commands.GetPageInfos(langCode, entity));
            else if (!PageInfos[langCode][entity].Any() || forceUpdate)
                PageInfos[langCode].AddOrUpdate(entity, _commands.GetPageInfos(langCode, entity));
            return PageInfos[langCode][entity];
        }

        public static IList<Operation> GetOperations(string langCode, LookupEnums lookup, bool forceUpdate = false)
        {
            if (!Operations.ContainsKey(langCode))
                Operations.GetOrAdd(langCode, new ConcurrentDictionary<LookupEnums, IList<Operation>>());
            if (!Operations[langCode].ContainsKey(lookup))
                Operations[langCode].GetOrAdd(lookup, _commands.GetOperations(langCode, lookup));
            else if (!Operations[langCode][lookup].Any() || forceUpdate)
                Operations[langCode].AddOrUpdate(lookup, _commands.GetOperations(langCode, lookup));
            return Operations[langCode][lookup];
        }

        internal static object GetMasterTableObject(string langCode, EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!MasterTables.ContainsKey(langCode))
                MasterTables.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, object>());
            if (!MasterTables[langCode].ContainsKey(entity))
                MasterTables[langCode].GetOrAdd(entity, _commands.GetMasterTableObject(langCode, entity));
            else if (MasterTables[langCode][entity] == null || forceUpdate)
                MasterTables[langCode].AddOrUpdate(entity, _commands.GetMasterTableObject(langCode, entity));
            return MasterTables[langCode][entity];
        }

        internal static DisplayMessage GetDisplayMessageByCode(string langCode, string messageCode, bool forceUpdate = false)
        {
            if (!DisplayMessages.ContainsKey(langCode))
                DisplayMessages.GetOrAdd(langCode, new ConcurrentDictionary<string, DisplayMessage>());
            if (!DisplayMessages[langCode].ContainsKey(messageCode))
                DisplayMessages[langCode].GetOrAdd(messageCode, _commands.GetDisplayMessageByCode(langCode, messageCode));
            else if (DisplayMessages[langCode][messageCode] == null || forceUpdate)
                DisplayMessages[langCode].AddOrUpdate(messageCode, _commands.GetDisplayMessageByCode(langCode, messageCode));
            var displayMessage = DisplayMessages[langCode][messageCode] ?? new DisplayMessage();

            if (displayMessage.OperationIds.Count != displayMessage.Operations.Count)
            {
                displayMessage.Operations.Clear();
                displayMessage.OperationIds.ForEach(msg => msg.SetOperationToDisplayMessage(langCode, displayMessage));
            }
            return displayMessage;
        }

        internal static IList<ColumnSetting> GetColumnSettingsByEntityAlias(string langCode, EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!ColumnSettings.ContainsKey(langCode))
                ColumnSettings.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>());
            if (!ColumnSettings[langCode].ContainsKey(entity))
                ColumnSettings[langCode].GetOrAdd(entity, _commands.GetColumnSettingsByEntityAlias(langCode, entity));
            else if (!ColumnSettings[langCode][entity].Any() || forceUpdate)
                ColumnSettings[langCode].AddOrUpdate(entity, _commands.GetColumnSettingsByEntityAlias(langCode, entity));
            return ColumnSettings[langCode][entity];
        }

        internal static IList<ColumnSetting> GetGridColumnSettingsByEntityAlias(string langCode, EntitiesAlias entity, bool forceUpdate = false, bool isGridSetting = false)
        {
            if (!GridColumnSettings.ContainsKey(langCode))
                GridColumnSettings.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>>());
            if (!GridColumnSettings[langCode].ContainsKey(entity))
                GridColumnSettings[langCode].GetOrAdd(entity, _commands.GetGridColumnSettingsByEntityAlias(langCode, entity, isGridSetting));
            else if (!GridColumnSettings[langCode][entity].Any() || forceUpdate)
                GridColumnSettings[langCode].AddOrUpdate(entity, _commands.GetGridColumnSettingsByEntityAlias(langCode, entity, isGridSetting));
            return GridColumnSettings[langCode][entity];
        }

        internal static IList<ValidationRegEx> GetValidationRegExpsByEntityAlias(string langCode, EntitiesAlias entity, bool forceUpdate = false)
        {
            if (!ValidationRegExpressions.ContainsKey(langCode))
                ValidationRegExpressions.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>());
            if (!ValidationRegExpressions[langCode].ContainsKey(entity))
                ValidationRegExpressions[langCode].GetOrAdd(entity, _commands.GetValidationRegExpsByEntityAlias(langCode, entity));
            else if (!ValidationRegExpressions[langCode][entity].Any() || forceUpdate)
                ValidationRegExpressions[langCode].AddOrUpdate(entity, _commands.GetValidationRegExpsByEntityAlias(langCode, entity));
            return ValidationRegExpressions[langCode][entity];
        }

        private static void SetOperationToDisplayMessage(this string msgOperation, string langCode, DisplayMessage displayMessage, bool forceUpdate = false)
        {
            if (Enum.IsDefined(typeof(MessageOperationTypeEnum), msgOperation.Trim()))
            {
                if (!Operations.ContainsKey(langCode) || !Operations[langCode].ContainsKey(LookupEnums.MsgOperationType))
                    GetOperations(langCode, LookupEnums.MsgOperationType);
                var operation = Operations[langCode][LookupEnums.MsgOperationType].FirstOrDefault(e => e.SysRefName.Equals(msgOperation.Trim()));
                displayMessage.Operations.Add(operation);
            }
        }

        public static IList<ConditionalOperator> GetConditionalOperators(string langCode, bool forceUpdate = false)
        {
            if (!ConditionalOperators.ContainsKey(langCode))
            {
                ConditionalOperators.GetOrAdd(langCode, new List<ConditionalOperator>());
                //TODO: Make database call to get name using LookupEnums.RelationalOperator
                //Iterate ConditionalOperators and only update it's LangName from MessageRefType table by Language.
                // Like Active = Activo same way Greater than in spanish = 'mas grande que'
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.And, SysRefName = "&&", LangName = "And" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.Or, SysRefName = "||", LangName = "Or" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.GreaterThan, SysRefName = ">", LangName = "Greater Than" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.GreaterThanEqual, SysRefName = ">=", LangName = "Greater Than Equal to" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.LessThan, SysRefName = "<", LangName = "Less Than" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.LessThanEqual, SysRefName = "<=", LangName = "Less Than Equal to" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.Equal, SysRefName = "==", LangName = "Equals to" });
                ConditionalOperators[langCode].Add(new ConditionalOperator { Operator = RelationalOperator.NotEqual, SysRefName = "!=", LangName = "Not Equals to" });
            }
            return ConditionalOperators[langCode];
        }

        internal static SysSetting GetSystemSettings(string langCode, bool forceUpdate = false)
        {
            if (!SysSettings.ContainsKey(langCode) || forceUpdate)
                SysSettings.AddOrUpdate(langCode, _commands.GetSystemSettings(langCode));
            return SysSettings[langCode];
        }
    }
}