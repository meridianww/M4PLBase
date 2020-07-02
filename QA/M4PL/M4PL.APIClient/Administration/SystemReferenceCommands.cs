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
// Date Programmed:                              10/10/2017
// Program Name:                                 SystemReferenceCommands
// Purpose:                                      Client to consume M4PL API called SystemReferenceController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;

namespace M4PL.APIClient.Administration
{
    public class SystemReferenceCommands : BaseCommands<SystemReferenceView>, ISystemReferenceCommands
    {
        /// <summary>
        /// Route to call System References
        /// </summary>
        public override string RouteSuffix
        {
            get { return "SystemReferences"; }
        }

        public IList<IdRefLangName> GetDeletedRecordLookUpIds(string allIds)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "DeletedRecordLookUpIds");
            var content = RestClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, routeSuffix, ActiveUser).AddParameter("allIds", allIds)).Content;
            return JsonConvert.DeserializeObject<ApiResult<IdRefLangName>>(content).Results;
        }
    }
}