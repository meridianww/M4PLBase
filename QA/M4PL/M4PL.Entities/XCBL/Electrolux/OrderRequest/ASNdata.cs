#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "ASNdata")]
    public class ASNdata
    {
        [XmlElement(ElementName = "Scac")]
        public string Scac { get; set; }
        [XmlElement(ElementName = "VehicleId")]
        public string VehicleId { get; set; }
        [XmlElement(ElementName = "BolNumber")]
        public string BolNumber { get; set; }
        [XmlElement(ElementName = "Shipdate")]
        public string Shipdate { get; set; }
        [XmlElement(ElementName = "ETAtime")]
        public string ETAtime { get; set; }
        [XmlElement(ElementName = "ETAdate")]
        public string ETAdate { get; set; }
    }
}
