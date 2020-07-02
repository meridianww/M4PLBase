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
// Program Name:                                 ScnDriverListCommands
// Purpose:                                      Contains commands to perform CRUD on ScnDriverList
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScnDriverListCommands : BaseCommands<Entities.Scanner.ScnDriverList>
    {
        /// <summary>
        /// Gets list of ScnDriverLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScnDriverList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnDriverListView, EntitiesAlias.ScnDriverList);
        }

        /// <summary>
        /// Gets the specific ScnDriverList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnDriverList Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScnDriverList);
        }

        /// <summary>
        /// Creates a new ScnDriverList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnDriverList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnDriverList Post(ActiveUser activeUser, Entities.Scanner.ScnDriverList scnDriverList)
        {
            var parameters = GetParameters(scnDriverList);
            parameters.AddRange(activeUser.PostDefaultParams(scnDriverList));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScnDriverList);
        }

        /// <summary>
        /// Updates the existing ScnDriverList record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnDriverList"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnDriverList Put(ActiveUser activeUser, Entities.Scanner.ScnDriverList scnDriverList)
        {
            var parameters = GetParameters(scnDriverList);
            parameters.AddRange(activeUser.PutDefaultParams(scnDriverList.Id, scnDriverList));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnDriverList);
        }

        /// <summary>
        /// Deletes a specific ScnDriverList
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteScnDriverList);
            return 0;
        }

        /// <summary>
        /// Deletes list of ScnDriverLists
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScnDriverList, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the ScnDriverLists Module
        /// </summary>
        /// <param name="scnDriverList"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScnDriverList scnDriverList)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@driverID", scnDriverList.DriverID),
               new Parameter("@firstName", scnDriverList.FirstName),
               new Parameter("@lastName", scnDriverList.LastName),
               new Parameter("@programID", scnDriverList.ProgramID),
               new Parameter("@locationNumber", scnDriverList.LocationNumber),
           };
            return parameters;
        }
    }
}
