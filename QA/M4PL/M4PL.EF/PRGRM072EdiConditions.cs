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
    
    public partial class PRGRM072EdiConditions
    {
        public long Id { get; set; }
        public Nullable<long> PecParentProgramId { get; set; }
        public Nullable<long> PecProgramId { get; set; }
        public string PecJobField { get; set; }
        public string PecCondition { get; set; }
        public string PerLogical { get; set; }
        public string PecJobField2 { get; set; }
        public string PecCondition2 { get; set; }
        public int StatusId { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual PRGRM000Master PRGRM000Master { get; set; }
    }
}
