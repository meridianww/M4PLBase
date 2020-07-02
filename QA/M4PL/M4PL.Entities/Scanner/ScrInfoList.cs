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
// Program Name:                                 ScrInfoList
// Purpose:                                      Contains objects related to ScrInfoList
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	public class ScrInfoList : BaseModel
	{
		public long InfoListID { get; set; }
		public string InfoListDesc { get; set; }
		public byte InfoListPhoto { get; set; }
		public object CatalogTitle { get; set; }
	}
}