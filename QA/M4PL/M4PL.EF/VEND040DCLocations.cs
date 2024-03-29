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
    
    public partial class VEND040DCLocations
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public VEND040DCLocations()
        {
            this.PRGRM040ProgramBillableRate = new HashSet<PRGRM040ProgramBillableRate>();
        }
    
        public long Id { get; set; }
        public Nullable<int> VdcItemNumber { get; set; }
        public string VdcLocationCode { get; set; }
        public string VdcCustomerCode { get; set; }
        public string VdcLocationTitle { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual VEND000Master VEND000Master { get; set; }
    }
}
