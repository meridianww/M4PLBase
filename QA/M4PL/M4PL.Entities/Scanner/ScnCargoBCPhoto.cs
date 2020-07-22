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
// Programmer:                                   Janardana
// Date Programmed:                              07/26/2018
// Program Name:                                 ScnCargoBCPhoto
// Purpose:                                      Contains objects related to ScnCargoBCPhoto
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	public class ScnCargoBCPhoto : BaseModel
	{
		public long CargoID { get; set; }
		public byte[] Photo { get; set; }
		public string Step { get; set; }
	}
}