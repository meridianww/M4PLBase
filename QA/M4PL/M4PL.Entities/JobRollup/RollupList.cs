using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobRollup
{
	public class RollupList
	{
		public long JobId { get; set; }
		public string ColumnValue { get; set; }
		public bool IsCompleted { get; set; }
	}
}
