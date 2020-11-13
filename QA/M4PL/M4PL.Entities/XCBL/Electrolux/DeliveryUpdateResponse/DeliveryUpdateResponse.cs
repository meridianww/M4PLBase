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
    [XmlRoot(ElementName = "DeliveryUpdateResponse")]
    public class DeliveryUpdateResponse
    {
        /// <summary>
        /// Response model for Electrolux delivery update
        /// </summary>
        [XmlElement(ElementName = "ResponseHeader")]
        public ResponseHeader ResponseHeader { get; set; }
        /// <summary>
        /// Gets or Sets Record details which is updated to Electrolux
        /// </summary>
        [XmlElement(ElementName = "UpdatedRecord")]
        public UpdatedRecord UpdatedRecord { get; set; }
    }
}
