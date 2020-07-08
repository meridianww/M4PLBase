#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
	public class JobHistoryCommand : BaseCommands<JobHistoryView>, IJobHistoryCommand
	{
		/// <summary>
		/// Route to call JobCargos
		/// </summary>
		public override string RouteSuffix
		{
			get { return "JobHistorys"; }
		}

        public override IList<JobHistoryView> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            var content = restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "GetPagedData"), ActiveUser).AddObject(pagedDataInfo)).Content;
            content = content.Replace("[[", "[");
            content = content.Replace("]]", "]");
            var apiResult = JsonConvert.DeserializeObject<ApiResult<JobHistoryView>>(content);
            pagedDataInfo.TotalCount = ((apiResult != null) && apiResult.TotalResults > 0) ? apiResult.TotalResults : apiResult.ReturnedResults;
            return apiResult.Results;
        }
    }
}