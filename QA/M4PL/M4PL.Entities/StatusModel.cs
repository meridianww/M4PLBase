using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
	public class StatusModel
	{
		public int StatusCode { get; set; }
		public string Status { get; set; }
		public string AdditionalDetail { get; set; }
	}
}
