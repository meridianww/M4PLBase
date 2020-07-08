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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobRefStatusCommands
// Purpose:                                      Client to consume M4PL API called JobRefStatusController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
	public class JobRefStatusCommands : BaseCommands<JobRefStatusView>, IJobRefStatusCommands
	{
		/// <summary>
		/// Route to call JobRefStatuses
		/// </summary>
		public override string RouteSuffix
		{
			get { return "JobRefStatuses"; }
		}

        public override IList<JobRefStatusView> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            var content = restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "GetPagedData"), ActiveUser).AddObject(pagedDataInfo)).Content;
            content = content.Replace("[[", "[");
            content = content.Replace("]]", "]");
            var apiResult = JsonConvert.DeserializeObject<ApiResult<JobRefStatusView>>(content);
            pagedDataInfo.TotalCount = ((apiResult != null) && apiResult.TotalResults > 0) ? apiResult.TotalResults : apiResult.ReturnedResults;
            return apiResult.Results;
        }
    }
}