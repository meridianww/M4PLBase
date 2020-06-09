/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrder
Purpose:                                      Contains objects related to NavSalesOrder
==========================================================================================================*/

namespace M4PL.Entities.Finance.SalesOrder
{
    public class NavSalesOrderRequest
    {
        public string Sell_to_Customer_No { get; set; }
        public string Order_Date { get; set; }
        public string Received_Date { get; set; }
        public string Delivery_Date { get; set; }
        public string External_Document_No { get; set; }
        public string Cust_Reference_No { get; set; }
        public string M4PL_Job_ID { get; set; }
        public string Ship_from_Code { get; set; }
        public string Ship_from_Name { get; set; }
        public string Ship_from_Name_2 { get; set; }
        public string Ship_from_Address { get; set; }
        public string Ship_from_Address_2 { get; set; }
        public string Ship_from_City { get; set; }
        public string Ship_from_County { get; set; }
        public string Ship_from_Post_Code { get; set; }
        public string Ship_from_Contact { get; set; }
        public string Ship_from_Phone { get; set; }
        public string Ship_from_Mobile { get; set; }
        public string Ship_from_Email { get; set; }
        public string Ship_to_Code { get; set; }
        public string Ship_to_Name { get; set; }
        public string Ship_to_Address { get; set; }
        public string Ship_to_Address_2 { get; set; }
        public string Ship_to_City { get; set; }
        public string Ship_to_County { get; set; }
        public string Ship_to_Post_Code { get; set; }
        public string Ship_to_Contact { get; set; }
        public string Ship_to_Phone { get; set; }
        public string Ship_to_Mobile { get; set; }
        public string Ship_to_Email { get; set; }
        public string Shortcut_Dimension_1_Code { get; set; }
        public string Shortcut_Dimension_2_Code { get; set; }
        public string Shipment_Date { get; set; }
        public decimal Mileage { get; set; }
        public decimal Storage { get; set; }
        public bool Electronic_Invoice { get; set; }
    }
}
