/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Client to consume M4PL API called JobController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Route to call Jobs
    /// </summary>
    public class JobReportCommands : BaseCommands<JobReportView>, IJobReportCommands
    {
        public override string RouteSuffix
        {
            get { return "JobReports"; }
        }
        public IList<JobVocReport> GetVocReportData(string locationCode, DateTime? startDate, DateTime? endDate)
        { 
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "VocReport"), ActiveUser).AddParameter("locationCode", locationCode).AddParameter("startDate", startDate).AddParameter("endDate", endDate);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<List<JobVocReport>>>(result.Content).Results.FirstOrDefault(); 
        }
    }
}