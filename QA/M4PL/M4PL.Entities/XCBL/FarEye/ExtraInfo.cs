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
	/// <summary>
	/// Model class for Extra information of FarEye Order Event
	/// </summary>
	public class ExtraInfo
	{
		/// <summary>
		/// Gets or Sets Comments
		/// </summary>
		[JsonProperty("comments")]
		public string comments { get; set; }
		/// <summary>
		/// Gets or Sets Promised Delivery Date
		/// </summary>
		[JsonProperty("promised_delivery_date")]
		public string PromisedDeliveryDate { get; set; }
		/// <summary>
		/// Gets or Sets Expected Delivery Date
		/// </summary>
		[JsonProperty("expected_delivery_date")]
		public string ExpectedDeliveryDate { get; set; }
		/// <summary>
		/// Gets or Sets Received By
		/// </summary>
		[JsonProperty("received_by")]
		public string ReceivedBy { get; set; }
		/// <summary>
		/// Gets or Sets Relation
		/// </summary>
		[JsonProperty("relation")]
		public string Relation { get; set; }
		/// <summary>
		/// Gets or Sets Epod
		/// </summary>
		[JsonProperty("epod")]
		public string Epod { get; set; }
		/// <summary>
		/// Gets or Sets Signature
		/// </summary>
		[JsonProperty("signature")]
		public string Signature { get; set; }
		/// <summary>
		/// Gets or sets Customer Code
		/// </summary>
		[JsonProperty("customer_code")]
		public string CustomerCode { get; set; }
		/// <summary>
		/// Gets or Sets Customer Name
		/// </summary>
		[JsonProperty("customer_name")]
		public string CustomerName { get; set; }
	}
}
