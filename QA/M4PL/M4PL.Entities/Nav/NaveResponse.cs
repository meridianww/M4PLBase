/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/18/2019
//====================================================================================================================================================*/

using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Nav
{
	public class NaveResponse 
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }

		[JsonProperty("value")]
		public List<NavCustomer> CustomerList { get; set; }
	}
}
