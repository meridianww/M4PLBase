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
    
    public partial class SYSTM000Validation
    {
        public long Id { get; set; }
        public string LangCode { get; set; }
        public long RefTabPageId { get; set; }
        public string ValFieldName { get; set; }
        public Nullable<bool> ValRequired { get; set; }
        public string ValRequiredMessage { get; set; }
        public Nullable<bool> ValUnique { get; set; }
        public string ValUniqueMessage { get; set; }
        public Nullable<int> ValRegExLogic0 { get; set; }
        public string ValRegEx1 { get; set; }
        public string ValRegExMessage1 { get; set; }
        public Nullable<int> ValRegExLogic1 { get; set; }
        public string ValRegEx2 { get; set; }
        public string ValRegExMessage2 { get; set; }
        public Nullable<int> ValRegExLogic2 { get; set; }
        public string ValRegEx3 { get; set; }
        public string ValRegExMessage3 { get; set; }
        public Nullable<int> ValRegExLogic3 { get; set; }
        public string ValRegEx4 { get; set; }
        public string ValRegExMessage4 { get; set; }
        public Nullable<int> ValRegExLogic4 { get; set; }
        public string ValRegEx5 { get; set; }
        public string ValRegExMessage5 { get; set; }
        public Nullable<int> StatusId { get; set; }
        public Nullable<System.DateTime> DateEntered { get; set; }
        public string EnteredBy { get; set; }
        public Nullable<System.DateTime> DateChanged { get; set; }
        public string ChangedBy { get; set; }
    
        public virtual SYSTM000Ref_Table SYSTM000Ref_Table { get; set; }
    }
}
