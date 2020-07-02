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
// Date Programmed:                              25/07/2019
// Program Name:                                 JobCostSheetCommands
// Purpose:                                      Client to consume M4PL API called JobCostSheetController
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
	public class JobCostSheetCommands : BaseCommands<JobCostSheetView>, IJobCostSheetCommands
	{
		private new readonly string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];

		private readonly RestClient _restClient;

		public JobCostSheetCommands()
		{
			_restClient = new RestClient(new Uri(_baseUri));
		}

		/// <summary>
		/// Route to call JobCostSheet
		/// </summary>
		public override string RouteSuffix
		{
			get { return "JobCostSheets"; }
		}

		public IList<JobCostCodeAction> GetJobCostCodeAction(long jobId)
		{
			var content = RestClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobCostCodeAction"), ActiveUser).AddParameter("jobId", jobId)).Content;
			var apiResult = JsonConvert.DeserializeObject<ApiResult<JobCostCodeAction>>(content);
			return apiResult.Results;
		}

		public JobCostSheetView GetJobCostCodeByProgram(long id, long jobId)
		{
			var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "JobCostCodeByProgram");
			var jobCostCodeByProgram = JsonConvert.DeserializeObject<ApiResult<JobCostSheet>>(
			  _restClient.Execute(
				  HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("id", id).AddParameter("jobId", jobId)).Content).Results?.FirstOrDefault();

			return jobCostCodeByProgram != null ? new JobCostSheetView() { JobID = jobCostCodeByProgram.JobID, CstChargeID = jobCostCodeByProgram.CstChargeID, CstChargeCode = jobCostCodeByProgram.CstChargeCode, CstTitle = jobCostCodeByProgram.CstTitle, CstUnitId = jobCostCodeByProgram.CstUnitId, CstRate = jobCostCodeByProgram.CstRate, ChargeTypeId = jobCostCodeByProgram.ChargeTypeId, StatusId = jobCostCodeByProgram.StatusId, CstElectronicBilling = jobCostCodeByProgram.CstElectronicBilling, IsProblem = jobCostCodeByProgram.IsProblem } : null;
		}
	}
}