/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgCostLocationCommands
Purpose:                                      Contains commands to perform CRUD on PrgCostLocation
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgCostLocationCommands : BaseCommands<PrgCostLocation>
    {
        /// <summary>
        /// Gets list of PrgCostLocationsComments records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgCostLocation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgCostLocations, EntitiesAlias.PrgCostLocation);
        }

        /// <summary>
        /// Gets the specific PrgCostLocationsComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgCostLocation Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetPrgCostLocations);
        }

        /// <summary>
        /// Creates a new PrgCostLocationsComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgCostLocation"></param>
        /// <returns></returns>

        public static PrgCostLocation Post(ActiveUser activeUser, PrgCostLocation prgCostLocation)
        {
            var parameters = GetParameters(prgCostLocation);
            parameters.AddRange(activeUser.PostDefaultParams(prgCostLocation));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgCostLocations);
        }

        /// <summary>
        /// Updates the existing PrgCostLocationsComments record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgCostLocation"></param>
        /// <returns></returns>

        public static PrgCostLocation Put(ActiveUser activeUser, PrgCostLocation prgCostLocation)
        {
            var parameters = GetParameters(prgCostLocation);
            parameters.AddRange(activeUser.PutDefaultParams(prgCostLocation.Id, prgCostLocation));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgCostLocations);
        }

        /// <summary>
        /// Deletes a specific PrgCostLocationsComments record
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
        /// Deletes list of PrgCostLocationsComments records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgCostLocation, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgCostLocationsComments Module
        /// </summary>
        /// <param name="prgCostLocation"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgCostLocation prgCostLocation)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@pvlProgramID", prgCostLocation.PclProgramID),
               new Parameter("@pvlVendorID", prgCostLocation.PclVendorID),
               new Parameter("@pvlItemNumber", prgCostLocation.PclItemNumber),
               new Parameter("@pvlLocationCode", prgCostLocation.PclLocationCode),
               new Parameter("@pvlLocationTitle", prgCostLocation.PclLocationTitle),
               new Parameter("@statusId", prgCostLocation.StatusId),
               new Parameter("@pvlUserCode1", prgCostLocation.PclUserCode1),
               new Parameter("@pvlUserCode2", prgCostLocation.PclUserCode2),
               new Parameter("@pvlUserCode3", prgCostLocation.PclUserCode3),
               new Parameter("@pvlUserCode4", prgCostLocation.PclUserCode4),
               new Parameter("@pvlUserCode5", prgCostLocation.PclUserCode5),
            };
            return parameters;
        }

        public static IList<TreeModel> CostLocationTree(long orgId, bool isAssignedCostLocation, long programId, long? parentId, bool isChild)
        {
            var parameters = new[]
            {
               new Parameter("@orgId", orgId),
               new Parameter("@isAssignedCostLocation", isAssignedCostLocation),
               new Parameter("@parentId", parentId),
               new Parameter("@programId", programId),
               new Parameter("@isChild", isChild)
            };

            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetAssignUnassignCostLocations, parameters, storedProcedure: true);
            return result;
        }

		public static bool MapVendorCostLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
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
               ,new Parameter("@dateEntered", TimeUtility.GetPacificDateTime())
			};

            bool result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.InsAssignUnassignCostLocations, parameters, storedProcedure: true);

            return result;
        }
    }
}
