﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities
{
	public class EmailAttachment
	{
		public int ID { get; set; }

		public int EmailDetailID { get; set; }

		public byte[] AttachmentData { get; set; }

		public string AttachmentName { get; set; }
	}
}