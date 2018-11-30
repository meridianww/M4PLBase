namespace xCBLSoapWebService
{

    /// <summary>
    /// This class is used to store all the Shipping Schedule data that will be outputted to the csv file
    /// </summary>
    public class ShippingSchedule
    {
        public string ScheduleID { get; set; }
        public string ScheduleIssuedDate { get; set; }
        public string OrderNumber { get; set; }
        public string OrderType { get; set; }
        public string SequenceNumber { get; set; }
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
        public string StreetSupplement1 { get; set; }
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
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string LocationID { get; set; }
        public string EstimatedArrivalDate { get; set; }
        public string WorkOrderNumber { get; set; }
        public string SSID { get; set; }
    }
}