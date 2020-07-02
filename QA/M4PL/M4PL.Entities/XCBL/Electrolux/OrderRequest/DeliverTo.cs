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
    [XmlRoot(ElementName = "DeliverTo")]
    public class DeliverTo
    {
        [XmlElement(ElementName = "LocationID")]
        public string LocationID { get; set; }
        [XmlElement(ElementName = "LocationName")]
        public string LocationName { get; set; }
        [XmlElement(ElementName = "contactFirstName")]
        public string ContactFirstName { get; set; }
        [XmlElement(ElementName = "contactLastName")]
        public string ContactLastName { get; set; }
        [XmlElement(ElementName = "contactEmailID")]
        public string ContactEmailID { get; set; }
        [XmlElement(ElementName = "addressLine1")]
        public string AddressLine1 { get; set; }
        [XmlElement(ElementName = "addressLine2")]
        public string AddressLine2 { get; set; }
        [XmlElement(ElementName = "addressLine3")]
        public string AddressLine3 { get; set; }
        [XmlElement(ElementName = "city")]
        public string City { get; set; }
        [XmlElement(ElementName = "state")]
        public string State { get; set; }
        [XmlElement(ElementName = "zipCode")]
        public string ZipCode { get; set; }
        [XmlElement(ElementName = "country")]
        public string Country { get; set; }
        [XmlElement(ElementName = "contactNumber")]
        public string ContactNumber { get; set; }
        [XmlElement(ElementName = "lotID")]
        public string LotID { get; set; }
    }
}
