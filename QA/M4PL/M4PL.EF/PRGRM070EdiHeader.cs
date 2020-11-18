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
    
    public partial class PRGRM070EdiHeader
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PRGRM070EdiHeader()
        {
            this.PRGRM071EdiMapping = new HashSet<PRGRM071EdiMapping>();
        }
    
        public long Id { get; set; }
        public Nullable<bool> PehParentEDI { get; set; }
        public Nullable<int> PehItemNumber { get; set; }
        public string PehEdiCode { get; set; }
        public string PehEdiTitle { get; set; }
        public byte[] PehEdiDescription { get; set; }
        public string PehTradingPartner { get; set; }
        public string PehEdiDocument { get; set; }
        public string PehEdiVersion { get; set; }
        public string PehSCACCode { get; set; }
        public Nullable<bool> PehSndRcv { get; set; }
        public string PehInsertCode { get; set; }
        public string PehUpdateCode { get; set; }
        public string PehCancelCode { get; set; }
        public string PehHoldCode { get; set; }
        public string PehOriginalCode { get; set; }
        public string PehReturnCode { get; set; }
        public string PehInOutFolder { get; set; }
        public string PehArchiveFolder { get; set; }
        public string PehProcessFolder { get; set; }
        public string UDF01 { get; set; }
        public string UDF02 { get; set; }
        public string UDF03 { get; set; }
        public string UDF04 { get; set; }
        public string UDF05 { get; set; }
        public string UDF06 { get; set; }
        public string UDF07 { get; set; }
        public string UDF08 { get; set; }
        public string UDF09 { get; set; }
        public string UDF10 { get; set; }
        public Nullable<int> PehAttachments { get; set; }
        public Nullable<System.DateTime> PehDateStart { get; set; }
        public Nullable<System.DateTime> PehDateEnd { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string PehFtpServerUrl { get; set; }
        public string PehFtpUsername { get; set; }
        public string PehFtpPassword { get; set; }
        public string PehFtpPort { get; set; }
        public bool IsSFTPUsed { get; set; }
    
        public virtual PRGRM000Master PRGRM000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PRGRM071EdiMapping> PRGRM071EdiMapping { get; set; }
    }
}
