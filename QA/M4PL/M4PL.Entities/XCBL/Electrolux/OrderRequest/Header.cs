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
    [XmlRoot(ElementName = "header")]
    public class Header
    {
        /// <summary>
        /// Gets or Sets Message for Header
        /// </summary>
        [XmlElement(ElementName = "message")]
        public Message Message { get; set; }
        /// <summary>
        /// Gets or Sets Shipment From Location Details
        /// </summary>
        [XmlElement(ElementName = "from")]
        public From From { get; set; }
        /// <summary>
        /// Gets or Sets Shipment To Location Details
        /// </summary>
        [XmlElement(ElementName = "to")]
        public To To { get; set; }
    }
}
