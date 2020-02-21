using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobComment
	{
		public long JobId { get; set; }
		public string JobGatewayTitle { get; set; }
		public string JobGatewayComment { get; set; }
	}
}
