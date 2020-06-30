/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 scrOsdListCommands
Purpose:                                      Contains commands to perform CRUD on scrOsdList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrOsdListCommands : BaseCommands<Entities.Scanner.ScrOsdList>
    {
        /// <summary>
        /// Gets list of scrOsdLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrOsdList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrOsdListView, EntitiesAlias.ScrOsdList);
        }

        /// <summary>
        /// Gets the specific scrOsdList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrOsdList);
        }

        /// <summary>
        /// Creates a new scrOsdList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrOsdList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdList Post(ActiveUser activeUser, Entities.Scanner.ScrOsdList scrOsdList)
        {
            var parameters = GetParameters(scrOsdList);
            parameters.AddRange(activeUser.PostDefaultParams(scrOsdList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrOsdList);
        }

        /// <summary>
        /// Updates the existing scrOsdList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrOsdList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrOsdList Put(ActiveUser activeUser, Entities.Scanner.ScrOsdList scrOsdList)
        {
            var parameters = GetParameters(scrOsdList);
            parameters.AddRange(activeUser.PutDefaultParams(scrOsdList.Id, scrOsdList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrOsdList);
        }

        /// <summary>
        /// Deletes a specific scrOsdList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrOsdList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrOsdLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrOsdList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrOsdLists Module
        /// </summary>
        /// <param name="scrOsdList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrOsdList scrOsdList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@programID", scrOsdList.ProgramID),
               new Parameter("@osdItemNumber", scrOsdList.OSDItemNumber),
               new Parameter("@osdCode", scrOsdList.OSDCode),
               new Parameter("@osdTitle", scrOsdList.OSDTitle),
               new Parameter("@oSDType", scrOsdList.OSDType),
               new Parameter("@statusId", scrOsdList.StatusId),
           };
            return parameters;
        }
    }
}