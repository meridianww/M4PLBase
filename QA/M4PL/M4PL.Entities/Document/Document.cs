using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Document
{
	public class DocumentData
	{
		public string DocumentName { get; set; }

		public byte[] DocumentContent { get; set; }

		public string DocumentExtension { get; set; }

		public string DocumentHtml { get; set; }
	}
}
