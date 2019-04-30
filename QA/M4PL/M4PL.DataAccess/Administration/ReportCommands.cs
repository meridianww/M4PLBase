using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class ReportCommands : BaseCommands<Report>
    {
        /// <summary>
        /// Gets the list of Meudriver Details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Report> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.Report, langCode: true);
        }

        /// <summary>
        /// Gets the specific menu driver record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Report Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new record for menu driver in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="report"></param>
        /// <returns></returns>

        public static Report Post(ActiveUser activeUser, Report report)
        {
            var parameters = GetParameters(report);
            // parameters.Add(new Parameter("@langCode", report.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(report));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// updates the record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="report"></param>
        /// <returns></returns>

        public static Report Put(ActiveUser activeUser, Report report)
        {
            var parameters = GetParameters(report);
            // parameters.Add(new Parameter("@langCode", report.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(report.Id, report));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
            return 0;
        }

        /// <summary>
        /// Deletes a list of record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Report, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the required parameters for the  menu driver Module
        /// </summary>
        /// <param name="report"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Report report)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@orgId", report.OrganizationId),
                new Parameter("@mainModuleId", report.RprtMainModuleId),
                new Parameter("@reportName", report.RprtName),
                new Parameter("@reportDesc", report.RprtDescription),
                new Parameter("@isDefault", report.RprtIsDefault),
                new Parameter("@statusId", report.StatusId),
            };
            return parameters;
        }
    }
}