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
    
    public partial class SYSTM000ErrorLog
    {
        public long Id { get; set; }
        public string ErrRelatedTo { get; set; }
        public string ErrInnerException { get; set; }
        public string ErrMessage { get; set; }
        public string ErrSource { get; set; }
        public string ErrStackTrace { get; set; }
        public string ErrAdditionalMessage { get; set; }
        public System.DateTime ErrDateStamp { get; set; }
        public string LogType { get; set; }
    }
}
