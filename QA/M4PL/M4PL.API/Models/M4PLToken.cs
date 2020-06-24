using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using Orbit.WebApi.Extensions.Common;

namespace M4PL.API.Models
{
    /// <summary>
    /// Extend the token
    /// </summary>
    public class M4PLToken : Token
    {
        [JsonProperty(".expires")]
        public override string Expires { get; set; }
        [JsonProperty(".issued")]
        public override string Issued { get; set; }
        [JsonProperty("access_token")]
        public override string AccessToken { get; set; }
        [JsonProperty("as:client_id")]
        public override string ClientId { get; set; }
        [JsonProperty("expires_in")]
        public override int ExpiresIn { get; set; }
        [JsonProperty("refresh_token")]
        public override string RefreshToken { get; set; }
        [JsonProperty("token_type")]
        public override string TokenType { get; set; }
        [JsonProperty("userName")]
        public override string Username { get; set; }
        [JsonProperty("systemMessage")]
        public override string SystemMessage { get; set; }
        [JsonProperty("userSecurity")]
        public IList<UserSecurity> UserSecurity { get; set; }
    }
}