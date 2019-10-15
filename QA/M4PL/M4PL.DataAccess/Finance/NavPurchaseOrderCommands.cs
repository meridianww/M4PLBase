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
		public static NavPurchaseOrderRequest GetPurchaseOrderCreationData(ActiveUser activeUser, long jobId, EntitiesAlias entityName)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobId", jobId)
		   };

			return SqlSerializer.Default.DeserializeSingleRecord<NavPurchaseOrderRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
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
