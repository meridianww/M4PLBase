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
    
    public partial class SYSTM000ProcessorMaster
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SYSTM000ProcessorMaster()
        {
            this.SYSTM040ProcessorConfig = new HashSet<SYSTM040ProcessorConfig>();
        }
    
        public long ID { get; set; }
        public string ProCode { get; set; }
        public string ProTitle { get; set; }
        public string ProDescription { get; set; }
        public string ProLocation { get; set; }
        public string ProProcess { get; set; }
        public Nullable<bool> ProEnabled { get; set; }
        public string ProFrequency { get; set; }
        public string ProIntervalValue { get; set; }
        public Nullable<System.DateTime> ProStartTime { get; set; }
        public Nullable<System.DateTime> ProEndTime { get; set; }
        public Nullable<bool> ProSunday { get; set; }
        public Nullable<bool> ProMonday { get; set; }
        public Nullable<bool> ProTuesday { get; set; }
        public Nullable<bool> ProWednesday { get; set; }
        public Nullable<bool> ProThursday { get; set; }
        public Nullable<bool> ProFriday { get; set; }
        public Nullable<bool> ProSaturday { get; set; }
        public Nullable<System.DateTime> ProLastRun { get; set; }
        public Nullable<bool> ProFinished { get; set; }
        public string ProFinishStatus { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ProApiServerName { get; set; }
    
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SYSTM040ProcessorConfig> SYSTM040ProcessorConfig { get; set; }
    }
}
