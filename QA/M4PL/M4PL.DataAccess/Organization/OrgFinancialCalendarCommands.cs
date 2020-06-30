/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 OrgFinancialCalendarCommands
Purpose:                                      Contains commands to perform CRUD on OrgFinancialCalendar
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrgFinancialCalendarCommands : BaseCommands<OrgFinancialCalendar>
    {
        /// <summary>
        /// Gets list of Organization Financial Calendar records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<OrgFinancialCalendar> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgFinancialCalView, EntitiesAlias.OrgFinancialCalendar);
        }

        /// <summary>
        /// Gets the specific Organization Financial Calendar record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static OrgFinancialCalendar Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrgFinancialCalender);
        }

        /// <summary>
        /// Creates a new Organization Financial Calendar record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgFinancialCalendar"></param>
        /// <returns></returns>

        public static OrgFinancialCalendar Post(ActiveUser activeUser, OrgFinancialCalendar orgFinancialCalendar)
        {
            var parameters = GetParameters(orgFinancialCalendar);
            // parameters.Add(new Parameter("@langCode", orgFinancialCalendar.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(orgFinancialCalendar));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgFinancialCalender);
        }

        /// <summary>
        /// Updates the existing Organization Financial Calendar record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgFinancialCalendar"></param>
        /// <returns></returns>

        public static OrgFinancialCalendar Put(ActiveUser activeUser, OrgFinancialCalendar orgFinancialCalendar)
        {
            var parameters = GetParameters(orgFinancialCalendar);
            // parameters.Add(new Parameter("@langCode", orgFinancialCalendar.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(orgFinancialCalendar.Id, orgFinancialCalendar));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgFinancialCalender);
        }

        /// <summary>
        /// Deletes a specific Organization Financial Calendar record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationFinancialCalendar);
            return 0;
        }

        /// <summary>
        /// Deletes list of Organization Financial Calendar records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.OrgFinancialCalendar, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Organization Financial Calendar Module
        /// </summary>
        /// <param name="orgFinancialCalender"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(OrgFinancialCalendar orgFinancialCalender)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", orgFinancialCalender.OrganizationId),
               new Parameter("@fclPeriod", orgFinancialCalender.FclPeriod),
               new Parameter("@fclPeriodCode", orgFinancialCalender.FclPeriodCode),
               new Parameter("@fclPeriodStart", orgFinancialCalender.FclPeriodStart),
               new Parameter("@fclPeriodEnd", orgFinancialCalender.FclPeriodEnd),
               new Parameter("@fclPeriodTitle", orgFinancialCalender.FclPeriodTitle),
               new Parameter("@fclAutoShortCode", orgFinancialCalender.FclAutoShortCode),
               new Parameter("@fclWorkDays", orgFinancialCalender.FclWorkDays),
               new Parameter("@finCalendarTypeId", orgFinancialCalender.FinCalendarTypeId),
               new Parameter("@statusId", orgFinancialCalender.StatusId),
           };
            return parameters;
        }
    }
}