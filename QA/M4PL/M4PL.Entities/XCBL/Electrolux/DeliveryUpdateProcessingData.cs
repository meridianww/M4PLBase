using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL.Electrolux
{
	public class DeliveryUpdateProcessingData
	{
		public long Id { get; set; }
		public bool IsProcessed { get; set; }
		public long JobId { get; set; }
		public string OrderNumber { get; set; }
	}
}
