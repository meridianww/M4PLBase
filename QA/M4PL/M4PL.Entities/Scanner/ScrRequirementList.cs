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
	public class ScrRequirementList : BaseModel
	{
		public long? ProgramID { get; set; }
		public string ProgramIDName { get; set; }
		public int? RequirementLineItem { get; set; }
		public string RequirementCode { get; set; }
		public string RequirementTitle { get; set; }
		public byte[] RequirementDesc { get; set; }
	}
}