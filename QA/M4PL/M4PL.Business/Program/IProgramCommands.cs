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
// Program Name:                                 IProgramCommands
// Purpose:                                      Set of rules for ProgramCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace M4PL.Business.Program
{
	/// <summary>
	/// Performs basic CRUD operation on the Program Entity
	/// </summary>
	public interface IProgramCommands : IBaseCommands<Entities.Program.Program>
	{
		IList<TreeModel> ProgramTree(ActiveUser activeUser, long id, long? parentId, bool isCustNode);

		Entities.Program.Program GetProgram(ActiveUser activeUser, long id, long? parentId);

		IList<TreeModel> ProgramCopyTree(ActiveUser activeUser, long programId, long? parentId, bool isCustNode, bool isSource);

		Task<bool> CopyPPPModel(CopyPPPModel copyPPPMopdel, ActiveUser activeUser);

		List<Entities.Program.Program> GetProgramsByCustomer(long custId);
	}
}