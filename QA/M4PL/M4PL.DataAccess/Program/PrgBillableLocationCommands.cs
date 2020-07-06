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
// Programmer:                                   Nikhil Chauhan
// Date Programmed:                              24/07/2019
// Program Name:                                 PrgBillableLocationCommands
// Purpose:                                      Contains commands to perform CRUD on PrgBillableLocationCommands
//=============================================================================================================
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
	public class PrgBillableLocationCommands : BaseCommands<PrgBillableLocation>
	{
		public static IList<PrgBillableLocation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgBillableLocations, EntitiesAlias.PrgBillableLocation);
		}

		/// <summary>
		/// Gets the specific PrgBillableLocationsComments record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgBillableLocation Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetPrgBillableLocations);
		}

		/// <summary>
		/// Creates a new PrgBillableLocationsComments record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgBillableLocation"></param>
		/// <returns></returns>

		public static PrgBillableLocation Post(ActiveUser activeUser, PrgBillableLocation prgBillableLocation)
		{
			var parameters = GetParameters(prgBillableLocation);
			parameters.AddRange(activeUser.PostDefaultParams(prgBillableLocation));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgBillableLocations);
		}

		/// <summary>
		/// Updates the existing PrgBillableLocationsComments record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgBillableLocation"></param>
		/// <returns></returns>

		public static PrgBillableLocation Put(ActiveUser activeUser, PrgBillableLocation prgBillableLocation)
		{
			var parameters = GetParameters(prgBillableLocation);
			parameters.AddRange(activeUser.PutDefaultParams(prgBillableLocation.Id, prgBillableLocation));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgBillableLocations);
		}

		/// <summary>
		/// Deletes a specific PrgBillableLocationsComments record
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
		/// Deletes list of PrgBillableLocationsComments records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgBillableLocation, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the PrgBillableLocationsComments Module
		/// </summary>
		/// <param name="prgBillableLocation"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(PrgBillableLocation prgBillableLocation)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@pvlProgramID", prgBillableLocation.PblProgramID),
			   new Parameter("@pvlVendorID", prgBillableLocation.PblVendorID),
			   new Parameter("@pvlItemNumber", prgBillableLocation.PblItemNumber),
			   new Parameter("@pvlLocationCode", prgBillableLocation.PblLocationCode),
			   new Parameter("@pvlLocationTitle", prgBillableLocation.PblLocationTitle),
			   new Parameter("@statusId", prgBillableLocation.StatusId),
			   new Parameter("@pvlUserCode1", prgBillableLocation.PblUserCode1),
			   new Parameter("@pvlUserCode2", prgBillableLocation.PblUserCode2),
			   new Parameter("@pvlUserCode3", prgBillableLocation.PblUserCode3),
			   new Parameter("@pvlUserCode4", prgBillableLocation.PblUserCode4),
			   new Parameter("@pvlUserCode5", prgBillableLocation.PblUserCode5),
			};
			return parameters;
		}

		public static IList<TreeModel> BillableLocationTree(long orgId, bool isAssignedBillableLocation, long programId, long? parentId, bool isChild)
		{
			var parameters = new[]
			{
			   new Parameter("@orgId", orgId),
			   new Parameter("@isAssignedPriceLocation", isAssignedBillableLocation),
			   new Parameter("@parentId", parentId),
			   new Parameter("@programId", programId),
			   new Parameter("@isChild", isChild)
			};

			var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetAssignUnassignBillableLocations, parameters, storedProcedure: true);
			return result;
		}

		public static bool MapVendorBillableLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
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

			var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.InsAssignUnassignBillableLocations, parameters, storedProcedure: true);
			return result;
		}

		//public static IList<TreeModel> ProgramVendorTree(long orgId, bool isAssignedPrgVendor, long programId, long? parentId, bool isChild)
		//{
		//    var parameters = new[]
		//    {
		//        new Parameter("@orgId", orgId),
		//       new Parameter("@isAssignedPrgVendor", isAssignedPrgVendor),
		//       new Parameter("@parentId", parentId),
		//         new Parameter("@programId", programId),
		//       new Parameter("@isChild", isChild)
		//    };

		//    var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetAssignUnassignProgram, parameters, storedProcedure: true);
		//    return result;
		//}

		//public static bool MapVendorLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
		//{
		//    Parameter[] parameters =
		//      {
		//        new Parameter("@userId", activeUser.UserId)
		//       ,new Parameter("@parentId", programVendorMap.ParentId)
		//       ,new Parameter("@assign", programVendorMap.Assign)
		//       ,new Parameter("@locationIds",  programVendorMap.LocationIds)
		//       ,new Parameter("@vendorIds",  programVendorMap.VendorIds)
		//       ,new Parameter("@enteredBy",activeUser.UserName)
		//       ,new Parameter("@assignedOn",programVendorMap.AssignedOn)
		//    };

		//    var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.InsertAssignUnassignProgram, parameters, storedProcedure: true);
		//    return result;
		//}
	}
}