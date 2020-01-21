using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobAdvanceReportRequest
	{
		public long CustomerId { get; set; }
		public List<long> ProgramId { get; set; }
		public List<string> Origin { get; set; }
		public List<string> Destination { get; set; }
		public List<string> Brand { get; set; }
		public List<string> GatewayTitle { get; set; }
		public List<string> ServiceMode { get; set; }
		public List<string> ProductType { get; set; }
		public int Scheduled { get; set; }
		public int OrderType { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public List<string> Channel { get; set; }
		public string Mode { get; set; }
		public int JobStatus { get; set; }
		public string Search { get; set; }
	}
}
