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
    
    public partial class VEND000Master
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public VEND000Master()
        {
            this.PRGRM051VendorLocations = new HashSet<PRGRM051VendorLocations>();
            this.VEND010Contacts = new HashSet<VEND010Contacts>();
            this.VEND020BusinessTerms = new HashSet<VEND020BusinessTerms>();
            this.VEND030DocumentReference = new HashSet<VEND030DocumentReference>();
            this.VEND040DCLocations = new HashSet<VEND040DCLocations>();
            this.VEND050Finacial_Cal = new HashSet<VEND050Finacial_Cal>();
        }
    
        public long Id { get; set; }
        public string VendERPID { get; set; }
        public Nullable<long> VendOrgID { get; set; }
        public Nullable<int> VendItemNumber { get; set; }
        public string VendCode { get; set; }
        public string VendTitle { get; set; }
        public byte[] VendDescription { get; set; }
        public Nullable<long> VendWorkAddressId { get; set; }
        public Nullable<long> VendBusinessAddressId { get; set; }
        public Nullable<long> VendCorporateAddressId { get; set; }
        public Nullable<int> VendContacts { get; set; }
        public byte[] VendLogo { get; set; }
        public byte[] VendNotes { get; set; }
        public Nullable<int> VendTypeId { get; set; }
        public string VendWebPage { get; set; }
        public Nullable<int> StatusId { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        public virtual CONTC000Master CONTC000Master1 { get; set; }
        public virtual CONTC000Master CONTC000Master2 { get; set; }
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM051VendorLocations> PRGRM051VendorLocations { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND010Contacts> VEND010Contacts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND020BusinessTerms> VEND020BusinessTerms { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND030DocumentReference> VEND030DocumentReference { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND040DCLocations> VEND040DCLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND050Finacial_Cal> VEND050Finacial_Cal { get; set; }
    }
}
