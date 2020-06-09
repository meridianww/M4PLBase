/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrderItem
Purpose:                                      Contains objects related to NavSalesOrderItem
==========================================================================================================*/

namespace M4PL.Entities.Finance.ShippingItem
{
    public class NavSalesOrderItemRequest
    {
        public string No { get; set; }
        public long M4PLItemId { get; set; }
        public decimal Qty_to_Invoice { get; set; }
        public decimal Qty_to_Ship { get; set; }
        public decimal Quantity { get; set; }
        public string Planned_Delivery_Date { get; set; }
        public string Shipment_Date { get; set; }
        public string Planned_Shipment_Date { get; set; }
        public string M4PL_Job_ID { get; set; }
        public string FilteredTypeField { get; set; }
        public string Document_No { get; set; }
        public int Line_No { get; set; }
        public string Type { get; set; }
        public string Shortcut_Dimension_1_Code { get; set; }
        public string Shortcut_Dimension_2_Code { get; set; }
    }
}
