//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace M4PL.EF
{
    using System;
    using System.Collections.Generic;
    
    public partial class EDI210Invoice
    {
        public long einInvoiceID { get; set; }
        public string einTradingPartner { get; set; }
        public string einShipmentID { get; set; }
        public string einPaymentType { get; set; }
        public string einCurrencyCode { get; set; }
        public string einInvoiceDate { get; set; }
        public Nullable<decimal> einTotalAmountDue { get; set; }
        public string einDeliveryDate { get; set; }
        public string einSCACCode { get; set; }
        public string einPickupDate { get; set; }
        public Nullable<decimal> einTotalWeight { get; set; }
        public string einShipperName { get; set; }
        public Nullable<long> einShipperNameID { get; set; }
        public string einShipperAddress1 { get; set; }
        public string einShipperAddress2 { get; set; }
        public string einShipperCity { get; set; }
        public string einShipperState { get; set; }
        public string einShipperPostalCode { get; set; }
        public string einShipperCountryCode { get; set; }
        public string einShipFromName { get; set; }
        public Nullable<long> einShipFromNameID { get; set; }
        public string einShipFromAddress1 { get; set; }
        public string einShipFromAddress2 { get; set; }
        public string einShipFromCity { get; set; }
        public string einShipFromState { get; set; }
        public string einShipFromPostalCode { get; set; }
        public string einShipFromCountryCode { get; set; }
        public string einConsigneeName { get; set; }
        public Nullable<long> einConsigneeNameID { get; set; }
        public string einConsigneeAddress1 { get; set; }
        public string einConsigneeAddress2 { get; set; }
        public string einConsigneeCity { get; set; }
        public string einConsigneeState { get; set; }
        public string einConsigneePostalCode { get; set; }
        public string einConsigneeCountryCode { get; set; }
        public string einShipToName { get; set; }
        public Nullable<long> einShipToNameID { get; set; }
        public string einShipToAddress1 { get; set; }
        public string einShipToAddress2 { get; set; }
        public string einShipToCity { get; set; }
        public string einShipToState { get; set; }
        public string einShipToPostalCode { get; set; }
        public string einShipToCountryCode { get; set; }
        public string einBillToName { get; set; }
        public string einBillToAddress1 { get; set; }
        public string einBillToAddress2 { get; set; }
        public string einBillToCity { get; set; }
        public string einBillToState { get; set; }
        public string einBillToPostalCode { get; set; }
        public string einBillToCountryCode { get; set; }
        public Nullable<decimal> einWeight { get; set; }
        public string einWeightQualifier { get; set; }
        public string einLadingDescription { get; set; }
        public string einCommodityCode { get; set; }
        public Nullable<long> einPieces { get; set; }
        public Nullable<decimal> einFreightCharge { get; set; }
        public Nullable<decimal> einFuelSurcharge { get; set; }
        public Nullable<decimal> einVolume { get; set; }
        public string einVolumeQualifier { get; set; }
        public string einAdditionalHandling { get; set; }
        public string einCabinetReturn { get; set; }
        public string einGoodSalesTax { get; set; }
        public string einHarmonizedServiceTax { get; set; }
        public string einInsideDelivery { get; set; }
        public string einMinimumCharge { get; set; }
        public string einOutOfRangeMiles { get; set; }
        public string einPickupCharge { get; set; }
        public string einReconsignment { get; set; }
        public string einRedeliveryAttempt { get; set; }
        public string einHolidayOrWeekendDelivery { get; set; }
        public string einSpecialDelivery { get; set; }
        public string einStairsExcessDelivery { get; set; }
        public string einStorage { get; set; }
        public string einStanisciHandling { get; set; }
        public string einUnloadingFee { get; set; }
        public string einBridgeToll { get; set; }
        public string einExtraLabor { get; set; }
        public string einHighwayToll { get; set; }
        public string einAccessorial1 { get; set; }
        public string einAccessorial2 { get; set; }
        public string einAccessorial3 { get; set; }
        public string einAccessorial4 { get; set; }
        public string einAccessorial5 { get; set; }
        public string einAccessorial6 { get; set; }
        public string einAccessorial7 { get; set; }
        public string einAccessorial8 { get; set; }
        public string einAccessorial9 { get; set; }
        public string einAccessorial10 { get; set; }
        public string ProFlags02 { get; set; }
        public string ProFlags03 { get; set; }
        public string ProFlags04 { get; set; }
        public string ProFlags05 { get; set; }
        public string ProFlags06 { get; set; }
        public string ProFlags07 { get; set; }
        public string ProFlags08 { get; set; }
        public string ProFlags09 { get; set; }
        public string ProFlags10 { get; set; }
        public string ProFlags11 { get; set; }
        public string ProFlags12 { get; set; }
        public string ProFlags13 { get; set; }
        public string ProFlags14 { get; set; }
        public string ProFlags15 { get; set; }
        public string ProFlags16 { get; set; }
        public string ProFlags17 { get; set; }
        public string ProFlags18 { get; set; }
        public string ProFlags19 { get; set; }
        public string ProFlags20 { get; set; }
        public string einInvoiceNumber { get; set; }
        public Nullable<int> einFuelSurchargeQty { get; set; }
        public Nullable<int> einAdditionalHandlingQty { get; set; }
        public Nullable<int> einCabinetReturnQty { get; set; }
        public Nullable<int> einGoodSalesTaxQty { get; set; }
        public Nullable<int> einHarmonizedServiceTaxQty { get; set; }
        public Nullable<int> einInsideDeliveryQty { get; set; }
        public Nullable<int> einMinimumChargeQty { get; set; }
        public Nullable<int> einOutOfRangeMilesQty { get; set; }
        public Nullable<int> einPickupChargeQty { get; set; }
        public Nullable<int> einReconsignmentQty { get; set; }
        public Nullable<int> einRedeliveryAttemptQty { get; set; }
        public Nullable<int> einHolidayOrWeekendDeliveryQty { get; set; }
        public Nullable<int> einSpecialDeliveryQty { get; set; }
        public Nullable<int> einStairsExcessDeliveryQty { get; set; }
        public Nullable<int> einStorageQty { get; set; }
        public Nullable<int> einStanisciHandlingQty { get; set; }
        public Nullable<int> einUnloadingFeeQty { get; set; }
        public Nullable<int> einBridgeTollQty { get; set; }
        public Nullable<int> einExtraLaborQty { get; set; }
        public Nullable<int> einHighwayTollQty { get; set; }
        public Nullable<int> einAccessorial1Qty { get; set; }
        public Nullable<int> einAccessorial2Qty { get; set; }
        public Nullable<int> einAccessorial3Qty { get; set; }
        public Nullable<int> einAccessorial4Qty { get; set; }
        public Nullable<int> einAccessorial5Qty { get; set; }
        public Nullable<int> einAccessorial6Qty { get; set; }
        public Nullable<int> einAccessorial7Qty { get; set; }
        public Nullable<int> einAccessorial8Qty { get; set; }
        public Nullable<int> einAccessorial9Qty { get; set; }
        public Nullable<int> einAccessorial10Qty { get; set; }
    }
}
