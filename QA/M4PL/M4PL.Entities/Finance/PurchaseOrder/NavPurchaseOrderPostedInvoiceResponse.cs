#region Copyright
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

namespace M4PL.Entities.Finance.PurchaseOrder
{
	public class NavPurchaseOrderPostedInvoiceResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<PostedPurchaseOrder> NavPurchaseOrder { get; set; }
	}

	public class PostedPurchaseOrder
	{
		public string No { get; set; }
		public string M4PL_Job_ID { get; set; }
		public string Vendor_Invoice_No { get; set; }
		public string Document_Date { get; set; }
		public string Vendor_Order_No { get; set; }
	}
}
