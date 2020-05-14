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
				string.Format("{0}-{1}-{2}", orderHeader?.ASNdata?.Shipdate.Substring(0, 4), orderHeader?.ASNdata?.Shipdate.Substring(4, 6), orderHeader?.ASNdata?.Shipdate.Substring(6, 8)).ToDate()
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
			jobDatatoUpdate.StatusId = (int)StatusType.Active;
			jobDatatoUpdate.ProgramID = programId;
			jobDatatoUpdate.JobType = "Original";
			jobDatatoUpdate.ShipmentType = "Cross-Dock Shipment";
			jobDatatoUpdate.JobSiteCode = orderHeader?.ShipTo.LocationName;
			jobDatatoUpdate.JobOrderedDate = !string.IsNullOrEmpty(orderHeader.OrderDate) ? Convert.ToDateTime(orderHeader.OrderDate) : (DateTime?)null;
			jobDatatoUpdate.JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
					: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
            if (isASNRequest)
            {
				jobDatatoUpdate.JobQtyActual = orderLineDetailList?.OrderLineDetail?.Count;
				jobDatatoUpdate.JobPartsActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Count();
				jobDatatoUpdate.JobServiceActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Count();
				jobDatatoUpdate.JobOriginDateTimeBaseline = asnShipDate.HasValue ? asnShipDate.ToDateTime().AddDays(1) : jobDatatoUpdate.JobOriginDateTimeBaseline;
				jobDatatoUpdate.JobOriginDateTimePlanned = asnShipDate.HasValue ? asnShipDate.ToDateTime().AddDays(1) : jobDatatoUpdate.JobOriginDateTimePlanned;
			}
			else
			{
				jobDatatoUpdate.JobQtyOrdered = orderLineDetailList?.OrderLineDetail?.Count;
				jobDatatoUpdate.JobPartsOrdered = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Count();
				jobDatatoUpdate.JobServiceOrder = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Count();
				jobDatatoUpdate.JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
						? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
						: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
						? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
			}

			return jobDatatoUpdate;
		}
	}
}
