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
    [XmlRoot(ElementName = "Order")]
    public class Order
    {
        /// <summary>
        /// Gets or Sets Order Header info
        /// </summary>
        [XmlElement(ElementName = "OrderHeader")]
        public OrderHeader OrderHeader { get; set; }
        /// <summary>
        /// Gets or Sets List of Order Line Detail
        /// </summary>
        [XmlElement(ElementName = "OrderLineDetailList")]
        public OrderLineDetailList OrderLineDetailList { get; set; }
        /// <summary>
        /// Gets or Sets List of Order Description
        /// </summary>
        [XmlElement(ElementName = "OrderDescriptionList")]
        public OrderDescriptionList OrderDescriptionList { get; set; }
    }
}
