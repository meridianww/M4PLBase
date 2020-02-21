using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobCostCodeAction
	{
		public long CostCodeId { get; set; }
		public string CostCode { get; set; }
		public string CostTitle { get; set; }
		public string CostActionCode { get; set; }
	}
}
