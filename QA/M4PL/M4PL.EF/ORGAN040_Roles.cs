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
    
    public partial class ORGAN040_Roles
    {
        public long Id { get; set; }
        public Nullable<long> OrgID { get; set; }
        public string OrgRoleCode { get; set; }
        public string OrgRoleTitle { get; set; }
        public Nullable<bool> OrgRoleDefault { get; set; }
        public Nullable<int> StatusId { get; set; }
        public System.DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
    }
}
