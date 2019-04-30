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
    
    public partial class PRGRM000Master
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PRGRM000Master()
        {
            this.JOBDL000Master = new HashSet<JOBDL000Master>();
            this.JOBDL020Gateways = new HashSet<JOBDL020Gateways>();
            this.MVOC000Program = new HashSet<MVOC000Program>();
            this.PRGRM010Ref_GatewayDefaults = new HashSet<PRGRM010Ref_GatewayDefaults>();
            this.PRGRM020_Roles = new HashSet<PRGRM020_Roles>();
            this.PRGRM020Program_Role = new HashSet<PRGRM020Program_Role>();
            this.PRGRM020Ref_AttributesDefault = new HashSet<PRGRM020Ref_AttributesDefault>();
            this.PRGRM030ShipStatusReasonCodes = new HashSet<PRGRM030ShipStatusReasonCodes>();
            this.PRGRM031ShipApptmtReasonCodes = new HashSet<PRGRM031ShipApptmtReasonCodes>();
            this.PRGRM040ProgramBillableRate = new HashSet<PRGRM040ProgramBillableRate>();
            this.PRGRM041ProgramCostRate = new HashSet<PRGRM041ProgramCostRate>();
            this.PRGRM051VendorLocations = new HashSet<PRGRM051VendorLocations>();
            this.PRGRM070EdiHeader = new HashSet<PRGRM070EdiHeader>();
            this.SCR010CatalogList = new HashSet<SCR010CatalogList>();
            this.SYSTM000_StatusLog = new HashSet<SYSTM000_StatusLog>();
        }
    
        public long Id { get; set; }
        public Nullable<long> PrgOrgID { get; set; }
        public Nullable<long> PrgCustID { get; set; }
        public string PrgItemNumber { get; set; }
        public string PrgProgramCode { get; set; }
        public string PrgProjectCode { get; set; }
        public string PrgPhaseCode { get; set; }
        public string PrgProgramTitle { get; set; }
        public string PrgAccountCode { get; set; }
        public Nullable<decimal> DelEarliest { get; set; }
        public Nullable<decimal> DelLatest { get; set; }
        public Nullable<bool> DelDay { get; set; }
        public Nullable<decimal> PckEarliest { get; set; }
        public Nullable<decimal> PckLatest { get; set; }
        public Nullable<bool> PckDay { get; set; }
        public Nullable<int> StatusId { get; set; }
        public Nullable<System.DateTime> PrgDateStart { get; set; }
        public Nullable<System.DateTime> PrgDateEnd { get; set; }
        public Nullable<System.DateTime> PrgDeliveryTimeDefault { get; set; }
        public Nullable<System.DateTime> PrgPickUpTimeDefault { get; set; }
        public byte[] PrgDescription { get; set; }
        public byte[] PrgNotes { get; set; }
        public Nullable<short> PrgHierarchyLevel { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual CUST000Master CUST000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL000Master> JOBDL000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MVOC000Program> MVOC000Program { get; set; }
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM010Ref_GatewayDefaults> PRGRM010Ref_GatewayDefaults { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020_Roles> PRGRM020_Roles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Program_Role> PRGRM020Program_Role { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Ref_AttributesDefault> PRGRM020Ref_AttributesDefault { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM030ShipStatusReasonCodes> PRGRM030ShipStatusReasonCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM031ShipApptmtReasonCodes> PRGRM031ShipApptmtReasonCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM051VendorLocations> PRGRM051VendorLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM070EdiHeader> PRGRM070EdiHeader { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR010CatalogList> SCR010CatalogList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000_StatusLog> SYSTM000_StatusLog { get; set; }
    }
}
