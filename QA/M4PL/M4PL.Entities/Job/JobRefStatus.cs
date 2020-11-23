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
// Program Name:                                 JobRefStatus
// Purpose:                                      Contains objects related to JobRefStatus
//==========================================================================================================

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Ref Status
	/// </summary>
	public class JobRefStatus : BaseModel
	{
		/// <summary>
		/// Gets or sets the Job identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? JobID { get; set; }
		/// <summary>
		/// Gets or sets the Job identifier's Name
		/// </summary>
		public string JobIDName { get; set; }

		/// <summary>
		/// Gets or sets the Job Outline Code.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string JbsOutlineCode { get; set; }
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string JbsStatusCode { get; set; }
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string JbsTitle { get; set; }
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public byte[] JbsDescription { get; set; }
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public int? SeverityId { get; set; }
	}
}