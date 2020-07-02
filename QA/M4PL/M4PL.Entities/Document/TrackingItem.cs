#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Document
{
	public class TrackingItem
	{
		public string ItemNumber { get; set; }
		public string GatewayACD { get; set; }
		public string ScheduledDate { get; set; }
		public string GatewayCode { get; set; }
		public string GatewayTitle { get; set; }
		public string GatewayType { get; set; }
	}
}