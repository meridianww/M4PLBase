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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 PrgMvoc
// Purpose:                                      Contains objects related to PrgMvoc
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
	/// <summary>
	///
	/// </summary>
	public class PrgMvoc : BaseModel
	{
		/// <summary>
		/// Gets or sets the Organization ID.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? VocOrgID { get; set; }
		/// <summary>
		/// Gets or Sets Org Name
		/// </summary>
		public string VocOrgIDName { get; set; }

		/// <summary>
		/// Gets or sets the Program identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? VocProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Name
		/// </summary>
		public string VocProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the SurveyCode. e.g. VOC01 for Customer Survey
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string VocSurveyCode { get; set; }

		/// <summary>
		/// Gets or sets the Survey Title e.g. Customer Survey
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string VocSurveyTitle { get; set; }

		/// <summary>
		/// Gets or sets the Description.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public byte[] VocDescription { get; set; }

		/// <summary>
		/// Gets or sets the Date Time of VOC when it gets open.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public DateTime? VocDateOpen { get; set; }

		/// <summary>
		/// Gets or sets the Date Time of VOC when it gets closed.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public DateTime? VocDateClose { get; set; }

		/// <summary>
		/// Gets Or Sets flag for VocAllStar
		/// </summary>
		public bool VocAllStar { get; set; }
	}
}