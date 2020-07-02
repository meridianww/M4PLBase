#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Finance.PurchaseOrder
{
	public class NavJobPurchaseOrder
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public IList<NavPurchaseOrder> NavPurchaseOrder { get; set; }
	}
}