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
        /// <summary>
        /// Gets or Sets Location ID
        /// </summary>
        [XmlElement(ElementName = "LocationID")]
        public string LocationID { get; set; }
        /// <summary>
        /// Gets or Sets Location Name
        /// </summary>
        [XmlElement(ElementName = "LocationName")]
        public string LocationName { get; set; }
        /// <summary>
        /// Gets or Sets First Name
        /// </summary>
        [XmlElement(ElementName = "contactFirstName")]
        public string ContactFirstName { get; set; }
        /// <summary>
        /// Gets or Sets Last Name
        /// </summary>
        [XmlElement(ElementName = "contactLastName")]
        public string ContactLastName { get; set; }
        /// <summary>
        /// Gets or Sets Email ID
        /// </summary>
        [XmlElement(ElementName = "contactEmailID")]
        public string ContactEmailID { get; set; }
        /// <summary>
        /// Gets or Sets Address
        /// </summary>
        [XmlElement(ElementName = "addressLine1")]
        public string AddressLine1 { get; set; }
        /// <summary>
        /// Gets or Sets Address
        /// </summary>
        [XmlElement(ElementName = "addressLine2")]
        public string AddressLine2 { get; set; }
        /// <summary>
        /// Gets or Sets Address
        /// </summary>
        [XmlElement(ElementName = "addressLine3")]
        public string AddressLine3 { get; set; }
        /// <summary>
        /// Gets or Sets City Name
        /// </summary>
        [XmlElement(ElementName = "city")]
        public string City { get; set; }
        /// <summary>
        /// Gets or Sets State Name
        /// </summary>
        [XmlElement(ElementName = "state")]
        public string State { get; set; }
        /// <summary>
        /// Gets or Sets ZipCode
        /// </summary>
        [XmlElement(ElementName = "zipCode")]
        public string ZipCode { get; set; }
        /// <summary>
        /// Gets or Sets Country Name
        /// </summary>
        [XmlElement(ElementName = "country")]
        public string Country { get; set; }
        /// <summary>
        /// Gets or Sets Contact Number
        /// </summary>
        [XmlElement(ElementName = "contactNumber")]
        public string ContactNumber { get; set; }
        /// <summary>
        /// Gets or Sets LOT ID
        /// </summary>
        [XmlElement(ElementName = "lotID")]
        public string LotID { get; set; }
    }
}
