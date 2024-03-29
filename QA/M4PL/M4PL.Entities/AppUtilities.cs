﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 AppUtilities
// Purpose:                                      Contains objects related to AppUtilities
//==========================================================================================================

using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Entities
{
	/// <summary>
	///
	/// </summary>
	public static class AppUtilities
	{
		public static void AddOrUpdate(this ConcurrentDictionary<string, IList<RibbonMenu>> dictionary,
		   string langCode, IList<RibbonMenu> appMenus)
		{
			dictionary.AddOrUpdate(langCode, appMenus, (key, oldValue) => appMenus);
		}

		#region commented code

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NavSalesOrderDimensionResponse> dictionary,
		////   string langCode, NavSalesOrderDimensionResponse dimensionValues)
		////{
		////	dictionary.AddOrUpdate(langCode, dimensionValues, (key, oldValue) => dimensionValues);
		////}

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NavSalesOrderPostedInvoiceResponse> dictionary,
		////   string langCode, NavSalesOrderPostedInvoiceResponse navSalesOrderResponse)
		////{
		////	dictionary.AddOrUpdate(langCode, navSalesOrderResponse, (key, oldValue) => navSalesOrderResponse);
		////}

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NavPurchaseOrderPostedInvoiceResponse> dictionary,
		////   string langCode, NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderResponse)
		////{
		////	dictionary.AddOrUpdate(langCode, navPurchaseOrderResponse, (key, oldValue) => navPurchaseOrderResponse);
		////}

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NavSalesOrderItemResponse> dictionary,
		////   string langCode, NavSalesOrderItemResponse navSalesOrderItemResponse)
		////{
		////	dictionary.AddOrUpdate(langCode, navSalesOrderItemResponse, (key, oldValue) => navSalesOrderItemResponse);
		////}

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NavPurchaseOrderItemResponse> dictionary,
		////   string langCode, NavPurchaseOrderItemResponse navPurchaseOrderItemResponse)
		////{
		////	dictionary.AddOrUpdate(langCode, navPurchaseOrderItemResponse, (key, oldValue) => navPurchaseOrderItemResponse);
		////}

		////public static void AddOrUpdate(this ConcurrentDictionary<string, NAVOrderItemResponse> dictionary,
		////   string langCode, NAVOrderItemResponse navOrderItemResponse)
		////{
		////	dictionary.AddOrUpdate(langCode, navOrderItemResponse, (key, oldValue) => navOrderItemResponse);
		////}

		#endregion
		public static void AddOrUpdate(this ConcurrentDictionary<int, IList<IdRefLangName>> dictionary,
			int lookupId, IList<IdRefLangName> idRefLangNames)
		{
			dictionary.AddOrUpdate(lookupId, idRefLangNames, (key, oldValue) => idRefLangNames);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<LookupEnums, IList<Operation>> dictionary,
			LookupEnums lookup, IList<Operation> operations)
		{
			dictionary.AddOrUpdate(lookup, operations, (key, oldValue) => operations);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<EntitiesAlias, IList<PageInfo>> dictionary,
		   EntitiesAlias entity, IList<PageInfo> pageAndTabNames)
		{
			dictionary.AddOrUpdate(entity, pageAndTabNames, (key, oldValue) => pageAndTabNames);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<string, DisplayMessage> dictionary, string messageCode, DisplayMessage displayMessage)
		{
			dictionary.AddOrUpdate(messageCode, displayMessage, (key, oldValue) => displayMessage);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<EntitiesAlias, IList<ColumnSetting>> dictionary, EntitiesAlias entity, IList<ColumnSetting> list)
		{
			dictionary.AddOrUpdate(entity, list, (key, oldValue) => list);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<EntitiesAlias, IList<ValidationRegEx>> dictionary, EntitiesAlias entity, IList<ValidationRegEx> list)
		{
			dictionary.AddOrUpdate(entity, list, (key, oldValue) => list);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<EntitiesAlias, object> dictionary,
		 EntitiesAlias entity, object obj)
		{
			dictionary.AddOrUpdate(entity, obj, (key, oldValue) => obj);
		}

		public static IList<RibbonMenu> BuildMenus(this IEnumerable<RibbonMenu> source)
		{
			var roots = source.Where(i => i.MnuBreakDownStructure.Length == 5).ToList();

			if (roots.Count > 0)
			{
				var list = source.Where(mn => mn.MnuBreakDownStructure.Length > 5).ToList();
				for (int i = 0; i < roots.Count; i++)
					AddChildren(roots[i], list);
			}

			return roots;
		}

		private static void AddChildren(RibbonMenu appMenu, List<RibbonMenu> list)
		{
			appMenu.Children = list.Where(ch => ch.MnuBreakDownStructure.StartsWith(appMenu.MnuBreakDownStructure) &&
			ch.MnuBreakDownStructure.Split(new string[] { appMenu.MnuBreakDownStructure }, StringSplitOptions.None).Count() > 1
			&& ch.MnuBreakDownStructure.Split(new string[] { appMenu.MnuBreakDownStructure }, StringSplitOptions.None)[1].Length == 3).OrderBy(p => p.MnuBreakDownStructure).ToList();
			for (int i = 0; i < appMenu.Children.Count; i++)
				AddChildren(appMenu.Children[i], list);
		}

		public static IList<LeftMenu> BuildMenus(this IEnumerable<LeftMenu> source)
		{
			var roots = source.Where(i => i.MnuBreakDownStructure.Length == 5).ToList();

			if (roots.Count > 0)
			{
				var list = source.Where(mn => mn.MnuBreakDownStructure.Length > 5).ToList();
				for (int i = 0; i < roots.Count; i++)
					AddChildren(roots[i], list);
			}

			return roots;
		}

		private static void AddChildren(LeftMenu appMenu, List<LeftMenu> list)
		{
			appMenu.Children = list.Where(ch => ch.MnuBreakDownStructure.StartsWith(appMenu.MnuBreakDownStructure) &&
			ch.MnuBreakDownStructure.Split(new string[] { appMenu.MnuBreakDownStructure }, StringSplitOptions.None).Count() > 1
			&& ch.MnuBreakDownStructure.Split(new string[] { appMenu.MnuBreakDownStructure }, StringSplitOptions.None)[1].Length == 3).OrderBy(p => p.MnuBreakDownStructure).ToList();
			for (int i = 0; i < appMenu.Children.Count; i++)
				AddChildren(appMenu.Children[i], list);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<string, SysSetting> dictionary, string langCode, SysSetting sysSetting)
		{
			dictionary.AddOrUpdate(langCode, sysSetting, (key, oldValue) => sysSetting);
		}

		public static void AddOrUpdate(this ConcurrentDictionary<string, BusinessConfiguration> dictionary, string langCode, BusinessConfiguration businessConfiguration)
		{
			dictionary.AddOrUpdate(langCode, businessConfiguration, (key, oldValue) => businessConfiguration);
		}
	}
}