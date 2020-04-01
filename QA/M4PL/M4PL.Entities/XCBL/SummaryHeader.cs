using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL
{
    public class SummaryHeader
    {
        public long SummaryHeaderId { get; set; }
        public string TradingPartner { get; set; }
        public long? GroupControlNo { get; set; }
        public string BOLNo { get; set; }
        public string MasterBOLNo { get; set; }
        public string MethodOfPayment { get; set; }
        public string SetPurpose { get; set; }
        public string CustomerReferenceNo { get; set; }
        public string ShipDescription { get; set; }
        public string OrderType { get; set; }
        public string PurchaseOrderNo { get; set; }
        public DateTime? ShipDate { get; set; }
        public DateTime? ArrivalDate3PL { get; set; }
        public string ServiceMode { get; set; }
        public string ProductType { get; set; }
        public string ReasonCodeCancellation { get; set; }
        public string ManifestNo { get; set; }
        public decimal? TotalWeight { get; set; }
        public decimal? TotalCubicFeet { get; set; }
        public long? TotalPieces { get; set; }
        public string DeliveryCommitmentType { get; set; }
        public DateTime? ScheduledPickupDate { get; set; }
        public DateTime? ScheduledDeliveryDate { get; set; }
        public string SpecialNotes { get; set; }
        public DateTime? OrderedDate { get; set; }
        public string TextData { get; set; }
        public string LocationId { get; set; }
        public string LocationNumber { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public bool isxcblAcceptanceRequired { get; set; }
        public bool isxcblProcessed { get; set; }
        public bool isxcblRejected { get; set; }
        public DateTime? ProcessingDate { get; set; }
        public DateTime? DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public DateTime? DateChanged { get; set; }
        public string ChangedBy { get; set; }
    }
}
