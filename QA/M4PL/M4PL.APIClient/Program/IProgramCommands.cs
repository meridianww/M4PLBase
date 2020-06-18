/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IProgramCommands
Purpose:                                      Set of rules for ProgramCommands
=============================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Program;
using System.Collections.Generic;
using System.Threading.Tasks;

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
    }
}