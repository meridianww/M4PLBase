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
    
    public partial class SYSTM000Ref_States
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SYSTM000Ref_States()
        {
            this.CONTC000Master = new HashSet<CONTC000Master>();
            this.CONTC000Master1 = new HashSet<CONTC000Master>();
        }
    
        public int Id { get; set; }
        public string StateAbbr { get; set; }
        public string StateName { get; set; }
        public Nullable<bool> StateIsDefault { get; set; }
        public System.DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master1 { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
    }
}
