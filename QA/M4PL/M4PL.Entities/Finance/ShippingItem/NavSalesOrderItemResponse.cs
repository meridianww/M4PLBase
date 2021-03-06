﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.ShippingItem
{
	public class NavSalesOrderItemResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<PostedSalesOrderLine> NavSalesOrderItem { get; set; }
	}

	public class PostedSalesOrderLine
	{
		public string No { get; set; }

		public string Document_No { get; set; }

		public string Cross_Reference_No { get; set; }

		public string Description { get; set; }

		public decimal Unit_Price { get; set; }
        public int Quantity { get; set; }
    }
}
