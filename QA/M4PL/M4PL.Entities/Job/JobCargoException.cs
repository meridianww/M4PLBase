using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobCargoException
	{
		public string ExceptionCode { get; set; }

		public string ExceptionReason { get; set; }

		public string InstallStatus { get; set; }
	}
}
