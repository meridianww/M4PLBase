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
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Job
{
	public class JobCardCommands : BaseCommands<JobCardView>, IJobCardCommands
	{
		/// <summary>
		/// Route to call JobAdvanceReport
		/// </summary>
		public override string RouteSuffix
		{
			get { return "JobCard"; }
		}

		public IList<JobCardTileDetail> GetCardTileData(long companyId, string whereCondition)
		{
			var jobCondition = new JobCardCondition() { CompanyId = companyId, WhereCondition = whereCondition };
			var request = HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "GetCardTileData"), ActiveUser).AddObject(jobCondition);
			var result = RestClient.Execute(request);
			return JsonConvert.DeserializeObject<ApiResult<JobCardTileDetail>>(result.Content).Results;
		}

		public IList<JobCard> GetDropDownDataForJobCard(long customerId)
		{
			var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetDropDownDataForJobCard"), ActiveUser).AddParameter("customerId", customerId);
			var result = RestClient.Execute(request);
			return JsonConvert.DeserializeObject<ApiResult<List<JobCard>>>(result.Content).Results?.FirstOrDefault();
		}
	}
}