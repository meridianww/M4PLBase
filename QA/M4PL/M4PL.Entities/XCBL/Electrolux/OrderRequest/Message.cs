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
    [XmlRoot(ElementName = "message")]
    public class Message
    {
        /// <summary>
        /// Gets or Set Subject e.g. Order
        /// </summary>
        [XmlElement(ElementName = "subject")]
        public string Subject { get; set; }
        /// <summary>
        /// Gets or Sets PayloadType e.g. FXS-2.0
        /// </summary>
        [XmlElement(ElementName = "payloadType")]
        public string PayloadType { get; set; }
    }
}
