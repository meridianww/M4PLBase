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
    [XmlRoot(ElementName = "fxEnvelope")]
    public class ElectroluxOrderDetails
    {
        [XmlElement(ElementName = "header")]
        public Header Header { get; set; }
        [XmlElement(ElementName = "body")]
        public Body Body { get; set; }
    }
}
