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
    
    public partial class EmailDetail
    {
        public int ID { get; set; }
        public string FromAddress { get; set; }
        public string ReplyToAddress { get; set; }
        public string ToAddress { get; set; }
        public string CCAddress { get; set; }
        public string BCCAddress { get; set; }
        public string Subject { get; set; }
        public bool IsBodyHtml { get; set; }
        public string Body { get; set; }
        public byte EmailPriority { get; set; }
        public System.DateTime QueuedDate { get; set; }
        public Nullable<System.DateTime> LastAttemptDate { get; set; }
        public byte Status { get; set; }
        public byte RetryAttempt { get; set; }
    }
}
