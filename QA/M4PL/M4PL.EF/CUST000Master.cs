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
    
    public partial class CUST000Master
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CUST000Master()
        {
            this.CUST020BusinessTerms = new HashSet<CUST020BusinessTerms>();
            this.CUST030DocumentReference = new HashSet<CUST030DocumentReference>();
            this.CUST040DCLocations = new HashSet<CUST040DCLocations>();
            this.CUST050Finacial_Cal = new HashSet<CUST050Finacial_Cal>();
            this.DriverScrubReportMaster = new HashSet<DriverScrubReportMaster>();
            this.PRGRM000Master = new HashSet<PRGRM000Master>();
            this.PRGRM041ProgramCostRate = new HashSet<PRGRM041ProgramCostRate>();
        }
    
        public long Id { get; set; }
        public string CustERPID { get; set; }
        public Nullable<int> CustItemNumber { get; set; }
        public string CustCode { get; set; }
        public string CustTitle { get; set; }
        public byte[] CustDescription { get; set; }
        public Nullable<int> CustContacts { get; set; }
        public byte[] CustLogo { get; set; }
        public byte[] CustNotes { get; set; }
        public string CustWebPage { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        public virtual CONTC000Master CONTC000Master1 { get; set; }
        public virtual CONTC000Master CONTC000Master2 { get; set; }
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST020BusinessTerms> CUST020BusinessTerms { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST030DocumentReference> CUST030DocumentReference { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST040DCLocations> CUST040DCLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST050Finacial_Cal> CUST050Finacial_Cal { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DriverScrubReportMaster> DriverScrubReportMaster { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM000Master> PRGRM000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate { get; set; }
    }
}
