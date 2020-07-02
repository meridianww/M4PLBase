#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgReportCommands : BaseCommands<PrgReport>
    {
        /// <summary>
        /// Gets list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.PrgReport);
        }

        /// <summary>
        /// Gets the specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgReport"></param>
        /// <returns></returns>

        public static PrgReport Post(ActiveUser activeUser, PrgReport prgReport)
        {
            var parameters = GetParameters(prgReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(prgReport));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// Updates the existing Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgReport"></param>
        /// <returns></returns>

        public static PrgReport Put(ActiveUser activeUser, PrgReport prgReport)
        {
            var parameters = GetParameters(prgReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(prgReport.Id, prgReport));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteProgram);
        }

        /// <summary>
        /// Deletes list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Program, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Program Module
        /// </summary>
        /// <param name="PrgReport"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgReport PrgReport)
        {
            var parameters = new List<Parameter>
            {
            };
            return parameters;
        }
    }
}