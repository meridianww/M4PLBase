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
    
    public partial class NAV000JobOrderItemMapping
    {
        public long JobOrderItemMappingId { get; set; }
        public string EntityName { get; set; }
        public Nullable<int> LineNumber { get; set; }
        public System.DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<long> M4PLItemId { get; set; }
        public string Document_Number { get; set; }
    
        public virtual JOBDL000Master JOBDL000Master { get; set; }
    }
}
