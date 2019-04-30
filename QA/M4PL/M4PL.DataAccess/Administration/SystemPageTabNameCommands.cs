/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SystemPageTabNameCommands
Purpose:                                      Contains commands to perform CRUD on SystemPageTabName
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class SystemPageTabNameCommands : BaseCommands<SystemPageTabName>
    {
        /// <summary>
        /// Gets list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<SystemPageTabName> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSystemPageTabNameView, EntitiesAlias.SystemPageTabName, langCode: true);
        }

        /// <summary>
        /// Gets the specific SystemPageTableName record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static SystemPageTabName Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetSystemPageTabName, langCode: true);
        }

        /// <summary>
        /// Creates a new SystemPageTableName record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemPageTabName"></param>
        /// <returns></returns>

        public static SystemPageTabName Post(ActiveUser activeUser, SystemPageTabName systemPageTabName)
        {
            var parameters = GetParameters(systemPageTabName);
            // parameters.Add(new Parameter("@langCode", systemPageTabName.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(systemPageTabName));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertSystemPageTabName);
        }

        /// <summary>
        /// Updates the existing SystemPageTableName recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemPageTabName"></param>
        /// <returns></returns>

        public static SystemPageTabName Put(ActiveUser activeUser, SystemPageTabName systemPageTabName)
        {
            var parameters = GetParameters(systemPageTabName);
            // parameters.Add(new Parameter("@langCode", systemPageTabName.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(systemPageTabName.Id, systemPageTabName));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateSystemPageTabName);
        }

        /// <summary>
        /// Deletes a specific SystemPageTableName record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteSystemPageTabName);
            return 0;
        }

        /// <summary>
        /// Deletes list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.SystemPageTabName, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the systemPageTabName Module
        /// </summary>
        /// <param name="systemPageTabName"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(SystemPageTabName systemPageTabName)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@langCode", systemPageTabName.LangCode),
                new Parameter("@refTableName", systemPageTabName.RefTableName),
                new Parameter("@tabSortOrder", systemPageTabName.TabSortOrder),
                new Parameter("@tabTableName", systemPageTabName.TabTableName),
                new Parameter("@tabPageTitle", systemPageTabName.TabPageTitle),
                new Parameter("@tabExecuteProgram", systemPageTabName.TabExecuteProgram),
                new Parameter("@statusId", systemPageTabName.StatusId),
               new Parameter("@where", string.Format(" AND {0}='{1}' ", SysRefTabPageNameColumns.RefTableName.ToString(), systemPageTabName.RefTableName)),
            };
            return parameters;
        }
    }
}