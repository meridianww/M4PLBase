using Newtonsoft.Json;

namespace M4PL.Entities.Finance
{
	/// <summary>
	/// Class For Nav Vendor
	/// </summary>
	public class NavVendorData
	{
		[JsonProperty("No")]
		public string Id { get; set; }
		public string PBS_Vendor_Code { get; set; }
		public string Name { get; set; }
		public string Responsibility_Center { get; set; }
		public string Location_Code { get; set; }
		public string Post_Code { get; set; }
		public string Country_Region_Code { get; set; }
		public string Phone_No { get; set; }
		public string Fax_No { get; set; }
		public string IC_Partner_Code { get; set; }
		public string Contact { get; set; }
		public string Search_Name { get; set; }
		public string Purchaser_Code { get; set; }
		public string Vendor_Posting_Group { get; set; }
		public string Gen_Bus_Posting_Group { get; set; }
		public string VAT_Bus_Posting_Group { get; set; }
		public string Payment_Terms_Code { get; set; }
		public string Fin_Charge_Terms_Code { get; set; }
		public string Currency_Code { get; set; }
		public string Language_Code { get; set; }
		public string Blocked { get; set; }
		public string Last_Date_Modified { get; set; }
		public string Application_Method { get; set; }
		public string Shipment_Method_Code { get; set; }
		public string Lead_Time_Calculation { get; set; }
		public string Base_Calendar_Code { get; set; }
		public double Balance_LCY { get; set; }
		public double Balance_Due_LCY { get; set; }
		public string Global_Dimension_1_Filter { get; set; }
		public string Global_Dimension_2_Filter { get; set; }
		public string Currency_Filter { get; set; }
		public string Date_Filter { get; set; }
	}
}
