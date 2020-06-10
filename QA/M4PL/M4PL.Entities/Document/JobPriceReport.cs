using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Document
{
	public class JobPriceReport
	{
		public long JobId { get; set; }
		public DateTime? DeliveryDateTimePlanned { get; set; }
		public DateTime? OriginDateTimePlanned { get; set; }
		public string GatewayStatus { get; set; }
		public string VendorLocation { get; set; }
		public string ContractNumber { get; set; }
		public string PlantCode { get; set; }
		public int QuantityActual { get; set; }
		public int PartActual { get; set; }
		public decimal Cubes { get; set; }
		public string ChargeCode { get; set; }
		public string ChargeTitle { get; set; }
		public decimal? Rate { get; set; }
		public string ServiceMode { get; set; }
		public string CustomerPurchaseOrder { get; set; }
		public string Brand { get; set; }
		public string StatusName { get; set; }
		public string DeliverySitePOC { get; set; }
		public string DeliverySitePOCPhone { get; set; }
		public string DeliverySitePOC2 { get; set; }
		public string DeliverySitePOCPhone2 { get; set; }
		public string DeliverySitePOCEmail { get; set; }
		public string OriginSiteName { get; set; }
		public string DeliverySiteName { get; set; }
		public string DeliveryStreetAddress { get; set; }
		public string DeliveryStreetAddress2 { get; set; }
		public string DeliveryCity { get; set; }
		public string DeliveryState { get; set; }
		public string DeliveryPostalCode { get; set; }
		public DateTime? DeliveryDateTimeActual { get; set; }
		public DateTime? OriginDateTimeActual { get; set; }
		public DateTime? OrderedDate { get; set; }
	}
}
