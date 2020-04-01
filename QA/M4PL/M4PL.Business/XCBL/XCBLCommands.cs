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
        public long PostXCBLSummaryHeader(XCBLToM4PLRequisitionRequest xCBLToM4PLRequisitionRequest)
        {
            return _commands.PostXCBLSummaryHeader(GetSummaryHeaderModel(xCBLToM4PLRequisitionRequest));
        }


        private XCBLSummaryHeaderModel GetSummaryHeaderModel(XCBLToM4PLRequisitionRequest xCBLToM4PLRequisitionRequest)
        {
            XCBLSummaryHeaderModel summaryHeader = new XCBLSummaryHeaderModel();
            summaryHeader.SummaryHeader = new SummaryHeader()
            {
                CustomerReferenceNo = xCBLToM4PLRequisitionRequest.OrderNumber,
                ProcessingDate = xCBLToM4PLRequisitionRequest.ScheduleIssuedDate,
                SetPurpose = xCBLToM4PLRequisitionRequest.PurposeCoded,
                SpecialNotes = xCBLToM4PLRequisitionRequest.ShippingInstruction,
                Latitude = xCBLToM4PLRequisitionRequest.Latitude,
                Longitude = xCBLToM4PLRequisitionRequest.Longitude,
                LocationId = xCBLToM4PLRequisitionRequest.LocationID
            };
            summaryHeader.Address = new Address()
            {
                AddressTypeId =Convert.ToByte(xCBLAddressType.Consignee),
                Address1 = xCBLToM4PLRequisitionRequest.Street,
                Address2 = xCBLToM4PLRequisitionRequest.Streetsupplement1,
                City = xCBLToM4PLRequisitionRequest.City,
                CountryCode = xCBLToM4PLRequisitionRequest.RegionCoded ?? xCBLToM4PLRequisitionRequest.RegionCoded.Substring(0, 2),
                State = xCBLToM4PLRequisitionRequest.RegionCoded ?? xCBLToM4PLRequisitionRequest.RegionCoded.Substring(2, 2),
                Name = xCBLToM4PLRequisitionRequest.Name1
            };

            summaryHeader.CustomAttribute = new CustomAttribute()
            {
                 
            };

            summaryHeader.UserDefinedField = new UserDefinedField()
            {

            };
            return summaryHeader;
        }

    }
}
