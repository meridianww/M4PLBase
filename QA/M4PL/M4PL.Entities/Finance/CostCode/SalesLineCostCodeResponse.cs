using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.CostCode
{
   public class SalesLineCostCodeResponse
    {

        [JsonProperty("@odata.context")]
        public string ContextData { get; set; }

        [JsonProperty("value")]
        public List<SalesLineCostCode> SalesLinePriceCodeList { get; set; }
    }
}
