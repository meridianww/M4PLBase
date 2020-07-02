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
// Program Name:                                 NavSalesOrderDimensionValues
// Purpose:                                      Contains objects related to NavSalesOrderDimensionValues
//==========================================================================================================

using Newtonsoft.Json;

namespace M4PL.Entities.Finance.SalesOrderDimension
{
    public class NavSalesOrderDimensionValues
    {
        public string Dimension_Code { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public string Dimension_Value_Type { get; set; }
        public string Totaling { get; set; }
        public bool Blocked { get; set; }
        public string Map_to_IC_Dimension_Value_Code { get; set; }
        public string Consolidation_Code { get; set; }

        [JsonProperty("ERP_ID")]
        public string ERPId { get; set; }
    }
}
