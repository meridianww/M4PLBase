﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IPrgEdiHeaderCommands
Purpose:                                      Set of rules for PrgEdiHeaderCommands
=============================================================================================================*/

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
    }
}