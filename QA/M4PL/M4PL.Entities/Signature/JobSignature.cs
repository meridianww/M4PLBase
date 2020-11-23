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
// Programmer:                                   Kamal
// Date Programmed:                              04/18/2020
// Program Name:                                 JobSurvey
// Purpose:                                      Contains model for JobSurvey
//=============================================================================================================

namespace M4PL.Entities.Signature
{
	public class JobSignature
	{
		/// <summary>
		/// Gets or Sets Job Id
		/// </summary>
		public string JobId { get; set; }
		/// <summary>
		/// Gets or Sets User Name
		/// </summary>
		public string UserName { get; set; }
		/// <summary>
		/// Gets or Sets Signature Text
		/// </summary>
		public string Signature { get; set; }
	}
}