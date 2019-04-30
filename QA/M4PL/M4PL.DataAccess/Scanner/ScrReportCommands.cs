using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrReportCommands : BaseCommands<ScrReport>
    {
        /// <summary>
        /// Gets list of Scanner records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<ScrReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.ScrReport);
        }

        /// <summary>
        /// Gets the specific Scanner record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static ScrReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new Scanner record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ScrReport"></param>
        /// <returns></returns>

        public static ScrReport Post(ActiveUser activeUser, ScrReport ScrReport)
        {
            var parameters = GetParameters(ScrReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(ScrReport));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// Updates the existing Scanner record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ScrReport"></param>
        /// <returns></returns>

        public static ScrReport Put(ActiveUser activeUser, ScrReport ScrReport)
        {
            var parameters = GetParameters(ScrReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(ScrReport.Id, ScrReport));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific Scanner record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return 1;
           // return Delete(activeUser, id, StoredProceduresConstant.DeleteScanner);
        }

        /// <summary>
        /// Deletes list of Scanner records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Scanner, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Scanner Module
        /// </summary>
        /// <param name="ScrReport"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(ScrReport ScrReport)
        {
            var parameters = new List<Parameter>
            {
            };
            return parameters;
        }
    }
}