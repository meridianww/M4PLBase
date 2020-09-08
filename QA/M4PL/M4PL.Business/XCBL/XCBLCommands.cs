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
            Entities.Job.Job existingJobDataInDB = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, orderHeader?.OrderNumber, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId);

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
                            processingJobDetail = jobDetails != null ? _jobCommands.Put(ActiveUser, jobDetails, isLatLongUpdatedFromXCBL: false, isRelatedAttributeUpdate: false, isServiceCall: true) : jobDetails;
                            if (processingJobDetail?.Id > 0)
                            {
                                InsertxCBLDetailsInTable(processingJobDetail.Id, electroluxOrderDetails);
								bool isFarEyePushRequired = false;
								_jobCommands.CopyJobGatewayFromProgramForXcBLForElectrolux(ActiveUser, processingJobDetail.Id, (long)processingJobDetail.ProgramID, "In Transit", M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, out isFarEyePushRequired);
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

        #endregion

        #region Private Methods

        private void ProcessElectroluxOrderCancellationRequest(Entities.Job.Job job)
        {
            _jobCommands.CancelJobByCustomerSalesOrderNumber(ActiveUser, job, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId);
        }
        private Entities.Job.Job GetJobModelForElectroluxOrderCreation(ElectroluxOrderDetails electroluxOrderDetails, List<SystemReference> systemOptionList)
        {
            Entities.Job.Job jobCreationData = null;
            JobAddressMapper addressMapper = new JobAddressMapper();
            JobBasicDetailMapper basicDetailMapper = new JobBasicDetailMapper();
            var orderDetails = electroluxOrderDetails.Body?.Order?.OrderHeader;
            var orderLineDetailList = electroluxOrderDetails.Body?.Order?.OrderLineDetailList;
            long programId = M4PBusinessContext.ComponentSettings.ElectroluxProgramId;
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
                        AddressTypeId = Convert.ToByte(xCBLAddressType.ShipTo),
                        Address1 = request.Street,
                        Address2 = request.Streetsupplement1,
                        City = request.City,
                        CountryCode = GetCountryCodeAndStateCode(request.RegionCoded,  true),
                        State = GetCountryCodeAndStateCode(request.RegionCoded,  false),
                        Name = request.Name1,
                        PostalCode = request.PostalCode
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
                List<CopiedGateway> gatewayIds = new List<CopiedGateway>();
                copiedGatewayIds.ForEach(d =>
                {
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
        private XCBLToM4PLShippingScheduleRequest ProcessShippingScheduleRequestForAWC(XCBLToM4PLRequest xCBLToM4PLRequest, ref List<long> copiedGatewayIds)
        {
            bool isChanged = false;
            bool isLatLongUpdatedFromXCBL = false;
            var request = Newtonsoft.Json.JsonConvert.DeserializeObject<XCBLToM4PLShippingScheduleRequest>(xCBLToM4PLRequest.Request.ToString());
            var existingJobData = _jobCommands.GetJobByCustomerSalesOrder(ActiveUser, request.OrderNumber, M4PBusinessContext.ComponentSettings.AWCCustomerId);
            string actionCode = string.Empty;

            JobGateway jobGateway;
            List<JobUpdateDecisionMaker> jobUpdateDecisionMakerList = _jobCommands.GetJobUpdateDecisionMaker();

            if (existingJobData.JobLatitude != request.Latitude || existingJobData.JobLongitude != request.Longitude)
            {
                isLatLongUpdatedFromXCBL = true;
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "Latitude") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "Latitude").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                if (jobGateway != null && jobGateway.GwyCompleted)
                {
                    isChanged = true;
                    existingJobData.JobLatitude = existingJobData.JobLatitude != request.Latitude ? request.Latitude : existingJobData.JobLatitude;
                    existingJobData.JobLongitude = existingJobData.JobLongitude != request.Longitude ? request.Longitude : existingJobData.JobLongitude;
                }

                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }
            }
            if (existingJobData.JobDeliveryPostalCode != request.PostalCode ||
                existingJobData.JobDeliveryCity != request.City)
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "City") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "City").ActionCode : string.Empty;
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                if (jobGateway != null && jobGateway.GwyCompleted)
                {
                    isChanged = true;
                    existingJobData.JobDeliveryCity = existingJobData.JobDeliveryCity != request.City ? request.City : existingJobData.JobDeliveryCity;
                    existingJobData.JobDeliveryPostalCode = existingJobData.JobDeliveryPostalCode != request.PostalCode ? request.PostalCode : existingJobData.JobDeliveryPostalCode;
                }

                if (jobGateway != null)
                {
                    copiedGatewayIds.Add(jobGateway.Id);
                }
            }

            if (existingJobData.JobDeliverySiteName != request.Name1 ||
                existingJobData.JobDeliveryStreetAddress != request.Street ||
                existingJobData.JobDeliveryStreetAddress2 != request.Streetsupplement1)
            {
                isChanged = true;
                existingJobData.JobDeliverySiteName = existingJobData.JobDeliverySiteName != request.Name1 ? request.Name1 : existingJobData.JobDeliverySiteName;
                existingJobData.JobDeliveryStreetAddress = existingJobData.JobDeliveryStreetAddress != request.Street ? request.Street : existingJobData.JobDeliveryStreetAddress;
                existingJobData.JobDeliveryStreetAddress2 = existingJobData.JobDeliveryStreetAddress2 != request.Streetsupplement1 ? request.Streetsupplement1 : existingJobData.JobDeliveryStreetAddress2;
            }

            if (existingJobData.JobDeliveryDateTimeActual.HasValue &&
                request.EstimatedArrivalDate.Subtract(Convert.ToDateTime(existingJobData.JobDeliveryDateTimeActual))
                .TotalHours <= 48)
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "XCBL-Date") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "XCBL-Date").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);

                        if (jobGateway.GwyCompleted)
                        {
                            isChanged = true;
                            existingJobData.JobDeliveryDateTimeActual = existingJobData.JobDeliveryDateTimeActual != request.EstimatedArrivalDate ? request.EstimatedArrivalDate : existingJobData.JobDeliveryDateTimeActual;
                        }
                    }
                }
            }

            if (request.Other_Before7 == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF02") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF02").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                        if (jobGateway.GwyCompleted)
                        {
                            isChanged = true;
                        }
                    }
                }
            }


            if (request.EstimatedArrivalDate.Subtract(Convert.ToDateTime(existingJobData.JobDeliveryDateTimePlanned)).TotalMinutes > 0)
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "ScheduledDeliveryDate") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "ScheduledDeliveryDate").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                        if (jobGateway.GwyCompleted)
                        {
                            isChanged = true;
                            existingJobData.JobDeliveryDateTimePlanned = request.EstimatedArrivalDate;
                        }
                    }
                }
            }

            else if (request.Other_Before7 == "N")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF02") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF02").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }

            if (request.Other_Before9 == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF03") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF03").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                    }
                }
            }

            else if (request.Other_Before9 == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF03") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF03").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }

            if (request.Other_Before12 == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF04") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF04").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                    }
                }
            }

            else if (request.Other_Before12 == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF04") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF04").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }

            if (request.Other_SameDay == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF05") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF05").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                    }
                }
            }

            else if (request.Other_SameDay == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF05") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF05").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }

            if (request.Other_FirstStop == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF01") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF01").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                    }
                }
            }

            else if (request.Other_FirstStop == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF01") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF01").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }

            if (request.Other_OwnerOccupied == "Y")
            {
                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF06") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF06").ActionCode : string.Empty;
                if (!string.IsNullOrEmpty(actionCode))
                {
                    jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);

                    if (jobGateway != null)
                    {
                        copiedGatewayIds.Add(jobGateway.Id);
                    }
                }
            }

            else if (request.Other_OwnerOccupied == "N")
            {

                actionCode = jobUpdateDecisionMakerList.Any(obj => obj.xCBLColumnName == "UDF06") ? jobUpdateDecisionMakerList.Find(obj => obj.xCBLColumnName == "UDF06").ActionCode : string.Empty;

                if (!string.IsNullOrEmpty(actionCode))
                {
                    _jobCommands.ArchiveJobGatewayForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, actionCode);
                }
            }


            if (!string.IsNullOrEmpty(request.ShippingInstruction))
            {
                jobGateway = _jobCommands.CopyJobGatewayFromProgramForXcBL(ActiveUser, existingJobData.Id, (long)existingJobData.ProgramID, "Comment", request.ShippingInstruction);
            }


            if (isChanged)
            {
                _jobCommands.Put(ActiveUser, existingJobData, isLatLongUpdatedFromXCBL);
            }

            InsertxCBLDetailsInTableForAWC(existingJobData.Id, request);
            
            return request;
        }

        private void InsertxCBLDetailsInTableForAWC(long jobId,XCBLToM4PLShippingScheduleRequest request)
        {
            _jobEDIxCBLCommand.Post(ActiveUser, new JobEDIXcbl()
            {
                JobId = jobId,
                EdtCode = "ASN",
                EdtTypeId = M4PBusinessContext.ComponentSettings.XCBLEDTType,
                EdtData = Newtonsoft.Json.JsonConvert.SerializeObject(request),
                TransactionDate = Utilities.TimeUtility.GetPacificDateTime(),
                EdtTitle = "ASN"
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
                EdtTypeId = M4PBusinessContext.ComponentSettings.XCBLEDTType,
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

        #endregion
    }
}
