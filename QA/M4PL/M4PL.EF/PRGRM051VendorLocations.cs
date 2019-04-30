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
    
    public partial class PRGRM051VendorLocations
    {
        public long Id { get; set; }
        public Nullable<long> PvlProgramID { get; set; }
        public Nullable<long> PvlVendorID { get; set; }
        public Nullable<int> PvlItemNumber { get; set; }
        public string PvlLocationCode { get; set; }
        public string PvlLocationCodeCustomer { get; set; }
        public string PvlLocationTitle { get; set; }
        public Nullable<long> PvlContactMSTRID { get; set; }
        public Nullable<int> StatusId { get; set; }
        public Nullable<System.DateTime> PvlDateStart { get; set; }
        public Nullable<System.DateTime> PvlDateEnd { get; set; }
        public string PvlUserCode1 { get; set; }
        public string PvlUserCode2 { get; set; }
        public string PvlUserCode3 { get; set; }
        public string PvlUserCode4 { get; set; }
        public string PvlUserCode5 { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        public virtual PRGRM000Master PRGRM000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual VEND000Master VEND000Master { get; set; }
    }
}
