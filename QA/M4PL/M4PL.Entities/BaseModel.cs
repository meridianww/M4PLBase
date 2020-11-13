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
// Program Name:                                 BaseModel
// Purpose:                                      Contains objects related to BaseModel
//==========================================================================================================

using System;

namespace M4PL.Entities
{
	/// <summary>
	/// Base Model
	/// </summary>
	public class BaseModel : SysRefModel
	{
		/// <summary>
		/// Gets or Sets StatusId e.g. 1 for Active
		/// </summary>
		public int? StatusId { get; set; }
		/// <summary>
		/// Gets or Sets Date Entered
		/// </summary>
		public DateTime? DateEntered { get; set; }
		/// <summary>
		/// Gets or Sets Date of Updation
		/// </summary>
		public DateTime? DateChanged { get; set; }
		/// <summary>
		/// Gets or Sets User Name who has created the record e.g. Nfujimoto
		/// </summary>
		public string EnteredBy { get; set; }
		/// <summary>
		/// Gets or Sets User Name who has updated the record e.g. nfujimoto
		/// </summary>
		public string ChangedBy { get; set; }
		/// <summary>
		/// Gets or Sets Item Number
		/// </summary>
		public int? ItemNumber { get; set; }
	}
}