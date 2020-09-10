using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class OrderDetails
    {
        public OrderDetails()
        {
            OrderGatewayDetails = new List<OrderGatewayDetails>();
            //OrderDocumentDetails = new List<OrderDocumentDetails>();
        }
        public long Id { get; set; }
        public string CustomerSalesOrder { get; set; }
        public string GatewayStatus { get; set; }
        public DateTime? DeliveryDatePlanned { get; set; }
        public DateTime? ArrivalDatePlanned { get; set; }
        public string BOL { get; set; }
        public string ManifestNo { get; set; }
        public DateTime? OrderDate { get; set; }
        public DateTime? ShipmentDate { get; set; }
        public long? CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string GwyOrderType { get; set; }
        public string GwyShipmentType { get; set; }
        public bool IsJobPermission { get; set; }
        public List<OrderGatewayDetails> OrderGatewayDetails { get; set; }
        //public List<OrderDocumentDetails> OrderDocumentDetails { get; set; }
    }
}