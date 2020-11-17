#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "POD")]
    public class POD
    {
        /// <summary>
        /// Gets or Sets Delivery Images
        /// </summary>
        [XmlElement(ElementName = "DeliveryImages")]
        public DeliveryImages DeliveryImages { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Signature
        /// </summary>
        [XmlElement(ElementName = "DeliverySignature")]
        public DeliverySignature DeliverySignature { get; set; }
    }
}
