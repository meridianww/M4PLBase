
/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil Chauhan
Date Programmed:                              08/21/2019
Program Name:                                 PrgEdiConditionCommands
Purpose:                                      Contains commands to perform CRUD on PrgEdiConditionCommands
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Program
{
   public class PrgEdiConditionCommands : BaseCommands<PrgEdiCondition>
    {
        public static IList<PrgEdiCondition> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgEdiConditionView, EntitiesAlias.PrgEdiCondition);
        }

        /// <summary>
        /// Gets the specific PrgEdiConditions record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgEdiCondition Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgEdiCondition);
        }

        /// <summary>
        /// Creates a new PrgEdiConditions record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEdiCondition"></param>
        /// <returns></returns>

        public static PrgEdiCondition Post(ActiveUser activeUser, PrgEdiCondition prgEdiCondition)
        {
            var parameters = GetParameters(prgEdiCondition);
            parameters.AddRange(activeUser.PostDefaultParams(prgEdiCondition));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgEdiCondition);
        }

        /// <summary>
        /// Updates the existing PrgEdiConditions record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEdiCondition"></param>
        /// <returns></returns>

        public static PrgEdiCondition Put(ActiveUser activeUser, PrgEdiCondition prgEdiCondition)
        {
            var parameters = GetParameters(prgEdiCondition);
            parameters.AddRange(activeUser.PutDefaultParams(prgEdiCondition.Id, prgEdiCondition));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgEdiCondition);
        }

        /// <summary>
        /// Deletes a specific PrgEdiConditions record
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
        /// Deletes list of PrgEdiConditions records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgEdiCondition, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgEdiConditions Module
        /// </summary>
        /// <param name="prgEdiCondition"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgEdiCondition prgEdiCondition)
        {
            var parameters = new List<Parameter>
            {

               new Parameter("@pecProgramId", prgEdiCondition.PecProgramId ), // == null ? prgEdiCondition.ParentId : prgEdiCondition.PecProgramId
               new Parameter("@pecParentProgramId", prgEdiCondition.PecParentProgramId),
               new Parameter("@pecJobField", prgEdiCondition.PecJobField),
               new Parameter("@pecCondition", prgEdiCondition.PecCondition),
               new Parameter("@perLogical", prgEdiCondition.PerLogical),
               new Parameter("@pecJobField2", prgEdiCondition.PecJobField2),
               new Parameter("@pecCondition2", prgEdiCondition.PecCondition2),
             
            };
            return parameters;
        }

      
    }
}
