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
// Date Programmed:                              07/31/2019
// Program Name:                                 NavPriceCodeCommands
// Purpose:                                      Client to consume M4PL API called NavPriceCodeCommands
//===================================================================================================================

using M4PL.APIClient.ViewModels.Document;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Finance
{
	public class NavPriceCodeCommands : BaseCommands<NavPriceCodeView>,
		INavPriceCodeCommands
	{
		public override string RouteSuffix
		{
			get { return "NavPriceCode"; }
		}

		public IList<NavPriceCodeView> GetAllPriceCode()
		{
			var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetAllPriceCode"), ActiveUser);
			var result = RestClient.Execute(request);
			return JsonConvert.DeserializeObject<ApiResult<List<NavPriceCodeView>>>(result.Content).Results?.FirstOrDefault();
		}
        public DocumentDataView GetPriceCodeReportByJobId( string jobId)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetPriceCodeReportByJobId"), ActiveUser).AddParameter("jobId", jobId);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<DocumentDataView>>(result.Content).Results?.FirstOrDefault();
        }
    }
}