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
        /// <summary>
        /// Gets or Sets SCAC 
        /// </summary>
        [XmlElement(ElementName = "Scac")]
        public string Scac { get; set; }
        /// <summary>
        /// Gets or Sets VehicleId e.g. VEH22032
        /// </summary>
        [XmlElement(ElementName = "VehicleId")]
        public string VehicleId { get; set; }
        /// <summary>
        /// Gets or Sets BOL Number
        /// </summary>
        [XmlElement(ElementName = "BolNumber")]
        public string BolNumber { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Date
        /// </summary>
        [XmlElement(ElementName = "Shipdate")]
        public string Shipdate { get; set; }
        /// <summary>
        /// Gets or Set Estimated Time of Arrival
        /// </summary>
        [XmlElement(ElementName = "ETAtime")]
        public string ETAtime { get; set; }
        /// <summary>
        /// Gets or Sets Estimated Date of Arrival
        /// </summary>
        [XmlElement(ElementName = "ETAdate")]
        public string ETAdate { get; set; }
    }
}
