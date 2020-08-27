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
    
    public partial class PRGRM043ProgramCostLocations
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PRGRM043ProgramCostLocations()
        {
            this.PRGRM041ProgramCostRate = new HashSet<PRGRM041ProgramCostRate>();
        }
    
        public long Id { get; set; }
        public Nullable<long> PclProgramID { get; set; }
        public Nullable<long> PclVendorID { get; set; }
        public Nullable<int> PclItemNumber { get; set; }
        public string PclLocationCode { get; set; }
        public string PclLocationCodeCustomer { get; set; }
        public string PclLocationTitle { get; set; }
        public string PclUserCode1 { get; set; }
        public string PclUserCode2 { get; set; }
        public string PclUserCode3 { get; set; }
        public string PclUserCode4 { get; set; }
        public string PclUserCode5 { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public int StatusId { get; set; }
        public Nullable<long> PclVenderLocationId { get; set; }
        public Nullable<long> PclVenderDCLocationId { get; set; }
    
        public virtual PRGRM000Master PRGRM000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate { get; set; }
        public virtual VEND000Master VEND000Master { get; set; }
    }
}
