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
// Program Name:                                 SubSecurityByRoleCommands
// Purpose:                                      Contains commands to perform CRUD on SubSecurityByRole
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class SubSecurityByRoleCommands : BaseCommands<SubSecurityByRole>
    {
        /// <summary>
        /// Gets list of SubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<SubSecurityByRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSubSecurityByRoleView, EntitiesAlias.SubSecurityByRole);
        }

        /// <summary>
        /// Gets specific record detail based on the Id and Active user Details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static SubSecurityByRole Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetSubSecurityByRole);
        }

        /// <summary>
        /// Creates a new SubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="subSecurityByRole"></param>
        /// <returns></returns>
        public static SubSecurityByRole Post(ActiveUser activeUser, SubSecurityByRole subSecurityByRole)
        {
            var parameters = GetParameters(subSecurityByRole);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(subSecurityByRole));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertSubSecurityByRole);
        }

        /// <summary>
        /// Updates the specific SubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="subSecurityByRole"></param>
        /// <returns></returns>
        public static SubSecurityByRole Put(ActiveUser activeUser, SubSecurityByRole subSecurityByRole)
        {
            var parameters = GetParameters(subSecurityByRole);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(subSecurityByRole.Id, subSecurityByRole));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateSubSecurityByRole);
        }

        /// <summary>
        /// Deletes the Role from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteSubSecurityByRole);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.SubSecurityByRole, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the parameters required for the SubSecurityByRole module
        /// </summary>
        /// <param name="subSecurityByRole"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(SubSecurityByRole subSecurityByRole)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@secByRoleId", subSecurityByRole.SecByRoleId),
                new Parameter("@refTableName", subSecurityByRole.RefTableName),
                new Parameter("@menuOptionLevelId", subSecurityByRole.SubsMenuOptionLevelId),
                new Parameter("@menuAccessLevelId", subSecurityByRole.SubsMenuAccessLevelId),
                new Parameter("@statusId", subSecurityByRole.StatusId),
            };
            return parameters;
        }
    }
}