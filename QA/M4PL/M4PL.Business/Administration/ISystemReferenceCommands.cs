/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ISystemReferenceCommands
Purpose:                                      Set of rules for SystemReferenceCommands
=============================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the SystemReference Entity
    /// </summary>
    public interface ISystemReferenceCommands : IBaseCommands<SystemReference>
    {
        IList<IdRefLangName> GetDeletedRecordLookUpIds(string allIds);
    }
}