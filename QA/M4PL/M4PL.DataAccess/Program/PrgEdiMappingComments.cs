/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like PrgEdiMappingComments
Purpose:                                      Contains commands to perform CRUD on PrgEdiMapping
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgEdiMappingComments : BaseCommands<PrgEdiMapping>
    {
        /// <summary>
        /// Gets list of PrgEdiMapping records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgEdiMapping> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgEdiMappingView, EntitiesAlias.PrgEdiMapping);
        }

        /// <summary>
        /// Gets the specific PrgEdiMapping record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgEdiMapping Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgEdiMapping);
        }

        /// <summary>
        /// Creates a new PrgEdiMapping record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEdiMapping"></param>
        /// <returns></returns>

        public static PrgEdiMapping Post(ActiveUser activeUser, PrgEdiMapping prgEdiMapping)
        {
            var parameters = GetParameters(prgEdiMapping);
            parameters.AddRange(activeUser.PostDefaultParams(prgEdiMapping));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgEdiMapping);
        }

        /// <summary>
        /// Updates the existing PrgEdiMapping recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEdiMapping"></param>
        /// <returns></returns>

        public static PrgEdiMapping Put(ActiveUser activeUser, PrgEdiMapping prgEdiMapping)
        {
            var parameters = GetParameters(prgEdiMapping);
            parameters.AddRange(activeUser.PutDefaultParams(prgEdiMapping.Id, prgEdiMapping));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgEdiMapping);
        }

        /// <summary>
        /// Deletes a specific PrgEdiMapping record
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
        /// Deletes list of PrgEdiMapping records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgEdiMapping, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgEdiMapping Module
        /// </summary>
        /// <param name="prgEdiMapping"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgEdiMapping prgEdiMapping)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@pemHeaderID", prgEdiMapping.PemHeaderID),
               new Parameter("@pemEdiTableName", prgEdiMapping.PemEdiTableName),
               new Parameter("@pemEdiFieldName", prgEdiMapping.PemEdiFieldName),
               new Parameter("@pemEdiFieldDataType", prgEdiMapping.PemEdiFieldDataType),
               new Parameter("@pemSysTableName", prgEdiMapping.PemSysTableName),
               new Parameter("@pemSysFieldName", prgEdiMapping.PemSysFieldName),
               new Parameter("@PemSysFieldDataType", prgEdiMapping.PemSysFieldDataType),
               new Parameter("@statusId", prgEdiMapping.StatusId),
               new Parameter("@pemDateStart", prgEdiMapping.PemDateStart),
               new Parameter("@pemDateEnd", prgEdiMapping.PemDateEnd),
               new Parameter("@pemInsertUpdate", prgEdiMapping.PemInsertUpdate)
            };
            return parameters;
        }
    }
}