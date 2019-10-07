﻿/*Copyright(2016) Meridian                    Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommand
Purpose:                                      Contains commands to perform CRUD on NavSalesOrderCommand
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
	public class NavSalesOrderCommand : BaseCommands<NavSalesOrder>
	{
		public static NavSalesOrder GetRecordDataFromDatabase(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			NavSalesOrder navSalesOrder = null;
			SetCollection sets = new SetCollection();
			sets.AddSet<NavSalesOrder>("NavSalesOrder");
			sets.AddSet<NavSalesOrderItem>("NavSalesOrderItem");
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };
			SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetDataForOrder);
			var navSalesOrderSet = sets.GetSet<NavSalesOrder>("NavSalesOrder");
			var navSalesOrderItemSet = sets.GetSet<NavSalesOrderItem>("NavSalesOrderItem");
			if (navSalesOrderSet != null && navSalesOrderSet.Count > 0)
			{
				navSalesOrder = new NavSalesOrder();
				navSalesOrder = navSalesOrderSet.FirstOrDefault();
				navSalesOrder.SalesLines = navSalesOrderItemSet != null && navSalesOrderItemSet.Count > 0 ? navSalesOrderItemSet.ToArray() : null;
			}

			return navSalesOrder;
		}
	}
}
