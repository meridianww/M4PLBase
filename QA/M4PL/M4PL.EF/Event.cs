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
    
    public partial class Event
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Event()
        {
            this.EventEntityRelation = new HashSet<EventEntityRelation>();
        }
    
        public int ID { get; set; }
        public string EventName { get; set; }
        public string EventShortName { get; set; }
        public string FromMail { get; set; }
        public string Description { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string XSLTPath { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual EventType EventType { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EventEntityRelation> EventEntityRelation { get; set; }
    }
}