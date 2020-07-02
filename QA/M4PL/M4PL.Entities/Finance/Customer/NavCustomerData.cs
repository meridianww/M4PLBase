#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright


//
//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              20/06/2019
//====================================================================================================================================================
using Newtonsoft.Json;

namespace M4PL.Entities.Finance.Customer
{
    /// <summary>
    /// Class For Nav Customer
    /// </summary>
    public class NavCustomerData
    {
        [JsonProperty("No")]
        public string Id { get; set; }
        public string PBS_Customer_Code { get; set; }
        public string Name { get; set; }
        public string Responsibility_Center { get; set; }
        public string Location_Code { get; set; }
        public string Post_Code { get; set; }
        public string Country_Region_Code { get; set; }
        public string Search_Name { get; set; }
        public string Phone_No { get; set; }
        public string IC_Partner_Code { get; set; }
        public string Contact { get; set; }
        public string Salesperson_Code { get; set; }
        public string Customer_Posting_Group { get; set; }
        public string Gen_Bus_Posting_Group { get; set; }
        public string VAT_Bus_Posting_Group { get; set; }
        public string Customer_Price_Group { get; set; }
        public string Customer_Disc_Group { get; set; }
        public string Payment_Terms_Code { get; set; }
        public string Reminder_Terms_Code { get; set; }
        public string Fin_Charge_Terms_Code { get; set; }
        public string Currency_Code { get; set; }
        public string Language_Code { get; set; }
        public int Credit_Limit_LCY { get; set; }
        public string Blocked { get; set; }
        public string Last_Date_Modified { get; set; }
        public string Application_Method { get; set; }
        public bool Combine_Shipments { get; set; }
        public string Reserve { get; set; }
        public string Shipping_Advice { get; set; }
        public string Shipping_Agent_Code { get; set; }
        public string E_Ship_Agent_Service { get; set; }
        public string Base_Calendar_Code { get; set; }
        public double Balance_LCY { get; set; }
        public double Balance_Due_LCY { get; set; }
        public double Sales_LCY { get; set; }
        public string CFDI_Purpose { get; set; }
        public string CFDI_Relation { get; set; }
        public string Global_Dimension_1_Filter { get; set; }
        public string Global_Dimension_2_Filter { get; set; }
        public string Currency_Filter { get; set; }
        public string Date_Filter { get; set; }
    }
}
