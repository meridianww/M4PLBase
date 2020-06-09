using System;

namespace M4PL.Entities.Job
{
    public class JobAdvanceReport : BaseModel
    {
        //public long Id { get; set; }
        public string CustTitle { get; set; }
        public DateTime? JobOrderedDate { get; set; }
        public string JobBOL { get; set; }
        public DateTime? JobOriginDateTimePlanned { get; set; }
        public DateTime? JobDeliveryDateTimePlanned { get; set; }
        //public int StatusId { get; set; }
        public string JobGatewayStatus { get; set; }
        public string JobDeliverySiteName { get; set; }
        public string JobCustomerSalesOrder { get; set; }
        public string JobManifestNo { get; set; }
        public string PlantIDCode { get; set; }
        public string JobSellerSiteName { get; set; }
        public string JobDeliveryStreetAddress { get; set; }
        public string JobDeliveryStreetAddress2 { get; set; }
        public string JobDeliveryCity { get; set; }
        public string JobDeliveryState { get; set; }
        public string JobDeliveryPostalCode { get; set; }
        public string JobDeliverySitePOC { get; set; }
        public string JobDeliverySitePOCPhone { get; set; }
        public string JobDeliverySitePOCPhone2 { get; set; }
        public string JobSellerSitePOCEmail { get; set; }
        public string JobServiceMode { get; set; }
        public DateTime? JobOriginDateTimeActual { get; set; }
        public DateTime? JobDeliveryDateTimeActual { get; set; }
        public string JobCustomerPurchaseOrder { get; set; }
        public decimal? JobTotalCubes { get; set; }
        public int? TotalParts { get; set; }
        public string JobNotes { get; set; }
        public string JobCarrierContract { get; set; }
        public int? TotalQuantity { get; set; }
        public string JobSiteCode { get; set; }
        public int JobWeightUnitTypeId { get; set; }
        public int CgoPackagingTypeId { get; set; }
        public int JobPartsOrdered { get; set; }
        public string CargoTitle { get; set; }
    }
}
