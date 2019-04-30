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
        IList<TreeModel> ProgramTree(long id, long? parentId, bool isCustNode);

        Entities.Program.Program GetProgram(ActiveUser activeUser, long id, long? parentId);

        IList<TreeModel> ProgramCopyTree(ActiveUser activeUser, long programId, long? parentId, bool isCustNode, bool isSource);

        Task<bool> CopyPPPModel(CopyPPPModel copyPPPMopdel, ActiveUser activeUser);

    }
}