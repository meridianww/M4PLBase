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
    
    public partial class SYSTM000PhantomMaster
    {
        public long Id { get; set; }
        public string SpmDatabase { get; set; }
        public string SpmTitle { get; set; }
        public string SpmDescription { get; set; }
        public string SpmLocation { get; set; }
        public string SpmProcess { get; set; }
        public int SpmIntervalMinutes { get; set; }
        public Nullable<bool> SpmEnable { get; set; }
        public Nullable<bool> SpmSunday { get; set; }
        public Nullable<bool> SpmMonday { get; set; }
        public Nullable<bool> SpmTuesday { get; set; }
        public Nullable<bool> SpmWednesday { get; set; }
        public Nullable<bool> SpmThursday { get; set; }
        public Nullable<bool> SpmFriday { get; set; }
        public Nullable<bool> SpmSaturday { get; set; }
        public Nullable<bool> SpmFinished { get; set; }
        public string SpmFinish_Status { get; set; }
        public Nullable<int> SpmRetry { get; set; }
        public Nullable<System.TimeSpan> SpmStartTime { get; set; }
        public Nullable<System.TimeSpan> SpmEndTime { get; set; }
        public Nullable<System.DateTime> SpmLastRun { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
    }
}
