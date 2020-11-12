#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.XCBL.HelperClasses;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.FarEye;
using M4PL.Entities.XCBL.FarEye.Order;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace M4PL.Business.XCBL
{
	public class FarEyeCommands : BaseCommands<FarEyeOrderDetails>, IFarEyeCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public FarEyeOrderDetails Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<FarEyeOrderDetails> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public FarEyeOrderDetails Patch(FarEyeOrderDetails entity)
		{
			throw new NotImplementedException();
		}

		public FarEyeOrderDetails Post(FarEyeOrderDetails entity)
		{
			throw new NotImplementedException();
		}

		public FarEyeOrderDetails Put(FarEyeOrderDetails entity)
		{
			throw new NotImplementedException();
		}

		public FarEyeOrderResponse OrderProcessingFromFarEye(FarEyeOrderDetails orderDetail)
		{
			ElectroluxOrderDetails electroluxOrderRequestModel = GetElectroluxOrderDetails(orderDetail);
			XCBLCommands xcBLCommands = new XCBLCommands();
			xcBLCommands.ActiveUser = this.ActiveUser;
			var orderResult = xcBLCommands.ProcessElectroluxOrderRequest(electroluxOrderRequestModel, true);

			FarEyeOrderResponse farEyeOrderResponse = new FarEyeOrderResponse();
			farEyeOrderResponse.status = (orderResult == null || (orderResult != null && orderResult.StatusCode == "Failure")) ? 500 : 200;
			farEyeOrderResponse.orderNumber = orderDetail.order_number;
			farEyeOrderResponse.trackingNumber = orderDetail.tracking_number;
			farEyeOrderResponse.timestamp = TimeUtility.UnixTimeNow();
			if (orderResult != null && orderResult.StatusCode == "Failure" && !string.IsNullOrEmpty(orderResult.Subject))
			{
				farEyeOrderResponse.errors = new List<string>();
				farEyeOrderResponse.errors.Add(orderResult.Subject);
			}

			return farEyeOrderResponse;
		}

		public OrderEventResponse UpdateOrderEvent(OrderEvent orderEvent)
		{
			if (orderEvent == null)
			{
				return new OrderEventResponse() { Status = (int)HttpStatusCode.ExpectationFailed, Timestamp = TimeUtility.UnixTimeNow(), Errors = new List<string>() { "OrderEvent Object can not be null." } };
			}
			else if (string.IsNullOrEmpty(orderEvent.OrderNumber))
			{
				return new OrderEventResponse() { Status = (int)HttpStatusCode.ExpectationFailed, Timestamp = TimeUtility.UnixTimeNow(), Errors = new List<string>() { "OrderNumber can not be null or empty." } };
			}

			var orderData = M4PL.DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderEvent.OrderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
			if (orderData != null && orderData.Id > 0)
			{
				DataAccess.Job.JobEDIXcblCommands.Post(ActiveUser, new JobEDIXcbl()
				{
					JobId = orderData.Id,
					EdtCode = "Order Tracking",
					EdtTypeId = M4PLBusinessConfiguration.XCBLEDTType.ToInt(),
					EdtData = JsonConvert.SerializeObject(orderEvent),
					TransactionDate = TimeUtility.GetPacificDateTime(),
					EdtTitle = "Order Tracking"
				});

				if (!string.IsNullOrEmpty(orderEvent.StatusCode))
				{
					bool isFarEyePushRequired = false;
					if (orderEvent.StatusCode.Equals("shipment_in_transit", StringComparison.OrdinalIgnoreCase))
					{
						M4PL.DataAccess.Job.JobCommands.CopyJobGatewayFromProgramForXcBLForElectrolux(ActiveUser, orderData.Id, (long)orderData.ProgramID, "In Transit", M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), out isFarEyePushRequired);

						if (isFarEyePushRequired)
						{
							FarEyeHelper.PushStatusUpdateToFarEye((long)orderData.Id, ActiveUser);
						}
					}
					else if (orderEvent.StatusCode.Equals("call_to_customer", StringComparison.OrdinalIgnoreCase))
					{
						var customerCallActionData = DataAccess.Job.JobGatewayCommands.GetGatewayWithParent(ActiveUser, 0, (long)orderData.Id, "Action", false, "Call Customer");
						if (customerCallActionData != null)
						{
							customerCallActionData.GatewayTypeId = 86;
							customerCallActionData.GwyGatewayCode = "Call Customer";
							customerCallActionData.GwyGatewayACD = DateTime.UtcNow.AddHours(customerCallActionData.DeliveryUTCValue);
							customerCallActionData.GwyGatewayTitle = "Call Customer";
							customerCallActionData.GwyTitle = "Call Customer";
							customerCallActionData.GwyCompleted = false;
							DataAccess.Job.JobGatewayCommands.PostWithSettings(ActiveUser, null, customerCallActionData, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), orderData.Id);
						}
					}
					else if (orderEvent.StatusCode.Equals("reschedule", StringComparison.OrdinalIgnoreCase))
					{
						var rescheduleActionData = DataAccess.Job.JobGatewayCommands.GetGatewayWithParent(ActiveUser, 0, (long)orderData.Id, "Action", false, "Reschedule-49");
						if (rescheduleActionData != null)
						{
							rescheduleActionData.GatewayTypeId = 86;
							rescheduleActionData.isScheduleReschedule = true;
							rescheduleActionData.GwyDDPNew = orderEvent?.Information?.RescheduleDate?.ToDateTime();
							rescheduleActionData.GwyGatewayCode = "Reschedule-49";
							rescheduleActionData.GwyGatewayACD = DateTime.UtcNow.AddHours(rescheduleActionData.DeliveryUTCValue);
							rescheduleActionData.GwyGatewayTitle = "Electrolux Request";
							rescheduleActionData.GwyTitle = "Electrolux Request";
							rescheduleActionData.GwyCompleted = true;
							var gatewayInsertResult = DataAccess.Job.JobGatewayCommands.PostWithSettings(ActiveUser, null, rescheduleActionData, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), orderData.Id);
							if (gatewayInsertResult != null && gatewayInsertResult.IsFarEyePushRequired)
							{
								FarEyeHelper.PushStatusUpdateToFarEye((long)orderData.Id, ActiveUser);
							}
						}
					}
				}

				return new OrderEventResponse() { Status = (int)HttpStatusCode.OK, Timestamp = TimeUtility.UnixTimeNow(), Errors = new List<string>() { string.Format("Order {0} is successfully updated.", orderData.JobCustomerSalesOrder) } };
			}
			else
			{
				return new OrderEventResponse() { Status = (int)HttpStatusCode.ExpectationFailed, Timestamp = TimeUtility.UnixTimeNow(), Errors = new List<string>() { "OrderNumber is not present in the Meridian system." } };
			}
		}

		public FarEyeOrderCancelResponse CancelOrder(FarEyeOrderCancelRequest farEyeOrderCancelRequest)
		{
			DateTime processingStartDateTime = DateTime.Now;
			FarEyeOrderCancelResponse response = new FarEyeOrderCancelResponse();
			if (farEyeOrderCancelRequest.tracking_number == null || (farEyeOrderCancelRequest.tracking_number != null && farEyeOrderCancelRequest.tracking_number.Count == 0))
			{
				response.errors = new List<string>();
				response.errors.Add("There is no Tracking number present.");
				response.status = 400;
				response.reference_id = farEyeOrderCancelRequest.reference_id;
				response.order_number = farEyeOrderCancelRequest.order_number;
				response.timestamp = TimeUtility.UnixTimeNow();
				response.execution_time = (DateTime.Now - processingStartDateTime).TotalMilliseconds.ToInt();
			}
			else
			{
				Job.JobCommands jobCommands = new Job.JobCommands();
				jobCommands.ActiveUser = this.ActiveUser;
				response.items_track_details = new List<ItemsTrackDetail>();
				foreach (var trackingNumber in farEyeOrderCancelRequest.tracking_number)
				{
					var statusModel = jobCommands.CancelJobByOrderNumber(trackingNumber, farEyeOrderCancelRequest.carrier_code, farEyeOrderCancelRequest.reason);
					response.items_track_details.Add(new ItemsTrackDetail() { status = statusModel.Status, message = statusModel.AdditionalDetail, tracking_number = trackingNumber });
				}

				response.status = response.items_track_details.Where(x => x.status.Equals("Failure", StringComparison.OrdinalIgnoreCase)).Any() ? 400 : 200;
				response.reference_id = farEyeOrderCancelRequest.reference_id;
				response.order_number = farEyeOrderCancelRequest.order_number;
				response.timestamp = TimeUtility.UnixTimeNow();
				response.execution_time = (DateTime.Now - processingStartDateTime).TotalMilliseconds.ToInt();
			}

			return response;
		}

		public FarEyeDeliveryStatus GetOrderStatus(string orderNumber, DeliveryUpdate deliveryUpdate = null, ActiveUser activeUser = null)
		{
			activeUser = activeUser == null ? ActiveUser : activeUser;
			orderNumber = !string.IsNullOrEmpty(orderNumber) ? orderNumber :
				deliveryUpdate == null ? string.Empty
				: deliveryUpdate.OrderNumber;
			FarEyeDeliveryStatus farEyeDeliveryStatusResponse = null;
			var jobDetail = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(activeUser, orderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
			if (jobDetail != null)
			{
				deliveryUpdate = deliveryUpdate == null ? DataAccess.XCBL.XCBLCommands.GetDeliveryUpdateModel(jobDetail.Id, activeUser) : deliveryUpdate;
				if (deliveryUpdate != null)
				{
					farEyeDeliveryStatusResponse = new FarEyeDeliveryStatus();
					farEyeDeliveryStatusResponse.order_number = jobDetail.JobServiceMode;
					farEyeDeliveryStatusResponse.type = "DeliveryNumber";
					farEyeDeliveryStatusResponse.value = orderNumber;
					farEyeDeliveryStatusResponse.carrier_code = "Meridian";
					farEyeDeliveryStatusResponse.carrier_status = deliveryUpdate.InstallStatus;
					farEyeDeliveryStatusResponse.carrier_status_code = deliveryUpdate.InstallStatus;
					farEyeDeliveryStatusResponse.carrier_status_description = deliveryUpdate.InstallStatus;
					farEyeDeliveryStatusResponse.carrier_sub_status = deliveryUpdate.InstallStatus;
					farEyeDeliveryStatusResponse.carrier_sub_status_description = deliveryUpdate.InstallStatus;
					farEyeDeliveryStatusResponse.status_received_at = deliveryUpdate.InstallStatusTS;
					farEyeDeliveryStatusResponse.location_code = jobDetail.JobOriginSiteName;
					farEyeDeliveryStatusResponse.destination_location = jobDetail.JobDeliverySiteName;
					farEyeDeliveryStatusResponse.latitude = jobDetail.JobLatitude.ToInt();
					farEyeDeliveryStatusResponse.longitude = jobDetail.JobLongitude.ToInt();
					farEyeDeliveryStatusResponse.extra_info = new DeliveryExtraInfo()
					{
						comments = deliveryUpdate.AdditionalComments,
						epod = JsonConvert.SerializeObject(deliveryUpdate.POD),
						promised_delivery_date = jobDetail.JobOriginDateTimeBaseline.HasValue ? jobDetail.JobOriginDateTimeBaseline.ToString() : string.Empty,
						expected_delivery_date = jobDetail.JobOriginDateTimePlanned.HasValue ? jobDetail.JobOriginDateTimePlanned.ToString() : string.Empty
					};

					farEyeDeliveryStatusResponse.info = new DeliveryInfo();
					farEyeDeliveryStatusResponse.info.reschedule_reason = deliveryUpdate.RescheduleReason;
					farEyeDeliveryStatusResponse.info.reschedule_date = deliveryUpdate.RescheduledInstallDate;
					if (deliveryUpdate.OrderLineDetail != null && deliveryUpdate.OrderLineDetail.OrderLine != null && deliveryUpdate.OrderLineDetail.OrderLine.Count > 0)
					{
						farEyeDeliveryStatusResponse.info.LineItems = new List<DeliveryLineItem>();
						deliveryUpdate.OrderLineDetail.OrderLine.ForEach(
							x => farEyeDeliveryStatusResponse.info.LineItems.Add(new DeliveryLineItem()
							{
								item_number = x.LineNumber,
								comments = x.ItemInstallComments,
								exception_code = x.Exceptions?.ExceptionInfo?.ExceptionCode,
								exception_detail = x.Exceptions?.ExceptionInfo?.ExceptionDetail,
								item_install_status = x.ItemInstallStatus,
								material_id = x.ItemNumber
							}));
					}

					if (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.RescheduledInstallDate))
					{
						farEyeDeliveryStatusResponse.carrier_status = "Reschedule";
						farEyeDeliveryStatusResponse.carrier_status_code = "Reschedule";
						farEyeDeliveryStatusResponse.carrier_status_description = "Reschedule";
						farEyeDeliveryStatusResponse.carrier_sub_status = "Reschedule";
						farEyeDeliveryStatusResponse.carrier_sub_status_description = "Reschedule";
						farEyeDeliveryStatusResponse.status_received_at = deliveryUpdate.RescheduledInstallDate;
					}

					if (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.CancelDate) && !string.IsNullOrEmpty(deliveryUpdate.InstallStatus) && !deliveryUpdate.InstallStatus.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
					{
						farEyeDeliveryStatusResponse.carrier_status = "Canceled";
						farEyeDeliveryStatusResponse.carrier_status_code = "Canceled";
						farEyeDeliveryStatusResponse.carrier_status_description = "Canceled";
						farEyeDeliveryStatusResponse.carrier_sub_status = "Canceled";
						farEyeDeliveryStatusResponse.carrier_sub_status_description = "Canceled";
						farEyeDeliveryStatusResponse.status_received_at = deliveryUpdate.CancelDate;
					}
				}
			}

			return farEyeDeliveryStatusResponse;
		}

		private ElectroluxOrderDetails GetElectroluxOrderDetails(FarEyeOrderDetails orderDetail)
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
				,Action = orderDetail.type_of_action.Equals("Create", StringComparison.OrdinalIgnoreCase) ? "Add" : orderDetail.type_of_action
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
				,ASNdata = new ASNdata() { BolNumber = orderDetail?.info?.bill_of_lading, VehicleId = orderDetail?.info?.transport_id, Shipdate = orderDetail?.info?.good_issue_date }
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
				,
				ShipTo = new ShipTo()
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
				,
				DeliverTo = new DeliverTo()
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

			electroluxOrderDetail.Header.Message = new Message() { Subject = orderDetail.type_of_service.Equals("DeliveryNumber", StringComparison.OrdinalIgnoreCase) ? "ASN" : orderDetail.type_of_service };

			return electroluxOrderDetail;
		}
	}
}