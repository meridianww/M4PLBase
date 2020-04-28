using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using M4PL.Entities.XCBL.Electrolux;

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

				if(xCBLSummaryHeaderModel.CopiedGatewayIds == null)
				{
					xCBLSummaryHeaderModel.CopiedGatewayIds = new List<CopiedGateway>();
				}
                var uttGatewayIds = xCBLSummaryHeaderModel.CopiedGatewayIds.ToDataTable();

                var parameters = new List<Parameter>
            {
                new Parameter("@UttSummaryHeader",GetSummaryHeaderDT(xCBLSummaryHeaderModel.SummaryHeader)),
                new Parameter("@UttAddress", uttAddress,"xcbl.UttAddress"),
                new Parameter("@UttCustomAttribute",uttCustomAttribute ,"xcbl.UttCustomAttribute"),
                new Parameter("@UttUserDefinedField",uttUserDefinedField, "xcbl.UttUserDefinedField"),
				new Parameter("@UttLineDetail",uttLineDetail, "xcbl.UttLineDetail"),
                new Parameter("@UttCopiedGatewayIds",uttGatewayIds, "dbo.uttIDList")
                
            };

                result = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsertXcblData, parameters.ToArray(), false, true);
                return result;
            }
            catch(Exception ex)
            {
                _logger.Log(ex, "Exception occured in method PostXCBLSummaryHeader. Exception :" + ex.Message,"XCBL POST", Utilities.Logger.LogType.Error);
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
				new Parameter("@ProcessingDate", DateTime.UtcNow)
			};

				SqlSerializer.Default.Execute(StoredProceduresConstant.InsertJobDeliveryUpdateLog, parameters.ToArray(), true);
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error is happening while inserting data for Delivery update log", "InsertJobDeliveryUpdateLog", Utilities.Logger.LogType.Error);
			}
		}

		public static List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData()
		{
			return new List<DeliveryUpdateProcessingData>() { new DeliveryUpdateProcessingData() { JobId = 112, OrderNumber = "234" } };
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

                if (xcblSummaryHeader !=null && xcblSummaryHeader.Count > 0)
                {
                    xCBLSummaryHeaderModel = new XCBLSummaryHeaderModel();
                    xCBLSummaryHeaderModel.SummaryHeader = xcblSummaryHeader.First();
                }

                if(xcblAddress!=null && xcblAddress.Count > 0)
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
    }
}
