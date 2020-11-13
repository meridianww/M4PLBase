#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse
{
    [XmlRoot(ElementName = "ResponseHeader")]
    public class ResponseHeader
    {
        /// <summary>
        /// Gets or Sets Status Code e.g. Success
        /// </summary>
        [XmlElement(ElementName = "StatusCode")]
        public string StatusCode { get; set; }
        /// <summary>
        /// Gets or Sets Transaction ID
        /// </summary>
        [XmlElement(ElementName = "TransactionID")]
        public string TransactionID { get; set; }
    }
}
