/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipApptmtReasonCodeCommands
Purpose:                                      Contains commands to perform CRUD on PrgShipApptmtReasonCode
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    /// <summary>
    /// Gets list of PrgShipApptmtReasonCode records
    /// </summary>
    public class PrgShipApptmtReasonCodeCommands : BaseCommands<PrgShipApptmtReasonCode>
    {
        public static IList<PrgShipApptmtReasonCode> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgShipApptmtReasonCodeView, EntitiesAlias.PrgShipApptmtReasonCode);
        }

        /// <summary>
        /// Gets the specific PrgShipApptmtReasonCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgShipApptmtReasonCode Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgShipApptmtReasonCode);
        }

        /// <summary>
        /// Creates a new PrgShipApptmtReasonCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgShipApptmtReasonCode"></param>
        /// <returns></returns>

        public static PrgShipApptmtReasonCode Post(ActiveUser activeUser, PrgShipApptmtReasonCode prgShipApptmtReasonCode)
        {
            var parameters = GetParameters(prgShipApptmtReasonCode);
            // parameters.Add(new Parameter("@langCode", prgShipApptmtReasonCode.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(prgShipApptmtReasonCode));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgShipApptmtReasonCode);
        }

        /// <summary>
        /// Updates the existing PrgShipApptmtReasonCode recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgShipApptmtReasonCode"></param>
        /// <returns></returns>

        public static PrgShipApptmtReasonCode Put(ActiveUser activeUser, PrgShipApptmtReasonCode prgShipApptmtReasonCode)
        {
            var parameters = GetParameters(prgShipApptmtReasonCode);
            // parameters.Add(new Parameter("@langCode", prgShipApptmtReasonCode.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(prgShipApptmtReasonCode.Id, prgShipApptmtReasonCode));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgShipApptmtReasonCode);
        }

        /// <summary>
        /// Deletes a specific PrgShipApptmtReasonCode record
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
        /// Deletes list of PrgShipApptmtReasonCode records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgShipApptmtReasonCode, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgShipApptmtReasonCode Module
        /// </summary>
        /// <param name="prgShipApptmtReasonCode"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgShipApptmtReasonCode prgShipApptmtReasonCode)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@pacOrgId", prgShipApptmtReasonCode.PacOrgID),
               new Parameter("@pacProgramId", prgShipApptmtReasonCode.PacProgramID),
               new Parameter("@pacApptItem", prgShipApptmtReasonCode.PacApptItem),
               new Parameter("@pacApptReasonCode", prgShipApptmtReasonCode.PacApptReasonCode),
               new Parameter("@pacApptLength", prgShipApptmtReasonCode.PacApptLength),
               new Parameter("@pacApptInternalCode", prgShipApptmtReasonCode.PacApptInternalCode),
               new Parameter("@pacApptPriorityCode", prgShipApptmtReasonCode.PacApptPriorityCode),
               new Parameter("@pacApptTitle", prgShipApptmtReasonCode.PacApptTitle),
               new Parameter("@pacApptCategoryCodeId", prgShipApptmtReasonCode.PacApptCategoryCodeId),
               new Parameter("@pacApptUser01Code", prgShipApptmtReasonCode.PacApptUser01Code),
               new Parameter("@pacApptUser02Code", prgShipApptmtReasonCode.PacApptUser02Code),
               new Parameter("@pacApptUser03Code", prgShipApptmtReasonCode.PacApptUser03Code),
               new Parameter("@pacApptUser04Code", prgShipApptmtReasonCode.PacApptUser04Code),
               new Parameter("@pacApptUser05Code", prgShipApptmtReasonCode.PacApptUser05Code),
               new Parameter("@statusId", prgShipApptmtReasonCode.StatusId),
            };
            return parameters;
        }
    }
}