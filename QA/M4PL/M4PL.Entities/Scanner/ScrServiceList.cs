﻿#region Copyright

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
// Program Name:                                 ScrServiceList
// Purpose:                                      Contains objects related to ScrServiceList
//==========================================================================================================
namespace M4PL.Entities.Scanner
{
	public class ScrServiceList : BaseModel
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
		/// Gets or Sets Service Line Item for Scanner
		/// </summary>
		public int? ServiceLineItem { get; set; }
		/// <summary>
		/// Gets or Sets Service Code for Scanner
		/// </summary>
		public string ServiceCode { get; set; }
		/// <summary>
		/// Gets or Sets Service Title for Scanner
		/// </summary>
		public string ServiceTitle { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public byte[] ServiceDescription { get; set; }
	}
}