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
// Program Name:                                 AttachmentCommands
// Purpose:                                      Client to consume M4PL API called AttachmentController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Attachment;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;

namespace M4PL.APIClient.Attachment
{
    public class AttachmentCommands : BaseCommands<AttachmentView>, IAttachmentCommands
    {
        /// <summary>
        /// Route to call Contacts
        /// </summary>
        public override string RouteSuffix
        {
            get { return "Attachments"; }
        }

        public virtual IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName)
        {
            var content = RestClient.Execute(
               HttpRestClient.RestAuthRequest(Method.DELETE, string.Format("{0}/{1}", RouteSuffix, "DeleteAndUpdateAttachmentCount"), ActiveUser).AddParameter("ids", string.Join(",", ids)).AddParameter("statusId", statusId).AddParameter("parentTable", parentTable).AddParameter("fieldName", fieldName)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            var result = JsonConvert.DeserializeObject<ApiResult<IdRefLangName>>(content).Results;
            return result;
        }
    }
}