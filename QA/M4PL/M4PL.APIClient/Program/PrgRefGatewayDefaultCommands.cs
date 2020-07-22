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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 PrgRefGatewayDefaultCommands
// Purpose:                                      Client to consume M4PL API called PrgRefGatewayDefaultController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Program
{
	public class PrgRefGatewayDefaultCommands : BaseCommands<PrgRefGatewayDefaultView>, IPrgRefGatewayDefaultCommands
	{
		/// <summary>
		/// Route to call PrgGatewayDefaults
		/// </summary>
		public override string RouteSuffix
		{
			get { return "PrgRefGatewayDefaults"; }
		}

		public IList<TreeModel> ProgramGatewayTree(long programId)
		{
			return new List<TreeModel>();
		}

		public PrgRefGatewayDefaultView PutWithSettings(PrgRefGatewayDefaultView prgRefGatewayDefaultView)
		{
			var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPut");
			var result = JsonConvert.DeserializeObject<ApiResult<PrgRefGatewayDefaultView>>(
				 restClient.Execute(
				HttpRestClient.RestAuthRequest(Method.PUT, newRouteSuffix, ActiveUser).AddObject(prgRefGatewayDefaultView)).Content).Results?.FirstOrDefault();
			return result;
		}

		public PrgRefGatewayDefaultView PostWithSettings(PrgRefGatewayDefaultView prgRefGatewayDefaultView)
		{
			var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPost");
			var result = JsonConvert.DeserializeObject<ApiResult<PrgRefGatewayDefaultView>>(
				 restClient.Execute(
				HttpRestClient.RestAuthRequest(Method.POST, newRouteSuffix, ActiveUser).AddObject(prgRefGatewayDefaultView)).Content).Results?.FirstOrDefault();
			return result;
		}
	}
}