#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 scrCatalogListCommands
// Purpose:                                      Contains commands to perform CRUD on scrCatalogList
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScrCatalogListCommands : BaseCommands<Entities.Scanner.ScrCatalogList>
    {
        /// <summary>
        /// Gets list of scrCatalogLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScrCatalogList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrCatalogListView, EntitiesAlias.ScrCatalogList);
        }

        /// <summary>
        /// Gets the specific scrCatalogList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrCatalogList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScrCatalogList);
        }

        /// <summary>
        /// Creates a new scrCatalogList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrCatalogList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrCatalogList Post(ActiveUser activeUser, Entities.Scanner.ScrCatalogList scrCatalogList)
        {
            var parameters = GetParameters(scrCatalogList);
            parameters.AddRange(activeUser.PostDefaultParams(scrCatalogList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScrCatalogList);
        }

        /// <summary>
        /// Updates the existing scrCatalogList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scrCatalogList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScrCatalogList Put(ActiveUser activeUser, Entities.Scanner.ScrCatalogList scrCatalogList)
        {
            var parameters = GetParameters(scrCatalogList);
            parameters.AddRange(activeUser.PutDefaultParams(scrCatalogList.Id, scrCatalogList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrCatalogList);
        }

        /// <summary>
        /// Deletes a specific scrCatalogList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletescrCatalogList);
            return 0;
        }

        /// <summary>
        /// Deletes list of scrCatalogLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScrCatalogList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the scrCatalogLists Module
        /// </summary>
        /// <param name="scrCatalogList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScrCatalogList scrCatalogList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@catalogProgramID", scrCatalogList.CatalogProgramID),
               new Parameter("@catalogItemNumber", scrCatalogList.CatalogItemNumber),
               new Parameter("@catalogCode", scrCatalogList.CatalogCode),
               new Parameter("@catalogTitle", scrCatalogList.CatalogTitle),
               new Parameter("@statusId", scrCatalogList.StatusId),
               new Parameter("@catalogCustCode",string.IsNullOrWhiteSpace(scrCatalogList.CatalogCustCode) ? scrCatalogList.CatalogCode :scrCatalogList.CatalogCustCode),
               new Parameter("@catalogUoMCode", scrCatalogList.CatalogUoMCode),
               new Parameter("@catalogCubes", scrCatalogList.CatalogCubes),
               new Parameter("@catalogWidth", scrCatalogList.CatalogWidth),
               new Parameter("@catalogLength", scrCatalogList.CatalogLength),
               new Parameter("@catalogHeight", scrCatalogList.CatalogHeight),
               new Parameter("@catalogWLHUoM", scrCatalogList.CatalogWLHUoM),
               new Parameter("@catalogWeight", scrCatalogList.CatalogWeight),
           };
            return parameters;
        }
    }
}