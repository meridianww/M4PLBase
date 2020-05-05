using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
	[XmlRoot(ElementName = "Exceptions")]
	public class Exceptions
	{
		[XmlElement(ElementName = "HasExceptions")]
		public string HasExceptions { get; set; }

		[XmlElement(ElementName = "Exceptions")]
		public ExceptionInfo ExceptionInfo { get; set; }
	}
}
