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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/04/2019
// Program Name:                                 NavPurchaseOrderCommands
// Purpose:                                      Contains commands to perform CRUD on NavPurchaseOrderCommands
//=============================================================================================================
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Finance
{
	public class NavPurchaseOrderCommands : BaseCommands<NavPurchaseOrder>
	{
		public static NavPurchaseOrderRequest GetPurchaseOrderCreationData(ActiveUser activeUser, List<long> jobIdList, EntitiesAlias entityName)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@EntityName", entityName.ToString()),
			   new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList")
		   };

			return SqlSerializer.Default.DeserializeSingleRecord<NavPurchaseOrderRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
		}

		public static long UpdateJobPurchaseOrderMapping(ActiveUser activeUser, List<long> jobIdList, string poNumber, bool isElectronicInvoiced)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@JobId", jobIdList.First()),
			   new Parameter("@PONumber", poNumber),
			   new Parameter("@IsElectronicInvoiced", isElectronicInvoiced),
			   new Parameter("@EnteredBy", activeUser.UserName)
		   };

			return SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.UpdJobPurchaseOrderMapping, parameters.ToArray(), false, true);
		}
	}
}