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
// Program Name:                                 ScrRequirementList
// Purpose:                                      Contains objects related to ScrRequirementList
//==========================================================================================================
namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Requirement List
	/// </summary>
	public class ScrRequirementList : BaseModel
	{
		/// <summary>
		/// Gets or Sets ProgramID
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Name
		/// </summary>
		public string ProgramIDName { get; set; }
		/// <summary>
		/// Gets or Sets Scanner Requirement Line Item
		/// </summary>
		public int? RequirementLineItem { get; set; }
		/// <summary>
		/// Gets or Sets Scanner Requirement Code
		/// </summary>
		public string RequirementCode { get; set; }
		/// <summary>
		/// Gets or Sets Requirement Title
		/// </summary>
		public string RequirementTitle { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public byte[] RequirementDesc { get; set; }
	}
}