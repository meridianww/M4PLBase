/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 JobAdvanceReportCommands
Purpose:                                      Client to consume M4PL API called JobAdvanceReportController
=================================================================================================================*/

using System.Collections.Generic;
using System.Linq;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;

namespace M4PL.APIClient.Job
{
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReportView>, IJobAdvanceReportCommands
	{
		/// <summary>
		/// Route to call JobAdvanceReport
		/// </summary>
		public override string RouteSuffix
        {
            get { return "JobAdvanceReport"; }
        }
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(long customerId, string entity)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "AdvanceReport"), ActiveUser).AddParameter("customerId", customerId).AddParameter("entity", entity);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<List<JobAdvanceReportFilter>>>(result.Content).Results?.FirstOrDefault();
        }
    }
}