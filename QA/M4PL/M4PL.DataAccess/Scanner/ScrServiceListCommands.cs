/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 scrServiceListCommands
Purpose:                                      Contains commands to perform CRUD on scrOsdReasonList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrServiceListCommands : BaseCommands<Entities.Scanner.ScrServiceList>
    {
        /// <summary>
        /// Gets list of scrServiceLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrServiceList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrServiceListView, EntitiesAlias.ScrServiceList);
        }

        /// <summary>
        /// Gets the specific scrServiceList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrServiceList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrServiceList);
        }

        /// <summary>
        /// Creates a new scrServiceList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrServiceList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrServiceList Post(ActiveUser activeUser, Entities.Scanner.ScrServiceList scrServiceList)
        {
            var parameters = GetParameters(scrServiceList);
            parameters.AddRange(activeUser.PostDefaultParams(scrServiceList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrServiceList);
        }

        /// <summary>
        /// Updates the existing scrServiceList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrServiceList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrServiceList Put(ActiveUser activeUser, Entities.Scanner.ScrServiceList scrServiceList)
        {
            var parameters = GetParameters(scrServiceList);
            parameters.AddRange(activeUser.PutDefaultParams(scrServiceList.Id, scrServiceList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrServiceList);
        }

        /// <summary>
        /// Deletes a specific scrServiceList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrServiceList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrServiceLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrServiceList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrServiceLists Module
        /// </summary>
        /// <param name="scrServiceList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrServiceList scrServiceList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@programID", scrServiceList.ProgramID),
               new Parameter("@serviceLineItem", scrServiceList.ServiceLineItem),
               new Parameter("@serviceCode", scrServiceList.ServiceCode),
               new Parameter("@serviceTitle", scrServiceList.ServiceTitle),
               new Parameter("@statusId", scrServiceList.StatusId),
           };
            return parameters;
        }
    }
}