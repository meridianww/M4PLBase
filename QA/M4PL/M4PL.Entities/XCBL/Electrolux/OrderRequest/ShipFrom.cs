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
    [XmlRoot(ElementName = "ShipFrom")]
    public class ShipFrom
    {
        /// <summary>
        /// Gets or Sets Location ID e.g. 0070219513
        /// </summary>
        [XmlElement(ElementName = "LocationID")]
        public string LocationID { get; set; }
        /// <summary>
        /// Gets or Sets Location Name e.g. EDC FSA SC13
        /// </summary>
        [XmlElement(ElementName = "LocationName")]
        public string LocationName { get; set; }
        /// <summary>
        /// Gets or Sets First name 
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
        /// Gets or Sets City
        /// </summary>
        [XmlElement(ElementName = "city")]
        public string City { get; set; }
        /// <summary>
        /// Gets or Sets State
        /// </summary>
        [XmlElement(ElementName = "state")]
        public string State { get; set; }
        /// <summary>
        /// Gets or Sets ZipCode
        /// </summary>
        [XmlElement(ElementName = "zipCode")]
        public string ZipCode { get; set; }
        /// <summary>
        /// Gets or Sets Country
        /// </summary>
        [XmlElement(ElementName = "country")]
        public string Country { get; set; }
        /// <summary>
        /// Gets or Sets Contact Number
        /// </summary>
        [XmlElement(ElementName = "contactNumber")]
        public string ContactNumber { get; set; }
    }
}
