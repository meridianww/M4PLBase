/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrderItem
Purpose:                                      Contains objects related to NavSalesOrderItem
==========================================================================================================*/
using System;

namespace M4PL.Entities.Finance
{
	public class NavSalesOrderItem
	{
		public ItemType Type { get; set; }
		public string No { get; set; }
		public string M4PL_Job_ID { get; set; }
		public string Description { get; set; }
		public decimal Net_Weight { get; set; }
		public string Location_Code { get; set; }
		public decimal Quantity { get; set; }
		public decimal Unit_Price { get; set; }
		public string Tax_Group_Code { get; set; }
		public decimal Line_Discount_Amount { get; set; }
		public decimal Qty_to_Ship { get; set; }
		public decimal Qty_to_Invoice { get; set; }
		public DateTime Shipment_Date { get; set; }
		public DateTime Planned_Shipment_Date { get; set; }
		public DateTime Planned_Delivery_Date { get; set; }
	}
}
