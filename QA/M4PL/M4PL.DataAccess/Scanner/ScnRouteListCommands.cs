/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnRouteListCommands
Purpose:                                      Contains commands to perform CRUD on ScnRouteList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScnRouteListCommands : BaseCommands<Entities.Scanner.ScnRouteList>
    {
        /// <summary>
        /// Gets list of ScnRouteLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScnRouteList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnRouteListView, EntitiesAlias.ScnRouteList);
        }

        /// <summary>
        /// Gets the specific ScnRouteList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnRouteList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScnRouteList);
        }

        /// <summary>
        /// Creates a new ScnRouteList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnRouteList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnRouteList Post(ActiveUser activeUser, Entities.Scanner.ScnRouteList scnRouteList)
        {
            var parameters = GetParameters(scnRouteList);
            parameters.AddRange(activeUser.PostDefaultParams(scnRouteList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScnRouteList);
        }

        /// <summary>
        /// Updates the existing ScnRouteList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnRouteList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnRouteList Put(ActiveUser activeUser, Entities.Scanner.ScnRouteList scnRouteList)
        {
            var parameters = GetParameters(scnRouteList);
            parameters.AddRange(activeUser.PutDefaultParams(scnRouteList.Id, scnRouteList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnRouteList);
        }

        /// <summary>
        /// Deletes a specific ScnRouteList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteScnRouteList);
            return 0;
        }

        /// <summary>
        /// Deletes list of ScnRouteLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScnRouteList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the ScnRouteLists Module
        /// </summary>
        /// <param name="scnRouteList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScnRouteList scnRouteList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@routeID", scnRouteList.RouteID),
               new Parameter("@routeName", scnRouteList.RouteName),
               new Parameter("@programID", scnRouteList.ProgramID),
           };
            return parameters;
        }
    }
}
