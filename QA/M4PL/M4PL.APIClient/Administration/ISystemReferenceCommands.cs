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
// Program Name:                                 ISystemReferenceCommands
// Purpose:                                      Set of rules for SystemReference
//=============================================================================================================

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