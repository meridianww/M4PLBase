/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              11/13/2019
Program Name:                                 NAVOrderItemResponse
Purpose:                                      Contains objects related to NAVOrderItemResponse
==========================================================================================================*/
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.OrderItem
{
	public class NAVOrderItemResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<NAVOrderItem> OrderItemList { get; set; }
	}
}
