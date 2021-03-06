﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Finance
{
	public class GatewayCommands : BaseCommands<GatewayView>,
		IGatewayCommands
	{
		public override string RouteSuffix
		{
			get { return "GatewayImport"; }
		}

		public StatusModel GenerateProgramGateway(List<GatewayView> gatewayView)
		{
			string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
			RestClient _restClient = new RestClient(new Uri(_baseUri));

			var route = string.Format("{0}/{1}", RouteSuffix, "GenerateProgramGateway");

			var result = JsonConvert.DeserializeObject<ApiResult<StatusModel>>(_restClient.Execute(
			   HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(gatewayView)).Content).Results?.FirstOrDefault();

			return result;
		}
	}
}


