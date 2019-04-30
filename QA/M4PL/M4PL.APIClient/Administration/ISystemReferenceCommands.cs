﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ISystemReferenceCommands
Purpose:                                      Set of rules for SystemReference
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the SystemReference Entity
    /// </summary>
    public interface ISystemReferenceCommands : IBaseCommands<SystemReferenceView>
    {
        IList<IdRefLangName> GetDeletedRecordLookUpIds(string allIds);
    }
}