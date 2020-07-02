#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              19/02/2020
// Program Name:                                 IJobEDIXcblCommands
// Purpose:                                      Set the rules for IJobEDIXcblCommands
//====================================================================================================================================================

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
	/// <summary>
	/// Performs basic CRUD operation on the JobEDIXcbl Entity
	/// </summary>
	public interface IJobEDIXcblCommands : IBaseCommands<JobEDIXcblView>
	{
	}
}