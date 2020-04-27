using M4PL.Entities;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
	public class JobBasicDetailMapper
	{
		public Entities.Job.Job ToJobBasicDetailModel(OrderHeader orderHeader, ref Entities.Job.Job jobDatatoUpdate, long programId)
		{
			if (orderHeader == null) return jobDatatoUpdate;

			jobDatatoUpdate = jobDatatoUpdate != null ? jobDatatoUpdate : new Entities.Job.Job();
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
			jobDatatoUpdate.JobOrderedDate = !string.IsNullOrEmpty(orderHeader.OrderDate) ? Convert.ToDateTime(orderHeader.OrderDate) : (DateTime?)null;
			jobDatatoUpdate.JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
					: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
            jobDatatoUpdate.JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
                    ? Convert.ToDateTime(string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime))
                    : !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
                    ? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;

            return jobDatatoUpdate;
		}
	}
}
