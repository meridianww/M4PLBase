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
    
    public partial class SYSTM000Ref_Dashboard
    {
        public long Id { get; set; }
        public Nullable<long> OrganizationId { get; set; }
        public Nullable<int> DshMainModuleId { get; set; }
        public string DshName { get; set; }
        public byte[] DshTemplate { get; set; }
        public string DshDescription { get; set; }
        public bool DshIsDefault { get; set; }
        public Nullable<int> StatusId { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
    }
}
