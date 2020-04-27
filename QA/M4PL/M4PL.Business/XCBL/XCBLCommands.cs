using M4PL.Entities;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using _jobEDIxCBLCommand = M4PL.DataAccess.Job.JobEDIXcblCommands;
using M4PL.Entities.Support;
using M4PL.Entities.Job;
using M4PL.Business.XCBL.ElectroluxOrderMapping;
using M4PL.Utilities;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Business.XCBL.HelperClasses;
using System.Xml.Serialization;
using System.Xml;
using System.IO;

namespace M4PL.Business.XCBL
{
	public class XCBLCommands : BaseCommands<XCBLToM4PLRequest>, IXCBLCommands
    {
		public int M4PLBusinessConfiguration { get; private set; }
		#region Public Methods

		public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public IList<XCBLToM4PLRequest> Get()
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
			JobCargoMapper cargoMapper = new JobCargoMapper();
			OrderHeader orderHeader = electroluxOrderDetails?.Body?.Order?.OrderHeader;
			string message = electroluxOrderDetails?.Header?.Message?.Subject;
            Task[] tasks = new Task[2];
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
						if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderCreation(electroluxOrderDetails) : jobDetails;
							processingJobDetail = jobDetails != null ? _jobCommands.Post(ActiveUser, jobDetails, false) : jobDetails;
							if (processingJobDetail.Id > 0)
							{
								InsertxCBLDetailsInTable(processingJobDetail.Id, electroluxOrderDetails);
								List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapper(electroluxOrderDetails?.Body?.Order?.OrderLineDetailList?.OrderLineDetail, processingJobDetail.Id);
								if (jobCargos != null && jobCargos.Count > 0)
								{
									_jobCommands.InsertJobCargoData(jobCargos, ActiveUser);
								}
							}
						}
						else if (string.Equals(orderHeader.Action, ElectroluxAction.Delete.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							Entities.Job.Job job = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderHeader.OrderNumber);
							if (job?.Id > 0)
							{
								InsertxCBLDetailsInTable(job.Id, electroluxOrderDetails);
								ProcessElectroluxOrderCancellationRequest(job);
							}
						}
					}
				}
				else if (!string.IsNullOrEmpty(message) && string.Equals(message, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase))
				{
					if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
					{
						jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderUpdation(electroluxOrderDetails) : jobDetails;
						processingJobDetail = jobDetails != null ? _jobCommands.Put(ActiveUser, jobDetails) : jobDetails;
						if (processingJobDetail.Id > 0)
						{
							InsertxCBLDetailsInTable(processingJobDetail.Id, electroluxOrderDetails);
							List<JobCargo> jobCargos = cargoMapper.ToJobCargoMapper(electroluxOrderDetails?.Body?.Order?.OrderLineDetailList?.OrderLineDetail, processingJobDetail.Id);
							if (jobCargos != null && jobCargos.Count > 0)
							{
								_jobCommands.InsertJobCargoData(jobCargos, ActiveUser);
							}
						}
					}
				}
			});

            Task.WaitAll(tasks);
            return new OrderResponse() { ClientMessageID = processingJobDetail?.Id > 0 ? processingJobDetail?.Id.ToString() : string.Empty , SenderMessageID = processingJobDetail?.JobCustomerSalesOrder, StatusCode = "Success", Subject = "Order" };
        }

		public XCBLToM4PLRequest Put(XCBLToM4PLRequest entity)
		{
			throw new NotImplementedException();
		}

		public DeliveryUpdateResponse ProcessElectroluxOrderDeliveryUpdate(DeliveryUpdate deliveryUpdate, long jobId)
		{
			return ElectroluxHelper.SendDeliveryUpdateRequestToElectrolux(ActiveUser, deliveryUpdate, jobId);
		}

		#endregion

		#region Private Methods

		private void ProcessElectroluxOrderCancellationRequest(Entities.Job.Job job)
		{
			_jobCommands.CancelJobByCustomerSalesOrderNumber(ActiveUser, job);
		}
		private Entities.Job.Job GetJobModelForElectroluxOrderCreation(ElectroluxOrderDetails electroluxOrderDetails)
		{
			Entities.Job.Job jobCreationData = null;
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
			long programId = M4PBusinessContext.ComponentSettings.ElectroluxProgramId;
			basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref jobCreationData, programId);
			addressMapper.ToJobAddressModel(orderDetails, ref jobCreationData);

			return jobCreationData;
		}
		private Entities.Job.Job GetJobModelForElectroluxOrderUpdation(ElectroluxOrderDetails electroluxOrderDetails)
		{
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			JobASNDataMapper jobASNDataMapper = new JobASNDataMapper();
			Entities.Job.Job existingJobData = null;
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
			if (orderDetails != null)
			{
				existingJobData = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderDetails.OrderNumber);
				if (existingJobData == null) { return existingJobData; }
				basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref existingJobData, (long)existingJobData.ProgramID);
				addressMapper.ToJobAddressModel(orderDetails, ref existingJobData);
				jobASNDataMapper.ToJobASNModel(orderDetails, ref existingJobData);
			}

			return existingJobData;
		}
		private XCBLSummaryHeaderModel GetSummaryHeaderModel(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            dynamic request;
            XCBLSummaryHeaderModel summaryHeader = new XCBLSummaryHeaderModel();
            if (xCBLToM4PLRequest.EntityId == (int)XCBLRequestType.ShippingSchedule)
            {
                List<long> copiedGatewayIds = new List<long>();
                request = ProcessShippingScheduleRequestForAWC(xCBLToM4PLRequest, ref copiedGatewayIds);
                //request = (XCBLToM4PLShippingScheduleRequest)xCBLToM4PLRequest.Request;
                summaryHeader.SummaryHeader = new SummaryHeader()
                {
                    CustomerReferenceNo = request.OrderNumber,
                    ProcessingDate = request.ScheduleIssuedDate,
                    SetPurpose = request.PurposeCoded,
                    SpecialNotes = request.ShippingInstruction,
                    Latitude = request.Latitude,
                    Longitude = request.Longitude,
                    LocationId = request.LocationID,
                    OrderType = request.OrderType,
                    ScheduledDeliveryDate = request.EstimatedArrivalDate
                };
                summaryHeader.Address = new List<Address>()
                {
                    new Address()
                    {
                        AddressTypeId = Convert.ToByte(xCBLAddressType.Consignee),
                        Address1 = request.Street,
                        Address2 = request.Streetsupplement1,
                        City = request.City,
                        CountryCode = request.RegionCoded ?? request.RegionCoded.Substring(0, 2),
                        State = request.RegionCoded ?? request.RegionCoded.Substring(2, 2),
                        Name = request.Name1
                    }
                };

                summaryHeader.CustomAttribute = new CustomAttribute()
                {

                };

                summaryHeader.UserDefinedField = new UserDefinedField()
                {
                    UDF01 = request.Other_FirstStop,
                    UDF02 = request.Other_Before7,
                    UDF03 = request.Other_Before9,
                    UDF04 = request.Other_Before12,
                    UDF05 = request.Other_SameDay,
                    UDF06 = request.Other_OwnerOccupied,
                };

                summaryHeader.LineDetail = new List<LineDetail>()
                {

                };
                List<CopiedGateway> gatewayIds =  new List<CopiedGateway>();
                copiedGatewayIds.ForEach(d => {
                    gatewayIds.Add(new CopiedGateway() { Id = d });
                });
                summaryHeader.CopiedGatewayIds = gatewayIds;

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
                        CountryCode = request.ShipToParty_RegionCoded ?? request.ShipToParty_RegionCoded.Substring(0, 2),
                        State = request.ShipToParty_RegionCoded ?? request.ShipToParty_RegionCoded.Substring(2, 2),
                        PostalCode = request.ShipToParty_PostalCode
                    },
                     new Address()
                    {
                        AddressTypeId = (int)xCBLAddressType.ShipFrom,
                        Name = request.ShipFromParty_Name1,
                        Address1 = request.ShipFromParty_Street,
                        Address2 = request.ShipFromParty_StreetSupplement1,
                        City = request.ShipFromParty_City,
                        CountryCode = request.ShipFromParty_RegionCoded ?? request.ShipFromParty_RegionCoded.Substring(0, 2),
                        State = request.ShipFromParty_RegionCoded ?? request.ShipFromParty_RegionCoded.Substring(2, 2),
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
						string.Format(format: "{0}-{1}-{2}", arg0: orderHeader?.ASNdata?.Shipdate.Substring(0, 4), arg1: orderHeader?.ASNdata.Shipdate?.Substring(4, 6), arg2: orderHeader?.ASNdata?.Shipdate.Substring(6, 8)).ToDate()
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
        private XCBLToM4PLShippingScheduleRequest ProcessShippingScheduleRequestForAWC(XCBLToM4PLRequest xCBLToM4PLRequest, ref List<long> copiedGatewayIds)
        {
            bool isChanged = false;
            bool isLatLongUpdatedFromXCBL = false;
            var request = Newtonsoft.Json.JsonConvert.DeserializeObject<XCBLToM4PLShippingScheduleRequest>(xCBLToM4PLRequest.Request.ToString());
            var existingJobData = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, request.OrderNumber);
            string actionCode = string.Empty;

            JobGateway jobGateway;
            List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList = _jobCommands.GetJobUpdateDecisionMaker();

            if (existingJobData.JobLatitude != request.Latitude || existingJobData.JobLongitude != request.Longitude)
            {
                isChanged = true;
                isLatLongUpdatedFromXCBL = true;
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "Latitude") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "Latitude").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                if (jobGateway.GwyCompleted)
                {
                    existingJobData.JobLatitude = existingJobData.JobLatitude != request.Latitude ? request.Latitude : existingJobData.JobLatitude;
                    existingJobData.JobLongitude = existingJobData.JobLongitude != request.Longitude ? request.Longitude : existingJobData.JobLongitude;
                }

                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }

            }

            if (existingJobData.JobDeliveryDateTimeActual.HasValue && (request.EstimatedArrivalDate - Convert.ToDateTime(existingJobData.JobDeliveryDateTimeActual)).Hours <= 48)
            {
                isChanged = true;
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "ScheduledDeliveryDate") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "ScheduledDeliveryDate").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, "");

                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }
            }

            if (request.Other_Before7 == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF02") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF02").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }
            }
            else if (request.Other_Before7 == "N")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF02") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF02").ActionCode : string.Empty;
                _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
            }

            if (request.Other_Before9 == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF03") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF03").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }
            }
            else if (request.Other_Before9 == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF03") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF03").ActionCode : string.Empty;
                _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
            }

            if (isChanged)
            {
                _jobCommands.Put(ActiveUser, existingJobData, isLatLongUpdatedFromXCBL);
            }
            return request;

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
				EdtTypeId = M4PBusinessContext.ComponentSettings.XCBLEDTType,
				EdtData = orderXml,
				TransactionDate = DateTime.UtcNow,
				EdtTitle = string.Equals(message, ElectroluxMessage.Order.ToString(), StringComparison.OrdinalIgnoreCase) 
				? string.Format("{0} {1}", message, orderDetails?.Body?.Order?.OrderHeader.Action) : message
			});
		}

		#endregion
	}
}
