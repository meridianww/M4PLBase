#region Copyright

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
//Program Name:                                 TreeListProvider
//Purpose:                                      Methods and properties related to TreeListProvider
//====================================================================================================================================================*/

using DevExpress.Web.ASPxTreeList;
using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Linq;

namespace M4PL.Web.Providers
{
	public class TreeListProvider
	{
		public static void VirtualModeCreateChildren(TreeListVirtualModeCreateChildrenEventArgs e, MvcRoute route, ICommonCommands commonCommands)
		{
			var treeListModel = e.NodeObject as TreeListModel;
			var children = treeListModel == null ? commonCommands.GetCustPPPTree(null, null).ToList() : commonCommands.GetCustPPPTree(treeListModel.CustomerId, treeListModel.ParentId).ToList();
			children.ForEach(c =>
			{
				var customerRouteCheck = new MvcRoute(route, c.Id);
				if (treeListModel == null && c.Id == c.CustomerId && c.ParentId == null)
				{
					var tableRef = commonCommands.Tables[EntitiesAlias.Customer];
					customerRouteCheck.Entity = EntitiesAlias.Customer;
					customerRouteCheck.EntityName = tableRef.TblLangName;
					customerRouteCheck.Area = tableRef.MainModuleName;
				}
				c.Route = Newtonsoft.Json.JsonConvert.SerializeObject(customerRouteCheck);
			});
			e.Children = children;
		}

		public static void VirtualModeNodeCreating(TreeListVirtualModeNodeCreatingEventArgs e, MvcRoute route, ICommonCommands commonCommands)
		{
			var treeListModel = e.NodeObject as TreeListModel;
			if (treeListModel == null)
				return;
			var treeRoute = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(treeListModel.Route);
			e.NodeKeyValue = EntitiesAlias.Customer == treeRoute.Entity ? treeRoute.Entity + "_" + treeListModel.Id : treeListModel.Id.ToString();
			var childNodes = commonCommands.GetCustPPPTree(treeListModel.CustomerId, treeListModel.ParentId).ToList();
			e.IsLeaf = !(childNodes.Count > 0);
			e.SetNodeValue("HierarchyLevel", treeListModel.HierarchyLevel);
			e.SetNodeValue("Text", treeListModel.Text);
			e.SetNodeValue("IconCss", treeListModel.IconCss);
		}
	}
}