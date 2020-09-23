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

namespace M4PL.Entities.XCBL.FarEye
{
	public class ExtraInfo
	{
		[JsonProperty("comments")]
		public string comments { get; set; }

		[JsonProperty("promised_delivery_date")]
		public string PromisedDeliveryDate { get; set; }

		[JsonProperty("expected_delivery_date")]
		public string ExpectedDeliveryDate { get; set; }

		[JsonProperty("received_by")]
		public string ReceivedBy { get; set; }

		[JsonProperty("relation")]
		public string Relation { get; set; }

		[JsonProperty("epod")]
		public string Epod { get; set; }

		[JsonProperty("signature")]
		public string Signature { get; set; }

		[JsonProperty("customer_code")]
		public string CustomerCode { get; set; }

		[JsonProperty("customer_name")]
		public string CustomerName { get; set; }
	}
}
