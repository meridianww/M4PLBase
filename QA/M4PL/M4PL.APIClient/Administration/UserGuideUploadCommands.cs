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
// Programmer:                                   Kamal
// Date Programmed:                              12/11/2020
// Program Name:                                 UserGuideUploadCommands
// Purpose:                                      Client to consume M4PL API called UserGuideUploadController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Administration;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Administration
{
    public class UserGuideUploadCommands : BaseCommands<UserGuidUploadView>, IUserGuideUploadCommands
    {
        public override string RouteSuffix
        {
            get { return "UserGuideUpload"; }
        }
        public bool UploadUserGuide(UserGuidUploadView userGuidUploadView)
        {
            var routeSuffix = string.Format("{0}/{1}", RouteSuffix, "UploadUserGuide");
            var request = HttpRestClient.RestAuthRequest(Method.POST, routeSuffix, ActiveUser);
            request.AddJsonBody(userGuidUploadView.FileContent);
            request.AddFileBytes("PostedFile", (userGuidUploadView.FileContent != null && userGuidUploadView.FileContent.Length > 1) ? userGuidUploadView.FileContent : new byte[] { }, userGuidUploadView.DocumentName, "multipart/form-data");
            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(RestClient.Execute(request).Content).Results?.FirstOrDefault();
            return result.HasValue ? (bool)result : false;
        }

        public bool GenerateKnowledgeDetail(UserGuidUploadView userGuidUploadView)
        {
            var content = RestClient.Execute(
                            HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "GenerateKnowledgeDetail"), ActiveUser)
                            .AddObject(userGuidUploadView)).Content;
            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(content).Results?.FirstOrDefault();
            return result.HasValue ? (bool)result : false;           
        }
    }
}
