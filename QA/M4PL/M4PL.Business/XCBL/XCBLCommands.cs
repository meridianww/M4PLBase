using M4PL.Entities;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using M4PL.Entities.Support;
using M4PL.Entities.Job;
using M4PL.Business.XCBL.ElectroluxOrderMapping;

namespace M4PL.Business.XCBL
{
    public class XCBLCommands : BaseCommands<Entities.XCBL.XCBLToM4PLRequest>, IXCBLCommands
    {
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
			Entities.Job.Job createdJobDetail = null;
			Entities.Job.Job jobDetails = null;
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
					if (orderHeader != null && string.IsNullOrEmpty(orderHeader.Action))
					{
						if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderCreation(electroluxOrderDetails) : jobDetails;
							createdJobDetail = jobDetails != null ? _jobCommands.Post(ActiveUser, jobDetails) : jobDetails;
						}
						else if (string.Equals(orderHeader.Action, ElectroluxAction.Delete.ToString(), StringComparison.OrdinalIgnoreCase))
						{
							ProcessElectroluxOrderCancellationRequest(orderHeader.OrderNumber);
						}
					}
				}
				else if (!string.IsNullOrEmpty(message) && string.Equals(message, ElectroluxMessage.ASN.ToString(), StringComparison.OrdinalIgnoreCase))
				{
					if (string.Equals(orderHeader.Action, ElectroluxAction.Add.ToString(), StringComparison.OrdinalIgnoreCase))
					{
						jobDetails = electroluxOrderDetails != null ? GetJobModelForElectroluxOrderUpdation(electroluxOrderDetails) : jobDetails;
						createdJobDetail = jobDetails != null ? _jobCommands.Put(ActiveUser, jobDetails) : jobDetails;
					}
					else if (string.Equals(orderHeader.Action, ElectroluxAction.Delete.ToString(), StringComparison.OrdinalIgnoreCase))
					{
						ProcessElectroluxOrderCancellationRequest(orderHeader.OrderNumber);
					}
				}
			});

            Task.WaitAll(tasks);
            return new OrderResponse() { ClientMessageID = createdJobDetail.Id.ToString(), SenderMessageID = createdJobDetail.JobCustomerSalesOrder, StatusCode = "Success", Subject = "Order" };
        }

		private void ProcessElectroluxOrderCancellationRequest(string orderNumber)
		{
			_jobCommands.CancelJobByCustomerSalesOrderNumber(ActiveUser, orderNumber);
		}

		public XCBLToM4PLRequest Put(XCBLToM4PLRequest entity)
		{
			throw new NotImplementedException();
		}

		private Entities.Job.Job GetJobModelForElectroluxOrderCreation(ElectroluxOrderDetails electroluxOrderDetails)
		{
			Entities.Job.Job jobCreationData = null;
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;				
			basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref jobCreationData, 20100);
			addressMapper.ToJobAddressModel(orderDetails, ref jobCreationData);

			return jobCreationData;
		}

		private Entities.Job.Job GetJobModelForElectroluxOrderUpdation(ElectroluxOrderDetails electroluxOrderDetails)
		{
			JobAddressMapper addressMapper = new JobAddressMapper();
			JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
			Entities.Job.Job existingJobData = null;
			var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
			if (orderDetails != null)
			{
				existingJobData = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderDetails.OrderNumber);
				if (existingJobData == null) { return existingJobData; }
				basicDetailMapper.ToJobBasicDetailModel(orderDetails, ref existingJobData, (long)existingJobData.ProgramID);
				addressMapper.ToJobAddressModel(orderDetails, ref existingJobData);
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
                summaryHeader.CopiedGatewayIds = copiedGatewayIds;

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
                    ShipDate = Convert.ToDateTime(request.RequestedShipByDate),
                    Latitude = request.EndTransportLocation_Latitude,
                    Longitude = request.EndTransportLocation_Longitude,
                    ManifestNo = request.Other_Manifest_RefNum,
                    SpecialNotes = request.ShippingInstructions,
                    OrderedDate = Convert.ToDateTime(request.Other_WorkOrder_RefDate),
                    ProcessingDate = Convert.ToDateTime(request.RequisitionIssueDate)
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
            if (electroluxOrderDetails != null)
            {
                var orderDetails = electroluxOrderDetails.Body.Order;
                if (orderDetails != null)
                {
                    string deliveryTime = orderDetails.OrderHeader != null ? orderDetails.OrderHeader.DeliveryTime : string.Empty;
                    deliveryTime = (string.IsNullOrEmpty(deliveryTime) && deliveryTime.Length >= 6) ?
                                       deliveryTime.Substring(0, 2) + ":" + deliveryTime.Substring(2, 2) + ":" +
                                       deliveryTime.Substring(4, 2) : "";

                    summaryHeader.SummaryHeader = new SummaryHeader()
                    {
                        OrderType = "Order",
                        PurchaseOrderNo = orderDetails.OrderHeader.CustomerPO,
                        ScheduledDeliveryDate = !string.IsNullOrEmpty(orderDetails.OrderHeader.DeliveryDate) && !string.IsNullOrEmpty(orderDetails.OrderHeader.DeliveryTime)
                        ? Convert.ToDateTime(string.Format("{0} {1}", orderDetails.OrderHeader.DeliveryDate, deliveryTime))
                        : !string.IsNullOrEmpty(orderDetails.OrderHeader.DeliveryDate) && string.IsNullOrEmpty(orderDetails.OrderHeader.DeliveryTime)
                        ? Convert.ToDateTime(orderDetails.OrderHeader.DeliveryDate) : (DateTime?)null,
                        OrderedDate = !string.IsNullOrEmpty(orderDetails.OrderHeader.OrderDate) ? Convert.ToDateTime(orderDetails.OrderHeader.OrderDate) : (DateTime?)null,
                        CustomerReferenceNo = orderDetails.OrderHeader.OrderNumber,
                        SetPurpose = orderDetails.OrderHeader.OrderType,
                        TradingPartner = orderDetails.OrderHeader.SenderID,
                        LocationId = orderDetails.OrderHeader.ShipFrom != null ? orderDetails.OrderHeader.ShipFrom.LocationID : null,
                        LocationNumber = orderDetails.OrderHeader.ShipTo != null ? orderDetails.OrderHeader.ShipTo.LocationName : null,
                    };

                    summaryHeader.Address = new List<Address>();

                    if (orderDetails.OrderHeader.ShipFrom != null)
                    {
                        summaryHeader.Address.Add(new Address()
                        {
                            AddressTypeId = (int)xCBLAddressType.ShipFrom,
                            Name = "ShipFrom",
                            Address1 = orderDetails.OrderHeader.ShipFrom.AddressLine1,
                            Address2 = orderDetails.OrderHeader.ShipFrom.AddressLine2,
                            StreetAddress3 = orderDetails.OrderHeader.ShipFrom.AddressLine3,
                            City = orderDetails.OrderHeader.ShipFrom.City,
                            State = orderDetails.OrderHeader.ShipFrom.State,
                            PostalCode = orderDetails.OrderHeader.ShipFrom.ZipCode,
                            CountryCode = orderDetails.OrderHeader.ShipFrom.Country,
                            ContactName = string.IsNullOrEmpty(orderDetails.OrderHeader.ShipFrom.ContactLastName)
                            ? orderDetails.OrderHeader.ShipFrom.ContactFirstName
                            : string.Format("{0} {1}", orderDetails.OrderHeader.ShipFrom.ContactFirstName, orderDetails.OrderHeader.ShipFrom.ContactLastName),
                            ContactNumber = orderDetails.OrderHeader.ShipFrom.ContactNumber,
                            ContactEmail = orderDetails.OrderHeader.ShipFrom.ContactEmailID,
                            LocationID = orderDetails.OrderHeader.ShipFrom.LocationID,
                            LocationName = orderDetails.OrderHeader.ShipFrom.LocationName,
                        });
                    }

                    if (orderDetails.OrderHeader.ShipTo != null)
                    {
                        summaryHeader.Address.Add(new Address()
                        {
                            AddressTypeId = (int)xCBLAddressType.ShipTo,
                            Name = "ShipTo",
                            Address1 = orderDetails.OrderHeader.ShipTo.AddressLine1,
                            Address2 = orderDetails.OrderHeader.ShipTo.AddressLine2,
                            StreetAddress3 = orderDetails.OrderHeader.ShipTo.AddressLine3,
                            City = orderDetails.OrderHeader.ShipTo.City,
                            State = orderDetails.OrderHeader.ShipTo.State,
                            PostalCode = orderDetails.OrderHeader.ShipTo.ZipCode,
                            CountryCode = orderDetails.OrderHeader.ShipTo.Country,
                            ContactName = string.IsNullOrEmpty(orderDetails.OrderHeader.ShipTo.ContactLastName)
                            ? orderDetails.OrderHeader.ShipTo.ContactFirstName
                            : string.Format("{0} {1}", orderDetails.OrderHeader.ShipTo.ContactFirstName, orderDetails.OrderHeader.ShipTo.ContactLastName),
                            ContactNumber = orderDetails.OrderHeader.ShipTo.ContactNumber,
                            ContactEmail = orderDetails.OrderHeader.ShipTo.ContactEmailID,
                            LocationID = orderDetails.OrderHeader.ShipTo.LocationID,
                            LocationName = orderDetails.OrderHeader.ShipTo.LocationName,
                        });
                    }

                    if (orderDetails.OrderHeader.DeliverTo != null)
                    {
                        summaryHeader.Address.Add(new Address()
                        {
                            AddressTypeId = (int)xCBLAddressType.Consignee,
                            Name = "Consignee",
                            Address1 = orderDetails.OrderHeader.DeliverTo.AddressLine1,
                            Address2 = orderDetails.OrderHeader.DeliverTo.AddressLine2,
                            StreetAddress3 = orderDetails.OrderHeader.DeliverTo.AddressLine3,
                            City = orderDetails.OrderHeader.DeliverTo.City,
                            State = orderDetails.OrderHeader.DeliverTo.State,
                            PostalCode = orderDetails.OrderHeader.DeliverTo.ZipCode,
                            CountryCode = orderDetails.OrderHeader.DeliverTo.Country,
                            ContactName = string.IsNullOrEmpty(orderDetails.OrderHeader.DeliverTo.ContactLastName)
                            ? orderDetails.OrderHeader.DeliverTo.ContactFirstName
                            : string.Format("{0} {1}", orderDetails.OrderHeader.DeliverTo.ContactFirstName, orderDetails.OrderHeader.DeliverTo.ContactLastName),
                            ContactNumber = orderDetails.OrderHeader.DeliverTo.ContactNumber,
                            ContactEmail = orderDetails.OrderHeader.DeliverTo.ContactEmailID,
                            LocationID = orderDetails.OrderHeader.DeliverTo.LocationID,
                            LocationName = orderDetails.OrderHeader.DeliverTo.LocationName,
                        });
                    }
                }

                summaryHeader.LineDetail = new List<LineDetail>();
                if (orderDetails.OrderLineDetailList != null && orderDetails.OrderLineDetailList.OrderLineDetail != null && orderDetails.OrderLineDetailList.OrderLineDetail.Count > 0)
                {
                    foreach (var orderLine in orderDetails.OrderLineDetailList.OrderLineDetail)
                    {
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
                        });
                    }
                }

                summaryHeader.CustomAttribute = new CustomAttribute()
                {

                };

                summaryHeader.UserDefinedField = new UserDefinedField()
                {

                };
            }

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
    }
}
