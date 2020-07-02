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
// Date Programmed:                              06/06/2018
// Program Name:                                 DeliveryStatus
// Purpose:                                      Contains objects related to DeliveryStatus
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	///  Delivery Status Class to create and maintain Delivery Status Data
	/// </summary>
	public class DeliveryStatus : BaseModel
	{
		public string DeliveryStatusCode { get; set; }

		public string DeliveryStatusTitle { get; set; }

		public int? SeverityId { get; set; }

		public byte[] DeliveryStatusDescription { get; set; }

		public string OrganizationIdName { get; set; }
	}
}