/*Copyright(2016) Meridian                    Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavPurchaseOrderCommands
Purpose:                                      Contains commands to perform CRUD on NavPurchaseOrderCommands
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using M4PL.Entities;
using System.Linq;

namespace M4PL.DataAccess.Finance
{
	public class NavPurchaseOrderCommands : BaseCommands<NavPurchaseOrder>
	{
		public static NavPurchaseOrder GetRecordDataFromDatabase(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			NavPurchaseOrder navPurchaseOrder = null;
			SetCollection sets = new SetCollection();
			sets.AddSet<NavPurchaseOrder>("NavPurchaseOrder");
			sets.AddSet<PurchaseOrderItem>("PurchaseOrderItem");
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };
			SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetDataForOrder);
			var navPurchaseOrderSet = sets.GetSet<NavPurchaseOrder>("NavPurchaseOrder");
			var purchaseOrderItemSet = sets.GetSet<PurchaseOrderItem>("PurchaseOrderItem");
			if (navPurchaseOrderSet != null && navPurchaseOrderSet.Count > 0)
			{
				navPurchaseOrder = new NavPurchaseOrder();
				navPurchaseOrder = navPurchaseOrderSet.FirstOrDefault();
				navPurchaseOrder.PurchLines = purchaseOrderItemSet != null && purchaseOrderItemSet.Count > 0 ? purchaseOrderItemSet.ToArray() : null;
			}

			return navPurchaseOrder;
		}

		public static bool UpdateJobOrderMapping(ActiveUser activeUser, long jobId, string soNumber, string poNumber)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@JobId", jobId),
			   new Parameter("@SONumber", soNumber),
			   new Parameter("@PONumber", poNumber),
			   new Parameter("@EnteredBy", activeUser.UserName)
		   };

			return ExecuteScaler(StoredProceduresConstant.UpdJobOrderMapping, parameters);
		}
	}
}
