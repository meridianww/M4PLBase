/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 scrOsdReasonListCommands
Purpose:                                      Contains commands to perform CRUD on scrOsdReasonList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrOsdReasonListCommands : BaseCommands<Entities.Scanner.ScrOsdReasonList>
    {
        /// <summary>
        /// Gets list of scrOsdReasonLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrOsdReasonList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrOsdReasonListView, EntitiesAlias.ScrOsdReasonList);
        }

        /// <summary>
        /// Gets the specific scrOsdReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdReasonList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrOsdReasonList);
        }

        /// <summary>
        /// Creates a new scrOsdReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrOsdReasonList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdReasonList Post(ActiveUser activeUser, Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
        {
            var parameters = GetParameters(scrOsdReasonList);
            parameters.AddRange(activeUser.PostDefaultParams(scrOsdReasonList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrOsdReasonList);
        }

        /// <summary>
        /// Updates the existing scrOsdReasonList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrOsdReasonList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdReasonList Put(ActiveUser activeUser, Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
        {
            var parameters = GetParameters(scrOsdReasonList);
            parameters.AddRange(activeUser.PutDefaultParams(scrOsdReasonList.Id, scrOsdReasonList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrOsdReasonList);
        }

        /// <summary>
        /// Deletes a specific scrOsdReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrOsdReasonList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrOsdReasonLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrOsdReasonList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrOsdReasonLists Module
        /// </summary>
        /// <param name="scrOsdReasonList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@programID", scrOsdReasonList.ProgramID),
               new Parameter("@reasonItemNumber", scrOsdReasonList.ReasonItemNumber),
               new Parameter("@reasonIDCode", scrOsdReasonList.ReasonIDCode),
               new Parameter("@reasonTitle", scrOsdReasonList.ReasonTitle),
               new Parameter("@statusId", scrOsdReasonList.StatusId),
           };
            return parameters;
        }
    }
}