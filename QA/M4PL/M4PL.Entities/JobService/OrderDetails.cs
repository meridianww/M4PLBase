using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Job/Order Details
    /// </summary>
    public class OrderDetails
    {
        /// <summary>
        /// default constructor
        /// </summary>
        public OrderDetails()
        {
            OrderGatewayDetails = new List<OrderGatewayDetails>();
            //OrderDocumentDetails = new List<OrderDocumentDetails>();
        }
        /// <summary>
        /// Gets or Sets Job Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Customer Number
        /// </summary>
        public string CustomerSalesOrder { get; set; }
        /// <summary>
        /// Gets or Sets Current Gateway Status
        /// </summary>
        public string GatewayStatus { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Date Planned
        /// </summary>
        public DateTime? DeliveryDatePlanned { get; set; }
        /// <summary>
        /// Gets or Sets Arrival Date Planned
        /// </summary>
        public DateTime? ArrivalDatePlanned { get; set; }
        /// <summary>
        /// Gets or Sets BOL Number
        /// </summary>
        public string BOL { get; set; }
        /// <summary>
        /// Gets or Sets Manifest No
        /// </summary>
        public string ManifestNo { get; set; }
        /// <summary>
        /// Gets or Sets Order Date
        /// </summary>
        public DateTime? OrderDate { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Date
        /// </summary>
        public DateTime? ShipmentDate { get; set; }
        /// <summary>
        /// Gets or Sets Customer Id
        /// </summary>
        public long? CustomerId { get; set; }
        /// <summary>
        /// Gets or Sets Customer Code
        /// </summary>
        public string CustomerCode { get; set; }
        /// <summary>
        /// Gets or Sets Order Type
        /// </summary>
        public string GwyOrderType { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Type
        /// </summary>
        public string GwyShipmentType { get; set; }
        /// <summary>
        /// Gets or Sets permission flag for Job
        /// </summary>
        public bool IsJobPermission { get; set; }
        /// <summary>
        /// Gets or Sets List of Job Gateways
        /// </summary>
        public List<OrderGatewayDetails> OrderGatewayDetails { get; set; }
        //public List<OrderDocumentDetails> OrderDocumentDetails { get; set; }
    }
}