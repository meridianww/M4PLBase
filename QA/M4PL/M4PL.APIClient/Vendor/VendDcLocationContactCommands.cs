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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              09/25/2018
// Program Name:                                 VendDcLocationContactCommands
// Purpose:                                      Client to consume M4PL API called VendDcLocationContactController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Vendor;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Vendor
{
    public class VendDcLocationContactCommands : BaseCommands<VendDcLocationContactView>, IVendDcLocationContactCommands
    {
        /// <summary>
        ///  Route to call Vendor Dc location Contacts
        /// </summary>
        public override string RouteSuffix
        {
            get { return "VendDcLocationContacts"; }
        }

        public VendDcLocationContactView Get(long id, long? parentId)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<VendDcLocationContactView>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/GetVendDcLocationContact", ActiveUser).AddParameter("parentId", parentId).AddParameter("id", id)).Content).Results?.FirstOrDefault();
        }
    }
}
