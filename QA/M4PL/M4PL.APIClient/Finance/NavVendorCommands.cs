﻿#region Copyright

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
// Date Programmed:                              06/25/2019
// Program Name:                                 NavVendorCommands
// Purpose:                                      Client to consume M4PL API called NavVendorCommands
//===================================================================================================================
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Finance
{
	/// <summary>
	/// Route to call Nav Vendor
	/// </summary>
	public class NavVendorCommands : BaseCommands<NavVendorView>,
		INavVendorCommands
	{
		public override string RouteSuffix
		{
			get { return "NavVendor"; }
		}

		public IList<NavVendorView> GetAllNavVendor()
		{
			var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetAllNavVendor"), ActiveUser);
			var result = RestClient.Execute(request);
			return JsonConvert.DeserializeObject<ApiResult<List<NavVendorView>>>(result.Content).Results?.FirstOrDefault();
		}
	}
}