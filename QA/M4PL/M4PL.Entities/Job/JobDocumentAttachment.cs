using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobDocumentAttachment
	{
		public string DocumentCode { get; set; }
		public string DocumentTitle { get; set; }
		public List<AttchmentData> AttchmentData { get; set; }
	}

	public class AttchmentData
	{
		public string AttchmentName { get; set; }
		public string AttachmentTitle { get; set; }
		public byte[] AttachmentData { get; set; }
	}
}
