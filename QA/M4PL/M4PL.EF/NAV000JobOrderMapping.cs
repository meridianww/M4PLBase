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
    
    public partial class NAV000JobOrderMapping
    {
        public long JobOrderMappingId { get; set; }
        public string SONumber { get; set; }
        public string PONumber { get; set; }
        public System.DateTime DateEntered { get; set; }
        public string EnteredBy { get; set; }
    
        public virtual JOBDL000Master JOBDL000Master { get; set; }
    }
}
