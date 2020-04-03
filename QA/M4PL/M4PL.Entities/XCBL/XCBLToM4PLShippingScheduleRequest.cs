using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL
{
    public class XCBLToM4PLShippingScheduleRequest
    {
        public Guid ScheduleID { get; set; }
        public DateTime ScheduleIssuedDate { get; set; }
        public string OrderNumber { get; set; }
        public int SequenceNumber { get; set; }
        public string Other_FirstStop { get; set; }
        public string Other_Before7 { get; set; }
        public string Other_Before9 { get; set; }
        public string Other_Before12 { get; set; }
        public string Other_SameDay { get; set; }
        public string Other_OwnerOccupied { get; set; }
        public string Other_7 { get; set; }
        public string Other_8 { get; set; }
        public string Other_9 { get; set; }
        public string Other_10 { get; set; }
        public string PurposeCoded { get; set; }
        public string ScheduleType { get; set; }
        public string AgencyCoded { get; set; }
        public string Name1 { get; set; }
        public string Street { get; set; }
        public string Streetsupplement1 { get; set; }
        public string PostalCode { get; set; }
        public string City { get; set; }
        public string RegionCoded { get; set; }
        public string ContactName { get; set; }
        public string ContactNumber_1 { get; set; }
        public string ContactNumber_2 { get; set; }
        public string ContactNumber_3 { get; set; }
        public string ContactNumber_4 { get; set; }
        public string ContactNumber_5 { get; set; }
        public string ContactNumber_6 { get; set; }
        public string ShippingInstruction { get; set; }
        public string GPSSystem { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string LocationID { get; set; }
        public DateTime EstimatedArrivalDate { get; set; }
        public string OrderType { get; set; }
        public string InitialResponse { get; set; }
    }
}
