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
    
    public partial class SYSTM000Ref_UserSettings
    {
        public long Id { get; set; }
        public string LangCode { get; set; }
        public bool GlobalSetting { get; set; }
        public string SysJsonSetting { get; set; }
    
        public virtual ORGAN000Master ORGAN000Master { get; set; }
        public virtual SYSTM000OpnSezMe SYSTM000OpnSezMe { get; set; }
    }
}
