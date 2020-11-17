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
    /// <summary>
    /// Electrolux Order details request may be either type of Order or ASN. Order is to create new order and ASN is to update existing Order.
    /// </summary>
    [XmlRoot(ElementName = "fxEnvelope")]
    public class ElectroluxOrderDetails
    {
        /// <summary>
        /// Gets or Sets Header Information of XCBL Request
        /// </summary>
        [XmlElement(ElementName = "header")]
        public Header Header { get; set; }
        /// <summary>
        /// Gets or Sets Body of XCBL Request
        /// </summary>
        [XmlElement(ElementName = "body")]
        public Body Body { get; set; }
    }
}
