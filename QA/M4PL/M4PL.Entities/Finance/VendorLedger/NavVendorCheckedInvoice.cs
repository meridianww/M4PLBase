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
	public class NavVendorCheckedInvoice
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<VendorCheckedInvoice> VendorCheckedInvoice { get; set; }
	}

	public class VendorCheckedInvoice
	{
		public string odataetag { get; set; }
		public int Entry_No { get; set; }
		public string Posting_Date { get; set; }
		public string Document_Type { get; set; }
		public string Document_No { get; set; }
		public string External_Document_No { get; set; }
		public string Vendor_No { get; set; }
		public string Message_to_Recipient { get; set; }
		public string Description { get; set; }
		public string Global_Dimension_1_Code { get; set; }
		public string Global_Dimension_2_Code { get; set; }
		public string IC_Partner_Code { get; set; }
		public string Purchaser_Code { get; set; }
		public string Currency_Code { get; set; }
		public string Payment_Method_Code { get; set; }
		public string Payment_Reference { get; set; }
		public string Creditor_No { get; set; }
		public float Original_Amount { get; set; }
		public float Original_Amt_LCY { get; set; }
		public float Amount { get; set; }
		public float Amount_LCY { get; set; }
		public float Debit_Amount { get; set; }
		public float Debit_Amount_LCY { get; set; }
		public int Credit_Amount { get; set; }
		public int Credit_Amount_LCY { get; set; }
		public int Remaining_Amount { get; set; }
		public int Remaining_Amt_LCY { get; set; }
		public string Bal_Account_Type { get; set; }
		public string Bal_Account_No { get; set; }
		public string Due_Date { get; set; }
		public string Pmt_Discount_Date { get; set; }
		public string Pmt_Disc_Tolerance_Date { get; set; }
		public int Original_Pmt_Disc_Possible { get; set; }
		public int Remaining_Pmt_Disc_Possible { get; set; }
		public int Max_Payment_Tolerance { get; set; }
		public bool Open { get; set; }
		public string On_Hold { get; set; }
		public string User_ID { get; set; }
		public string Source_Code { get; set; }
		public string Reason_Code { get; set; }
		public bool Reversed { get; set; }
		public int Reversed_by_Entry_No { get; set; }
		public int Reversed_Entry_No { get; set; }
		public string IRS_1099_Code { get; set; }
		public int IRS_1099_Amount { get; set; }
		public bool Exported_to_Payment_File { get; set; }
		public int Dimension_Set_ID { get; set; }
		public int Closed_by_Entry_No { get; set; }
		public string Date_Filter { get; set; }
	}
}
