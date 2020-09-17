#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.XCBL.ElectroluxOrderMapping;
using M4PL.Business.XCBL.HelperClasses;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using _adminCommand = M4PL.DataAccess.Administration.SystemReferenceCommands;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using _jobEDIxCBLCommand = M4PL.DataAccess.Job.JobEDIXcblCommands;

namespace M4PL.Business.XCBL
{
	public class XCBLCommands : BaseCommands<XCBLToM4PLRequest>, IXCBLCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		#region Public Methods

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public XCBLToM4PLRequest Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<XCBLToM4PLRequest> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public XCBLToM4PLRequest Patch(XCBLToM4PLRequest entity)
		{
			throw new NotImplementedException();
		}

		public XCBLToM4PLRequest Post(XCBLToM4PLRequest entity)
		{
			throw new NotImplementedException();
		}

		public long PostXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequest)
		{
			XCBLSummaryHeaderModel request = GetSummaryHeaderModel(xCBLToM4PLRequest);
			return _commands.InsertxCBLDetailsInDB(request);
		}

		public OrderResponse ProcessElectroluxOrderRequest(ElectroluxOrderDetails electroluxOrderDetails)
		{
			Entities.Job.Job processingJobDetail = null;
			Entities.Job.Job jobDetails = null;
			OrderResponse response = null;
			Task[] tasks = new Task[2];
			JobCargoMapper cargoMapper = new JobCargoMapper();
			OrderHeader orderHeader = electroluxOrderDetails?.Body?.Order?.OrderHeader;
			string locationCode = !string.IsNullOrEmpty(orderHeader?.ShipTo.LocationName) && orderHeader?.ShipTo.LocationName.Length >= 4 ? orderHeader.ShipTo.LocationName.Substring(orderHeader.ShipTo.LocationName.Length - 4) : null;
			string message = electroluxOrderDetails?.Header?.Message?.Subject;
			response = ValidateElectroluxOrderRequest(response, orderHeader, message);
			if (response != null) { return response; }
			List<SystemReference> systemOptionList = _adminCommand.GetSystemRefrenceList();
			int serviceId = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			Entities.Job.Job existingJobDataInDB = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderHeader?.OrderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());

			// Populate the data in xCBL tables
			tasks[0] = Task.Factory.StartNew(() =>
			{
				XCBLSummaryHeaderModel request = GetSummaryHeaderModel(electroluxOrderDetails);
				if (request != null)
				{
					_commands.InsertxCBLDetailsInDB(request);
				}
			});
			// Creation of a Job
			tasks[1] = Task.Factory.StartNew(() =>
			{
				if (!string.IsNullOrEmpty(message) && string.Equals(message, ElectroluxMessage.Order.ToString(), StringComparison.OrdinalIgnoreCase))
				{
					if (!string.IsNullOrEmpty(orderHeader?.Action))
					{
						if (existingJobDataInDB?.Id > 0 && string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							response = new OrderResponse()
							{
								ClientMessageID = string.Empty,
								SenderMessageID = orderHeader?.OrderNumber,
								StatusCode = "Failure",
								Subject = "There is already a Order present in the Meridian system with the same Order Number."
							};
						}
						else if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderCreation(electroluxOrderDetails, systemOptionList) : jobDetails;
							processingJobDetail = jobDetails != null ? _jobCommands.Post(ActiveUser, jobDetails, false, true) : jobDetails;
							if (processingJobDetail?.Id > 0)
							{
								InsertxCBLDetailsInTable(processingJobDetail.Id, electroluxOrderDetails);
								List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapper(electroluxOrderDetails?.Body?.Order?.OrderLineDetailList?.OrderLineDetail, processingJobDetail.Id, systemOptionList);
								if (jobCargos != null && jobCargos.Count > 0)
								{
									_jobCommands.InsertJobCargoData(jobCargos, ActiveUser);
								}

								if (processingJobDetail.ProgramID.HasValue)
								{
									_jobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
								}
							}
							else
							{
								response = new OrderResponse()
								{
									ClientMessageID = string.Empty,
									SenderMessageID = orderHeader?.OrderNumber,
									StatusCode = "Failure",
									Subject = "Request has been recieved and logged, there is some issue while creating order in the system, please try again."
								};
							}
						}
						else if (string.Equals(orderHeader.Action, ElectroluxAction.Delete.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							if (existingJobDataInDB?.Id > 0 && !string.Equals(existingJobDataInDB.JobGatewayStatus, "Canceled", StringComparison.OrdinalIgnoreCase))
							{
								processingJobDetail = existingJobDataInDB;
								InsertxCBLDetailsInTable(existingJobDataInDB.Id, electroluxOrderDetails);
								ProcessElectroluxOrderCancellationRequest(existingJobDataInDB);
							}
							if (existingJobDataInDB?.Id > 0 && string.Equals(existingJobDataInDB.JobGatewayStatus, "Canceled", StringComparison.OrdinalIgnoreCase))
							{
								response = new OrderResponse()
								{
									ClientMessageID = string.Empty,
									SenderMessageID = orderHeader?.OrderNumber,
									StatusCode = "Failure",
									Subject = "Delete action can not be proceed for the order as requested order is already canceled in the meridian system, please try again."
								};
							}
							else if (existingJobDataInDB?.Id <= 0)
							{
								response = new OrderResponse()
								{
									ClientMessageID = string.Empty,
									SenderMessageID = orderHeader?.OrderNumber,
									StatusCode = "Failure",
									Subject = "Delete action can not be proceed for the order as requested order is not present in the meridian system, please try again."
								};
							}
						}
					}
				}
				else if (!string.IsNullOrEmpty(message) && string.Equals(message, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase))
				{
					if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
					{
						jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderUpdation(electroluxOrderDetails, systemOptionList, existingJobDataInDB) : jobDetails;
						bool isJobCancelled = jobDetails?.Id > 0 ? _jobCommands.IsJobCancelled(jobDetails.Id) : true;
						if (jobDetails?.Id <= 0)
						{
							response = new OrderResponse()
							{
								ClientMessageID = string.Empty,
								SenderMessageID = orderHeader?.OrderNumber,
								StatusCode = "Failure",
								Subject = "Can not proceed the ASN request to the system as requesed order is not present in the meridian system, please try again."
							};
						}
						else if (jobDetails?.Id > 0 && !isJobCancelled)
						{
							jobDetails.JobIsDirtyDestination = true;
							jobDetails.JobIsDirtyContact = true;
							processingJobDetail = jobDetails != null ? _jobCommands.Put(ActiveUser, jobDetails, isLatLongUpdatedFromXCBL: false, isRelatedAttributeUpdate: false, isServiceCall: true) : jobDetails;
							if (processingJobDetail?.Id > 0)
							{
								InsertxCBLDetailsInTable(processingJobDetail.Id, electroluxOrderDetails);
								bool isFarEyePushRequired = false;
								_jobCommands.CopyJobGatewayFromProgramForXcBLForElectrolux(ActiveUser, processingJobDetail.Id, (long)processingJobDetail.ProgramID, "In Transit", M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), out isFarEyePushRequired);
								List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapper(electroluxOrderDetails?.Body?.Order?.OrderLineDetailList?.OrderLineDetail, processingJobDetail.Id, systemOptionList);
								if (jobCargos != null && jobCargos.Count > 0)
								{
									_jobCommands.InsertJobCargoData(jobCargos, ActiveUser);
								}

								if (processingJobDetail.ProgramID.HasValue)
								{
									_jobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
								}

								if (isFarEyePushRequired)
								{
									FarEyeHelper.PushStatusUpdateToFarEye((long)processingJobDetail.Id, ActiveUser);
								}
							}
						}
						else if (jobDetails?.Id > 0 && isJobCancelled)
						{
							response = new OrderResponse()
							{
								ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
								SenderMessageID = orderHeader?.OrderNumber,
								StatusCode = "Failure",
								Subject = "Can not proceed the ASN request to the system as requesed order is already canceled in the meridian system, please try again."
							};
						}
					}
					else
					{
						response = new OrderResponse()
						{
							ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
							SenderMessageID = orderHeader?.OrderNumber,
							StatusCode = "Failure",
							Subject = "Please correct the action type for the request as only action Add is allowed to pass with ASN, please try again."
						};
					}
				}
			});

			Task.WaitAll(tasks);

			response = response != null ? response : new OrderResponse()
			{
				ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
				SenderMessageID = orderHeader?.OrderNumber,
				StatusCode = "Success",
				Subject = message
			};

			return response;
		}

		public XCBLToM4PLRequest Put(XCBLToM4PLRequest entity)
		{
			throw new NotImplementedException();
		}

		public DeliveryUpdateResponse ProcessElectroluxOrderDeliveryUpdate(DeliveryUpdate deliveryUpdate, long jobId)
		{
			return ElectroluxHelper.SendDeliveryUpdateRequestToElectrolux(ActiveUser, deliveryUpdate, jobId);
		}

		public List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData()
		{
			return _commands.GetDeliveryUpdateProcessingData();
		}

		public DeliveryUpdate GetDeliveryUpdateModel(long jobId)
		{
			var deliveryUpdateModel = _commands.GetDeliveryUpdateModel(jobId, ActiveUser);
			return ElectroluxHelper.GetDeliveryUpdateModel(deliveryUpdateModel, ActiveUser);
		}

		public bool UpdateDeliveryUpdateProcessingLog(DeliveryUpdateProcessingData deliveryUpdateProcessingData)
		{
			return _commands.UpdateDeliveryUpdateProcessingLog(deliveryUpdateProcessingData);
		}

		#endregion Public Methods

		#region Private Methods

		private void ProcessElectroluxOrderCancellationRequest(Entities.Job.Job job)
		{
			_jobCommands.CancelJobByCustomerSalesOrderNumber(ActiveUser, job, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), string.Empty, string.Empty);
		}

		private Entities.Job.Job GetJobModelForElectroluxOrderCreation(ElectroluxOrderDetails electroluxOrderDetails, List<SystemReference> systemOptionList)
		{
			Entities.Job.Job jobCreationData = null;
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
			var orderLineDetailList = electroluxOrderDetails.Body?.Order?.OrderLineDetailList;
			long programId = M4PLBusinessConfiguration.ElectroluxProgramId.ToLong();
			basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref jobCreationData, programId, orderLineDetailList, false, systemOptionList);
			addressMapper.ToJobAddressModel(orderDetails, ref jobCreationData);

			return jobCreationData;
		}

		private Entities.Job.Job GetJobModelForElectroluxOrderUpdation(ElectroluxOrderDetails electroluxOrderDetails, List<SystemReference> systemOptionList, Entities.Job.Job existingJobData)
		{
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			JobASNDataMapper jobASNDataMapper = new JobASNDataMapper();
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
			var orderLineDetailList = electroluxOrderDetails.Body?.Order?.OrderLineDetailList;
			if (orderDetails != null)
			{
				if (existingJobData == null || existingJobData.ProgramID == null) { return existingJobData; }
				basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref existingJobData, (long)existingJobData.ProgramID, orderLineDetailList, true, systemOptionList);
				addressMapper.ToJobAddressModel(orderDetails, ref existingJobData);
				jobASNDataMapper.ToJobASNModel(orderDetails, ref existingJobData);
			}

			return existingJobData;
		}

		private XCBLSummaryHeaderModel GetSummaryHeaderModel(XCBLToM4PLRequest xCBLToM4PLRequest)
		{
			dynamic request = null;
			XCBLSummaryHeaderModel summaryHeader = new XCBLSummaryHeaderModel();
			ActiveUser activeUser = ActiveUser;
			List<Task> tasks = new List<Task>();
			if (xCBLToM4PLRequest.EntityId == (int)XCBLRequestType.ShippingSchedule)
			{
				List<long> copiedGatewayIds = null;
				var xcBLToM4PLShippingScheduleRequest = Newtonsoft.Json.JsonConvert.DeserializeObject<XCBLToM4PLShippingScheduleRequest>(xCBLToM4PLRequest.Request.ToString());
				if (xcBLToM4PLShippingScheduleRequest != null)
				{
					var existingJobData = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, xcBLToM4PLShippingScheduleRequest.OrderNumber, M4PLBusinessConfiguration.AWCCustomerId.ToLong());
					if (existingJobData != null && existingJobData.Id > 0)
					{
						tasks.Add(Task.Factory.StartNew(() =>
						{
							try
							{
								copiedGatewayIds = ProcessShippingScheduleRequestForAWC(existingJobData, xcBLToM4PLShippingScheduleRequest, activeUser);
							}
							catch (Exception exp)
							{
								DataAccess.Logger.ErrorLogger.Log(exp, "Error occured while processing the shipping request.", "Shipping Schedule Processing", Utilities.Logger.LogType.Error);
							}
						}));

						tasks.Add(Task.Factory.StartNew(() =>
						{
							try
							{
								InsertxCBLDetailsInTableForAWC(existingJobData.Id, xCBLToM4PLRequest, "Shipping Schedule");
							}
							catch (Exception exp)
							{
								DataAccess.Logger.ErrorLogger.Log(exp, "Error occured while inserting data in edi xcbl table for shipping schedule.", "Shipping Schedule Processing", Utilities.Logger.LogType.Error);
							}
						}));
					}

					tasks.Add(Task.Factory.StartNew(() =>
					{
						try
						{
							summaryHeader.SummaryHeader = new SummaryHeader()
							{
								CustomerReferenceNo = xcBLToM4PLShippingScheduleRequest != null ? xcBLToM4PLShippingScheduleRequest.OrderNumber : string.Empty,
								ProcessingDate = xcBLToM4PLShippingScheduleRequest.ScheduleIssuedDate,
								SetPurpose = xcBLToM4PLShippingScheduleRequest.PurposeCoded,
								SpecialNotes = xcBLToM4PLShippingScheduleRequest.ShippingInstruction,
								Latitude = xcBLToM4PLShippingScheduleRequest.Latitude,
								Longitude = xcBLToM4PLShippingScheduleRequest.Longitude,
								LocationId = xcBLToM4PLShippingScheduleRequest.LocationID,
								OrderType = xcBLToM4PLShippingScheduleRequest.OrderType,
								ScheduledDeliveryDate = xcBLToM4PLShippingScheduleRequest.EstimatedArrivalDate
							};
							summaryHeader.Address = new List<Address>()
				{
					new Address()
					{
						AddressTypeId = Convert.ToByte(xCBLAddressType.ShipTo),
						Address1 = xcBLToM4PLShippingScheduleRequest.Street,
						Address2 = xcBLToM4PLShippingScheduleRequest.Streetsupplement1,
						City = xcBLToM4PLShippingScheduleRequest.City,
						CountryCode = GetCountryCodeAndStateCode(xcBLToM4PLShippingScheduleRequest.RegionCoded,  true),
						State = GetCountryCodeAndStateCode(xcBLToM4PLShippingScheduleRequest.RegionCoded,  false),
						Name = xcBLToM4PLShippingScheduleRequest.Name1,
						PostalCode = xcBLToM4PLShippingScheduleRequest.PostalCode
					}
				};

							summaryHeader.CustomAttribute = new CustomAttribute()
							{
							};

							summaryHeader.UserDefinedField = new UserDefinedField()
							{
								UDF01 = xcBLToM4PLShippingScheduleRequest.Other_FirstStop,
								UDF02 = xcBLToM4PLShippingScheduleRequest.Other_Before7,
								UDF03 = xcBLToM4PLShippingScheduleRequest.Other_Before9,
								UDF04 = xcBLToM4PLShippingScheduleRequest.Other_Before12,
								UDF05 = xcBLToM4PLShippingScheduleRequest.Other_SameDay,
								UDF06 = xcBLToM4PLShippingScheduleRequest.Other_OwnerOccupied,
							};

							summaryHeader.LineDetail = new List<LineDetail>()
							{
							};
						}
						catch (Exception exp)
						{
							DataAccess.Logger.ErrorLogger.Log(exp, "Error occured while inserting data in edi tables table for shipping schedule.", "Shipping Schedule Processing", Utilities.Logger.LogType.Error);
						}
					}));

					if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
					if (copiedGatewayIds != null && copiedGatewayIds.Count > 0)
					{
						List<CopiedGateway> gatewayIds = new List<CopiedGateway>();
						copiedGatewayIds.ForEach(d =>
						{
							gatewayIds.Add(new CopiedGateway() { Id = d });
						});
						summaryHeader.CopiedGatewayIds = gatewayIds;
					}
				}
			}
			else
			{
				request = xCBLToM4PLRequest.Request;
				summaryHeader.SummaryHeader = new SummaryHeader()
				{
					BOLNo = request.Other_BOL_RefNum,
					SetPurpose = request.TransitDirectionCoded,
					CustomerReferenceNo = request.Other_NewOrderNumber_RefNum,
					LocationId = request.Other_Domicile_RefNum,
					// ShipDescription = request.ReqNumber,
					PurchaseOrderNo = request.Other_OriginalOrder_RefNum,
					ShipDate = request.RequestedShipByDate.ToDate(),
					Latitude = request.EndTransportLocation_Latitude,
					Longitude = request.EndTransportLocation_Longitude,
					ManifestNo = request.Other_Manifest_RefNum,
					SpecialNotes = request.ShippingInstructions,
					OrderedDate = request.Other_WorkOrder_RefDate.ToDate(),
					ProcessingDate = request.RequisitionIssueDate.ToDate()
				};

				summaryHeader.Address = new List<Address>()
				{
					new Address()
					{
						AddressTypeId = (int)xCBLAddressType.Consignee,
						Name = request.ShipToParty_Name1,
						Address1 = request.ShipToParty_Street,
						Address2 = request.ShipToParty_StreetSupplement1,
						City = request.ShipToParty_City,
						CountryCode = GetCountryCodeAndStateCode(request.ShipToParty_RegionCoded,true),
						State = GetCountryCodeAndStateCode(request.ShipToParty_RegionCoded,false),
						PostalCode = request.ShipToParty_PostalCode
					},
					 new Address()
					{
						AddressTypeId = (int)xCBLAddressType.ShipFrom,
						Name = request.ShipFromParty_Name1,
						Address1 = request.ShipFromParty_Street,
						Address2 = request.ShipFromParty_StreetSupplement1,
						City = request.ShipFromParty_City,
						CountryCode = GetCountryCodeAndStateCode(request.ShipFromParty_RegionCoded,true),
						State = GetCountryCodeAndStateCode(request.ShipFromParty_RegionCoded,false),
						PostalCode = request.ShipFromParty_PostalCode
					},
				};
				summaryHeader.CustomAttribute = new CustomAttribute();
				summaryHeader.LineDetail = new List<LineDetail>()
				{
				};

				summaryHeader.UserDefinedField = new UserDefinedField()
				{
					UDF01 = request.Other_WorkOrder_RefNum,
					UDF02 = request.Other_Cabinets_RefNum,
					UDF03 = request.Other_Parts_RefNum,
					UDF04 = request.StartTransportLocation_Latitude,
					UDF05 = request.StartTransportLocation_Longitude
				};
			}

			return summaryHeader;
		}

		private string GetCountryCodeAndStateCode(string regionCode, bool isCountry)
		{
			if (string.IsNullOrEmpty(regionCode))
				return string.Empty;
			else
			{
				if (isCountry)
				{
					switch (regionCode.Substring(0, 2))
					{
						case "US":
							return "USA";

						case "MX":
							return "MEX";

						case "CA":
							return "CAN";

						default:
							return "USA";
					}
				}
				else
					return regionCode.Substring(2, 2);
			}
		}

		private XCBLSummaryHeaderModel GetSummaryHeaderModel(ElectroluxOrderDetails electroluxOrderDetails)
		{
			XCBLSummaryHeaderModel summaryHeader = new XCBLSummaryHeaderModel();
			string message = electroluxOrderDetails?.Header?.Message.Subject;
			var orderHeader = electroluxOrderDetails?.Body?.Order.OrderHeader;
			var orderLineDetailList = electroluxOrderDetails?.Body?.Order.OrderLineDetailList;
			if (orderHeader != null)
			{
				string deliveryTime = orderHeader != null ? orderHeader.DeliveryTime : string.Empty;
				deliveryTime = (string.IsNullOrEmpty(deliveryTime) && deliveryTime.Length >= 6) ?
								   deliveryTime.Substring(0, 2) + ":" + deliveryTime.Substring(2, 2) + ":" +
								   deliveryTime.Substring(4, 2) : "";
				summaryHeader.SummaryHeader = new SummaryHeader()
				{
					OrderType = message,
					PurchaseOrderNo = orderHeader.CustomerPO,
					Action = orderHeader.Action,
					ScheduledDeliveryDate = !string.IsNullOrEmpty(orderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? string.Format("{0} {1}", orderHeader.DeliveryDate, deliveryTime).ToDate()
					: !string.IsNullOrEmpty(orderHeader.DeliveryDate) && string.IsNullOrEmpty(orderHeader.DeliveryTime)
					? orderHeader.DeliveryDate.ToDate() : null,
					OrderedDate = !string.IsNullOrEmpty(orderHeader.OrderDate) ? orderHeader.OrderDate.ToDate() : null,
					CustomerReferenceNo = orderHeader.OrderNumber,
					SetPurpose = orderHeader?.OrderType,
					TradingPartner = orderHeader?.SenderID,
					LocationId = orderHeader?.ShipFrom?.LocationID,
					LocationNumber = orderHeader.ShipTo?.LocationName,
					TrailerNumber = orderHeader?.ASNdata?.VehicleId,
					BOLNo = orderHeader?.ASNdata?.BolNumber,
					ShipDate = !string.IsNullOrEmpty(orderHeader?.ASNdata?.Shipdate) && orderHeader?.ASNdata?.Shipdate.Length >= 8 ?
						string.Format(format: "{0}-{1}-{2}", arg0: orderHeader?.ASNdata?.Shipdate.Substring(0, 4), arg1: orderHeader?.ASNdata.Shipdate?.Substring(4, 2), arg2: orderHeader?.ASNdata?.Shipdate.Substring(6, 2)).ToDate()
						: null
				};

				summaryHeader.Address = new List<Address>();

				if (orderHeader.ShipFrom != null)
				{
					summaryHeader.Address.Add(new Address()
					{
						AddressTypeId = (int)xCBLAddressType.ShipFrom,
						Name = "ShipFrom",
						Address1 = orderHeader.ShipFrom.AddressLine1,
						Address2 = orderHeader.ShipFrom.AddressLine2,
						StreetAddress3 = orderHeader.ShipFrom.AddressLine3,
						City = orderHeader.ShipFrom.City,
						State = orderHeader.ShipFrom.State,
						PostalCode = orderHeader.ShipFrom.ZipCode,
						CountryCode = orderHeader.ShipFrom.Country,
						ContactName = string.IsNullOrEmpty(orderHeader.ShipFrom.ContactLastName)
						? orderHeader.ShipFrom.ContactFirstName
						: string.Format("{0} {1}", orderHeader.ShipFrom.ContactFirstName, orderHeader.ShipFrom.ContactLastName),
						ContactNumber = orderHeader.ShipFrom.ContactNumber,
						ContactEmail = orderHeader.ShipFrom.ContactEmailID,
						LocationID = orderHeader.ShipFrom.LocationID,
						LocationName = orderHeader.ShipFrom.LocationName,
					});
				}

				if (orderHeader.ShipTo != null)
				{
					summaryHeader.Address.Add(new Address()
					{
						AddressTypeId = (int)xCBLAddressType.ShipTo,
						Name = "ShipTo",
						Address1 = orderHeader.ShipTo.AddressLine1,
						Address2 = orderHeader.ShipTo.AddressLine2,
						StreetAddress3 = orderHeader.ShipTo.AddressLine3,
						City = orderHeader.ShipTo.City,
						State = orderHeader.ShipTo.State,
						PostalCode = orderHeader.ShipTo.ZipCode,
						CountryCode = orderHeader.ShipTo.Country,
						ContactName = string.IsNullOrEmpty(orderHeader.ShipTo.ContactLastName)
						? orderHeader.ShipTo.ContactFirstName
						: string.Format("{0} {1}", orderHeader.ShipTo.ContactFirstName, orderHeader.ShipTo.ContactLastName),
						ContactNumber = orderHeader.ShipTo.ContactNumber,
						ContactEmail = orderHeader.ShipTo.ContactEmailID,
						LocationID = orderHeader.ShipTo.LocationID,
						LocationName = orderHeader.ShipTo.LocationName,
					});
				}

				if (orderHeader.DeliverTo != null)
				{
					summaryHeader.Address.Add(new Address()
					{
						AddressTypeId = (int)xCBLAddressType.Consignee,
						Name = "Consignee",
						Address1 = orderHeader.DeliverTo.AddressLine1,
						Address2 = orderHeader.DeliverTo.AddressLine2,
						StreetAddress3 = orderHeader.DeliverTo.AddressLine3,
						City = orderHeader.DeliverTo.City,
						State = orderHeader.DeliverTo.State,
						PostalCode = orderHeader.DeliverTo.ZipCode,
						CountryCode = orderHeader.DeliverTo.Country,
						ContactName = string.IsNullOrEmpty(orderHeader.DeliverTo.ContactLastName)
						? orderHeader.DeliverTo.ContactFirstName
						: string.Format("{0} {1}", orderHeader.DeliverTo.ContactFirstName, orderHeader.DeliverTo.ContactLastName),
						ContactNumber = orderHeader.DeliverTo.ContactNumber,
						ContactEmail = orderHeader.DeliverTo.ContactEmailID,
						LocationID = orderHeader.DeliverTo.LocationID,
						LocationName = orderHeader.DeliverTo.LocationName,
					});
				}
			}

			summaryHeader.LineDetail = new List<LineDetail>();
			if (orderLineDetailList?.OrderLineDetail?.Count > 0)
			{
				orderLineDetailList.OrderLineDetail.ForEach(orderLine =>
					summaryHeader.LineDetail.Add(new LineDetail()
					{
						LineNumber = orderLine.LineNumber,
						ItemID = orderLine.ItemID,
						ItemDescription = orderLine.ItemDescription,
						ShipQuantity = orderLine.ShipQuantity,
						Weight = orderLine.Weight,
						WeightUnitOfMeasure = orderLine.WeightUnitOfMeasure,
						Volume = orderLine.Volume,
						VolumeUnitOfMeasure = orderLine.VolumeUnitOfMeasure,
						SecondaryLocation = orderLine.SecondaryLocation,
						MaterialType = orderLine.MaterialType,
						ShipUnitOfMeasure = orderLine.ShipUnitOfMeasure,
						CustomerStockNumber = orderLine.CustomerStockNumber,
						StatusCode = orderLine.StatusCode,
						EDILINEID = orderLine.EDILINEID,
						MaterialTypeDescription = orderLine.MaterialTypeDescription,
						LineNumberReference = orderLine.LineNumberReference
					})
				);
			}

			summaryHeader.CustomAttribute = new CustomAttribute()
			{
			};

			summaryHeader.UserDefinedField = new UserDefinedField()
			{
			};

			return summaryHeader;
		}

		private List<long> ProcessShippingScheduleRequestForAWC(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, ActiveUser activeUser)
		{
			List<long> copiedGatewayIds = new List<long>();
			string geoCordinateQuery = string.Empty;
			string cityandPostalChangeQuery = string.Empty;
			string deliverySiteNameQuery = string.Empty;
			string deliveryDateTimeActualQuery = string.Empty;
			string estimatedArrivalDateTimeQuery = string.Empty;
			bool isLatLongUpdatedFromXCBL = false;
			string finalSQLUpdateQuery = string.Empty;
			string actionCode = string.Empty;
			List<Task> tasks = new List<Task>();
			List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList = _jobCommands.GetJobUpdateDecisionMaker();
			if (existingJobData.JobIsSchedule && jobUpdateDecisionMakerList != null && jobUpdateDecisionMakerList.Count > 0 && jobUpdateDecisionMakerList.Where(x => x.xCBLColumnName == "ScheduledDeliveryDate").Any())
			{
				jobUpdateDecisionMakerList.Where(x => x.xCBLColumnName == "ScheduledDeliveryDate").FirstOrDefault().ActionCode = "XCBL-Reschedule";
			}

			if (jobUpdateDecisionMakerList != null && jobUpdateDecisionMakerList.Count > 0)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					// Update the Geo Cordinates If Anything Update
					UpdateJobGeoCordinates(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList, out isLatLongUpdatedFromXCBL, ref geoCordinateQuery);
				}));

				tasks.Add(Task.Factory.StartNew(() =>
				{
					// Update Delivery City and Postal Code If Anything Update
					UpdateJobDeliveryCityAndPostalCode(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList, ref cityandPostalChangeQuery);
				}));

				tasks.Add(Task.Factory.StartNew(() =>
					{
						// Update Delivery Site or Street Name
						UpdateDeliverySiteNameWithReasonUpdate(existingJobData, request, ref deliverySiteNameQuery);
					}));

				tasks.Add(Task.Factory.StartNew(() =>
						{
							// Update Delivery Date Time Actual
							UpdateDeliveryDateTimeActual(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList, ref deliveryDateTimeActualQuery);
						}));

				tasks.Add(Task.Factory.StartNew(() =>
							{
								// Update Estimated Arrival Date
								UpdateEstimatedArrivalDateTime(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList, ref estimatedArrivalDateTimeQuery);
							}));

				tasks.Add(Task.Factory.StartNew(() =>
				{
					// Schedule First Stop Update
					UpdateScheduleFirstStop(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
				}));

				tasks.Add(Task.Factory.StartNew(() =>
					{
						// Update Schedule Before 7
						UpdateScheduleBefore7(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
					}));

				tasks.Add(Task.Factory.StartNew(() =>
						{
							// Update Schedule Before 9
							UpdateScheduleBefore9(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
						}));

				tasks.Add(Task.Factory.StartNew(() =>
				{
					// Update Schedule Before 12
					UpdateScheduleBefore12(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
				}));

				tasks.Add(Task.Factory.StartNew(() =>
				{
					// Update Same Day Schedule
					UpdateSameDaySchedule(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
				}));

				tasks.Add(Task.Factory.StartNew(() =>
					{
						// Owner Occupied Update
						UpdateOwnerOccupied(existingJobData, request, copiedGatewayIds, jobUpdateDecisionMakerList);
					}));

				// Update Shipping Schedule
				if (!string.IsNullOrEmpty(request.ShippingInstruction))
				{
					tasks.Add(Task.Factory.StartNew(() =>
						{
							try
							{
								_jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, "Comment", request.ShippingInstruction);
							}
							catch (Exception exp)
							{
								M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "CopyJobGatewayFromProgramForXcBL", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
							}
						}));
				}

				if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
				if (!string.IsNullOrEmpty(geoCordinateQuery))
				{
					finalSQLUpdateQuery = geoCordinateQuery;
				}

				if (!string.IsNullOrEmpty(cityandPostalChangeQuery))
				{
					finalSQLUpdateQuery = string.IsNullOrEmpty(finalSQLUpdateQuery) ? cityandPostalChangeQuery : string.Format("{0}, {1}", finalSQLUpdateQuery, cityandPostalChangeQuery);
				}

				if (!string.IsNullOrEmpty(deliverySiteNameQuery))
				{
					finalSQLUpdateQuery = string.IsNullOrEmpty(finalSQLUpdateQuery) ? deliverySiteNameQuery : string.Format("{0}, {1}", finalSQLUpdateQuery, deliverySiteNameQuery);
				}

				if (!string.IsNullOrEmpty(deliveryDateTimeActualQuery))
				{
					finalSQLUpdateQuery = string.IsNullOrEmpty(finalSQLUpdateQuery) ? deliveryDateTimeActualQuery : string.Format("{0}, {1}", finalSQLUpdateQuery, deliveryDateTimeActualQuery);
				}

				if (!string.IsNullOrEmpty(estimatedArrivalDateTimeQuery))
				{
					finalSQLUpdateQuery = string.IsNullOrEmpty(finalSQLUpdateQuery) ? estimatedArrivalDateTimeQuery : string.Format("{0}, {1}", finalSQLUpdateQuery, estimatedArrivalDateTimeQuery);
				}

				if (!string.IsNullOrEmpty(finalSQLUpdateQuery))
				{
					finalSQLUpdateQuery = string.Format("Update dbo.JobDL000Master SET {0}, ChangedBy = '{1}' , DateChanged = '{2}' Where Id = {3}", finalSQLUpdateQuery, activeUser.UserName, DateTime.UtcNow.AddHours(-7), existingJobData.Id);
					_jobCommands.UpdateJobPartialDataByShippingSchedule(finalSQLUpdateQuery);
				}
			}

			return copiedGatewayIds;
		}

		private void InsertxCBLDetailsInTableForAWC(long jobId, XCBLToM4PLRequest xCBLToM4PLRequest, string title)
		{
			_jobEDIxCBLCommand.Post(ActiveUser, new JobEDIXcbl()
			{
				JobId = jobId,
				EdtCode = title,
				EdtTypeId = M4PLBusinessConfiguration.XCBLEDTType.ToInt(),
				EdtData = Newtonsoft.Json.JsonConvert.SerializeObject(xCBLToM4PLRequest),
				TransactionDate = Utilities.TimeUtility.GetPacificDateTime(),
				EdtTitle = title
			});
		}

		private void InsertxCBLDetailsInTable(long jobId, ElectroluxOrderDetails orderDetails)
		{
			string orderXml = string.Empty;
			string message = orderDetails?.Header?.Message?.Subject;
			XmlDocument xmlDoc = new XmlDocument();
			XmlSerializer xmlSerializer = new XmlSerializer(orderDetails.GetType());
			using (MemoryStream xmlStream = new MemoryStream())
			{
				xmlSerializer.Serialize(xmlStream, orderDetails);
				xmlStream.Position = 0;
				xmlDoc.Load(xmlStream);
				orderXml = string.Format(format: "{0} {1} {2}", arg0: "<fxEnvelope>", arg1: xmlDoc.DocumentElement.InnerXml, arg2: "</fxEnvelope>");
			}

			_jobEDIxCBLCommand.Post(ActiveUser, new JobEDIXcbl()
			{
				JobId = jobId,
				EdtCode = message,
				EdtTypeId = M4PLBusinessConfiguration.XCBLEDTType.ToInt(),
				EdtData = orderXml,
				TransactionDate = Utilities.TimeUtility.GetPacificDateTime(),
				EdtTitle = string.Equals(message, ElectroluxMessage.Order.ToString(), StringComparison.OrdinalIgnoreCase)
				? string.Format("{0} {1}", message, orderDetails?.Body?.Order?.OrderHeader.Action) : message
			});
		}

		private static OrderResponse ValidateElectroluxOrderRequest(OrderResponse response, OrderHeader orderHeader, string message)
		{
			if (string.IsNullOrEmpty(message))
			{
				response = new OrderResponse()
				{
					ClientMessageID = string.Empty,
					SenderMessageID = orderHeader?.OrderNumber,
					StatusCode = "Failure",
					Subject = "Subject could not be empty in the request, please check the request."
				};
			}
			else if (!string.IsNullOrEmpty(message) && !(string.Equals(message, ElectroluxMessage.Order.ToString(), StringComparison.OrdinalIgnoreCase) || string.Equals(message, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase)))
			{
				response = new OrderResponse()
				{
					ClientMessageID = string.Empty,
					SenderMessageID = orderHeader?.OrderNumber,
					StatusCode = "Failure",
					Subject = "Valid subject type for a request are either Order or ASN, please check the request."
				};
			}
			else if (string.IsNullOrEmpty(orderHeader?.Action))
			{
				response = new OrderResponse()
				{
					ClientMessageID = string.Empty,
					SenderMessageID = orderHeader?.OrderNumber,
					StatusCode = "Failure",
					Subject = "Action could not be empty in the request, please check the request."
				};
			}
			else if (!string.IsNullOrEmpty(orderHeader?.Action) && !(string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase) || string.Equals(orderHeader.Action, ElectroluxAction.Delete.ToString(), StringComparison.OrdinalIgnoreCase)))
			{
				response = new OrderResponse()
				{
					ClientMessageID = string.Empty,
					SenderMessageID = orderHeader?.OrderNumber,
					StatusCode = "Failure",
					Subject = "Valid action type for a request are either ADD or DELETE, please check the request."
				};
			}

			return response;
		}

		#endregion Private Methods

		#region Shipping Schedule Processing Methods

		private void UpdateJobGeoCordinates(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList, out bool isLatLongUpdatedFromXCBL, ref string geoCordinateQuery)
		{
			isLatLongUpdatedFromXCBL = false;
			try
			{
				if (string.Compare(existingJobData.JobLatitude, request.Latitude, true) != 0 || string.Compare(existingJobData.JobLongitude, request.Longitude, true) != 0)
				{
					isLatLongUpdatedFromXCBL = true;
					var coordinateAction = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("Latitude", StringComparison.OrdinalIgnoreCase));
					string actionCode = coordinateAction != null ? coordinateAction.ActionCode : string.Empty;
					var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
					if (jobGateway != null && jobGateway.GwyCompleted)
					{
						if (string.Compare(existingJobData.JobLatitude, request.Latitude, true) != 0)
						{
							geoCordinateQuery = string.Format("JobLatitude = '{0}'", request.Latitude);
						}

						if (string.Compare(existingJobData.JobLongitude, request.Longitude, true) != 0)
						{
							geoCordinateQuery = string.IsNullOrEmpty(geoCordinateQuery) ? string.Format("JobLongitude = '{0}'", request.Longitude) :
												string.Format("{0}, JobLongitude = '{1}'", geoCordinateQuery, request.Longitude);
						}
					}

					if (jobGateway != null)
					{
						copiedGatewayIds.Add(jobGateway.Id);
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateJobGeoCordinates", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateJobDeliveryCityAndPostalCode(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList, ref string cityandPostalChangeQuery)
		{
			try
			{
				if (string.Compare(existingJobData.JobDeliveryPostalCode, request.PostalCode, true) != 0 || string.Compare(existingJobData.JobDeliveryCity, request.City, true) != 0)
				{
					var deliveryLocationAction = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("City", StringComparison.OrdinalIgnoreCase));
					string actionCode = deliveryLocationAction != null ? deliveryLocationAction.ActionCode : string.Empty;
					var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
					if (jobGateway != null && jobGateway.GwyCompleted)
					{
						if (string.Compare(existingJobData.JobDeliveryCity, request.City, true) != 0)
						{
							cityandPostalChangeQuery = string.Format("JobDeliveryCity = '{0}'", request.City);
						}

						if (string.Compare(existingJobData.JobDeliveryPostalCode, request.PostalCode, true) != 0)
						{
							cityandPostalChangeQuery = string.IsNullOrEmpty(cityandPostalChangeQuery) ? string.Format("JobDeliveryPostalCode = '{0}'", request.PostalCode) :
												string.Format("{0}, JobDeliveryPostalCode = '{1}'", cityandPostalChangeQuery, request.PostalCode);
						}
					}

					if (jobGateway != null)
					{
						copiedGatewayIds.Add(jobGateway.Id);
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateJobDeliveryCityAndPostalCode", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateDeliverySiteNameWithReasonUpdate(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, ref string deliverySiteNameQuery)
		{
			try
			{
				if (string.Compare(existingJobData.JobDeliverySiteName, request.Name1, true) != 0 ||
							string.Compare(existingJobData.JobDeliveryStreetAddress, request.Street, true) != 0 ||
							string.Compare(existingJobData.JobDeliveryStreetAddress2, request.Streetsupplement1, true) != 0)
				{
					if (string.Compare(existingJobData.JobDeliverySiteName, request.Name1, true) != 0)
					{
						deliverySiteNameQuery = string.Format("JobDeliverySiteName = '{0}'", request.Name1);
					}

					if (string.Compare(existingJobData.JobDeliveryStreetAddress, request.Street, true) != 0)
					{
						deliverySiteNameQuery = string.IsNullOrEmpty(deliverySiteNameQuery) ? string.Format("JobDeliveryStreetAddress = '{0}'", request.Street) :
												string.Format("{0}, JobDeliveryStreetAddress = '{1}'", deliverySiteNameQuery, request.Street);
					}

					if (string.Compare(existingJobData.JobDeliveryStreetAddress2, request.Streetsupplement1, true) != 0)
					{
						deliverySiteNameQuery = string.IsNullOrEmpty(deliverySiteNameQuery) ? string.Format("JobDeliveryStreetAddress2 = '{0}'", request.Streetsupplement1) :
												string.Format("{0}, JobDeliveryStreetAddress2 = '{1}'", deliverySiteNameQuery, request.Streetsupplement1);
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateDeliverySiteNameWithReasonUpdate", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateDeliveryDateTimeActual(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList, ref string deliveryDateTimeActualQuery)
		{
			try
			{
				if (existingJobData.JobDeliveryDateTimeActual.HasValue &&
						request.EstimatedArrivalDate.Subtract(Convert.ToDateTime(existingJobData.JobDeliveryDateTimeActual))
						.TotalHours <= 48)
				{
					var deliveryDateTimeActualactionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("XCBL-Date", StringComparison.OrdinalIgnoreCase));
					string actionCode = deliveryDateTimeActualactionCode != null ? deliveryDateTimeActualactionCode.ActionCode : string.Empty;
					if (!string.IsNullOrEmpty(actionCode))
					{
						var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
						if (jobGateway != null)
						{
							copiedGatewayIds.Add(jobGateway.Id);

							if (jobGateway.GwyCompleted)
							{
								if (!existingJobData.JobDeliveryDateTimeActual.Equals(request.EstimatedArrivalDate))
								{
									deliveryDateTimeActualQuery = string.Format("JobDeliveryDateTimeActual = '{0}'", request.EstimatedArrivalDate);
								}
							}
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateDeliveryDateTimeActual", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateEstimatedArrivalDateTime(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList, ref string estimatedArrivalDateTimeQuery)
		{
			try
			{
				var deliveryDateTimePlannedActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("ScheduledDeliveryDate", StringComparison.OrdinalIgnoreCase));
				string actionCode = deliveryDateTimePlannedActionCode == null ? string.Empty : deliveryDateTimePlannedActionCode.ActionCode;
				if (!existingJobData.JobDeliveryDateTimePlanned.HasValue || request.EstimatedArrivalDate.CompareTo(existingJobData.JobDeliveryDateTimePlanned) != 0)
				{
					if (!string.IsNullOrEmpty(actionCode))
					{
						var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
						if (jobGateway != null)
						{
							copiedGatewayIds.Add(jobGateway.Id);
							if (jobGateway.GwyCompleted)
							{
								estimatedArrivalDateTimeQuery = string.Format("JobDeliveryDateTimePlanned = '{0}'", request.EstimatedArrivalDate);
							}
						}
					}
				}
				else
				{
					if (!existingJobData.JobIsSchedule)
					{
						if (!string.IsNullOrEmpty(actionCode))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
								if (jobGateway.GwyCompleted)
								{
									estimatedArrivalDateTimeQuery = string.Format("JobDeliveryDateTimePlanned = '{0}'", request.EstimatedArrivalDate);
								}
							}
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateEstimatedArrivalDateTime", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateScheduleFirstStop(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_FirstStop))
				{
					var firstStopActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF01", StringComparison.OrdinalIgnoreCase));
					if (firstStopActionCode != null && !string.IsNullOrEmpty(firstStopActionCode.ActionCode))
					{
						if (request.Other_FirstStop.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, firstStopActionCode.ActionCode);

							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_FirstStop.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, firstStopActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateScheduleFirstStop", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateScheduleBefore7(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_Before7))
				{
					var befor7ActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF02", StringComparison.OrdinalIgnoreCase));
					if (befor7ActionCode != null && !string.IsNullOrEmpty(befor7ActionCode.ActionCode))
					{
						if (request.Other_Before7.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor7ActionCode.ActionCode);
							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_Before7.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor7ActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateScheduleBefore7", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateScheduleBefore9(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_Before9))
				{
					var befor9ActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF03", StringComparison.OrdinalIgnoreCase));
					if (befor9ActionCode != null && !string.IsNullOrEmpty(befor9ActionCode.ActionCode))
					{
						if (request.Other_Before9.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor9ActionCode.ActionCode);

							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_Before9.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor9ActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateScheduleBefore9", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateScheduleBefore12(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_Before12))
				{
					var befor12ActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF04", StringComparison.OrdinalIgnoreCase));
					if (befor12ActionCode != null && !string.IsNullOrEmpty(befor12ActionCode.ActionCode))
					{
						if (request.Other_Before12.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor12ActionCode.ActionCode);

							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_Before12.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, befor12ActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateScheduleBefore12", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateSameDaySchedule(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_SameDay))
				{
					var sameDayActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF05", StringComparison.OrdinalIgnoreCase));
					if (sameDayActionCode != null && !string.IsNullOrEmpty(sameDayActionCode.ActionCode))
					{
						if (request.Other_SameDay.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, sameDayActionCode.ActionCode);

							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_SameDay.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, sameDayActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateSameDaySchedule", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		private void UpdateOwnerOccupied(Entities.Job.Job existingJobData, XCBLToM4PLShippingScheduleRequest request, List<long> copiedGatewayIds, List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList)
		{
			try
			{
				if (!string.IsNullOrEmpty(request.Other_OwnerOccupied))
				{
					var ownerOccupiedActionCode = jobUpdateDecisionMakerList.FirstOrDefault(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && obj.xCBLColumnName.Equals("UDF06", StringComparison.OrdinalIgnoreCase));
					if (ownerOccupiedActionCode != null && !string.IsNullOrEmpty(ownerOccupiedActionCode.ActionCode))
					{
						if (request.Other_OwnerOccupied.Equals("Y", StringComparison.OrdinalIgnoreCase))
						{
							var jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, ownerOccupiedActionCode.ActionCode);

							if (jobGateway != null)
							{
								copiedGatewayIds.Add(jobGateway.Id);
							}
						}
						else if (request.Other_OwnerOccupied.Equals("N", StringComparison.OrdinalIgnoreCase))
						{
							_jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, ownerOccupiedActionCode.ActionCode);
						}
					}
				}
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "UpdateOwnerOccupied", "Error occuring while processing shipping schedule.", Utilities.Logger.LogType.Error);
			}
		}

		#endregion Shipping Schedule Processing Methods
	}
}