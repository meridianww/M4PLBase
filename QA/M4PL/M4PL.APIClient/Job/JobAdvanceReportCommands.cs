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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              1/20/2020
// Program Name:                                 JobAdvanceReportCommands
// Purpose:                                      Client to consume M4PL API called JobAdvanceReportController
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
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReportView>, IJobAdvanceReportCommands
    {
        /// <summary>
        /// Route to call JobAdvanceReport
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobAdvanceReport"; }
        }

        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(string entity)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "AdvanceReport"), ActiveUser).AddParameter("entity", entity);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<List<JobAdvanceReportFilter>>>(result.Content).Results?.FirstOrDefault();
        }

        public StatusModel ImportScrubDriverDetails(JobDriverScrubReportData scriberDriverView)
        {
            var request = HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, 
                "GenerateScrubDriverDetails"), ActiveUser).AddJsonBody(scriberDriverView);
            var result = JsonConvert.DeserializeObject<ApiResult<StatusModel>>(RestClient.Execute(request).Content)
                .Results?.FirstOrDefault();
            return result;
        }
        public StatusModel ImportProjectedCapacityDetails(ProjectedCapacityData projectedCapacityView)
        {
            var request = HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix,
                "GenerateProjectedCapacityDetails"), ActiveUser).AddJsonBody(projectedCapacityView);
            var result = JsonConvert.DeserializeObject<ApiResult<StatusModel>>(RestClient.Execute(request).Content)
                .Results?.FirstOrDefault();
            return result;
        }       
    }
}