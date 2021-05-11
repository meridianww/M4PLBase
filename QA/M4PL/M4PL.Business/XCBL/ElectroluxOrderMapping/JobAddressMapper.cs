#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.FarEye.Order;

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

		public Entities.Job.Job ToJobAddressModelFromDataByFarEyeModel(FarEyeOrderDetails farEyeOrderDetails, ref Entities.Job.Job existingJobData)
		{
			if (farEyeOrderDetails == null) return existingJobData;
			UpdateDeliveryToDataByFarEyeModel(farEyeOrderDetails, ref existingJobData);
			UpdateShipFromDataByFarEyeModel(farEyeOrderDetails, ref existingJobData);
			UpdateShiptoDataByFarEyeModel(farEyeOrderDetails, ref existingJobData);
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
			existingJobData.JobDeliveryStreetAddress = string.IsNullOrEmpty(deliverToAddress.LotID) ? deliverToAddress.AddressLine1 : string.Format("{0} Lot # {1}", deliverToAddress.AddressLine1, deliverToAddress.LotID);
			existingJobData.JobDeliveryStreetAddress2 = deliverToAddress.AddressLine2;
			existingJobData.JobDeliveryStreetAddress3 = deliverToAddress.AddressLine3;
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
			if (shiptoAddress == null) { return; }
			existingJobData.JobOriginCity = shiptoAddress.City;
			existingJobData.JobOriginCountry = shiptoAddress.Country;
			existingJobData.JobOriginPostalCode = shiptoAddress.ZipCode;
			existingJobData.JobOriginState = shiptoAddress.State;
			existingJobData.JobOriginStreetAddress = string.IsNullOrEmpty(shiptoAddress.LotID) ? shiptoAddress.AddressLine1 : string.Format("{0} Lot # {1}", shiptoAddress.AddressLine1, shiptoAddress.LotID);
			existingJobData.JobOriginStreetAddress2 = shiptoAddress.AddressLine2;
			existingJobData.JobOriginStreetAddress3 = shiptoAddress.AddressLine3;
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

		private void UpdateDeliveryToDataByFarEyeModel(FarEyeOrderDetails farEyeOrderDetails, ref Entities.Job.Job existingJobData)
		{
			if(farEyeOrderDetails.type_of_order == "Reverse")
            {
				existingJobData.JobDeliveryCity = farEyeOrderDetails.return_city;
				existingJobData.JobDeliveryCountry = farEyeOrderDetails.return_country;
				existingJobData.JobDeliveryPostalCode = farEyeOrderDetails.return_postal_code;
				existingJobData.JobDeliveryState = farEyeOrderDetails.return_state_province;
				existingJobData.JobDeliveryStreetAddress = farEyeOrderDetails.return_address_line1;
				existingJobData.JobDeliveryStreetAddress2 = farEyeOrderDetails.return_address_line2;
				existingJobData.JobDeliveryStreetAddress3 = farEyeOrderDetails.return_landmark;
				existingJobData.JobDeliverySitePOCPhone = farEyeOrderDetails.return_contact_number;
				existingJobData.JobDeliverySitePOCPhone2 = farEyeOrderDetails.return_contact_number2;
				existingJobData.JobDeliverySitePOCEmail = farEyeOrderDetails.return_email;
				existingJobData.JobDeliverySiteName = farEyeOrderDetails.return_name;
			}
			else
            {
				existingJobData.JobDeliveryCity = farEyeOrderDetails.deliver_to_city;
				existingJobData.JobDeliveryCountry = farEyeOrderDetails.deliver_to_country;
				existingJobData.JobDeliveryPostalCode = farEyeOrderDetails.deliver_to_postal_code;
				existingJobData.JobDeliveryState = farEyeOrderDetails.deliver_to_state_province;
				existingJobData.JobDeliveryStreetAddress = string.IsNullOrEmpty(farEyeOrderDetails.deliver_lot_id) ? farEyeOrderDetails.deliver_to_address_line1 :
					string.Format("{0} Lot # {1}", farEyeOrderDetails.deliver_to_address_line1, farEyeOrderDetails.deliver_lot_id);
				existingJobData.JobDeliveryStreetAddress2 = farEyeOrderDetails.deliver_to_address_line2;
				existingJobData.JobDeliveryStreetAddress3 = farEyeOrderDetails.deliver_to_landmark;
				existingJobData.JobDeliverySitePOCPhone = farEyeOrderDetails.deliver_to_contact_number;
				existingJobData.JobDeliverySitePOCPhone2 = farEyeOrderDetails.deliver_to_contact_number2;
				existingJobData.JobDeliverySitePOCEmail = farEyeOrderDetails.deliver_to_email;
				existingJobData.JobDeliverySiteName = farEyeOrderDetails.deliver_to_name;
				existingJobData.JobDeliverySitePOC = farEyeOrderDetails.deliver_to_contact_name;
			}
		}

		private void UpdateShiptoDataByFarEyeModel(FarEyeOrderDetails farEyeOrderDetails, ref Entities.Job.Job existingJobData)
		{
			if(farEyeOrderDetails.type_of_order == "Reverse")
            {
				existingJobData.JobOriginCity = farEyeOrderDetails.origin_city;
				existingJobData.JobOriginCountry = farEyeOrderDetails.origin_country;
				existingJobData.JobOriginPostalCode = farEyeOrderDetails.origin_postal_code;
				existingJobData.JobOriginState = farEyeOrderDetails.origin_state_province;
				existingJobData.JobOriginStreetAddress = farEyeOrderDetails.origin_address_line1;
				existingJobData.JobOriginStreetAddress2 = farEyeOrderDetails.origin_address_line2;
				existingJobData.JobOriginStreetAddress3 = farEyeOrderDetails.origin_landmark;
				existingJobData.JobOriginSitePOCPhone = farEyeOrderDetails.origin_contact_number;
				existingJobData.JobOriginSitePOCPhone2 = farEyeOrderDetails.origin_contact_number2;
				existingJobData.JobOriginSitePOCEmail = farEyeOrderDetails.origin_email;
				existingJobData.JobOriginSiteName = farEyeOrderDetails.info.facility_code;
				existingJobData.JobOriginSitePOC = farEyeOrderDetails.origin_contact_name;
			}
		}

		private void UpdateShipFromDataByFarEyeModel(FarEyeOrderDetails farEyeOrderDetails, ref Entities.Job.Job existingJobData)
		{
			if(farEyeOrderDetails.type_of_order == "Reverse")
            {
				existingJobData.JobShipFromCity = farEyeOrderDetails.deliver_to_city;
				existingJobData.JobShipFromCountry = farEyeOrderDetails.deliver_to_country;
				existingJobData.JobShipFromPostalCode = farEyeOrderDetails.deliver_to_postal_code;
				existingJobData.JobShipFromState = farEyeOrderDetails.deliver_to_state_province;
				existingJobData.JobShipFromStreetAddress = farEyeOrderDetails.deliver_to_address_line1;
				existingJobData.JobShipFromStreetAddress2 = farEyeOrderDetails.deliver_to_address_line2;
				existingJobData.JobShipFromStreetAddress3 = farEyeOrderDetails.deliver_to_landmark;
				existingJobData.JobShipFromSitePOCPhone = farEyeOrderDetails.deliver_to_contact_number;
				existingJobData.JobShipFromSitePOCPhone2 = farEyeOrderDetails.deliver_to_contact_number2;
				existingJobData.JobShipFromSitePOCEmail = farEyeOrderDetails.deliver_to_email;
				existingJobData.JobShipFromSiteName = farEyeOrderDetails.deliver_to_name;
				existingJobData.JobShipFromSitePOC = farEyeOrderDetails.deliver_to_contact_name;
			}
			else
            {
				existingJobData.JobShipFromCity = farEyeOrderDetails.origin_city;
				existingJobData.JobShipFromCountry = farEyeOrderDetails.origin_country;
				existingJobData.JobShipFromPostalCode = farEyeOrderDetails.origin_postal_code;
				existingJobData.JobShipFromState = farEyeOrderDetails.origin_state_province;
				existingJobData.JobShipFromStreetAddress = farEyeOrderDetails.origin_address_line1;
				existingJobData.JobShipFromStreetAddress2 = farEyeOrderDetails.origin_address_line2;
				existingJobData.JobShipFromStreetAddress3 = farEyeOrderDetails.origin_landmark;
				existingJobData.JobShipFromSitePOCPhone = farEyeOrderDetails.origin_contact_number;
				existingJobData.JobShipFromSitePOCPhone2 = farEyeOrderDetails.origin_contact_number2;
				existingJobData.JobShipFromSitePOCEmail = farEyeOrderDetails.origin_email;
				existingJobData.JobShipFromSiteName = farEyeOrderDetails.origin_name;
				existingJobData.JobShipFromSitePOC = farEyeOrderDetails.origin_contact_name;
			}
		}
	}
}