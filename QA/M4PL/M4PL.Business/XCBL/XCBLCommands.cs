using M4PL.Entities;
using M4PL.Entities.XCBL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;

namespace M4PL.Business.XCBL
{
    public class XCBLCommands : IXCBLCommands
    {
        public long PostXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            XCBLSummaryHeaderModel request = GetSummaryHeaderModel(xCBLToM4PLRequest);
            return _commands.PostXCBLSummaryHeader(request);
        }


        private XCBLSummaryHeaderModel GetSummaryHeaderModel(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            dynamic request;
            XCBLSummaryHeaderModel summaryHeader = new XCBLSummaryHeaderModel();
            if (xCBLToM4PLRequest.EntityId == (int)XCBLRequestType.ShippingSchedule)
            {
                request = (XCBLToM4PLShippingScheduleRequest)xCBLToM4PLRequest.Request;
                summaryHeader.SummaryHeader = new SummaryHeader()
                {
                    CustomerReferenceNo = request.OrderNumber,
                    ProcessingDate = request.ScheduleIssuedDate,
                    SetPurpose = request.PurposeCoded,
                    SpecialNotes = request.ShippingInstruction,
                    Latitude = request.Latitude,
                    Longitude = request.Longitude,
                    LocationId = request.LocationID
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

                };
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

    }
}
