﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.XCBL
{
    public class LineDetail
    {
        public long SummaryHeaderId { get; set; }
        public string LineNumber { get; set; }
        public string ItemID { get; set; }
        public string ItemDescription { get; set; }
        public int ShipQuantity { get; set; }
        public decimal Weight { get; set; }
        public string WeightUnitOfMeasure { get; set; }
        public string Volume { get; set; }
        public string VolumeUnitOfMeasure { get; set; }
        public string SecondaryLocation { get; set; }
        public string MaterialType { get; set; }
        public string ShipUnitOfMeasure { get; set; }
        public string CustomerStockNumber { get; set; }
        public string StatusCode { get; set; }
        public string EDILINEID { get; set; }
        public string MaterialTypeDescription { get; set; }
        public string LineNumberReference { get; set; }
    }
}
