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
// Program Name:                                 MenuAccessLevelCommands
// Purpose:                                      Contains commands to perform CRUD on MenuAccessLevel
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class MenuAccessLevelCommands : BaseCommands<MenuAccessLevel>
    {
        /// <summary>
        /// Gets list of MenuAccessLevel data from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<MenuAccessLevel> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetMenuAccessLevelView, EntitiesAlias.MenuAccessLevel, langCode: true);
        }

        /// <summary>
        /// Gets a specific record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static MenuAccessLevel Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetMenuAccessLevel, langCode: true);
        }

        /// <summary>
        /// creates a new Menuaccesslevel record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="menuAccessLevel"></param>
        /// <returns></returns>

        public static MenuAccessLevel Post(ActiveUser activeUser, MenuAccessLevel menuAccessLevel)
        {
            var parameters = GetParameters(menuAccessLevel);
            parameters.Add(new Parameter("@langCode", menuAccessLevel.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(menuAccessLevel));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertMenuAccessLevel);
        }

        /// <summary>
        /// updates the record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="menuAccessLevel"></param>
        /// <returns></returns>

        public static MenuAccessLevel Put(ActiveUser activeUser, MenuAccessLevel menuAccessLevel)
        {
            var parameters = GetParameters(menuAccessLevel);
            parameters.Add(new Parameter("@langCode", menuAccessLevel.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(menuAccessLevel.Id, menuAccessLevel));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateMenuAccessLevel);
        }

        /// <summary>
        /// Deletes the specific record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuAccessLevel);
            return 0;
        }

        /// <summary>
        /// Deletes list of records from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids)
        {
            //return Delete(activeUser, ids, StoredProceduresConstant.DeleteMenuAccessLevel);
            return null;
        }

        /// <summary>
        /// Gets the list of parameters required for the menuaccesslevel Module
        /// </summary>
        /// <param name="menuAccessLevel"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(MenuAccessLevel menuAccessLevel)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@sysRefId", menuAccessLevel.SysRefId),
                new Parameter("@malOrder", menuAccessLevel.MalOrder),
                new Parameter("@malTitle", menuAccessLevel.MalTitle),
            };
            return parameters;
        }
    }
}