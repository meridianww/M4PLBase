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
    
    public partial class EmailAttachment
    {
        public int ID { get; set; }
        public int EmailDetailID { get; set; }
        public string AttachmentName { get; set; }
        public byte[] Attachment { get; set; }
    }
}