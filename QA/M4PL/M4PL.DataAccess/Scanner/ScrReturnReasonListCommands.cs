/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 scrReturnReasonListCommands
Purpose:                                      Contains commands to perform CRUD on scrOsdReasonList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrReturnReasonListCommands : BaseCommands<Entities.Scanner.ScrReturnReasonList>
    {
        /// <summary>
        /// Gets list of scrReturnReasonLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrReturnReasonList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrReturnReasonListView, EntitiesAlias.ScrReturnReasonList);
        }

        /// <summary>
        /// Gets the specific scrReturnReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrReturnReasonList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrReturnReasonList);
        }

        /// <summary>
        /// Creates a new scrReturnReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrReturnReasonList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrReturnReasonList Post(ActiveUser activeUser, Entities.Scanner.ScrReturnReasonList scrReturnReasonList)
        {
            var parameters = GetParameters(scrReturnReasonList);
            parameters.AddRange(activeUser.PostDefaultParams(scrReturnReasonList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrReturnReasonList);
        }

        /// <summary>
        /// Updates the existing scrReturnReasonList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrReturnReasonList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrReturnReasonList Put(ActiveUser activeUser, Entities.Scanner.ScrReturnReasonList scrReturnReasonList)
        {
            var parameters = GetParameters(scrReturnReasonList);
            parameters.AddRange(activeUser.PutDefaultParams(scrReturnReasonList.Id, scrReturnReasonList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrReturnReasonList);
        }

        /// <summary>
        /// Deletes a specific scrReturnReasonList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrReturnReasonList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrReturnReasonLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrReturnReasonList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrReturnReasonLists Module
        /// </summary>
        /// <param name="scrReturnReasonList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrReturnReasonList scrReturnReasonList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@programID", scrReturnReasonList.ProgramID),
               new Parameter("@returnReasonLineItem", scrReturnReasonList.ReturnReasonLineItem),
               new Parameter("@returnReasonCode", scrReturnReasonList.ReturnReasonCode),
               new Parameter("@returnReasonTitle", scrReturnReasonList.ReturnReasonTitle),
               new Parameter("@statusId", scrReturnReasonList.StatusId),
           };
            return parameters;
        }
    }
}