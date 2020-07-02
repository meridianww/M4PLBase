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
// Programmer:                                   Nikhil
// Date Programmed:                              26/07/2019
// Program Name:                                 JobBillableSheetCommands
// Purpose:                                      Client to consume M4PL API called JobBillableSheetController
//=================================================================================================================
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Job
{

    public class JobBillableSheetCommands : BaseCommands<JobBillableSheetView>, IJobBillableSheetCommands
    {
        private new readonly string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];

        private readonly RestClient _restClient;

        public JobBillableSheetCommands()
        {
            _restClient = new RestClient(new Uri(_baseUri));
        }

        /// <summary>
        /// Route to call JobBillableSheets
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobBillableSheets"; }
        }

        public IList<JobPriceCodeAction> GetJobPriceCodeAction(long jobId)
        {
            var content = RestClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobBillableCodeAction"), ActiveUser).AddParameter("jobId", jobId)).Content;
            var apiResult = JsonConvert.DeserializeObject<ApiResult<JobPriceCodeAction>>(content);
            return apiResult.Results;
        }

        public JobBillableSheetView GetJobPriceCodeByProgram(long id, long jobId)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "JobBillableCodeByProgram");
            var jobCostCodeByProgram = JsonConvert.DeserializeObject<ApiResult<JobBillableSheet>>(
              _restClient.Execute(
                  HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("id", id).AddParameter("jobId", jobId)).Content).Results?.FirstOrDefault();

            return jobCostCodeByProgram != null ? new JobBillableSheetView() { JobID = jobCostCodeByProgram.JobID, PrcChargeID = jobCostCodeByProgram.PrcChargeID, PrcChargeCode = jobCostCodeByProgram.PrcChargeCode, PrcTitle = jobCostCodeByProgram.PrcTitle, PrcUnitId = jobCostCodeByProgram.PrcUnitId, PrcRate = jobCostCodeByProgram.PrcRate, ChargeTypeId = jobCostCodeByProgram.ChargeTypeId, StatusId = jobCostCodeByProgram.StatusId, PrcElectronicBilling = jobCostCodeByProgram.PrcElectronicBilling, IsProblem = jobCostCodeByProgram.IsProblem } : null;
        }
    }
}
