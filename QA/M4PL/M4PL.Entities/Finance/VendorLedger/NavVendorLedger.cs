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

namespace M4PL.Entities.Finance.VendorLedger
{
	public class NavVendorLedger
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<VendorLedger> VendorLedger { get; set; }
	}

	public class VendorLedger
	{
		public string Entry_No { get; set; }
		public string Posting_Date { get; set; }
		public string Document_Type { get; set; }
		public string Document_No { get; set; }
		public string External_Document_No { get; set; }
		public string Vendor_No { get; set; }
		public string Amount { get; set; }
		public string Credit_Amount { get; set; }
		public string Closed_by_Entry_No { get; set; }
	}
}
