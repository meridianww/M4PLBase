#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.FarEyeOrderMapping
{
	public class FarEyeModelToxCBLModel
	{
		public ElectroluxOrderDetails GetElectroluxOrderDetails(Entities.XCBL.FarEye.Order.FarEyeOrderDetails orderDetail)
		{
			ElectroluxOrderDetails electroluxOrderDetail = new ElectroluxOrderDetails();

			electroluxOrderDetail.Header = new Header();
			electroluxOrderDetail.Body = new Body();
			electroluxOrderDetail.Body.Order = new Order();
			electroluxOrderDetail.Body.Order.OrderDescriptionList = new OrderDescriptionList();
			electroluxOrderDetail.Body.Order.OrderLineDetailList = new OrderLineDetailList() { OrderLineDetail = new List<OrderLineDetail>() };
			orderDetail.item_list.ForEach(x => electroluxOrderDetail.Body.Order.OrderLineDetailList.OrderLineDetail.Add(new OrderLineDetail()
			{
				LineNumber = x.item_reference_number,
				ItemID = x.item_code,
				ItemDescription = x.item_material_descritpion,
				ShipQuantity = x.item_quantity,
				Weight = x.item_weight.ToDecimal(),
				WeightUnitOfMeasure = x.item_weight_uom,
				Volume = x.item_volumn,
				VolumeUnitOfMeasure = x.item_volumn_uom,
				SecondaryLocation = x.secondary_location,
				MaterialType = x.item_material_type,
				ShipUnitOfMeasure = x.item_uom,
				CustomerStockNumber = x.customer_stock_number,
				StatusCode = x.item_status,
				//EDILINEID = string.Empty,
				MaterialTypeDescription = x.item_material_descritpion,
				LineNumberReference = x.item_number_of_reference_item,
				SerialNumber = x.item_serial_number,
				LineDescriptionDetails = new LineDescriptionDetails() { LineDescription = new LineDescription() }
			}));

			electroluxOrderDetail.Body.Order.OrderHeader = new OrderHeader()
			{
				 SenderID = orderDetail.reference_id
               // ,RecieverID = string.Empty
                ,OriginalOrderNumber = orderDetail.order_number
                ,OrderNumber = orderDetail.tracking_number
                ,Action = orderDetail.type_of_action
               // ,ReleaseNum = string.Empty
                ,OrderType = orderDetail.type_of_order
				,OrderDate = orderDetail?.info?.install_date
                ,CustomerPO = orderDetail?.info?.customer_po
				//,PurchaseOrderType
                ,CosigneePO = orderDetail?.info?.consignee_po
				,DeliveryDate = orderDetail?.info?.outbound_delivery_date
                //,DeliveryTime = string.Empty
                ,RMAIndicator = orderDetail?.info?.rma_indicator
                ,DepartmentNumber = orderDetail?.info?.department_number
                ,FreightCarrierCode = orderDetail?.info?.freight_carrier_code
                ,HotOrder = orderDetail?.info?.hot_order
                ,ASNdata = null
                ,ShipFrom = new ShipFrom()
				{
					LocationID = orderDetail.origin_code
				   ,LocationName = orderDetail.origin_name
				   ,ContactFirstName = orderDetail.origin_contact_name
				   ,ContactLastName = string.Empty
				   ,ContactEmailID = orderDetail.origin_email
				   ,AddressLine1 = orderDetail.origin_address_line1
				   ,AddressLine2 = orderDetail.origin_address_line2
				   ,AddressLine3 = orderDetail.origin_landmark
				   ,City = orderDetail.origin_city
				   ,State = orderDetail.origin_state_province
				   ,ZipCode = orderDetail.origin_postal_code
				   ,Country = orderDetail.origin_country
				   ,ContactNumber = orderDetail.origin_contact_number
				}
                ,ShipTo = new ShipTo()
				{
					LocationID = orderDetail.destination_code
				   ,LocationName = orderDetail.destination_name
				   ,ContactFirstName = orderDetail.destination_contact_name
				   ,ContactLastName = string.Empty
				   ,ContactEmailID = orderDetail.destination_email
				   ,AddressLine1 = orderDetail.destination_address_line1
				   ,AddressLine2 = orderDetail.destination_address_line2
				   ,AddressLine3 = orderDetail.destination_landmark
				   ,City = orderDetail.destination_city
				   ,State = orderDetail.destination_state_province
				   ,ZipCode = orderDetail.destination_postal_code
				   ,Country = orderDetail.destination_country
				   ,ContactNumber = orderDetail.destination_contact_number
				   ,LotID = orderDetail.destination_lot_id
				}
                ,DeliverTo = new DeliverTo()
				{
					LocationID = orderDetail.deliver_to_code
                   ,LocationName = orderDetail.deliver_to_name
				   ,ContactFirstName = orderDetail.deliver_to_contact_name
				   ,ContactLastName = string.Empty
                   ,ContactEmailID = orderDetail.deliver_to_email
				   ,AddressLine1 = orderDetail.deliver_to_address_line1
				   ,AddressLine2 = orderDetail.deliver_to_address_line2
				   ,AddressLine3 = orderDetail.deliver_to_landmark
				   ,City = orderDetail.deliver_to_city
				   ,State = orderDetail.deliver_to_state_province
				   ,ZipCode = orderDetail.deliver_to_postal_code
				   ,Country = orderDetail.deliver_to_country
				   ,ContactNumber = orderDetail.deliver_to_contact_number
				   ,LotID = orderDetail.deliver_lot_id
				}
			};

			electroluxOrderDetail.Header.Message = new Message() { Subject = orderDetail.type_of_service };

			return electroluxOrderDetail;
		}
	}
}
