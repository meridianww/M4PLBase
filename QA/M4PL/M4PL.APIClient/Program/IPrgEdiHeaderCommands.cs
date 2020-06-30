/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IPrgEdiHeaderCommands
Purpose:                                      Set of rules for PrgEdiHeaderCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgEdiHeader Entity
    /// </summary>
    public interface IPrgEdiHeaderCommands : IBaseCommands<PrgEdiHeaderView>
    {
        IList<TreeModel> EdiTree(long? parentId, bool model);
        int GetProgramLevel(long? programId);
    }
}