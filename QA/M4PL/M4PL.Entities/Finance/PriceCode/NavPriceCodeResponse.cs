/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              07/31/2019
Program Name:                                 NavPriceCodeResponse
Purpose:                                      Contains objects related to NavPriceCodeResponse
==========================================================================================================*/
using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Finance.PriceCode
{
    public class NavPriceCodeResponse
    {
        [JsonProperty("@odata.context")]
        public string ContextData { get; set; }

        [JsonProperty("value")]
        public List<NavPriceCode> PriceCodeList { get; set; }
    }
}
