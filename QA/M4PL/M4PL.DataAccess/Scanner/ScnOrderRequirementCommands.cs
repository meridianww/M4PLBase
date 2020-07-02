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
// Program Name:                                 ScnOrderRequirementCommands
// Purpose:                                      Contains commands to perform CRUD on ScnOrderRequirement
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScnOrderRequirementCommands : BaseCommands<Entities.Scanner.ScnOrderRequirement>
    {
        /// <summary>
        /// Gets list of ScnOrderRequirements
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScnOrderRequirement> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnOrderRequirementView, EntitiesAlias.ScnOrderRequirement);
        }

        /// <summary>
        /// Gets the specific ScnOrderRequirement
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderRequirement Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScnOrderRequirement);
        }

        /// <summary>
        /// Creates a new ScnOrderRequirement
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnOrderRequirement"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderRequirement Post(ActiveUser activeUser, Entities.Scanner.ScnOrderRequirement scnOrderRequirement)
        {
            var parameters = GetParameters(scnOrderRequirement);
            parameters.AddRange(activeUser.PostDefaultParams(scnOrderRequirement));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScnOrderRequirement);
        }

        /// <summary>
        /// Updates the existing ScnOrderRequirement record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnOrderRequirement"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderRequirement Put(ActiveUser activeUser, Entities.Scanner.ScnOrderRequirement scnOrderRequirement)
        {
            var parameters = GetParameters(scnOrderRequirement);
            parameters.AddRange(activeUser.PutDefaultParams(scnOrderRequirement.Id, scnOrderRequirement));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnOrderRequirement);
        }

        /// <summary>
        /// Deletes a specific ScnOrderRequirement
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteScnOrderRequirement);
            return 0;
        }

        /// <summary>
        /// Deletes list of ScnOrderRequirements
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScnOrderRequirement, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the ScnOrderRequirements Module
        /// </summary>
        /// <param name="scnOrderRequirement"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScnOrderRequirement scnOrderRequirement)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@requirementID", scnOrderRequirement.RequirementID),
               new Parameter("@requirementCode", scnOrderRequirement.RequirementCode),
               new Parameter("@jobID", scnOrderRequirement.JobID),
               new Parameter("@notes", scnOrderRequirement.Notes),
               new Parameter("@complete", scnOrderRequirement.Complete),
           };
            return parameters;
        }
    }
}
