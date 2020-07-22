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
        [XmlElement(ElementName = "ResponseHeader")]
        public ResponseHeader ResponseHeader { get; set; }
        [XmlElement(ElementName = "UpdatedRecord")]
        public UpdatedRecord UpdatedRecord { get; set; }
    }
}
