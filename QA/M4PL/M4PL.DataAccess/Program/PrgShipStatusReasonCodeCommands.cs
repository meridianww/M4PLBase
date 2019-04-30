/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipStatusReasonCodeCommands
Purpose:                                      Contains commands to perform CRUD on PrgShipStatusReasonCode
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgShipStatusReasonCodeCommands : BaseCommands<PrgShipStatusReasonCode>
    {
        /// <summary>
        /// Gets list of PrgShipStatusReasonCode records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgShipStatusReasonCode> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgShipStatusReasonCodeView, EntitiesAlias.PrgShipStatusReasonCode);
        }

        /// <summary>
        /// Gets the specific PrgShipStatusReasonCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgShipStatusReasonCode Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgShipStatusReasonCode);
        }

        /// <summary>
        /// Creates a new PrgShipStatusReasonCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgShipStatusReasonCode"></param>
        /// <returns></returns>

        public static PrgShipStatusReasonCode Post(ActiveUser activeUser, PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            var parameters = GetParameters(prgShipStatusReasonCode);
            // parameters.Add(new Parameter("@langCode", prgShipStatusReasonCode.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(prgShipStatusReasonCode));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgShipStatusReasonCode);
        }

        /// <summary>
        /// Updates the existing PrgShipStatusReasonCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgShipStatusReasonCode"></param>
        /// <returns></returns>

        public static PrgShipStatusReasonCode Put(ActiveUser activeUser, PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            var parameters = GetParameters(prgShipStatusReasonCode);
            // parameters.Add(new Parameter("@langCode", prgShipStatusReasonCode.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(prgShipStatusReasonCode.Id, prgShipStatusReasonCode));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgShipStatusReasonCode);
        }

        /// <summary>
        /// Deletes a specific PrgShipStatusReasonCode record
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
        /// Deletes list of PrgShipStatusReasonCode records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgShipStatusReasonCode, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgShipStatusReasonCode Module
        /// </summary>
        /// <param name="prgShipStatusReasonCode"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@pscOrgId", prgShipStatusReasonCode.PscOrgID),
               new Parameter("@pscProgramId ", prgShipStatusReasonCode.PscProgramID),
               new Parameter("@pscShipItem", prgShipStatusReasonCode.PscShipItem),
               new Parameter("@pscShipReasonCode", prgShipStatusReasonCode.PscShipReasonCode),
               new Parameter("@pscShipLength", prgShipStatusReasonCode.PscShipLength),
               new Parameter("@pscShipInternalCode", prgShipStatusReasonCode.PscShipInternalCode),
               new Parameter("@pscShipPriorityCode", prgShipStatusReasonCode.PscShipPriorityCode),
               new Parameter("@pscShipTitle", prgShipStatusReasonCode.PscShipTitle),
               new Parameter("@pscShipCategoryCode", prgShipStatusReasonCode.PscShipCategoryCode),
               new Parameter("@pscShipUser01Code", prgShipStatusReasonCode.PscShipUser01Code),
               new Parameter("@pscShipUser02Code", prgShipStatusReasonCode.PscShipUser02Code),
               new Parameter("@pscShipUser03Code", prgShipStatusReasonCode.PscShipUser03Code),
               new Parameter("@pscShipUser04Code", prgShipStatusReasonCode.PscShipUser04Code),
               new Parameter("@pscShipUser05Code", prgShipStatusReasonCode.PscShipUser05Code),
               new Parameter("@statusId", prgShipStatusReasonCode.StatusId),
            };
            return parameters;
        }
    }
}