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
    
    public partial class MVOC010Ref_Questions
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MVOC010Ref_Questions()
        {
            this.SVYANS000Master = new HashSet<SVYANS000Master>();
        }
    
        public long Id { get; set; }
        public Nullable<int> QueQuestionNumber { get; set; }
        public string QueCode { get; set; }
        public string QueTitle { get; set; }
        public byte[] QueDescription { get; set; }
        public Nullable<bool> QueType_YNAnswer { get; set; }
        public Nullable<bool> QueType_YNDefault { get; set; }
        public Nullable<int> QueType_RangeLo { get; set; }
        public Nullable<int> QueType_RangeHi { get; set; }
        public Nullable<int> QueType_RangeAnswer { get; set; }
        public Nullable<int> QueType_RangeDefault { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
        public string QueDescriptionText { get; set; }
    
        public virtual MVOC000Program MVOC000Program { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SVYANS000Master> SVYANS000Master { get; set; }
    }
}
