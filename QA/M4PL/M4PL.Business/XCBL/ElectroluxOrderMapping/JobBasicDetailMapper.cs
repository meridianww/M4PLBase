using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
	public class JobBasicDetailMapper
	{
		public Entities.Job.Job ToJobBasicDetailModel(OrderHeader orderHeader, ref Entities.Job.Job jobDatatoUpdate, long programId, OrderLineDetailList orderLineDetailList, bool isASNRequest, List<SystemReference> systemOptionList)
		{
			if (orderHeader == null) return jobDatatoUpdate;

			DateTime? asnShipDate = !string.IsNullOrEmpty(orderHeader?.ASNdata?.Shipdate) && orderHeader?.ASNdata?.Shipdate.Length >= 8 ?
				string.Format("{0}-{1}-{2}", orderHeader?.ASNdata?.Shipdate.Substring(0, 4), orderHeader?.ASNdata?.Shipdate.Substring(4, 2), orderHeader?.ASNdata?.Shipdate.Substring(6, 2)).ToDate()
				: null;
			jobDatatoUpdate = jobDatatoUpdate != null ? jobDatatoUpdate : new Entities.Job.Job();
			jobDatatoUpdate.JobQtyUnitTypeId = systemOptionList?.
				Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id ;
			string deliveryTime = orderHeader.DeliveryTime;
			deliveryTime = (!string.IsNullOrEmpty(orderHeader.DeliveryTime) && orderHeader.DeliveryTime.Length >= 6) ?
                               orderHeader.DeliveryTime.Substring(0, 2) + ":" + orderHeader.DeliveryTime.Substring(2, 2) + ":" +
                               orderHeader.DeliveryTime.Substring(4, 2) : "";
			jobDatatoUpdate.JobPONumber = orderHeader.CustomerPO;
			jobDatatoUpdate.JobCustomerSalesOrder = orderHeader.OrderNumber;
			jobDatatoUpdate.PlantIDCode = (orderHeader.ShipFrom != null && !string.IsNullOrEmpty(orderHeader.ShipFrom.LocationID)) ? orderHeader.ShipFrom.LocationID : jobDatatoUpdate.PlantIDCode;
			jobDatatoUpdate.StatusId = (int)StatusType.Active;
			jobDatatoUpdate.ProgramID = programId;
			jobDatatoUpdate.JobType = "Original";
			jobDatatoUpdate.ShipmentType = "Cross-Dock Shipment";
			jobDatatoUpdate.JobSiteCode = !string.IsNullOrEmpty(orderHeader?.ShipTo.LocationName) && orderHeader?.ShipTo.LocationName.Length >= 4 ? orderHeader.ShipTo.LocationName.Substring(orderHeader.ShipTo.LocationName.Length - 4) : null;
			jobDatatoUpdate.JobElectronicInvoice = true;
			jobDatatoUpdate.JobOrderedDate = !string.IsNullOrEmpty(orderHeader.OrderDate) ? Convert.ToDateTime(orderHeader.OrderDate) : (DateTime?)null;
			jobDatatoUpdate.JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
					: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
            if (isASNRequest)
            {
                int? qtyActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Count();
                int? jobPartsOrdered = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Count();
                int? jobServiceActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Count();

                jobDatatoUpdate.JobQtyActual = qtyActual == 0 ? null : qtyActual;
                jobDatatoUpdate.JobPartsActual = jobPartsOrdered == 0 ? null : jobPartsOrdered;
				jobDatatoUpdate.JobServiceActual = jobServiceActual == 0 ? null : jobServiceActual;
				jobDatatoUpdate.JobOriginDateTimeBaseline = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimeBaseline;
				jobDatatoUpdate.JobOriginDateTimePlanned = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
				jobDatatoUpdate.JobShipmentDate = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
			}
			else
			{
                int? partsOrderedCount = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Count();
                int? qtyOrderedCount =  orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Count();
                int? jobServiceOrderCount = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Count();

                jobDatatoUpdate.JobQtyOrdered = qtyOrderedCount == 0 ? null : qtyOrderedCount;
				jobDatatoUpdate.JobPartsOrdered = partsOrderedCount == 0 ? null : partsOrderedCount;
				jobDatatoUpdate.JobServiceOrder = jobServiceOrderCount == 0 ? null : jobServiceOrderCount;
				jobDatatoUpdate.JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
						? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
						: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
						? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
			}

			return jobDatatoUpdate;
		}
	}
}
