using M4PL.Entities.Support;
using Orbit.WebApi.Core.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;

namespace M4PL.API.Models
{
    public class M4PLApiPrincipal : ApiPrincipal
    {
        public M4PLApiPrincipal(ApiIdentity identity) : base(identity)
        {
        }

        public IList<UserSecurity> UserSecurity { get; set; }
    }
}