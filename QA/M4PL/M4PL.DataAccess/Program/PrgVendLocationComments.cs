/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgVendLocationComments
Purpose:                                      Contains commands to perform CRUD on PrgVendLocationComments
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgVendLocationComments : BaseCommands<PrgVendLocation>
    {
        /// <summary>
        /// Gets list of PrgVendLocationComments records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgVendLocation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgVendLocationView, EntitiesAlias.PrgVendLocation);
        }

        /// <summary>
        /// Gets the specific PrgVendLocationComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgVendLocation Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgVendLocation);
        }

        /// <summary>
        /// Creates a new PrgVendLocationComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public static PrgVendLocation Post(ActiveUser activeUser, PrgVendLocation prgVendLocation)
        {
            var parameters = GetParameters(prgVendLocation);
            parameters.AddRange(activeUser.PostDefaultParams(prgVendLocation));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgVendLocation);
        }

        /// <summary>
        /// Updates the existing PrgVendLocationComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public static PrgVendLocation Put(ActiveUser activeUser, PrgVendLocation prgVendLocation)
        {
            var parameters = GetParameters(prgVendLocation);
            parameters.AddRange(activeUser.PutDefaultParams(prgVendLocation.Id, prgVendLocation));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgVendLocation);
        }

        /// <summary>
        /// Deletes a specific PrgVendLocationComments record
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
        /// Deletes list of PrgVendLocationComments records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgVendLocation, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgVendLocationComments Module
        /// </summary>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgVendLocation prgVendLocation)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@pvlProgramID", prgVendLocation.PvlProgramID),
               new Parameter("@pvlVendorID", prgVendLocation.PvlVendorID),
               new Parameter("@pvlItemNumber", prgVendLocation.PvlItemNumber),
               new Parameter("@pvlLocationCode", prgVendLocation.PvlLocationCode),
               new Parameter("@pvlLocationCodeCustomer", prgVendLocation.PvlLocationCodeCustomer),
               new Parameter("@pvlLocationTitle", prgVendLocation.PvlLocationTitle),
               new Parameter("@pvlContactMSTRID", prgVendLocation.PvlContactMSTRID),
               new Parameter("@statusId", prgVendLocation.StatusId),
               new Parameter("@pvlDateStart", prgVendLocation.PvlDateStart),
               new Parameter("@pvlDateEnd", prgVendLocation.PvlDateEnd),
               new Parameter("@pvlUserCode1", prgVendLocation.PvlUserCode1),
               new Parameter("@pvlUserCode2", prgVendLocation.PvlUserCode2),
               new Parameter("@pvlUserCode3", prgVendLocation.PvlUserCode3),
               new Parameter("@pvlUserCode4", prgVendLocation.PvlUserCode4),
               new Parameter("@pvlUserCode5", prgVendLocation.PvlUserCode5),
            };
            return parameters;
        }

        public static IList<TreeModel> ProgramVendorTree(ActiveUser activeUser, long orgId, bool isAssignedPrgVendor, long programId, long? parentId, bool isChild)
        {
            var parameters = new[]
            {
                new Parameter("@orgId", orgId),
               new Parameter("@isAssignedPrgVendor", isAssignedPrgVendor),
               new Parameter("@parentId", parentId),
                 new Parameter("@programId", programId),
               new Parameter("@isChild", isChild),
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId)
            };

            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetAssignUnassignProgram, parameters, storedProcedure: true);
            return result;
        }

        public static bool MapVendorLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
        {
            Parameter[] parameters =
              {
                new Parameter("@userId", activeUser.UserId)
               ,new Parameter("@parentId", programVendorMap.ParentId)
               ,new Parameter("@assign", programVendorMap.Assign)
               ,new Parameter("@locationIds",  programVendorMap.LocationIds)
               ,new Parameter("@vendorIds",  programVendorMap.VendorIds)
               ,new Parameter("@enteredBy",activeUser.UserName)
               ,new Parameter("@assignedOn",programVendorMap.AssignedOn)
               ,new Parameter("@dateEntered",TimeUtility.GetPacificDateTime())
            };

            var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.InsertAssignUnassignProgram, parameters, storedProcedure: true);
            return result;
        }
    }
}