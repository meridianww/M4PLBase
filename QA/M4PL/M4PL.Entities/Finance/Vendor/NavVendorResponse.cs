using Newtonsoft.Json;
using System.Collections.Generic;

namespace M4PL.Entities.Finance.Vendor
{
    public class NavVendorResponse
    {
        [JsonProperty("@odata.context")]
        public string ContextData { get; set; }

        [JsonProperty("value")]
        public List<NavVendorData> VendorList { get; set; }
    }
}
