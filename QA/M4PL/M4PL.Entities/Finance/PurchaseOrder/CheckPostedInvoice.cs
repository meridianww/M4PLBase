#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.PurchaseOrder
{
	public class CheckPostedInvoice
	{
		/// <summary>
		/// Gets or Sets Posted Invoice Number
		/// </summary>
		public string No { get; set; }
		/// <summary>
		/// Gets or Sets M4PL JobId 
		/// </summary>
		public string M4PL_JobId { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Order Number
		/// </summary>
		public string Vendor_Order_No { get; set; }
		/// <summary>
		/// Gets or Sets Document Date
		/// </summary>
		public string Document_Date { get; set; }
		/// <summary>
		/// Gets or Sets Amount
		/// </summary>
		public decimal Amount { get; set; }
	}
}
