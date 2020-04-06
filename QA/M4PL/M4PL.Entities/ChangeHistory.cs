using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
	public class ChangeHistory
	{
		public string OrigionalData { get; set; }
		public string ChangedData { get; set; }
		public string ChangedBy { get; set; }
		public DateTime ChangedDate { get; set; }
	}
}
