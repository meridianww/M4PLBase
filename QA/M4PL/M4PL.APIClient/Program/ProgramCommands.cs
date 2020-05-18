/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ProgramCommands
Purpose:                                      Client to consume M4PL API called ProgramControllers
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Program
{
    public class ProgramCommands : BaseCommands<ProgramView>, IProgramCommands
    {
        /// <summary>
        /// Route to call programs
        /// </summary>
        public override string RouteSuffix
        {
            get { return "Programs"; }
        }

        public IList<TreeModel> ProgramTree()
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/ProgramTree", ActiveUser)).Content).Results;
        }

        public IList<TreeModel> ProgramTree(long? parentId, string model)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/ProgramTree", ActiveUser).AddParameter("parentId", parentId).AddParameter("model", model)).Content).Results;
        }

        public ViewModels.Program.ProgramView Get(long id, long? parentId)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<ProgramView>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/GetProgram", ActiveUser).AddParameter("parentId", parentId).AddParameter("id", id)).Content).Results?.FirstOrDefault();
        }

        public IList<TreeModel> ProgramTree(long? parentId, bool isCustNode)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/ProgramTree", ActiveUser).AddParameter("parentId", parentId).AddParameter("isCustNode", isCustNode)).Content).Results;
        }

        public IList<TreeModel> ProgramCopyTree(long programId, long? parentId, bool isCustNode, bool isSource)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/ProgramCopyTree", ActiveUser).AddParameter("isSource", isSource).AddParameter("programId", programId).AddParameter("parentId", parentId).AddParameter("isCustNode", isCustNode)).Content).Results;

        }

        public async System.Threading.Tasks.Task<bool> CopyPPPModel(CopyPPPModel copyPPPModel)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            
            var route = string.Format("{0}/{1}", RouteSuffix, "CopyPPPModel");

            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(copyPPPModel)).Content).Results?.FirstOrDefault();

            return result.HasValue ? (bool)result : false;
        }
    }
}