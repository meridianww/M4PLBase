using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.PurchaseOrder
{
	public class NavJobPurchaseOrder
	{
		[JsonProperty("@odata.context")]
		public string ContextData { get; set; }
		public IList<NavPurchaseOrder> NavPurchaseOrder { get; set; }
	}
}
