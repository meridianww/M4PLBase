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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/04/2019
// Program Name:                                 NavSalesOrderResponse
// Purpose:                                      Contains objects related to NavPurchaseOrderResponse
//==========================================================================================================
using Newtonsoft.Json;

namespace M4PL.Entities.Finance.PurchaseOrder
{
	public class NavPurchaseOrderResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public NavPurchaseOrder NavPurchaseOrder { get; set; }
	}
}