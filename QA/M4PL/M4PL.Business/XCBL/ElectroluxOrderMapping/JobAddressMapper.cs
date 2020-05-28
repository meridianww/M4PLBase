using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
	public class JobAddressMapper
	{
		public Entities.Job.Job ToJobAddressModel(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			if (orderHeader == null) return existingJobData;
			UpdateShipFromData(orderHeader, ref existingJobData);
			UpdateShiptoData(orderHeader, ref existingJobData);
			UpdateDeliveryToData(orderHeader, ref existingJobData);

			return existingJobData;
		}

		private void UpdateDeliveryToData(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			var deliverToAddress = orderHeader?.DeliverTo;
			if (deliverToAddress == null) { return; }
			existingJobData.JobDeliveryCity = deliverToAddress.City;
			existingJobData.JobDeliveryCountry = deliverToAddress.Country;
			existingJobData.JobDeliveryPostalCode = deliverToAddress.ZipCode;
			existingJobData.JobDeliveryState = deliverToAddress.State;
			existingJobData.JobDeliveryStreetAddress = deliverToAddress.AddressLine1;
			existingJobData.JobDeliveryStreetAddress2 = deliverToAddress.AddressLine2;
			existingJobData.JobDeliveryStreetAddress3 = deliverToAddress.AddressLine3;
			existingJobData.JobDeliveryStreetAddress4 = deliverToAddress.LotID;
			existingJobData.JobDeliverySitePOCPhone = deliverToAddress.ContactNumber;
			existingJobData.JobDeliverySitePOCEmail = deliverToAddress.ContactEmailID;
			existingJobData.JobDeliverySiteName = deliverToAddress.LocationName;
			existingJobData.JobDeliverySitePOC = string.IsNullOrEmpty(deliverToAddress.ContactLastName)
					? deliverToAddress.ContactFirstName
					: string.Format("{0} {1}", deliverToAddress.ContactFirstName, deliverToAddress.ContactLastName);
		}

		private void UpdateShiptoData(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			var shiptoAddress = orderHeader?.ShipTo;
			if(shiptoAddress == null) { return; }
				existingJobData.JobOriginCity = shiptoAddress.City;
				existingJobData.JobOriginCountry = shiptoAddress.Country;
				existingJobData.JobOriginPostalCode = shiptoAddress.ZipCode;
				existingJobData.JobOriginState = shiptoAddress.State;
				existingJobData.JobOriginStreetAddress = shiptoAddress.AddressLine1;
				existingJobData.JobOriginStreetAddress2 = shiptoAddress.AddressLine2;
				existingJobData.JobOriginStreetAddress3 = shiptoAddress.AddressLine3;
			    existingJobData.JobOriginStreetAddress4 = shiptoAddress.LotID;
			    existingJobData.JobOriginSitePOCPhone = shiptoAddress.ContactNumber;
				existingJobData.JobOriginSitePOCEmail = shiptoAddress.ContactEmailID;
		     	existingJobData.JobOriginSiteName = shiptoAddress.LocationName;
				existingJobData.JobOriginSitePOC = string.IsNullOrEmpty(shiptoAddress.ContactLastName)
						? shiptoAddress.ContactFirstName
						: string.Format("{0} {1}", shiptoAddress.ContactFirstName, shiptoAddress.ContactLastName);
		}

		private void UpdateShipFromData(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			var shipFromAddress = orderHeader?.ShipFrom;
			if (shipFromAddress == null) { return; }
			existingJobData.JobShipFromCity = shipFromAddress.City;
			existingJobData.JobShipFromCountry = shipFromAddress.Country;
			existingJobData.JobShipFromPostalCode = shipFromAddress.ZipCode;
			existingJobData.JobShipFromState = shipFromAddress.State;
			existingJobData.JobShipFromStreetAddress = shipFromAddress.AddressLine1;
			existingJobData.JobShipFromStreetAddress2 = shipFromAddress.AddressLine2;
			existingJobData.JobShipFromStreetAddress3 = shipFromAddress.AddressLine3;
			existingJobData.JobShipFromSitePOCPhone = shipFromAddress.ContactNumber;
			existingJobData.JobShipFromSitePOCEmail = shipFromAddress.ContactEmailID;
			existingJobData.JobShipFromSiteName = shipFromAddress.LocationName;
			existingJobData.JobShipFromSitePOC = string.IsNullOrEmpty(shipFromAddress.ContactLastName)
					? shipFromAddress.ContactFirstName
					: string.Format("{0} {1}", shipFromAddress.ContactFirstName, shipFromAddress.ContactLastName);
		}
	}
}
