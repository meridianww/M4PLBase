/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Client to consume M4PL API called JobEDIXcblController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Job
{
    public class JobXcblInfoCommands : BaseCommands<JobXcblInfoView>, IJobXcblInfoCommands
	{
		/// <summary>
		/// Route to call JobEDIXcbl
		/// </summary>
		public override string RouteSuffix
        {
            get { return "JobXcblInfos"; }
        }

		public JobXcblInfoView GetJobXcblInfo(long jobId, string gwyCode, string customerSalesOrder)
		{
            return JsonConvert.DeserializeObject<ApiResult<JobXcblInfoView>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetJobXcblInfo"), ActiveUser)
               .AddParameter("jobId", jobId).AddParameter("gwyCode", gwyCode).AddParameter("customerSalesOrder", customerSalesOrder)).Content).Results.FirstOrDefault();
		}

        public bool AcceptJobXcblInfo(List<JobXcblInfoView> jobXcblInfoView)
        {
           var content = RestClient.Execute(
                           HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "AcceptJobXcblInfo"), ActiveUser)
                           .AddObject(jobXcblInfoView)).Content;
            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results.FirstOrDefault();
            return result;
        }
    }
}