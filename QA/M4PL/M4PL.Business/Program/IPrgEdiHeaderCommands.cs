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
// Program Name:                                 IPrgEdiHeaderCommands
// Purpose:                                      Set of rules for PrgEdiHeaderCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using System.Collections.Generic;

namespace M4PL.Business.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgEdiHeader Entity
    /// </summary>
    public interface IPrgEdiHeaderCommands : IBaseCommands<PrgEdiHeader>
    {
        IList<TreeModel> EdiTree(long id, long? parentId, bool model);
        int GetProgramLevel(long id, long? programId);
    }
}