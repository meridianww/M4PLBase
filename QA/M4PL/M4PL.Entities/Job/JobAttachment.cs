using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobAttachment
	{
		public string FileName { get; set; }

		public string FileType { get; set; }

		public byte[] FileContent { get; set; }
	}
}
