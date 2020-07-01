/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 scrRequirementListCommands
Purpose:                                      Contains commands to perform CRUD on scrOsdReasonList
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrRequirementListCommands : BaseCommands<Entities.Scanner.ScrRequirementList>
    {
        /// <summary>
        /// Gets list of scrRequirementLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrRequirementList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrRequirementListView, EntitiesAlias.ScrRequirementList);
        }

        /// <summary>
        /// Gets the specific scrRequirementList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrRequirementList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrRequirementList);
        }

        /// <summary>
        /// Creates a new scrRequirementList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrRequirementList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrRequirementList Post(ActiveUser activeUser, Entities.Scanner.ScrRequirementList scrRequirementList)
        {
            var parameters = GetParameters(scrRequirementList);
            parameters.AddRange(activeUser.PostDefaultParams(scrRequirementList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrRequirementList);
        }

        /// <summary>
        /// Updates the existing scrRequirementList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrRequirementList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrRequirementList Put(ActiveUser activeUser, Entities.Scanner.ScrRequirementList scrRequirementList)
        {
            var parameters = GetParameters(scrRequirementList);
            parameters.AddRange(activeUser.PutDefaultParams(scrRequirementList.Id, scrRequirementList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrRequirementList);
        }

        /// <summary>
        /// Deletes a specific scrRequirementList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrRequirementList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrRequirementLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrRequirementList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrRequirementLists Module
        /// </summary>
        /// <param name="scrRequirementList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrRequirementList scrRequirementList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@programID", scrRequirementList.ProgramID),
               new Parameter("@requirementLineItem", scrRequirementList.RequirementLineItem),
               new Parameter("@requirementCode", scrRequirementList.RequirementCode),
               new Parameter("@requirementTitle", scrRequirementList.RequirementTitle),
               new Parameter("@statusId", scrRequirementList.StatusId),
           };
            return parameters;
        }
    }
}