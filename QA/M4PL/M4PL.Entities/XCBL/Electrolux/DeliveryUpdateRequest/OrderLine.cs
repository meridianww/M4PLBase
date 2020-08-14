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
    [XmlRoot(ElementName = "OrderLine")]
    public class OrderLine
    {
        [XmlElement(ElementName = "LineNumber")]
        public string LineNumber { get; set; }
        [XmlElement(ElementName = "ItemNumber")]
        public string ItemNumber { get; set; }
        [XmlElement(ElementName = "ItemInstallStatus")]
        public string ItemInstallStatus { get; set; }
		[XmlElement(ElementName = "Latitude")]
		public string Latitude { get; set; }
		[XmlElement(ElementName = "Longitude")]
		public string Longitude { get; set; }
		[XmlElement(ElementName = "UserNotes")]
        public string UserNotes { get; set; }
        [XmlElement(ElementName = "ItemInstallComments")]
        public string ItemInstallComments { get; set; }
        [XmlElement(ElementName = "Exceptions")]
        public Exceptions Exceptions { get; set; }
    }
}
