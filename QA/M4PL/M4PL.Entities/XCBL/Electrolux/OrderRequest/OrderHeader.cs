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
    [XmlRoot(ElementName = "OrderHeader")]
    public class OrderHeader
    {
        /// <summary>
        /// Gets or Sets SenderID 
        /// </summary>
        [XmlElement(ElementName = "senderID")]
        public string SenderID { get; set; }
        /// <summary>
        /// Gets or Sets RecieverID
        /// </summary>
        [XmlElement(ElementName = "recieverID")]
        public string RecieverID { get; set; }
        /// <summary>
        /// Gets or Sets Orginal Order Number e.g. 7700563492
        /// </summary>
        [XmlElement(ElementName = "originalOrderNumber")]
        public string OriginalOrderNumber { get; set; }
        /// <summary>
        /// Gets or Sets Order Number (Contract #) e.g. ElectroluxOrder005
        /// </summary>
        [XmlElement(ElementName = "orderNumber")]
        public string OrderNumber { get; set; }
        /// <summary>
        /// Gets or Sets Action e.g. ADD or DELETE
        /// </summary>
        [XmlElement(ElementName = "Action")]
        public string Action { get; set; }
        /// <summary>
        /// Gets or Sets Release Number 
        /// </summary>
        [XmlElement(ElementName = "ReleaseNum")]
        public string ReleaseNum { get; set; }
        /// <summary>
        /// Gets or Sets OrderType e.g. ZORS
        /// </summary>
        [XmlElement(ElementName = "orderType")]
        public string OrderType { get; set; }
        /// <summary>
        /// Gets or Sets Order Date e.g. 2020-06-05
        /// </summary>
        [XmlElement(ElementName = "orderDate")]
        public string OrderDate { get; set; }
        /// <summary>
        /// Gets or Sets Customer Purchase Order e.g. 44801478-000
        /// </summary>
        [XmlElement(ElementName = "customerPO")]
        public string CustomerPO { get; set; }
        /// <summary>
        /// Gets or Sets Type of PO e.g. Z06
        /// </summary>
        [XmlElement(ElementName = "purchaseOrderType")]
        public string PurchaseOrderType { get; set; }
        /// <summary>
        /// Gets or Sets Consignee Purchase Order 
        /// </summary>
        [XmlElement(ElementName = "cosigneePO")]
        public string CosigneePO { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Date e.g. 2020-06-05
        /// </summary>
        [XmlElement(ElementName = "deliveryDate")]
        public string DeliveryDate { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Time e.g. 120621
        /// </summary>
        [XmlElement(ElementName = "deliveryTime")]
        public string DeliveryTime { get; set; }
        /// <summary>
        /// Gets or Sets RMAIndicator 
        /// </summary>
        [XmlElement(ElementName = "RMAIndicator")]
        public string RMAIndicator { get; set; }
        /// <summary>
        /// Gets or Sets DepartmentNumber 
        /// </summary>
        [XmlElement(ElementName = "departmentNumber")]
        public string DepartmentNumber { get; set; }
        /// <summary>
        /// Gets or Sets FreightCarrierCode
        /// </summary>
        [XmlElement(ElementName = "freightCarrierCode")]
        public string FreightCarrierCode { get; set; }
        /// <summary>
        /// Gets or SetsHotOrder
        /// </summary>
        [XmlElement(ElementName = "HotOrder")]
        public string HotOrder { get; set; }
        /// <summary>
        /// Gets or Sets ASN Data for current XCBL request 
        /// </summary>
        [XmlElement(ElementName = "ASNdata")]
        public ASNdata ASNdata { get; set; }
        /// <summary>
        /// Gets or Sets Shipment From Details
        /// </summary>
        [XmlElement(ElementName = "ShipFrom")]
        public ShipFrom ShipFrom { get; set; }
        /// <summary>
        /// Gets or Sets Shipment to Details
        /// </summary>
        [XmlElement(ElementName = "ShipTo")]
        public ShipTo ShipTo { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Details
        /// </summary>
        [XmlElement(ElementName = "DeliverTo")]
        public DeliverTo DeliverTo { get; set; }
    }
}
