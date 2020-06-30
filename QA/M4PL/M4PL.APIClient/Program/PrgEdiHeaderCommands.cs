/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgEdiHeaderCommands
Purpose:                                      Client to consume M4PL API called PrgEdiHeaderController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
namespace M4PL.APIClient.Program
{
    public class PrgEdiHeaderCommands : BaseCommands<PrgEdiHeaderView>, IPrgEdiHeaderCommands
    {
        /// <summary>
        /// Route to call PrgEdiHeaders
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgEdiHeaders"; }
        }

        public IList<TreeModel> EdiTree(long? parentId, bool model)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/EdiTree", ActiveUser).AddParameter("parentId", parentId).AddParameter("model", model)).Content).Results;
        }

        public int GetProgramLevel(long? programId)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            return JsonConvert.DeserializeObject<ApiResult<int>>(_restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/getProgramLevel", ActiveUser).AddParameter("programId", programId)).Content).Results.FirstOrDefault();
        }
    }
}