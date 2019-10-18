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
    
    public partial class SYSTM000Ref_Options
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SYSTM000Ref_Options()
        {
            this.COMP000Master = new HashSet<COMP000Master>();
            this.COMPADD000Master = new HashSet<COMPADD000Master>();
            this.CONTC000Master = new HashSet<CONTC000Master>();
            this.CONTC000Master1 = new HashSet<CONTC000Master>();
            this.CONTC000Master2 = new HashSet<CONTC000Master>();
            this.CONTC000Master3 = new HashSet<CONTC000Master>();
            this.CONTC000Master4 = new HashSet<CONTC000Master>();
            this.CONTC000Master5 = new HashSet<CONTC000Master>();
            this.CONTC010Bridge = new HashSet<CONTC010Bridge>();
            this.CONTC010Bridge1 = new HashSet<CONTC010Bridge>();
            this.CONTC010Bridge2 = new HashSet<CONTC010Bridge>();
            this.CUST000Master = new HashSet<CUST000Master>();
            this.CUST000Master1 = new HashSet<CUST000Master>();
            this.CUST020BusinessTerms = new HashSet<CUST020BusinessTerms>();
            this.CUST020BusinessTerms1 = new HashSet<CUST020BusinessTerms>();
            this.CUST030DocumentReference = new HashSet<CUST030DocumentReference>();
            this.CUST030DocumentReference1 = new HashSet<CUST030DocumentReference>();
            this.CUST030DocumentReference2 = new HashSet<CUST030DocumentReference>();
            this.CUST040DCLocations = new HashSet<CUST040DCLocations>();
            this.CUST050Finacial_Cal = new HashSet<CUST050Finacial_Cal>();
            this.CUST050Finacial_Cal1 = new HashSet<CUST050Finacial_Cal>();
            this.JOBDL000Master = new HashSet<JOBDL000Master>();
            this.JOBDL000Master1 = new HashSet<JOBDL000Master>();
            this.JOBDL010Cargo = new HashSet<JOBDL010Cargo>();
            this.JOBDL020Gateways = new HashSet<JOBDL020Gateways>();
            this.JOBDL020Gateways1 = new HashSet<JOBDL020Gateways>();
            this.JOBDL020Gateways2 = new HashSet<JOBDL020Gateways>();
            this.JOBDL020Gateways3 = new HashSet<JOBDL020Gateways>();
            this.JOBDL020Gateways4 = new HashSet<JOBDL020Gateways>();
            this.JOBDL030Attributes = new HashSet<JOBDL030Attributes>();
            this.JOBDL030Attributes1 = new HashSet<JOBDL030Attributes>();
            this.JOBDL040DocumentReference = new HashSet<JOBDL040DocumentReference>();
            this.JOBDL040DocumentReference1 = new HashSet<JOBDL040DocumentReference>();
            this.JOBDL050Ref_Status = new HashSet<JOBDL050Ref_Status>();
            this.JOBDL050Ref_Status1 = new HashSet<JOBDL050Ref_Status>();
            this.JOBDL060Ref_CostSheetJob = new HashSet<JOBDL060Ref_CostSheetJob>();
            this.JOBDL060Ref_CostSheetJob1 = new HashSet<JOBDL060Ref_CostSheetJob>();
            this.JOBDL060Ref_CostSheetJob2 = new HashSet<JOBDL060Ref_CostSheetJob>();
            this.MVOC000Program = new HashSet<MVOC000Program>();
            this.MVOC010Ref_Questions = new HashSet<MVOC010Ref_Questions>();
            this.MVOC010Ref_Questions1 = new HashSet<MVOC010Ref_Questions>();
            this.ORGAN000Master = new HashSet<ORGAN000Master>();
            this.ORGAN000Master1 = new HashSet<ORGAN000Master>();
            this.ORGAN010Ref_Roles = new HashSet<ORGAN010Ref_Roles>();
            this.ORGAN010Ref_Roles1 = new HashSet<ORGAN010Ref_Roles>();
            this.ORGAN020Financial_Cal = new HashSet<ORGAN020Financial_Cal>();
            this.ORGAN020Financial_Cal1 = new HashSet<ORGAN020Financial_Cal>();
            this.ORGAN030Credentials = new HashSet<ORGAN030Credentials>();
            this.ORGAN040_Roles = new HashSet<ORGAN040_Roles>();
            this.PRGRM000Master = new HashSet<PRGRM000Master>();
            this.PRGRM010Ref_GatewayDefaults = new HashSet<PRGRM010Ref_GatewayDefaults>();
            this.PRGRM010Ref_GatewayDefaults1 = new HashSet<PRGRM010Ref_GatewayDefaults>();
            this.PRGRM010Ref_GatewayDefaults2 = new HashSet<PRGRM010Ref_GatewayDefaults>();
            this.PRGRM010Ref_GatewayDefaults3 = new HashSet<PRGRM010Ref_GatewayDefaults>();
            this.PRGRM020Program_Role = new HashSet<PRGRM020Program_Role>();
            this.PRGRM020Program_Role1 = new HashSet<PRGRM020Program_Role>();
            this.PRGRM020Ref_AttributesDefault = new HashSet<PRGRM020Ref_AttributesDefault>();
            this.PRGRM020Ref_AttributesDefault1 = new HashSet<PRGRM020Ref_AttributesDefault>();
            this.PRGRM030ShipStatusReasonCodes = new HashSet<PRGRM030ShipStatusReasonCodes>();
            this.PRGRM031ShipApptmtReasonCodes = new HashSet<PRGRM031ShipApptmtReasonCodes>();
            this.PRGRM040ProgramBillableRate = new HashSet<PRGRM040ProgramBillableRate>();
            this.PRGRM040ProgramBillableRate1 = new HashSet<PRGRM040ProgramBillableRate>();
            this.PRGRM040ProgramBillableRate2 = new HashSet<PRGRM040ProgramBillableRate>();
            this.PRGRM040ProgramBillableRate3 = new HashSet<PRGRM040ProgramBillableRate>();
            this.PRGRM041ProgramCostRate = new HashSet<PRGRM041ProgramCostRate>();
            this.PRGRM041ProgramCostRate1 = new HashSet<PRGRM041ProgramCostRate>();
            this.PRGRM041ProgramCostRate2 = new HashSet<PRGRM041ProgramCostRate>();
            this.PRGRM041ProgramCostRate3 = new HashSet<PRGRM041ProgramCostRate>();
            this.PRGRM051VendorLocations = new HashSet<PRGRM051VendorLocations>();
            this.PRGRM070EdiHeader = new HashSet<PRGRM070EdiHeader>();
            this.PRGRM071EdiMapping = new HashSet<PRGRM071EdiMapping>();
            this.PRGRM071EdiMapping1 = new HashSet<PRGRM071EdiMapping>();
            this.SCR010CatalogList = new HashSet<SCR010CatalogList>();
            this.SCR010CatalogList1 = new HashSet<SCR010CatalogList>();
            this.SCR010CatalogList2 = new HashSet<SCR010CatalogList>();
            this.SCR011OSDList = new HashSet<SCR011OSDList>();
            this.SCR011OSDReasonList = new HashSet<SCR011OSDReasonList>();
            this.SCR012RequirementList = new HashSet<SCR012RequirementList>();
            this.SCR013ServiceList = new HashSet<SCR013ServiceList>();
            this.SCR014ReturnReasonList = new HashSet<SCR014ReturnReasonList>();
            this.SYSMS010Ref_MessageTypes = new HashSet<SYSMS010Ref_MessageTypes>();
            this.SYSMS010Ref_MessageTypes1 = new HashSet<SYSMS010Ref_MessageTypes>();
            this.SYSTM000_StatusLog = new HashSet<SYSTM000_StatusLog>();
            this.SYSTM000_StatusLog1 = new HashSet<SYSTM000_StatusLog>();
            this.SYSTM000Delivery_Status = new HashSet<SYSTM000Delivery_Status>();
            this.SYSTM000Delivery_Status1 = new HashSet<SYSTM000Delivery_Status>();
            this.SYSTM000Master = new HashSet<SYSTM000Master>();
            this.SYSTM000Master1 = new HashSet<SYSTM000Master>();
            this.SYSTM000MenuDriver = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000MenuDriver1 = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000MenuDriver2 = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000MenuDriver3 = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000MenuDriver4 = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000MenuDriver5 = new HashSet<SYSTM000MenuDriver>();
            this.SYSTM000OpnSezMe = new HashSet<SYSTM000OpnSezMe>();
            this.SYSTM000PhantomMaster = new HashSet<SYSTM000PhantomMaster>();
            this.SYSTM000ProcessorMaster = new HashSet<SYSTM000ProcessorMaster>();
            this.SYSTM000Ref_Dashboard = new HashSet<SYSTM000Ref_Dashboard>();
            this.SYSTM000Ref_Dashboard1 = new HashSet<SYSTM000Ref_Dashboard>();
            this.SYSTM000Ref_Options1 = new HashSet<SYSTM000Ref_Options>();
            this.SYSTM000Ref_Report = new HashSet<SYSTM000Ref_Report>();
            this.SYSTM000Ref_Report1 = new HashSet<SYSTM000Ref_Report>();
            this.SYSTM000Ref_Settings = new HashSet<SYSTM000Ref_Settings>();
            this.SYSTM000Ref_States = new HashSet<SYSTM000Ref_States>();
            this.SYSTM000Ref_States1 = new HashSet<SYSTM000Ref_States>();
            this.SYSTM000Ref_Table = new HashSet<SYSTM000Ref_Table>();
            this.SYSTM000SecurityByRole = new HashSet<SYSTM000SecurityByRole>();
            this.SYSTM000SecurityByRole1 = new HashSet<SYSTM000SecurityByRole>();
            this.SYSTM000SecurityByRole2 = new HashSet<SYSTM000SecurityByRole>();
            this.SYSTM000SecurityByRole3 = new HashSet<SYSTM000SecurityByRole>();
            this.SYSTM010SubSecurityByRole = new HashSet<SYSTM010SubSecurityByRole>();
            this.SYSTM010SubSecurityByRole1 = new HashSet<SYSTM010SubSecurityByRole>();
            this.SYSTM010SubSecurityByRole2 = new HashSet<SYSTM010SubSecurityByRole>();
            this.SYSTM030Ref_TabPageName = new HashSet<SYSTM030Ref_TabPageName>();
            this.VEND000Master = new HashSet<VEND000Master>();
            this.VEND000Master1 = new HashSet<VEND000Master>();
            this.VEND020BusinessTerms = new HashSet<VEND020BusinessTerms>();
            this.VEND020BusinessTerms1 = new HashSet<VEND020BusinessTerms>();
            this.VEND030DocumentReference = new HashSet<VEND030DocumentReference>();
            this.VEND030DocumentReference1 = new HashSet<VEND030DocumentReference>();
            this.VEND030DocumentReference2 = new HashSet<VEND030DocumentReference>();
            this.VEND040DCLocations = new HashSet<VEND040DCLocations>();
            this.VEND050Finacial_Cal = new HashSet<VEND050Finacial_Cal>();
            this.VEND050Finacial_Cal1 = new HashSet<VEND050Finacial_Cal>();
            this.JOBDL061BillableSheet = new HashSet<JOBDL061BillableSheet>();
            this.SVYUSER000Master = new HashSet<SVYUSER000Master>();
        }
    
        public int Id { get; set; }
        public Nullable<int> SysLookupId { get; set; }
        public string SysLookupCode { get; set; }
        public string SysOptionName { get; set; }
        public Nullable<int> SysSortOrder { get; set; }
        public Nullable<bool> SysDefault { get; set; }
        public bool IsSysAdmin { get; set; }
        public Nullable<int> StatusId { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<COMP000Master> COMP000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<COMPADD000Master> COMPADD000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master4 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC000Master> CONTC000Master5 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC010Bridge> CONTC010Bridge { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC010Bridge> CONTC010Bridge1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CONTC010Bridge> CONTC010Bridge2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST000Master> CUST000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST000Master> CUST000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST020BusinessTerms> CUST020BusinessTerms { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST020BusinessTerms> CUST020BusinessTerms1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST030DocumentReference> CUST030DocumentReference { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST030DocumentReference> CUST030DocumentReference1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST030DocumentReference> CUST030DocumentReference2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST040DCLocations> CUST040DCLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST050Finacial_Cal> CUST050Finacial_Cal { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CUST050Finacial_Cal> CUST050Finacial_Cal1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL000Master> JOBDL000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL000Master> JOBDL000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL010Cargo> JOBDL010Cargo { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL020Gateways> JOBDL020Gateways4 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL030Attributes> JOBDL030Attributes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL030Attributes> JOBDL030Attributes1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL040DocumentReference> JOBDL040DocumentReference { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL040DocumentReference> JOBDL040DocumentReference1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL050Ref_Status> JOBDL050Ref_Status { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL050Ref_Status> JOBDL050Ref_Status1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL060Ref_CostSheetJob> JOBDL060Ref_CostSheetJob { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL060Ref_CostSheetJob> JOBDL060Ref_CostSheetJob1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL060Ref_CostSheetJob> JOBDL060Ref_CostSheetJob2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MVOC000Program> MVOC000Program { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MVOC010Ref_Questions> MVOC010Ref_Questions { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MVOC010Ref_Questions> MVOC010Ref_Questions1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN000Master> ORGAN000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN000Master> ORGAN000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN010Ref_Roles> ORGAN010Ref_Roles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN010Ref_Roles> ORGAN010Ref_Roles1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN020Financial_Cal> ORGAN020Financial_Cal { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN020Financial_Cal> ORGAN020Financial_Cal1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN030Credentials> ORGAN030Credentials { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ORGAN040_Roles> ORGAN040_Roles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM000Master> PRGRM000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM010Ref_GatewayDefaults> PRGRM010Ref_GatewayDefaults { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM010Ref_GatewayDefaults> PRGRM010Ref_GatewayDefaults1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM010Ref_GatewayDefaults> PRGRM010Ref_GatewayDefaults2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM010Ref_GatewayDefaults> PRGRM010Ref_GatewayDefaults3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Program_Role> PRGRM020Program_Role { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Program_Role> PRGRM020Program_Role1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Ref_AttributesDefault> PRGRM020Ref_AttributesDefault { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM020Ref_AttributesDefault> PRGRM020Ref_AttributesDefault1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM030ShipStatusReasonCodes> PRGRM030ShipStatusReasonCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM031ShipApptmtReasonCodes> PRGRM031ShipApptmtReasonCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM040ProgramBillableRate> PRGRM040ProgramBillableRate3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM041ProgramCostRate> PRGRM041ProgramCostRate3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM051VendorLocations> PRGRM051VendorLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM070EdiHeader> PRGRM070EdiHeader { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM071EdiMapping> PRGRM071EdiMapping { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM071EdiMapping> PRGRM071EdiMapping1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR010CatalogList> SCR010CatalogList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR010CatalogList> SCR010CatalogList1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR010CatalogList> SCR010CatalogList2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR011OSDList> SCR011OSDList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR011OSDReasonList> SCR011OSDReasonList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR012RequirementList> SCR012RequirementList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR013ServiceList> SCR013ServiceList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SCR014ReturnReasonList> SCR014ReturnReasonList { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSMS010Ref_MessageTypes> SYSMS010Ref_MessageTypes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSMS010Ref_MessageTypes> SYSMS010Ref_MessageTypes1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000_StatusLog> SYSTM000_StatusLog { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000_StatusLog> SYSTM000_StatusLog1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Delivery_Status> SYSTM000Delivery_Status { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Delivery_Status> SYSTM000Delivery_Status1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Master> SYSTM000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Master> SYSTM000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver4 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000MenuDriver> SYSTM000MenuDriver5 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000OpnSezMe> SYSTM000OpnSezMe { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000PhantomMaster> SYSTM000PhantomMaster { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000ProcessorMaster> SYSTM000ProcessorMaster { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Dashboard> SYSTM000Ref_Dashboard { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Dashboard> SYSTM000Ref_Dashboard1 { get; set; }
        public virtual SYSTM000Ref_Lookup SYSTM000Ref_Lookup { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Options> SYSTM000Ref_Options1 { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Report> SYSTM000Ref_Report { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Report> SYSTM000Ref_Report1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Settings> SYSTM000Ref_Settings { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_States> SYSTM000Ref_States { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_States> SYSTM000Ref_States1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000Ref_Table> SYSTM000Ref_Table { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000SecurityByRole> SYSTM000SecurityByRole { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000SecurityByRole> SYSTM000SecurityByRole1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000SecurityByRole> SYSTM000SecurityByRole2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000SecurityByRole> SYSTM000SecurityByRole3 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM010SubSecurityByRole> SYSTM010SubSecurityByRole { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM010SubSecurityByRole> SYSTM010SubSecurityByRole1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM010SubSecurityByRole> SYSTM010SubSecurityByRole2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM030Ref_TabPageName> SYSTM030Ref_TabPageName { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND000Master> VEND000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND000Master> VEND000Master1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND020BusinessTerms> VEND020BusinessTerms { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND020BusinessTerms> VEND020BusinessTerms1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND030DocumentReference> VEND030DocumentReference { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND030DocumentReference> VEND030DocumentReference1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND030DocumentReference> VEND030DocumentReference2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND040DCLocations> VEND040DCLocations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND050Finacial_Cal> VEND050Finacial_Cal { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VEND050Finacial_Cal> VEND050Finacial_Cal1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL061BillableSheet> JOBDL061BillableSheet { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SVYUSER000Master> SVYUSER000Master { get; set; }
    }
}
