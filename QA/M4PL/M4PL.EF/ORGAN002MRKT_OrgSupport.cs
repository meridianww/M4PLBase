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
    
    public partial class ORGAN002MRKT_OrgSupport
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ORGAN002MRKT_OrgSupport()
        {
            this.SYSTM000ZipcodeMaster = new HashSet<SYSTM000ZipcodeMaster>();
        }
    
        public long Id { get; set; }
        public Nullable<int> MrkOrder { get; set; }
        public string MrkCode { get; set; }
        public string MrkTitle { get; set; }
        public byte[] MrkDescription { get; set; }
        public byte[] MrkInstructions { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM000ZipcodeMaster> SYSTM000ZipcodeMaster { get; set; }
    }
}
