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
    [XmlRoot(ElementName = "OrderLineDetail")]
    public class OrderLineDetail
    {
        /// <summary>
        /// Gets or Sets LineNumber e.g. 000010
        /// </summary>
        [XmlElement(ElementName = "lineNumber")]
        public string LineNumber { get; set; }
        /// <summary>
        /// Gets or Sets ItemId e.g. FGMV155CTF
        /// </summary>
        [XmlElement(ElementName = "ItemID")]
        public string ItemID { get; set; }
        /// <summary>
        /// Gets or Sets Item description e.g. FGMV155CTF CONVN OTR MICRO 1 5 CF ESS
        /// </summary>
        [XmlElement(ElementName = "ItemDescription")]
        public string ItemDescription { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Quantity e.g. 2
        /// </summary>
        [XmlElement(ElementName = "shipQuantity")]
        public int ShipQuantity { get; set; }
        /// <summary>
        /// Gets or Sets Weight of the Shipment e.g. 5.000
        /// </summary>
        [XmlElement(ElementName = "weight")]
        public decimal Weight { get; set; }
        /// <summary>
        /// Gets or Sets Measurement Unit of Weight e.g. LBR
        /// </summary>
        [XmlElement(ElementName = "weightUnitOfMeasure")]
        public string WeightUnitOfMeasure { get; set; }
        /// <summary>
        /// Gets or Sets Volume of Shipment e.g. 7.180
        /// </summary>
        [XmlElement(ElementName = "volume")]
        public string Volume { get; set; }
        /// <summary>
        /// Gets or Sets Measurement Unit of Volume e.g. FTQ
        /// </summary>
        [XmlElement(ElementName = "volumeUnitOfMeasure")]
        public string VolumeUnitOfMeasure { get; set; }
        /// <summary>
        /// Gets or Sets Secondary Location 
        /// </summary>
        [XmlElement(ElementName = "secondaryLocation")]
        public string SecondaryLocation { get; set; }
        /// <summary>
        /// Gets or Sets Material Tyoe of Shipment e.g. Accessory
        /// </summary>
        [XmlElement(ElementName = "materialType")]
        public string MaterialType { get; set; }
        /// <summary>
        /// Gets or Sets Measurement Unit of Shipment e.g. EA
        /// </summary>
        [XmlElement(ElementName = "shipUnitOfMeasure")]
        public string ShipUnitOfMeasure { get; set; }
        /// <summary>
        /// Gets or Sets Customer Stock Number 
        /// </summary>
        [XmlElement(ElementName = "customerStockNumber")]
        public string CustomerStockNumber { get; set; }
        /// <summary>
        /// Gets or Sets Status Code e.g. B
        /// </summary>
        [XmlElement(ElementName = "statusCode")]
        public string StatusCode { get; set; }
        /// <summary>
        /// Gets or Sets EDI Line ID
        /// </summary>
        [XmlElement(ElementName = "EDILINEID")]
        public string EDILINEID { get; set; }
        /// <summary>
        /// Gets or Sets Material Type Description e.g. BI OTR / Over-The-Raw
        /// </summary>
        [XmlElement(ElementName = "materialTypeDescription")]
        public string MaterialTypeDescription { get; set; }
        /// <summary>
        /// Gets or Sets Liner Number Reference
        /// </summary>
        [XmlElement(ElementName = "LineNumberReference")]
        public string LineNumberReference { get; set; }
        /// <summary>
        /// Gets or Sets Serial Number
        /// </summary>
        [XmlElement(ElementName = "SerialNumber")]
        public string SerialNumber { get; set; }
        /// <summary>
        /// Gets or Sets Line Description Details
        /// </summary>
        [XmlElement(ElementName = "lineDescriptionDetails")]
        public LineDescriptionDetails LineDescriptionDetails { get; set; }
    }
}
