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
// Program Name:                                 PrgMvoc
// Purpose:                                      Contains commands to perform CRUD on PrgMvoc
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgMvocCommands : BaseCommands<PrgMvoc>
    {
        /// <summary>
        /// Gets list of PrgMvoc records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgMvoc> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgMvocView, EntitiesAlias.PrgMvoc);
        }

        /// <summary>
        /// Gets the specific PrgMvoc record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgMvoc Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgMvoc);
        }

        /// <summary>
        /// Creates a new PrgMvoc record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgMVOC"></param>
        /// <returns></returns>

        public static PrgMvoc Post(ActiveUser activeUser, PrgMvoc prgMvoc)
        {
            var parameters = GetParameters(prgMvoc);
            parameters.AddRange(activeUser.PostDefaultParams(prgMvoc));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgMvoc);
        }

        /// <summary>
        /// Updates the existing PrgMvoc record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgMVOC"></param>
        /// <returns></returns>

        public static PrgMvoc Put(ActiveUser activeUser, PrgMvoc prgMvoc)
        {
            var parameters = GetParameters(prgMvoc);
            parameters.AddRange(activeUser.PutDefaultParams(prgMvoc.Id, prgMvoc));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgMvoc);
        }

        /// <summary>
        /// Deletes a specific PrgMvoc record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of PrgMvoc records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgMvoc, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgMvoc Module
        /// </summary>
        /// <param name="prgMVOC"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgMvoc prgMVOC)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@vocOrgID ", prgMVOC.VocOrgID),
               new Parameter("@vocProgramID", prgMVOC.VocProgramID),
               new Parameter("@vocSurveyCode", prgMVOC.VocSurveyCode),
               new Parameter("@vocSurveyTitle", prgMVOC.VocSurveyTitle),
               new Parameter("@statusId", prgMVOC.StatusId),
               new Parameter("@vocDateOpen", prgMVOC.VocDateOpen),
               new Parameter("@vocDateClose", prgMVOC.VocDateClose),
               new Parameter("@vocAllStar", prgMVOC.VocAllStar),
            };
            return parameters;
        }
    }
}