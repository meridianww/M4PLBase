#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/03/2019
// Program Name:                                 NavSalesOrder
// Purpose:                                      Contains objects related to PurchaseOrderItem
//==========================================================================================================

namespace M4PL.Entities.Finance.PurchaseOrderItem
{
    public class NavPurchaseOrderItemRequest
    {
        public string No { get; set; }
        public long M4PLItemId { get; set; }
        public string Document_No { get; set; }
        public string M4PL_Job_ID { get; set; }
        public decimal Quantity { get; set; }
        public decimal Qty_to_Receive { get; set; }
        public decimal Qty_to_Invoice { get; set; }
        public string Promised_Receipt_Date { get; set; }
        public string Expected_Receipt_Date { get; set; }
        public string Order_Date { get; set; }
        public int Line_No { get; set; }
        public string Type { get; set; }
        public string FilteredTypeField { get; set; }
        public string Shortcut_Dimension_1_Code { get; set; }
        public string Shortcut_Dimension_2_Code { get; set; }
    }
}
