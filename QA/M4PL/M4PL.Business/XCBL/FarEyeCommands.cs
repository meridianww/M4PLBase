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
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using M4PL.Entities.XCBL.FarEye;
using M4PL.Entities.XCBL.FarEye.Order;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

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
			var orderResult = ProcessElectroluxOrderRequest(orderDetail);

			FarEyeOrderResponse farEyeOrderResponse = new FarEyeOrderResponse();
			farEyeOrderResponse.status = (orderResult == null || (orderResult != null && orderResult.StatusCode == "Failure")) ? 500 : 200;
			farEyeOrderResponse.orderNumber = orderDetail.order_number;
			farEyeOrderResponse.trackingNumber = !string.IsNullOrEmpty(orderDetail.tracking_number) ? orderDetail.tracking_number.Replace("O-", string.Empty) : string.Empty;
			farEyeOrderResponse.timestamp = TimeUtility.UnixTimeNow();
			if (orderResult != null && orderResult.StatusCode == "Failure" && !string.IsNullOrEmpty(orderResult.Subject))
			{
				farEyeOrderResponse.errors = new List<string>
				{
					orderResult.Subject
				};
			}
			else if (orderResult != null && orderResult.StatusCode == "Success")
			{
				long jobId = orderResult.ClientMessageID.ToLong();
				if (jobId > 0 && string.IsNullOrEmpty(orderDetail.tracking_number))
				{
					FarEyeHelper.PushStatusUpdateToFarEye(jobId, ActiveUser, true);
				}
			}

			return farEyeOrderResponse;
		}

		public OrderResponse ProcessElectroluxOrderRequest(FarEyeOrderDetails farEyeOrderDetails)
		{
			string inputString = farEyeOrderDetails == null ? "null" : JsonConvert.SerializeObject(farEyeOrderDetails);
			M4PL.DataAccess.Logger.ErrorLogger.Log(new Exception(), string.Format("Input Request recieved from FarEye is: {0}", inputString), "ProcessElectroluxOrderRequest", Utilities.Logger.LogType.Informational);
			if (farEyeOrderDetails == null)
			{
				new OrderResponse()
				{
					ClientMessageID = string.Empty,
					SenderMessageID = string.Empty,
					StatusCode = "Failure",
					Subject = "Input request for order creation is not parsed properly, please sent a valid input."
				};
			}

			Entities.Job.Job processingJobDetail = null;
			Entities.Job.Job jobDetails = null;
			Entities.Job.Job existingJobDataInDB = null;
			OrderResponse response = null;
			JobCargoMapper cargoMapper = new JobCargoMapper();
			if (response != null) { return response; }
			List<SystemReference> systemOptionList = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
			int serviceId = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			string locationCode = !string.IsNullOrEmpty(farEyeOrderDetails.info.facility_code) && farEyeOrderDetails.info.facility_code.Length >= 4 ? farEyeOrderDetails.info.facility_code.Substring(farEyeOrderDetails.info.facility_code.Length - 4) : null;
			if (string.IsNullOrEmpty(farEyeOrderDetails.tracking_number))
			{
				farEyeOrderDetails.tracking_number = string.Format("O-{0}", farEyeOrderDetails.order_number);
				existingJobDataInDB = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, farEyeOrderDetails.tracking_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
			}
			else
			{
				string tempOrderNumber = string.Format("O-{0}", farEyeOrderDetails.order_number);
				
				existingJobDataInDB = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, farEyeOrderDetails.tracking_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				if (existingJobDataInDB != null && existingJobDataInDB.Id > 0)
				{
					existingJobDataInDB.JobCustomerSalesOrder = farEyeOrderDetails.tracking_number;
				}
				else
				{
					existingJobDataInDB = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, tempOrderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					if (existingJobDataInDB != null && existingJobDataInDB.Id > 0)
                    {
						existingJobDataInDB.JobCustomerSalesOrder = farEyeOrderDetails.tracking_number;
					}						
					else
                    {
						existingJobDataInDB = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, farEyeOrderDetails.tracking_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					}						
				}
			}

			try
			{
				if (!string.IsNullOrEmpty(farEyeOrderDetails.type_of_service) && string.Equals(farEyeOrderDetails.type_of_service, ElectroluxMessage.Order.ToString(), StringComparison.OrdinalIgnoreCase))
				{
					jobDetails = GetJobModelForElectroluxOrderCreation(farEyeOrderDetails, systemOptionList, false);

					if (!string.IsNullOrEmpty(farEyeOrderDetails.type_of_action) && string.Equals(farEyeOrderDetails.type_of_action, "Create", StringComparison.OrdinalIgnoreCase) && existingJobDataInDB?.Id > 0)
					{
						jobDetails.Id = existingJobDataInDB.Id;
						// FarEye can send an update using the "Create" type of action so update the existing order 
						processingJobDetail = jobDetails != null ? DataAccess.Job.JobCommands.Put(ActiveUser, jobDetails, isLatLongUpdatedFromXCBL: false, isRelatedAttributeUpdate: false, isServiceCall: true) : existingJobDataInDB;

						if (processingJobDetail?.Id > 0)
						{
							string jobNotes = DataAccess.Job.JobCommands.GetJobNotes(processingJobDetail.Id);
							string orderNotes = !String.IsNullOrEmpty(farEyeOrderDetails.info.non_executable) ? farEyeOrderDetails.info.non_executable : string.Empty;

							if (!jobNotes.Contains(farEyeOrderDetails.delivery_instruction))
							{
								if (jobNotes.Length > 0)
								{
									jobNotes = jobNotes + System.Environment.NewLine + farEyeOrderDetails.delivery_instruction;
								}
								else
								{
									jobNotes = farEyeOrderDetails.delivery_instruction;
								}
								jobNotes += System.Environment.NewLine + orderNotes;
								DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, jobNotes);
							}
							else if (orderNotes.Length > 0)
							{
								DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, orderNotes);
							}

							InsertFarEyeDetailsInTable(processingJobDetail.Id, farEyeOrderDetails, farEyeOrderDetails.type_of_service);
							List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapperFromFarEye(farEyeOrderDetails, processingJobDetail.Id, systemOptionList);
							if (jobCargos != null && jobCargos.Count > 0)
							{
								DataAccess.Job.JobCommands.InsertJobCargoData(jobCargos, ActiveUser);
							}

							if (processingJobDetail.ProgramID.HasValue)
							{
								DataAccess.Job.JobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
							}
						}
						else
						{
							response = new OrderResponse()
							{
								ClientMessageID = string.Empty,
								SenderMessageID = farEyeOrderDetails.order_number,
								StatusCode = "Failure",
								Subject = "The order was not updated due to an error."
							};
						}

					}
					else
					{
						//jobDetails = GetJobModelForElectroluxOrderCreation(farEyeOrderDetails, systemOptionList, false);

						// Set the facility_code to the Origin Site Name since FarEye does not send the Origin address information
						jobDetails.JobOriginSiteName = farEyeOrderDetails.info.facility_code;
						processingJobDetail = jobDetails != null ? DataAccess.Job.JobCommands.Post(ActiveUser, jobDetails, false, true) : jobDetails;

					}

					if (processingJobDetail?.Id > 0)
					{
						string jobNotes = DataAccess.Job.JobCommands.GetJobNotes(processingJobDetail.Id);
						string orderNotes = !String.IsNullOrEmpty(farEyeOrderDetails.info.non_executable) ? farEyeOrderDetails.info.non_executable : string.Empty;

						if (!jobNotes.Contains(farEyeOrderDetails.delivery_instruction))
						{
							if (jobNotes.Length > 0)
							{
								jobNotes = jobNotes + System.Environment.NewLine + farEyeOrderDetails.delivery_instruction;
							}
							else
							{
								jobNotes = farEyeOrderDetails.delivery_instruction;
							}
							jobNotes += System.Environment.NewLine + orderNotes;
							DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, jobNotes);
						}
						else if (orderNotes.Length > 0)
						{
							DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, orderNotes);
						}

						InsertFarEyeDetailsInTable(processingJobDetail.Id, farEyeOrderDetails, farEyeOrderDetails.type_of_service);
						List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapperFromFarEye(farEyeOrderDetails, processingJobDetail.Id, systemOptionList);
						if (jobCargos != null && jobCargos.Count > 0)
						{
							DataAccess.Job.JobCommands.InsertJobCargoData(jobCargos, ActiveUser);
						}

						if (processingJobDetail.ProgramID.HasValue)
						{
							DataAccess.Job.JobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
						}
					}
					else
					{
						response = new OrderResponse()
						{
							ClientMessageID = string.Empty,
							SenderMessageID = farEyeOrderDetails.order_number,
							StatusCode = "Failure",
							Subject = "Request has been recieved and logged, there is some issue while creating order in the system, please try again."
						};
					}
				}
				else if (!string.IsNullOrEmpty(farEyeOrderDetails.type_of_service) && (string.Equals(farEyeOrderDetails.type_of_service, ElectroluxMessage.DeliveryNumber.ToString(), StringComparison.OrdinalIgnoreCase) || string.Equals(farEyeOrderDetails.type_of_service, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase)))
				{
					if (string.Equals(farEyeOrderDetails.type_of_service, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase))
					{
						jobDetails = GetJobModelForElectroluxOrderCreation(farEyeOrderDetails, systemOptionList, true);
					}
					else
					{
						jobDetails = GetJobModelForElectroluxOrderCreation(farEyeOrderDetails, systemOptionList, false);
					}					

					if (jobDetails.Id <= 0)
					{
						existingJobDataInDB = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, farEyeOrderDetails.tracking_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
						processingJobDetail = DataAccess.Job.JobCommands.GetJobByBOLMaster(ActiveUser, farEyeOrderDetails.order_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());

						if (processingJobDetail.Id > 0)
                        {
							jobDetails.Id = processingJobDetail.Id;

							if (existingJobDataInDB.Id < 1 && !processingJobDetail.JobCustomerSalesOrder.Contains("O-"))
							{
								jobDetails = GetJobModelForElectroluxOrderCreation(farEyeOrderDetails, systemOptionList, false);

								processingJobDetail = jobDetails != null ? DataAccess.Job.JobCommands.Post(ActiveUser, jobDetails, false, true) : jobDetails;

								if (processingJobDetail?.Id > 0)
								{
									string jobNotes = DataAccess.Job.JobCommands.GetJobNotes(processingJobDetail.Id);
									string orderNotes = !String.IsNullOrEmpty(farEyeOrderDetails.info.non_executable) ? farEyeOrderDetails.info.non_executable : string.Empty;

									if (!jobNotes.Contains(farEyeOrderDetails.delivery_instruction))
									{
										if (jobNotes.Length > 0)
										{
											jobNotes = jobNotes + System.Environment.NewLine + farEyeOrderDetails.delivery_instruction;
										}
										else
										{
											jobNotes = farEyeOrderDetails.delivery_instruction;
										}
										jobNotes += System.Environment.NewLine + orderNotes;
										DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, jobNotes);
									}
									else if (orderNotes.Length > 0)
									{
										DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, orderNotes);
									}

									InsertFarEyeDetailsInTable(processingJobDetail.Id, farEyeOrderDetails, farEyeOrderDetails.type_of_service);
									List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapperFromFarEye(farEyeOrderDetails, processingJobDetail.Id, systemOptionList);
									if (jobCargos != null && jobCargos.Count > 0)
									{
										DataAccess.Job.JobCommands.InsertJobCargoData(jobCargos, ActiveUser);
									}

									if (processingJobDetail.ProgramID.HasValue)
									{
										DataAccess.Job.JobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
									}
								}


							}
							else if(existingJobDataInDB.Id > 0 && !existingJobDataInDB.JobCustomerSalesOrder.Contains("O-"))
                            {
								jobDetails.Id = existingJobDataInDB.Id;
							}
						}
						
						bool isJobCancelled = jobDetails?.Id > 0 ? DataAccess.Job.JobCommands.IsJobCancelled(jobDetails.Id) : true;


						if (jobDetails?.Id <= 0 && processingJobDetail?.Id > 0)
						{
							response = new OrderResponse()
							{
								ClientMessageID = string.Empty,
								SenderMessageID = farEyeOrderDetails.order_number,
								StatusCode = "Failure",
								Subject = "Can not proceed the ASN request to the system as requesed order is not present in the meridian system, please try again."
							};
						}
						else if (jobDetails?.Id > 0 && !isJobCancelled)
						{
							jobDetails.JobIsDirtyDestination = true;
							jobDetails.JobIsDirtyContact = true;
							if (!String.IsNullOrEmpty(farEyeOrderDetails.info.non_executable))
							{
								jobDetails.JobDeliveryDateTimeBaseline = new DateTime(2049, 12, 31);
							}

							// Set the facility_code to the Origin Site Name since FarEye does not send the Origin address information
							jobDetails.JobOriginSiteName = farEyeOrderDetails.info.facility_code;
							if(jobDetails?.Id > 0)
                            {
								processingJobDetail = jobDetails != null ? DataAccess.Job.JobCommands.Put(ActiveUser, jobDetails, isLatLongUpdatedFromXCBL: false, isRelatedAttributeUpdate: false, isServiceCall: true) : jobDetails;
							}
							else
                            {
								processingJobDetail = existingJobDataInDB != null ? DataAccess.Job.JobCommands.Put(ActiveUser, existingJobDataInDB, isLatLongUpdatedFromXCBL: false, isRelatedAttributeUpdate: false, isServiceCall: true) : existingJobDataInDB;
							}
							
							//processingJobDetail = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, farEyeOrderDetails.tracking_number, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
							if (processingJobDetail?.Id > 0)
							{
								string jobNotes = DataAccess.Job.JobCommands.GetJobNotes(processingJobDetail.Id);
								string orderNotes = !String.IsNullOrEmpty(farEyeOrderDetails.info.non_executable) ? farEyeOrderDetails.info.non_executable : string.Empty;

								if (!jobNotes.Contains(farEyeOrderDetails.delivery_instruction))
								{
									if (jobNotes.Length > 0)
									{
										jobNotes = jobNotes + System.Environment.NewLine + farEyeOrderDetails.delivery_instruction;
									}
									else
									{
										jobNotes = farEyeOrderDetails.delivery_instruction;
									}
									jobNotes += System.Environment.NewLine + orderNotes;
									DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, jobNotes);
								}
								else if (orderNotes.Length > 0)
								{
									DataAccess.Job.JobCommands.UpdatedDriverAlert(ActiveUser, processingJobDetail.Id, orderNotes);
								}
								InsertFarEyeDetailsInTable(processingJobDetail.Id, farEyeOrderDetails, farEyeOrderDetails.type_of_service);
								bool isFarEyePushRequired = true;

								if (string.Equals(farEyeOrderDetails.type_of_service, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase))
								{
									DataAccess.Job.JobCommands.CopyJobGatewayFromProgramForXcBLForElectrolux(ActiveUser, processingJobDetail.Id, (long)processingJobDetail.ProgramID, "In Transit", M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), out isFarEyePushRequired);
								}


								if (M4PLBusinessConfiguration.IsFarEyePushRequired.ToBoolean())
								{
									if (isFarEyePushRequired)
									{
										FarEyeHelper.PushStatusUpdateToFarEye((long)processingJobDetail.Id, ActiveUser);
									}
								}

								List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapperFromFarEye(farEyeOrderDetails, processingJobDetail.Id, systemOptionList);
								if (jobCargos != null && jobCargos.Count > 0)
								{
									DataAccess.Job.JobCommands.InsertJobCargoData(jobCargos, ActiveUser);
								}

								if (processingJobDetail.ProgramID.HasValue)
								{
									DataAccess.Job.JobCommands.InsertCostPriceCodesForOrder((long)processingJobDetail.Id, (long)processingJobDetail.ProgramID, locationCode, serviceId, ActiveUser, true, 1);
								}
							}
						}
						else if (jobDetails?.Id > 0 && isJobCancelled)
						{
							response = new OrderResponse()
							{
								ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
								SenderMessageID = farEyeOrderDetails.order_number,
								StatusCode = "Failure",
								Subject = "Can not proceed the ASN request to the system as requesed order is already canceled in the meridian system, please try again."
							};
						}
						else
						{
							response = new OrderResponse()
							{
								ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
								SenderMessageID = farEyeOrderDetails.order_number,
								StatusCode = "Failure",
								Subject = "Please correct the action type for the request as only action Add is allowed to pass with ASN, please try again."
							};
						}
					}
				}
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is happening while processing the electrolux data.", "ProcessElectroluxOrderRequest", Utilities.Logger.LogType.Error);
				response = new OrderResponse()
				{
					ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
					SenderMessageID = farEyeOrderDetails.order_number,
					StatusCode = "Failure",
					Subject = exp.Message
				};
			}
			
			response = response != null ? response : new OrderResponse()
			{
				ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty,
				SenderMessageID = farEyeOrderDetails.order_number,
				StatusCode = "Success",
				Subject = farEyeOrderDetails.type_of_service
			};

			return response;
		}

		internal void InsertFarEyeDetailsInTable(long jobId, object orderDetails, string subject)
		{
			M4PL.DataAccess.Job.JobEDIXcblCommands.Post(ActiveUser, new JobEDIXcbl()
			{
				JobId = jobId,
				EdtCode = subject,
				EdtTypeId = M4PLBusinessConfiguration.XCBLEDTType.ToInt(),
				EdtData = JsonConvert.SerializeObject(orderDetails),
				TransactionDate = Utilities.TimeUtility.GetPacificDateTime(),
				EdtTitle = subject
			});
		}

		private Entities.Job.Job GetJobModelForElectroluxOrderCreation(FarEyeOrderDetails farEyeOrderDetails, List<SystemReference> systemOptionList, bool isUpdateRequired)
		{
			Entities.Job.Job jobCreationData = null;
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			long programId = M4PLBusinessConfiguration.ElectroluxProgramId.ToLong();
			basicDetailMapper.ToJobBasicDetailModelFromFarEyeData(farEyeOrderDetails, ref jobCreationData, programId, isUpdateRequired, systemOptionList);
			addressMapper.ToJobAddressModelFromDataByFarEyeModel(farEyeOrderDetails, ref jobCreationData);
			
			return jobCreationData;
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

			string orderNumber = string.IsNullOrEmpty(orderEvent.TrackingNumber) ? string.Format("O-{0}", orderEvent.OrderNumber) : orderEvent.TrackingNumber;
			var orderData = DataAccess.Job.JobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
			if (orderData == null || (orderData != null && orderData.Id == 0))
			{
				orderData = DataAccess.Job.JobCommands.GetJobByBOLMaster(ActiveUser, orderEvent.OrderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());//DataAccess.Job.JobCommands.GetJobByServiceMode(ActiveUser, orderEvent.OrderNumber, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
			}

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
							////if (gatewayInsertResult != null && gatewayInsertResult.IsFarEyePushRequired)
							////{
							////	FarEyeHelper.PushStatusUpdateToFarEye((long)orderData.Id, ActiveUser);
							////}
						}
					}
				}

				return new OrderEventResponse() { OrderNumber = orderEvent.OrderNumber, TrackingNumber = orderEvent.TrackingNumber, Status = (int)HttpStatusCode.OK, Timestamp = TimeUtility.UnixTimeNow(), Errors = new List<string>() { string.Format("Order {0} is successfully updated.", orderEvent.OrderNumber) } };
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
			Job.JobCommands jobCommands = new Job.JobCommands();
			jobCommands.ActiveUser = this.ActiveUser;
			response.items_track_details = new List<ItemsTrackDetail>();
			if (farEyeOrderCancelRequest.tracking_number != null && farEyeOrderCancelRequest.tracking_number.Count > 0)
			{
				foreach (var trackingNumber in farEyeOrderCancelRequest.tracking_number)
				{
					var statusModel = jobCommands.CancelJobByOrderNumber(trackingNumber, farEyeOrderCancelRequest.carrier_code, farEyeOrderCancelRequest.reason);
					response.items_track_details.Add(new ItemsTrackDetail() { status = statusModel.Status, message = statusModel.AdditionalDetail, tracking_number = trackingNumber });
				}
			}
			else
			{
				var statusModel = jobCommands.CancelJobByOrderNumber(string.Format("O-{0}", farEyeOrderCancelRequest.order_number), farEyeOrderCancelRequest.carrier_code, farEyeOrderCancelRequest.reason);
				response.items_track_details.Add(new ItemsTrackDetail() { status = statusModel.Status, message = statusModel.AdditionalDetail, tracking_number = farEyeOrderCancelRequest.order_number });
			}

			response.status = response.items_track_details.Where(x => x.status.Equals("Failure", StringComparison.OrdinalIgnoreCase)).Any() ? 400 : 200;
			response.reference_id = farEyeOrderCancelRequest.reference_id;
			response.order_number = farEyeOrderCancelRequest.order_number;
			response.timestamp = TimeUtility.UnixTimeNow();
			response.execution_time = (DateTime.Now - processingStartDateTime).TotalMilliseconds.ToInt();

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
					farEyeDeliveryStatusResponse.order_number = jobDetail.JobBOLMaster;
					farEyeDeliveryStatusResponse.type = "DeliveryNumber";
					farEyeDeliveryStatusResponse.value = !string.IsNullOrEmpty(orderNumber) && orderNumber.StartsWith("O-") ? null : orderNumber;
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
						epod = !string.IsNullOrEmpty(jobDetail.JobGatewayStatus) && (jobDetail.JobGatewayStatus.Equals("Delivered", StringComparison.OrdinalIgnoreCase)
						|| (jobDetail.JobGatewayStatus.Equals("POD Completion", StringComparison.OrdinalIgnoreCase))) ? string.Format("{0}?jobId={1}&tabName=POD", ConfigurationManager.AppSettings["M4PLApplicationURL"], deliveryUpdate.ServiceProviderID) : string.Empty,
						promised_delivery_date = jobDetail.JobOriginDateTimeBaseline.HasValue ? jobDetail.JobOriginDateTimeBaseline.Value.ToString("yyyyMMddHHmmss") : string.Empty,
						expected_delivery_date = jobDetail.JobOriginDateTimePlanned.HasValue ? jobDetail.JobOriginDateTimePlanned.Value.ToString("yyyyMMddHHmmss") : string.Empty
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
								item_number = x.CgoLineNumber,
								quantity = x.Quantity,
								comments = x.CgoTitle,
								exception_code = x.Exceptions?.ExceptionInfo?.ExceptionCode,
								exception_detail = x.Exceptions?.ExceptionInfo?.ExceptionDetail,
								item_install_status = !string.IsNullOrEmpty(x.ItemInstallStatus) ? x.ItemInstallStatus : 
								(deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.RescheduledInstallDate))
								? "Rescheduled" : (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.CancelDate) &&
								                 !string.IsNullOrEmpty(deliveryUpdate.InstallStatus) && 
												 !deliveryUpdate.InstallStatus.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
							    ? "Cancelled" : x.ItemInstallStatus,
								item_Install_status_description = !string.IsNullOrEmpty(x.ItemInstallStatus) ? x.ItemInstallStatus :
								(deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.RescheduledInstallDate))
								? "Rescheduled" : (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.CancelDate) &&
												 !string.IsNullOrEmpty(deliveryUpdate.InstallStatus) &&
												 !deliveryUpdate.InstallStatus.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
								? "Cancelled" : x.ItemInstallStatus,
								material_id = x.ItemNumber,
								serial_barcode = x.CgoSerialBarcode,
								serial_number = x.CgoSerialNumber
							}));
					}

					if (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.RescheduledInstallDate))
					{
						farEyeDeliveryStatusResponse.carrier_status = "RESCHEDULED";
						farEyeDeliveryStatusResponse.carrier_status_code = "RESCHEDULED";
						farEyeDeliveryStatusResponse.carrier_status_description = "RESCHEDULED";
						farEyeDeliveryStatusResponse.carrier_sub_status = "RESCHEDULED";
						farEyeDeliveryStatusResponse.carrier_sub_status_description = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_status = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_status_code = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_status_description = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_sub_status = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_sub_status_code = "RESCHEDULED";
						farEyeDeliveryStatusResponse.fareye_sub_status_description = "RESCHEDULED";
						farEyeDeliveryStatusResponse.status_received_at = deliveryUpdate.RescheduledInstallDate;
					}

					if (deliveryUpdate != null && !string.IsNullOrEmpty(deliveryUpdate.CancelDate) && !string.IsNullOrEmpty(deliveryUpdate.InstallStatus) && !deliveryUpdate.InstallStatus.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
					{
						farEyeDeliveryStatusResponse.carrier_status = "CANCELLED";
						farEyeDeliveryStatusResponse.carrier_status_code = "CANCELLED";
						farEyeDeliveryStatusResponse.carrier_status_description = "CANCELLED";
						farEyeDeliveryStatusResponse.carrier_sub_status = "CANCELLED";
						farEyeDeliveryStatusResponse.carrier_sub_status_description = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_status = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_status_code = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_status_description = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_sub_status = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_sub_status_code = "CANCELLED";
						farEyeDeliveryStatusResponse.fareye_sub_status_description = "CANCELLED";
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
				LineDescriptionDetails = new LineDescriptionDetails() { LineDescription = new LineDescription() { BillOfLadingIndicator = x.serial_barcode } }
			}));

			electroluxOrderDetail.Body.Order.OrderHeader = new OrderHeader()
			{
				SenderID = orderDetail.reference_id
				// ,RecieverID = string.Empty
				,OriginalOrderNumber = orderDetail.order_number
				,OrderNumber = orderDetail.tracking_number
				,Action = "Add"
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