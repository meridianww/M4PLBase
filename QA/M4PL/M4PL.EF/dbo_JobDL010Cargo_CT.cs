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
    
    public partial class dbo_JobDL010Cargo_CT
    {
        public byte[] C___start_lsn { get; set; }
        public byte[] C___end_lsn { get; set; }
        public byte[] C___seqval { get; set; }
        public int C___operation { get; set; }
        public byte[] C___update_mask { get; set; }
        public Nullable<long> Id { get; set; }
        public Nullable<long> JobID { get; set; }
        public Nullable<int> CgoLineItem { get; set; }
        public string CgoPartNumCode { get; set; }
        public string CgoTitle { get; set; }
        public string CgoSerialNumber { get; set; }
        public string CgoMasterLabel { get; set; }
        public string CgoPackagingType { get; set; }
        public string CgoMasterCartonLabel { get; set; }
        public Nullable<decimal> CgoWeight { get; set; }
        public string CgoWeightUnits { get; set; }
        public Nullable<decimal> CgoLength { get; set; }
        public Nullable<decimal> CgoWidth { get; set; }
        public Nullable<decimal> CgoHeight { get; set; }
        public string CgoVolumeUnits { get; set; }
        public Nullable<decimal> CgoCubes { get; set; }
        public byte[] CgoNotes { get; set; }
        public Nullable<int> CgoQtyExpected { get; set; }
        public Nullable<int> CgoQtyOnHand { get; set; }
        public Nullable<int> CgoQtyDamaged { get; set; }
        public Nullable<int> CgoQtyOnHold { get; set; }
        public string CgoQtyUnits { get; set; }
        public Nullable<int> CgoQtyOrdered { get; set; }
        public Nullable<decimal> CgoQtyCounted { get; set; }
        public Nullable<int> CgoQtyShortOver { get; set; }
        public Nullable<int> CgoQtyOver { get; set; }
        public string CgoLongitude { get; set; }
        public string CgoLatitude { get; set; }
        public string CgoReasonCodeOSD { get; set; }
        public string CgoReasonCodeHold { get; set; }
        public Nullable<int> CgoSeverityCode { get; set; }
        public Nullable<int> StatusId { get; set; }
        public string ProFlags01 { get; set; }
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
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public Nullable<int> CgoPackagingTypeId { get; set; }
        public Nullable<int> CgoWeightUnitsId { get; set; }
        public Nullable<int> CgoVolumeUnitsId { get; set; }
        public Nullable<int> CgoQtyUnitsId { get; set; }
        public string CgoComment { get; set; }
        public Nullable<System.DateTime> CgoDateLastScan { get; set; }
    }
}
