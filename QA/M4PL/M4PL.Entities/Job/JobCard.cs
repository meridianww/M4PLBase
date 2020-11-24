#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prasanta
// Date Programmed:                              02/15/2020
// Program Name:                                 JobCard
// Purpose:                                      Contains objects related to Job
//==========================================================================================================

namespace M4PL.Entities.Job
{
	/// <summary>
	///  It holds the data related to origin and delivery details for the particular program
	/// </summary>
	public class JobCard : Job
	{
		/// <summary>
		/// Gets or Sets Job Destination
		/// </summary>
		public string Destination { get; set; }
	}
}