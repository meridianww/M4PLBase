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
        /// <summary>
        /// Gets or Sets Line Number
        /// </summary>
        [XmlElement(ElementName = "LineNumber")]
        public string LineNumber { get; set; }
        /// <summary>
        /// Gets or Sets Item Number e.g. Cargo Line Item
        /// </summary>
        [XmlElement(ElementName = "ItemNumber")]
        public string ItemNumber { get; set; }
        /// <summary>
        /// Gets or Sets Installation Status e.g. NS
        /// </summary>
        [XmlElement(ElementName = "ItemInstallStatus")]
        public string ItemInstallStatus { get; set; }
        /// <summary>
        /// Gets or Sets Latitude
        /// </summary>
		[XmlElement(ElementName = "Latitude")]
		public string Latitude { get; set; }
        /// <summary>
        /// Gets or Sets Longitude
        /// </summary>
		[XmlElement(ElementName = "Longitude")]
		public string Longitude { get; set; }
        /// <summary>
        /// Gets or Sets User Notes
        /// </summary>
		[XmlElement(ElementName = "UserNotes")]
        public string UserNotes { get; set; }
        /// <summary>
        /// Gets or Sets Installation comments
        /// </summary>
        [XmlElement(ElementName = "ItemInstallComments")]
        public string ItemInstallComments { get; set; }

        /// <summary>
        /// Gets Or Sets CgoSerialBarcode
        /// </summary>
        [XmlElement(ElementName = "CgoSerialBarcode")]
        public string CgoSerialBarcode { get; set; }

        /// <summary>
        /// Gets Or Sets CgoSerialBarcode
        /// </summary>
        [XmlElement(ElementName = "CgoSerialNumber")]
        public string CgoSerialNumber { get; set; }

        /// <summary>
        /// Gets Or Sets CgoLineNumber
        /// </summary>
        [XmlElement(ElementName = "CgoLineNumber")]
        public string CgoLineNumber { get; set; }

        /// <summary>
        /// Gets or Sets Exception if any
        /// </summary>
        [XmlElement(ElementName = "Exceptions")]
        public Exceptions Exceptions { get; set; }

        [XmlElement(ElementName = "CgoQtyOrdered")]
        public string CgoQtyOrdered { get; set; }


        [XmlElement(ElementName = "CgoTitle")]
        public string CgoTitle { get; set; }
    }
}
