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
    
    public partial class XCBL_MER010TransactionLog
    {
        public int ID { get; set; }
        public Nullable<System.DateTime> TranDatetime { get; set; }
        public string TranWebUser { get; set; }
        public string TranFtpUser { get; set; }
        public string TranWebMethod { get; set; }
        public string TranWebMessageNumber { get; set; }
        public string TranWebMessageDescription { get; set; }
        public string TranWebMicrosoftDescription { get; set; }
        public string TranWebFilename { get; set; }
        public string TranWebDocumentID { get; set; }
        public string TranOrderNo { get; set; }
        public string TranMessageCode { get; set; }
        public string TranXMLData { get; set; }
        public byte[] TranPBSFile { get; set; }
    }
}
