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
		public string PcrCode { get; set; }
		public string PcrTitle { get; set; }
		public string PcrActionCode { get; set; }
	}
}
