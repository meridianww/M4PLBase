/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrGatewayListCommands
Purpose:                                      Contains commands to perform CRUD on ScrGatewayList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrGatewayListCommands : BaseCommands<Entities.Scanner.ScrGatewayList>
    {
        /// <summary>
        /// Gets list of ScrGatewayLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrGatewayList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrGatewayListView, EntitiesAlias.ScrGatewayList);
        }

        /// <summary>
        /// Gets the specific ScrGatewayList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrGatewayList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrGatewayList);
        }

        /// <summary>
        /// Creates a new ScrGatewayList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrGatewayList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrGatewayList Post(ActiveUser activeUser, Entities.Scanner.ScrGatewayList scrGatewayList)
        {
            var parameters = GetParameters(scrGatewayList);
            parameters.AddRange(activeUser.PostDefaultParams(scrGatewayList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrGatewayList);
        }

        /// <summary>
        /// Updates the existing ScrGatewayList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrGatewayList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrGatewayList Put(ActiveUser activeUser, Entities.Scanner.ScrGatewayList scrGatewayList)
        {
            var parameters = GetParameters(scrGatewayList);
            parameters.AddRange(activeUser.PutDefaultParams(scrGatewayList.Id, scrGatewayList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrGatewayList);
        }

        /// <summary>
        /// Deletes a specific ScrGatewayList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteScrGatewayList);
            return 0;
        }

        /// <summary>
        /// Deletes list of ScrGatewayLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrGatewayList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the ScrGatewayLists Module
        /// </summary>
        /// <param name="scrGatewayList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrGatewayList scrGatewayList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@gatewayStatusID", scrGatewayList.GatewayStatusID),
               new Parameter("@programID", scrGatewayList.ProgramID),
               new Parameter("@gatewayCode", scrGatewayList.GatewayCode),
           };
            return parameters;
        }
    }
}
