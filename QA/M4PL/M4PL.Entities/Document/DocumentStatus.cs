﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Document
{
	public class DocumentStatus
	{
		public bool IsAttachmentPresent { get; set; }

		public bool IsPODPresent { get; set; }

		public bool IsHistoryPresent { get; set; }
	}
}