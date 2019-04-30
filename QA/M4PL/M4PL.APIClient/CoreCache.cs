/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 CoreCache
//Purpose:                                      Represents CoreCache Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Concurrent;
using System.Collections.Generic;

namespace M4PL.APIClient
{
    public static class CoreCache
    {
        /// <summary>
        /// hold system level Settings
        /// </summary>
        public static ConcurrentDictionary<string, SysSetting> SysSettings { get; private set; }

        /// <summary>
        ///     To hold all tables
        /// </summary>
        public static IDictionary<EntitiesAlias, TableReference> Tables
        {
            get;
            private set;
        }

        /// <summary>
        /// To hold language Key with available Menus
        /// </summary>
        public static ConcurrentDictionary<string, IList<RibbonMenu>> RibbonMenus { get; private set; }

        /// <summary>
        /// To hold language Key with lookups list data
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<int, IList<IdRefLangName>>> IdRefLangNames { get; private set; }

        /// <summary>
        /// To hold language Key with operations lookup list data
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<LookupEnums, IList<Operation>>> Operations { get; private set; }

        /// <summary>
        /// To hold language Key with entities page and tab names
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>> PageInfos { get; private set; }

        /// <summary>
        ///     To hold Display messages list with code as key to show CRUD messages with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<string, DisplayMessage>> DisplayMessages
        {
            get; private set;
        }

        /// <summary>
        /// To hold language Key with entities ref page and tab names
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, object>> MasterTables { get; private set; }

        /// <summary>
        ///     To hold Column Aliases list with table name as key based on passed Aliases Entities with Language Code as Key
        /// </summary>
        public static ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ViewModels.ColumnSetting>>> ColumnSettings
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
        /// To hold language Key with operations lookup list data
        /// </summary>
        public static ConcurrentDictionary<string, IList<ConditionalOperator>> ConditionalOperators { get; private set; }

        static CoreCache()
        {
            RibbonMenus = new ConcurrentDictionary<string, IList<RibbonMenu>>();
            IdRefLangNames = new ConcurrentDictionary<string, ConcurrentDictionary<int, IList<IdRefLangName>>>();
            PageInfos = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>>();
            Operations = new ConcurrentDictionary<string, ConcurrentDictionary<LookupEnums, IList<Operation>>>();
            DisplayMessages = new ConcurrentDictionary<string, ConcurrentDictionary<string, DisplayMessage>>();
            ColumnSettings = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ViewModels.ColumnSetting>>>();
            ValidationRegExpressions = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>>();
            MasterTables = new ConcurrentDictionary<string, ConcurrentDictionary<EntitiesAlias, object>>();
            ConditionalOperators = new ConcurrentDictionary<string, IList<ConditionalOperator>>();
            SysSettings = new ConcurrentDictionary<string, SysSetting>();
        }

        /// <summary>
        ///     To start English version of it on Application start
        /// </summary>
        /// <param name="langCode">1 for EN</param>
        public static void Initialize(string langCode)
        {
            Tables = new Dictionary<EntitiesAlias, TableReference>();
            RibbonMenus.GetOrAdd(langCode, new List<RibbonMenu>());
            IdRefLangNames.GetOrAdd(langCode, new ConcurrentDictionary<int, IList<IdRefLangName>>());
            PageInfos.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<PageInfo>>());
            Operations.GetOrAdd(langCode, new ConcurrentDictionary<LookupEnums, IList<Operation>>());
            DisplayMessages.GetOrAdd(langCode, new ConcurrentDictionary<string, DisplayMessage>());
            ColumnSettings.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ViewModels.ColumnSetting>>());
            ValidationRegExpressions.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>>());
            MasterTables.GetOrAdd(langCode, new ConcurrentDictionary<EntitiesAlias, object>());
            ConditionalOperators.GetOrAdd(langCode, new List<ConditionalOperator>());
            SysSettings.GetOrAdd(langCode, new SysSetting());
        }
    }
}