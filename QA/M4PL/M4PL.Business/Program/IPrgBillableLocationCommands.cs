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
// Programmer:                                   Nikhil
// Date Programmed:                              24/07/2019
// Program Name:                                 IPrgBillableLocationCommands
// Purpose:                                      Set of rules for IPrgBillableLocationCommands
//==============================================================================================================
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Program
{
	public interface IPrgBillableLocationCommands : IBaseCommands<PrgBillableLocation>
	{
		IList<TreeModel> BillableLocationTree(long orgId, bool isAssignedBillableLocation, long programId, long? parentId, bool isChild);

		bool MapVendorBillableLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap);
	}
}