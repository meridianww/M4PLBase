#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.XCBL
{
    public class XCBLCommands : BaseCommands<XCBLSummaryHeaderModel>
    {
        public static long InsertxCBLDetailsInDB(XCBLSummaryHeaderModel xCBLSummaryHeaderModel)
        {
            try
            {
                long result = 0;
                var uttAddress = xCBLSummaryHeaderModel.Address.ToDataTable();
                uttAddress.RemoveColumnsFromDataTable(new List<string> { "AddressId" });

                var uttCustomAttribute = new List<CustomAttribute> { xCBLSummaryHeaderModel.CustomAttribute }.ToDataTable();
                uttCustomAttribute.RemoveColumnsFromDataTable(new List<string> { "CustomAttributeId" });

                var uttUserDefinedField = new List<UserDefinedField> { xCBLSummaryHeaderModel.UserDefinedField }.ToDataTable();
                uttUserDefinedField.RemoveColumnsFromDataTable(new List<string> { "UserDefinedFieldId" });

                var uttLineDetail = xCBLSummaryHeaderModel.LineDetail.ToDataTable();
                uttLineDetail.RemoveColumnsFromDataTable(new List<string> { "LineDetailId" });

                if (xCBLSummaryHeaderModel.CopiedGatewayIds == null)
                {
                    xCBLSummaryHeaderModel.CopiedGatewayIds = new List<CopiedGateway>();
                }
                var uttGatewayIds = xCBLSummaryHeaderModel.CopiedGatewayIds.ToDataTable();

                var parameters = new List<Parameter>
            {
                new Parameter("@UttSummaryHeader",GetSummaryHeaderDT(xCBLSummaryHeaderModel.SummaryHeader), "xcbl.UttSummaryHeader"),
                new Parameter("@UttAddress", uttAddress,"xcbl.UttAddress"),
                new Parameter("@UttCustomAttribute",uttCustomAttribute ,"xcbl.UttCustomAttribute"),
                new Parameter("@UttUserDefinedField",uttUserDefinedField, "xcbl.UttUserDefinedField"),
                new Parameter("@UttLineDetail",uttLineDetail, "xcbl.UttLineDetail"),
                new Parameter("@UttCopiedGatewayIds",uttGatewayIds, "dbo.uttIDList")

            };

                result = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsertXcblData, parameters.ToArray(), false, true);
                return result;
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method PostXCBLSummaryHeader. Exception :" + ex.Message, "XCBL POST", Utilities.Logger.LogType.Error);
                return -1;
            }
        }

        public static DataTable GetSummaryHeaderDT(SummaryHeader summaryHeader)
        {
            if (summaryHeader == null)
            {
                throw new ArgumentNullException("summaryHeaderList", "JobCommands.summaryHeaderList() - Argument null Exception");
            }

            using (var summaryHeaderUtt = new DataTable("UttSummaryHeader"))
            {
                summaryHeaderUtt.Locale = CultureInfo.InvariantCulture;
                summaryHeaderUtt.Columns.Add("TradingPartner");
                summaryHeaderUtt.Columns.Add("GroupControlNo");
                summaryHeaderUtt.Columns.Add("BOLNo");
                summaryHeaderUtt.Columns.Add("MasterBOLNo");
                summaryHeaderUtt.Columns.Add("MethodOfPayment");
                summaryHeaderUtt.Columns.Add("SetPurpose");
                summaryHeaderUtt.Columns.Add("CustomerReferenceNo");
                summaryHeaderUtt.Columns.Add("ShipDescription");
                summaryHeaderUtt.Columns.Add("OrderType");
                summaryHeaderUtt.Columns.Add("PurchaseOrderNo");
                summaryHeaderUtt.Columns.Add("ShipDate");
                summaryHeaderUtt.Columns.Add("ArrivalDate3PL");
                summaryHeaderUtt.Columns.Add("ServiceMode");
                summaryHeaderUtt.Columns.Add("ProductType");
                summaryHeaderUtt.Columns.Add("ReasonCodeCancellation");
                summaryHeaderUtt.Columns.Add("ManifestNo");
                summaryHeaderUtt.Columns.Add("TotalWeight");
                summaryHeaderUtt.Columns.Add("TotalCubicFeet");
                summaryHeaderUtt.Columns.Add("TotalPieces");
                summaryHeaderUtt.Columns.Add("DeliveryCommitmentType");
                summaryHeaderUtt.Columns.Add("ScheduledPickupDate");
                summaryHeaderUtt.Columns.Add("ScheduledDeliveryDate");
                summaryHeaderUtt.Columns.Add("SpecialNotes");
                summaryHeaderUtt.Columns.Add("OrderedDate");
                summaryHeaderUtt.Columns.Add("TextData");
                summaryHeaderUtt.Columns.Add("LocationId");
                summaryHeaderUtt.Columns.Add("LocationNumber");
                summaryHeaderUtt.Columns.Add("Latitude");
                summaryHeaderUtt.Columns.Add("Longitude");
                summaryHeaderUtt.Columns.Add("isxcblAcceptanceRequired");
                summaryHeaderUtt.Columns.Add("isxcblProcessed");
                summaryHeaderUtt.Columns.Add("isxcblRejected");
                summaryHeaderUtt.Columns.Add("ProcessingDate");
                summaryHeaderUtt.Columns.Add("Action");
                summaryHeaderUtt.Columns.Add("TrailerNumber");
                summaryHeaderUtt.Columns.Add("DateEntered");
                summaryHeaderUtt.Columns.Add("EnteredBy");
                summaryHeaderUtt.Columns.Add("DateChanged");
                summaryHeaderUtt.Columns.Add("ChangedBy");

                var row = summaryHeaderUtt.NewRow();
                row["TradingPartner"] = summaryHeader.TradingPartner;
                row["GroupControlNo"] = summaryHeader.GroupControlNo;
                row["BOLNo"] = summaryHeader.BOLNo;
                row["MasterBOLNo"] = summaryHeader.MasterBOLNo;
                row["MethodOfPayment"] = summaryHeader.MethodOfPayment;
                row["SetPurpose"] = summaryHeader.SetPurpose;
                row["CustomerReferenceNo"] = summaryHeader.CustomerReferenceNo;
                row["ShipDescription"] = summaryHeader.ShipDescription;
                row["OrderType"] = summaryHeader.OrderType;
                row["PurchaseOrderNo"] = summaryHeader.PurchaseOrderNo;
                row["ShipDate"] = summaryHeader.ShipDate;
                row["ArrivalDate3PL"] = summaryHeader.ArrivalDate3PL;
                row["ServiceMode"] = summaryHeader.ServiceMode;
                row["ProductType"] = summaryHeader.ProductType;
                row["ReasonCodeCancellation"] = summaryHeader.ReasonCodeCancellation;
                row["ManifestNo"] = summaryHeader.ManifestNo;
                row["TotalWeight"] = summaryHeader.TotalWeight;
                row["TotalCubicFeet"] = summaryHeader.TotalCubicFeet;
                row["TotalPieces"] = summaryHeader.TotalPieces;
                row["DeliveryCommitmentType"] = summaryHeader.DeliveryCommitmentType;
                row["ScheduledPickupDate"] = summaryHeader.ScheduledPickupDate;
                row["ScheduledDeliveryDate"] = summaryHeader.ScheduledDeliveryDate;
                row["SpecialNotes"] = summaryHeader.SpecialNotes;
                row["OrderedDate"] = summaryHeader.OrderedDate;
                row["TextData"] = summaryHeader.TextData;
                row["LocationId"] = summaryHeader.LocationId;
                row["LocationNumber"] = summaryHeader.LocationNumber;
                row["Latitude"] = summaryHeader.Latitude;
                row["Longitude"] = summaryHeader.Longitude;
                row["isxcblAcceptanceRequired"] = summaryHeader.isxcblAcceptanceRequired;
                row["isxcblProcessed"] = summaryHeader.isxcblProcessed;
                row["isxcblRejected"] = summaryHeader.isxcblRejected;
                row["ProcessingDate"] = summaryHeader.ProcessingDate;
                row["Action"] = summaryHeader.Action;
                row["TrailerNumber"] = summaryHeader.TrailerNumber;
                row["DateEntered"] = summaryHeader.DateEntered;
                row["EnteredBy"] = summaryHeader.EnteredBy;
                row["DateChanged"] = summaryHeader.DateChanged;
                row["ChangedBy"] = summaryHeader.ChangedBy;
                summaryHeaderUtt.Rows.Add(row);
                summaryHeaderUtt.AcceptChanges();

                return summaryHeaderUtt;
            }
        }

        public static void InsertJobDeliveryUpdateLog(string deliveryUpdateXml, string deliveryUpdateResponseString, long jobId)
        {
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@JobId", jobId),
                new Parameter("@DeliveryUpdateRequest", deliveryUpdateXml),
                new Parameter("@DeliveryUpdateResponse", deliveryUpdateResponseString),
                new Parameter("@IsProcessed", string.IsNullOrEmpty(deliveryUpdateResponseString) ? false : true),
                new Parameter("@ProcessingDate", Utilities.TimeUtility.GetPacificDateTime())
            };

                SqlSerializer.Default.Execute(StoredProceduresConstant.InsertJobDeliveryUpdateLog, parameters.ToArray(), true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error is happening while inserting data for Delivery update log", "InsertJobDeliveryUpdateLog", Utilities.Logger.LogType.Error);
            }
        }

        public static DeliveryUpdate GetDeliveryUpdateModel(long jobId, ActiveUser activeUser)
        {
            DeliveryUpdate deliveryUpdateModel = null;
            SetCollection sets = new SetCollection();
            sets.AddSet("DeliveryUpdate");
            sets.AddSet<OrderLine>("OrderLine");
            sets.AddSet("CargoException");
            sets.AddSet("CargoExceptionInfo");
            var parameters = new List<Parameter>
                   {
                       new Parameter("@JobId", jobId)
                   };
            SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetxCBLDeliveryUpdateModel);
            List<dynamic> deliveryUpdate = sets.GetSet("DeliveryUpdate");
            var orderLine = sets.GetSet<OrderLine>("OrderLine");
            List<dynamic> cargoException = sets.GetSet("CargoException");
            List<dynamic> cargoExceptionInfo = sets.GetSet("CargoExceptionInfo");
            if (deliveryUpdate?.Count > 0)
            {
                deliveryUpdateModel = PopulateDeliveryUpdateModelData(deliveryUpdate);
            }

            if (deliveryUpdateModel != null)
            {
                if (orderLine != null && orderLine.Count > 0)
                {
                    deliveryUpdateModel.OrderLineDetail = new OrderLineDetails() { OrderLine = orderLine?.ToList() };
                    if (cargoException?.Count > 0)
                    {
                        foreach (var orderLineData in deliveryUpdateModel.OrderLineDetail.OrderLine)
                        {
                            PopulateCargoExceptionDetails(cargoException, cargoExceptionInfo, orderLineData);
                        }
                    }
                }
            }

            return deliveryUpdateModel;
        }

        public static List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData()
        {
            return SqlSerializer.Default.DeserializeMultiRecords<DeliveryUpdateProcessingData>(
                    StoredProceduresConstant.GetDeliveryUpdateProcessingData, parameter: null, storedProcedure: true);
        }

        public static bool InsertDeliveryUpdateProcessingLog(long jobId, long customerId)
        {
            bool result = true;
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@JobId", jobId),
                new Parameter("@customerId", customerId)
            };
                SqlSerializer.Default.Execute(StoredProceduresConstant.InsertDeliveryUpdateProcessingLog, parameters.ToArray(), true);
            }
            catch (Exception exp)
            {
                result = false;
                _logger.Log(exp, "Error occurred while inserting the delivery processing log data", "InsertDeliveryUpdateProcessingLog", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static bool UpdateDeliveryUpdateProcessingLog(DeliveryUpdateProcessingData deliveryUpdateProcessingData)
        {
            bool result = true;
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@Id", deliveryUpdateProcessingData.Id),
                new Parameter("@IsProcessed", deliveryUpdateProcessingData.IsProcessed),
                new Parameter("@ProcessingDate", deliveryUpdateProcessingData.IsProcessed ? Utilities.TimeUtility.GetPacificDateTime() : (DateTime?)null)
            };
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateDeliveryUpdateProcessingLog, parameters.ToArray(), true);
            }
            catch (Exception exp)
            {
                result = false;
                _logger.Log(exp, "Error occurred while inserting the delivery processing log data", "InsertDeliveryUpdateProcessingLog", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static XCBLSummaryHeaderModel GetXCBLDataByCustomerReferenceNo(ActiveUser activeUser, string customerReferenceNo)
        {
            try
            {
                XCBLSummaryHeaderModel xCBLSummaryHeaderModel = null;
                SetCollection sets = new SetCollection();
                sets.AddSet<SummaryHeader>("SummaryHeader");
                sets.AddSet<Address>("Address");
                sets.AddSet<UserDefinedField>("UserDefinedField");
                sets.AddSet<CustomAttribute>("CustomAttribute");
                sets.AddSet<LineDetail>("LineDetail");


                var parameters = new List<Parameter>
                   {
                       new Parameter("@CustomerReferenceNo", customerReferenceNo),
                   };
                SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetXCBLDataBySummaryHeaderId);
                var xcblSummaryHeader = sets.GetSet<SummaryHeader>("SummaryHeader");
                var xcblAddress = sets.GetSet<Address>("Address");
                var xcblUserDefinedField = sets.GetSet<UserDefinedField>("UserDefinedField");
                var xcblCustomAttribute = sets.GetSet<CustomAttribute>("CustomAttribute");
                var xcblLineDetail = sets.GetSet<LineDetail>("LineDetail");

                if (xcblSummaryHeader != null && xcblSummaryHeader.Count > 0)
                {
                    xCBLSummaryHeaderModel = new XCBLSummaryHeaderModel();
                    xCBLSummaryHeaderModel.SummaryHeader = xcblSummaryHeader.First();
                }

                if (xcblAddress != null && xcblAddress.Count > 0)
                {
                    xCBLSummaryHeaderModel.Address = xcblAddress;
                }

                if (xcblUserDefinedField != null && xcblUserDefinedField.Count > 0)
                {
                    xCBLSummaryHeaderModel.UserDefinedField = xcblUserDefinedField.First();
                }

                if (xcblCustomAttribute != null && xcblCustomAttribute.Count > 0)
                {
                    xCBLSummaryHeaderModel.CustomAttribute = xcblCustomAttribute.First();
                }

                if (xcblLineDetail != null && xcblLineDetail.Count > 0)
                {
                    xCBLSummaryHeaderModel.LineDetail = xcblLineDetail;
                }

                return xCBLSummaryHeaderModel;
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method GetXCBLDataBySummaryHeaderId. Exception :" + ex.Message, "XCBL POST", Utilities.Logger.LogType.Error);
                return null;
            }
        }

        private static void PopulateCargoExceptionDetails(List<dynamic> cargoException, List<dynamic> cargoExceptionInfo, OrderLine orderLineData)
        {
            for (int currentCargoException = 0; currentCargoException < cargoException.Count; currentCargoException++)
            {
                if (cargoException[currentCargoException].ItemNumber == orderLineData.ItemNumber)
                {
                    orderLineData.Exceptions = new Exceptions() { HasExceptions = cargoException[currentCargoException].HasExceptions };
                    if ((bool)cargoException[currentCargoException]?.HasExceptions.Equals("True", StringComparison.OrdinalIgnoreCase))
                    {
                        for (int currentCargoExceptionInfo = 0; currentCargoExceptionInfo < cargoExceptionInfo.Count; currentCargoExceptionInfo++)
                        {
                            if (cargoExceptionInfo[currentCargoExceptionInfo].ItemNumber == orderLineData.ItemNumber)
                            {
                                orderLineData.Exceptions.ExceptionInfo = new ExceptionInfo()
                                {
                                    ExceptionCode = cargoExceptionInfo[currentCargoExceptionInfo].ExceptionCode,
                                    ExceptionDetail = cargoExceptionInfo[currentCargoExceptionInfo].ExceptionDetail
                                };
                            }
                        }
                    }
                }
            }
        }

        private static DeliveryUpdate PopulateDeliveryUpdateModelData(List<dynamic> deliveryUpdate)
        {
            DeliveryUpdate deliveryUpdateModel = new DeliveryUpdate()
            {
                ServiceProvider = deliveryUpdate[0].ServiceProvider,
                ServiceProviderID = deliveryUpdate[0].ServiceProviderID,
                OrderNumber = deliveryUpdate[0].OrderNumber,
                OrderDate = deliveryUpdate[0].OrderDate,
                SPTransactionID = deliveryUpdate[0].SPTransactionID,
                InstallStatus = deliveryUpdate[0].InstallStatus,
                InstallStatusTS = deliveryUpdate[0].InstallStatusTS,
                PlannedInstallDate = deliveryUpdate[0].PlannedInstallDate,
                ScheduledInstallDate = deliveryUpdate[0].ScheduledInstallDate,
                ActualInstallDate = deliveryUpdate[0].ActualInstallDate,
                RescheduledInstallDate = deliveryUpdate[0].RescheduledInstallDate,
                RescheduleReason = deliveryUpdate[0].RescheduleReason,
                CancelDate = deliveryUpdate[0].CancelDate,
                CancelReason = deliveryUpdate[0].CancelReason,
                AdditionalComments = deliveryUpdate[0].AdditionalComments,
                Exceptions = new Exceptions() { HasExceptions = deliveryUpdate[0].HasExceptions },
                POD = new POD() { DeliverySignature = new DeliverySignature() { SignedBy = deliveryUpdate[0].SignedBy }, DeliveryImages = new DeliveryImages() { } }
            };

            if ((bool)deliveryUpdate[0].HasExceptions?.Equals("True", StringComparison.OrdinalIgnoreCase))
            {
                deliveryUpdateModel.Exceptions.ExceptionInfo = new ExceptionInfo() { ExceptionCode = deliveryUpdate[0].ExceptionCode, ExceptionDetail = deliveryUpdate[0].ExceptionDetail };
            }

            return deliveryUpdateModel;
        }
    }
}
