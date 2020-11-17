#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderResponse
{
    [XmlRoot(ElementName = "OrderResponse")]
    public class OrderResponse
    {
        /// <summary>
        /// Gets or Sets Subject
        /// </summary>
        [XmlElement(ElementName = "subject")]
        public string Subject { get; set; }
        /// <summary>
        /// Gets or Sets Client Message ID
        /// </summary>
        [XmlElement(ElementName = "clientMessageID")]
        public string ClientMessageID { get; set; }
        /// <summary>
        /// Gets or Sets Sender Message ID
        /// </summary>
        [XmlElement(ElementName = "senderMessageID")]
        public string SenderMessageID { get; set; }
        /// <summary>
        /// Gets or Sets Status Code e.g. Success
        /// </summary>
        [XmlElement(ElementName = "statusCode")]
        public string StatusCode { get; set; }
    }
}
