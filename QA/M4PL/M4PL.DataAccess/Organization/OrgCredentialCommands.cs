#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 OrgCredentialCommands
// Purpose:                                      Contains commands to perform CRUD on OrgCredential
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrgCredentialCommands : BaseCommands<OrgCredential>
    {
        /// <summary>
        /// Gets list of Organization Credential records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<OrgCredential> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgCredentialView, EntitiesAlias.OrgCredential);
        }

        /// <summary>
        /// Gets the specific Organization Credential record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static OrgCredential Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrgCredential);
        }

        /// <summary>
        /// Creates a new Organization Credential record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgCredential"></param>
        /// <returns></returns>

        public static OrgCredential Post(ActiveUser activeUser, OrgCredential orgCredential)
        {
            var parameters = GetParameters(orgCredential);
            // parameters.Add(new Parameter("@langCode", orgCredential.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(orgCredential));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgCredential);
        }

        /// <summary>
        /// Updates the existing Organization Credential record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgCredential"></param>
        /// <returns></returns>

        public static OrgCredential Put(ActiveUser activeUser, OrgCredential orgCredential)
        {
            var parameters = GetParameters(orgCredential);
            // parameters.Add(new Parameter("@langCode", orgCredential.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(orgCredential.Id, orgCredential));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgCredential);
        }

        /// <summary>
        /// Deletes a specific Organization Credential record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationCredential);
            return 0;
        }

        /// <summary>
        /// Deletes list of Organization Credential records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.OrgCredential, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Organization Credential Module
        /// </summary>
        /// <param name="orgCredential"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(OrgCredential orgCredential)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", orgCredential.OrganizationId),
               new Parameter("@creItemNumber", orgCredential.CreItemNumber),
               new Parameter("@creCode", orgCredential.CreCode),
               new Parameter("@creTitle", orgCredential.CreTitle),
               new Parameter("@creExpDate", orgCredential.CreExpDate),
               new Parameter("@statusId", orgCredential.StatusId),
           };
            return parameters;
        }
    }
}