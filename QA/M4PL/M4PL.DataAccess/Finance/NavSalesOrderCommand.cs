/*Copyright(2016) Meridian                    Worldwide Transportation Group
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
		public static NavSalesOrderRequest GetSalesOrderCreationData(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };

			return SqlSerializer.Default.DeserializeSingleRecord<NavSalesOrderRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
		}

		public static List<NavSalesOrderItemRequest> GetSalesOrderItemCreationData(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };

			return SqlSerializer.Default.DeserializeMultiRecords<NavSalesOrderItemRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
		}

		public static List<NavPurchaseOrderItemRequest> GetPurchaseOrderItemCreationData(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };

			return SqlSerializer.Default.DeserializeMultiRecords<NavPurchaseOrderItemRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
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

		public static bool UpdateJobOrderItemMapping(ActiveUser activeUser, long jobId, string entityName, int lineNumber)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@JobId", jobId),
			   new Parameter("@EntityName", entityName),
			   new Parameter("@LineNumber", lineNumber),
			   new Parameter("@EnteredBy", activeUser.UserName)
		   };

			return ExecuteScaler(StoredProceduresConstant.UpdJobOrderItemMapping, parameters);
		}

		public static List<JobOrderItemMapping> GetJobOrderItemMapping(long jobId)
		{
			return SqlSerializer.Default.DeserializeMultiRecords<JobOrderItemMapping>(StoredProceduresConstant.GetJobOrderItemMapping, new Parameter("@JobId", jobId), false, true);
		}
	}
}
