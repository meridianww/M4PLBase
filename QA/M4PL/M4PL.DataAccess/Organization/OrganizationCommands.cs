/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrganizationCommands
Purpose:                                      Contains commands to perform CRUD on Organization
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrganizationCommands : BaseCommands<Entities.Organization.Organization>
    {
        /// <summary>
        /// Gets list of Organization records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Organization.Organization> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrganizationView, EntitiesAlias.Organization);
        }

        /// <summary>
        /// Gets the specific Organization record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Organization.Organization Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrganization);
        }

        /// <summary>
        /// Creates a new Organization record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="organization"></param>
        /// <returns></returns>

        public static Entities.Organization.Organization Post(ActiveUser activeUser, Entities.Organization.Organization organization)
        {
            var parameters = GetParameters(organization);
            // parameters.Add(new Parameter("@langCode", organization.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(organization));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrganization);
        }

        /// <summary>
        /// Updates the existing Organization record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="organization"></param>
        /// <returns></returns>

        public static Entities.Organization.Organization Put(ActiveUser activeUser, Entities.Organization.Organization organization)
        {
            var parameters = GetParameters(organization);
            // parameters.Add(new Parameter("@langCode", organization.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(organization.Id, organization));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrganization);
        }

        /// <summary>
        /// Deletes a specific Organization record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganization);
            return 0;
        }

        /// <summary>
        /// Deletes list of Organization records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Organization, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Organization Module
        /// </summary>
        /// <param name="organization"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Organization.Organization organization)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgCode", organization.OrgCode),
               new Parameter("@orgTitle", organization.OrgTitle),
               new Parameter("@orgGroupId", organization.OrgGroupId),
               new Parameter("@orgSortOrder", organization.OrgSortOrder),
               new Parameter("@statusId", organization.StatusId),
               new Parameter("@orgContactId", null),
           };
            return parameters;
        }
    }
}