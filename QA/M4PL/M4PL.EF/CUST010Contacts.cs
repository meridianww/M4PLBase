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
    
    public partial class CUST010Contacts
    {
        public long Id { get; set; }
        public Nullable<long> CustCustomerID { get; set; }
        public Nullable<int> CustItemNumber { get; set; }
        public string CustContactCode { get; set; }
        public string CustContactTitle { get; set; }
        public Nullable<long> CustContactMSTRID { get; set; }
        public Nullable<int> StatusId { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string ChangedBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
    
        public virtual CONTC000Master CONTC000Master { get; set; }
        public virtual CUST000Master CUST000Master { get; set; }
        public virtual SYSTM000Ref_Options SYSTM000Ref_Options { get; set; }
    }
}
