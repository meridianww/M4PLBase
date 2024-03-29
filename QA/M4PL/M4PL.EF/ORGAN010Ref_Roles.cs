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
    
    public partial class ORGAN010Ref_Roles
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ORGAN010Ref_Roles()
        {
            this.CONTC010Bridge = new HashSet<CONTC010Bridge>();
            this.PRGRM020Program_Role = new HashSet<PRGRM020Program_Role>();
            this.SYSTM000OpnSezMe = new HashSet<SYSTM000OpnSezMe>();
            this.SYSTM000SecurityByRole = new HashSet<SYSTM000SecurityByRole>();
        }
    
        public long Id { get; set; }
        public Nullable<int> OrgRoleSortOrder { get; set; }
        public string OrgRoleCode { get; set; }
        public Nullable<bool> OrgRoleDefault { get; set; }
        public string OrgRoleTitle { get; set; }
        public byte[] OrgRoleDescription { get; set; }
        public byte[] OrgComments { get; set; }
        public Nullable<bool> PrxJobDefaultAnalyst { get; set; }
        public Nullable<bool> PrxJobDefaultResponsible { get; set; }
        public Nullable<bool> PrxJobGWDefaultAnalyst { get; set; }
        public Nullable<bool> PrxJobGWDefaultResponsible { get; set; }
        public System.DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC010Bridge> CONTC010Bridge { get; set; }
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Program_Role> PRGRM020Program_Role { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000OpnSezMe> SYSTM000OpnSezMe { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000SecurityByRole> SYSTM000SecurityByRole { get; set; }
    }
}
