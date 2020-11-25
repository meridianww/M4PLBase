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
// Program Name:                                 ScrOsdReasonList
// Purpose:                                      Contains objects related to ScrOsdReasonList
//==========================================================================================================
namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner OSD Reason List 
	/// </summary>
	public class ScrOsdReasonList : BaseModel
	{
		/// <summary>
		/// Gets or Sets Program Id
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Id's Name
		/// </summary>
		public string ProgramIDName { get; set; }
		/// <summary>
		/// Gets or Sets Sorting order
		/// </summary>
		public int? ReasonItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets Reason Id Code
		/// </summary>
		public string ReasonIDCode { get; set; }
		/// <summary>
		/// Gets or Sets Reason Title
		/// </summary>
		public string ReasonTitle { get; set; }
		/// <summary>
		/// Gets or Sets Reason Description
		/// </summary>
		public byte[] ReasonDesc { get; set; }
	}
}