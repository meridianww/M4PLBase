﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              07/31/2019
Program Name:                                 NavCostCodeResponse
Purpose:                                      Contains objects related to NavCostCodeResponse
==========================================================================================================*/
using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Finance.SalesOrderDimension
{
    public class NavSalesOrderDimensionResponse
    {
        [JsonProperty("@odata.context")]
        public string ContextData { get; set; }

        [JsonProperty("value")]
        public List<NavSalesOrderDimensionValues> NavSalesOrderDimensionValues { get; set; }
    }
}
