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
// Program Name:                                 ProgramCommands
// Purpose:                                      Client to consume M4PL API called ProgramControllers
//=================================================================================================================

using M4PL.APIClient.ViewModels.Event;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Program
{
	public class PrgEventManagementCommands : BaseCommands<PrgEventManagementView>, IPrgEventManagementCommands
	{
		/// <summary>
		/// Route to call PrgEventManagement
		/// </summary>
		public override string RouteSuffix
		{
			get { return "PrgEventManagement"; }
		}
        
        public IList<EventSubscriberTypeView> GetEventSubscriber()
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            
            var content = _restClient.Execute(
            HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/GetEventSubscriber", ActiveUser)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            var desearilizedResult = JsonConvert.DeserializeObject<ApiResult<EventSubscriberTypeView>>(content);
            return desearilizedResult.Results;
        }

    }
}