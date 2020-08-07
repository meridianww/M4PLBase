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

using M4PL.APIClient.ViewModels.Event;
using M4PL.Entities;
using M4PL.Entities.Program;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
	/// <summary>
	/// Performs basic CRUD operation on the PrgEventManagementCommands Entity
	/// </summary>
	public interface IPrgEventManagementCommands : IBaseCommands<ViewModels.Program.PrgEventManagementView>
	{
        IList<EventSubscriberView> GetEventSubscriber();

    }
}