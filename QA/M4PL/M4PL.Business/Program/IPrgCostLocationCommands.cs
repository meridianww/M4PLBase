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
// Program Name:                                 IPrgCostLocationCommands
// Purpose:                                      Set of rules for IPrgCostLocationCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Program
{
	public interface IPrgCostLocationCommands : IBaseCommands<PrgCostLocation>
	{
		IList<TreeModel> CostLocationTree(long orgId, bool isAssignedCostLocation, long programId, long? parentId, bool isChild);

		bool MapVendorCostLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap);
	}
}