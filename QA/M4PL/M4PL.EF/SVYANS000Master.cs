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
    
    public partial class SVYANS000Master
    {
        public long Id { get; set; }
        public string SelectedAnswer { get; set; }
        public System.DateTime DateEntered { get; set; }
    
        public virtual MVOC010Ref_Questions MVOC010Ref_Questions { get; set; }
        public virtual SVYUSER000Master SVYUSER000Master { get; set; }
    }
}
