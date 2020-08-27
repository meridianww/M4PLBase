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
    
    public partial class PRGRM031ShipApptmtReasonCodes
    {
        public long Id { get; set; }
        public Nullable<int> PacApptItem { get; set; }
        public string PacApptReasonCode { get; set; }
        public Nullable<int> PacApptLength { get; set; }
        public string PacApptInternalCode { get; set; }
        public string PacApptPriorityCode { get; set; }
        public string PacApptTitle { get; set; }
        public byte[] PacApptDescription { get; set; }
        public byte[] PacApptComment { get; set; }
        public Nullable<int> PacApptCategoryCodeId { get; set; }
        public string PacApptUser01Code { get; set; }
        public string PacApptUser02Code { get; set; }
        public string PacApptUser03Code { get; set; }
        public string PacApptUser04Code { get; set; }
        public string PacApptUser05Code { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual PRGRM000Master PRGRM000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
    }
}
