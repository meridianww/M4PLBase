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
//=============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
	/// <summary>
	/// Performs basic CRUD operation on the ProgramCommands Entity
	/// </summary>
	public interface IProgramCommands : IBaseCommands<ViewModels.Program.ProgramView>
	{
		IList<TreeModel> ProgramTree();

		IList<TreeModel> ProgramTree(long? parentId, string model);

		IList<TreeModel> ProgramTree(long? parentId, bool isCustNode);

		ViewModels.Program.ProgramView Get(long id, long? parentId);

		IList<TreeModel> ProgramCopyTree(long programId, long? parentId, bool isCustNode, bool isSource);

		bool CopyPPPModel(CopyPPPModel copyPPPModel);

        bool CopyProgramModel(CopyProgramModel copyProgramModel);
    }
}