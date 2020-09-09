#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 BaseCommands
// Purpose:                                      Contains methods to store static data into cache, when there's no cache retrive from database
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.MasterTables;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;

namespace M4PL.DataAccess
{
	public static class CacheCommands
	{
		public static IList<TableReference> GetTables()
		{
			return SqlSerializer.Default.DeserializeMultiRecords<TableReference>(StoredProceduresConstant.GetTables, storedProcedure: true);
		}

		public static IList<RibbonMenu> GetRibbonMenus(string langCode)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
			};

			return SqlSerializer.Default.DeserializeMultiRecords<RibbonMenu>(StoredProceduresConstant.GetRibbonMenus, parameters,
				storedProcedure: true).BuildMenus();
		}

		public static BusinessConfiguration GetBusinessConfiguration(string langCode)
		{
			BusinessConfiguration businessConfiguration = new BusinessConfiguration();
			bool isProductionEnvironment = ConfigurationManager.AppSettings["IsProductionEnvironment"].ToBoolean();
			var parameters = new[]
			{
				new Parameter("@environment", isProductionEnvironment ? 1 : 2),
			};

			var configurationKeyValuePair = SqlSerializer.Default.DeserializeMultiRecords<ConfigurationKeyValuePair>(StoredProceduresConstant.GetBusinessConfiguration, parameters, false, true);
			if (configurationKeyValuePair != null && configurationKeyValuePair.Count > 0)
			{
				businessConfiguration.ConfigurationKeyValuePair = configurationKeyValuePair;
			}

			return businessConfiguration;
		}

		public static IList<IdRefLangName> GetIdRefLangNames(string langCode, int lookupId)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@lookupId", lookupId)
			};
			return
				SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(
					StoredProceduresConstant.GetIdRefLangNames, parameters, storedProcedure: true);
		}

		public static IList<IdRefLangName> GetIdRefLangNamesFromTable(string langCode, LookupEnums lookupName)
		{
			switch (lookupName)
			{
				case LookupEnums.MenuAccessLevel:
					return GenericCommands<MenuAccessLevel>.GetIdRefLangNamesFromTable(langCode, LookupEnums.MenuAccessLevel.ToInt())
					 .Select(
						 i =>
							 new IdRefLangName
							 {
								 SysRefId = i.SysRefId,
								 SysRefName = i.SysRefName,
								 LangName = i.MalTitle
							 })
					 .ToList();

				case LookupEnums.MenuOptionLevel:
					return GenericCommands<MenuOptionLevel>.GetIdRefLangNamesFromTable(langCode, LookupEnums.MenuOptionLevel.ToInt())
					.Select(
						i =>
							new IdRefLangName
							{
								SysRefId = i.SysRefId,
								SysRefName = i.SysRefName,
								LangName = i.MolMenuLevelTitle
							})
					.ToList();

				case LookupEnums.MainModule:
					return GenericCommands<MenuDriver>.GetIdRefLangNamesFromTable(langCode, LookupEnums.MainModule.ToInt())
					.Select(
						i =>
							new IdRefLangName
							{
								SysRefId = i.SysRefId,
								SysRefName = i.SysRefName,
								LangName = i.MnuTitle
							})
					.ToList();

				default:
					break;
			}
			return GetIdRefLangNames(langCode, lookupName.ToInt());
		}

		public static IList<Operation> GetOperations(string langCode, LookupEnums lookup)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@lookupId", lookup.ToInt())
			};
			return
				SqlSerializer.Default.DeserializeMultiRecords<Operation>(StoredProceduresConstant.GetOperations,
					parameters, storedProcedure: true);
		}

		public static IList<PageInfo> GetPageInfos(string langCode, EntitiesAlias entity)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@tableName", entity.ToString())
			};
			return
				  SqlSerializer.Default.DeserializeMultiRecords<PageInfo>(StoredProceduresConstant.GetPageAndTabNames,
					parameters, storedProcedure: true);
		}

		public static DisplayMessage GetDisplayMessageByCode(string langCode, string messageCode)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@msgCode", messageCode)
			};
			return
				SqlSerializer.Default.DeserializeSingleRecord<DisplayMessage>(StoredProceduresConstant.GetDisplayMessagesByCode,
					parameters, storedProcedure: true);
		}

		public static IList<ColumnSetting> GetColumnSettingsByEntityAlias(string langCode, EntitiesAlias entity)
		{
			var parameters = new[]
		  {
				new Parameter("@langCode", langCode),
				new Parameter("@tableName",entity.ToString())
			};
			return SqlSerializer.Default.DeserializeMultiRecords<ColumnSetting>(StoredProceduresConstant.GetColumnAliasesByTableName, parameters, storedProcedure: true);
		}

		public static IList<ColumnSetting> GetGridColumnSettingsByEntityAlias(string langCode, EntitiesAlias entity, bool isGridSetting)
		{
			var parameters = new[]
		  {
				new Parameter("@langCode", langCode),
				new Parameter("@tableName",entity.ToString()),
				new Parameter("@isGridSetting", isGridSetting)
			};
			var result = SqlSerializer.Default.DeserializeMultiRecords<ColumnSetting>(StoredProceduresConstant.GetGridColumnAliasesByTableName, parameters, storedProcedure: true);
			return result;
		}

		public static IList<ValidationRegEx> GetValidationRegExpsByEntityAlias(string langCode, EntitiesAlias entity)
		{
			var parameters = new[]
		  {
				new Parameter("@langCode", langCode),
				new Parameter("@tableName", entity.ToString())
			};
			return SqlSerializer.Default.DeserializeMultiRecords<ValidationRegEx>(StoredProceduresConstant.GetValidationRegExpsByTblName, parameters, storedProcedure: true);
		}

		public static object GetMasterTableObject(string langCode, EntitiesAlias entity)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@tableName", entity.ToString())
			};
			switch (entity)
			{
				case EntitiesAlias.ChooseColumn:
					return SqlSerializer.Default.DeserializeMultiRecordsPivot<ChooseColumn>(StoredProceduresConstant.GetMasterTableObject, parameters, storedProcedure: true);

				default:
					break;
			}
			return new object();
		}

		public static SysSetting GetSystemSettings(string langCode)
		{
			return SqlSerializer.Default.DeserializeSingleRecord<SysSetting>(StoredProceduresConstant.GetSystemSettings, new Parameter("@langCode", langCode), storedProcedure: true);
		}
	}
}