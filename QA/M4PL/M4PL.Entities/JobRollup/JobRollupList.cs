using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobRollup
{
	public class JobRollupList
	{
		public string FieldValue { get; set; }
		public List<long> JobId { get; set; }
	}
}
