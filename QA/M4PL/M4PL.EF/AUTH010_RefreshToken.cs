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
    
    public partial class AUTH010_RefreshToken
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string AuthClientId { get; set; }
        public System.DateTime IssuedUtc { get; set; }
        public System.DateTime ExpiresUtc { get; set; }
        public string ProtectedTicket { get; set; }
        public string UserAuthTokenId { get; set; }
    
        public virtual AUTH000_Client AUTH000_Client { get; set; }
    }
}
