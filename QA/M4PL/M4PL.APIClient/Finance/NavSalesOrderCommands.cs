#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/04/2019
// Program Name:                                 NavSalesOrderCommands
// Purpose:                                      Client to consume M4PL API called NavSalesOrderCommands
//===================================================================================================================

using M4PL.Entities.Finance;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;
using M4PL.Entities;
using M4PL.APIClient.ViewModels.Finance;

namespace M4PL.APIClient.Finance
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrderView>,
		INavSalesOrderCommands
	{
		public object Method { get; private set; }

		public override string RouteSuffix
		{
			get { return "NavSalesOrder"; }
		}

		public M4PLOrderCreationResponse GenerateOrdersInNav(long jobId)
		{
			return JsonConvert.DeserializeObject<ApiResult<M4PLOrderCreationResponse>>(
			RestClient.Execute(
				HttpRestClient.RestAuthRequest(RestSharp.Method.GET, string.Format("{0}/{1}", RouteSuffix, "GenerateOrdersInNav"), ActiveUser).AddParameter("jobId", jobId)).Content).Results?.FirstOrDefault();
		}
	}
}