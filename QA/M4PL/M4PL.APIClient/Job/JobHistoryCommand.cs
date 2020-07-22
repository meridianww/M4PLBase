#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
	public class JobHistoryCommand : BaseCommands<JobHistoryView>, IJobHistoryCommand
	{
		/// <summary>
		/// Route to call JobCargos
		/// </summary>
		public override string RouteSuffix
		{
			get { return "JobHistorys"; }
		}
	}
}