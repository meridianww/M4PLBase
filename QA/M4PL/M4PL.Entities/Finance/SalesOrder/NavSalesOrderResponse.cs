/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderResponse
Purpose:                                      Contains objects related to NavSalesOrderResponse
==========================================================================================================*/
using Newtonsoft.Json;

namespace M4PL.Entities.Finance.SalesOrder
{
	public class NavSalesOrderResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public NavSalesOrder NavSalesOrder { get; set; }
	}
}
