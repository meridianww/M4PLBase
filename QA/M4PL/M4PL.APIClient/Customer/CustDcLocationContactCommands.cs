/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              09/25/2018
Program Name:                                 CustDcLocationContactCommands
Purpose:                                      Client to consume M4PL API called CustDcLocationContactController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Configuration;
using System;
using System.Linq;

namespace M4PL.APIClient.Customer
{
    public class CustDcLocationContactCommands : BaseCommands<CustDcLocationContactView>, ICustDcLocationContactCommands
    {
        /// <summary>
        ///  Route to call Customer Dc location Contacts
        /// </summary>
        public override string RouteSuffix
        {
            get { return "CustDcLocationContacts"; }
        }

        public CustDcLocationContactView Get(long id, long? parentId)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<CustDcLocationContactView>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/GetCustDcLocationContact", ActiveUser).AddParameter("parentId", parentId).AddParameter("id", id)).Content).Results.FirstOrDefault();
        }

    }
}
