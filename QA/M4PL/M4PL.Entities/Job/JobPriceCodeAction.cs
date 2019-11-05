using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobPriceCodeAction
	{
		public long PriceCodeId { get; set; }
		public string PriceCode { get; set; }
		public string PriceTitle { get; set; }
		public string PriceActionCode { get; set; }
	}
}
