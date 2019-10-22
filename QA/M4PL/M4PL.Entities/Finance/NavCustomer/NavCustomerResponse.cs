/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              20/06/2019
//====================================================================================================================================================*/
using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Finance.NavCustomer
{
	public class NavCustomerResponse
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<NavCustomerData> CustomerList { get; set; }
	}
}
