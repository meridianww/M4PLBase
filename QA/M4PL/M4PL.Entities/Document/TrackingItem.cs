using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Document
{
	public class TrackingItem
	{
		public string ItemNumber { get; set; }
		public DateTime? GatewayACD { get; set; }
		public DateTime? ScheduledDate { get; set; }
		public string GatewayCode { get; set; }
		public string GatewayTitle { get; set; }
		public string GatewayType { get; set; }
	}
}
