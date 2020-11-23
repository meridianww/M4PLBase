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
// Program Name:                                 JobDocReference
// Purpose:                                      Contains objects related to JobDocReference
//==========================================================================================================

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Document Reference
	/// </summary>
	public class JobDocReference : BaseModel
	{
		/// <summary>
		/// Gets or Sets JobID
		/// </summary>
		public long? JobID { get; set; }
		/// <summary>
		/// Gets or Sets JobIDName
		/// </summary>
		public string JobIDName { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? JdrItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets JdrCode
		/// </summary>
		public string JdrCode { get; set; }
		/// <summary>
		/// Gets or Sets JdrTitle
		/// </summary>
		public string JdrTitle { get; set; }
		/// <summary>
		/// Gets or Sets DocTypeId
		/// </summary>
		public int? DocTypeId { get; set; }
		/// <summary>
		/// Gets or Sets JdrDescription
		/// </summary>
		public byte[] JdrDescription { get; set; }
		/// <summary>
		/// Gets or Sets count of JdrAttachment
		/// </summary>
		public int? JdrAttachment { get; set; }
		/// <summary>
		/// Gets or Sets JdrDateStart
		/// </summary>
		public DateTime? JdrDateStart { get; set; }
		/// <summary>
		/// Gets or Sets JdrDateEnd
		/// </summary>
		public DateTime? JdrDateEnd { get; set; }
		/// <summary>
		/// Gets or Sets flag if JdrRenewal
		/// </summary>
		public bool JdrRenewal { get; set; }
		/// <summary>
		/// Gets or Sets flag if JobCompleted
		/// </summary>
		public bool JobCompleted { get; set; }

	}
}