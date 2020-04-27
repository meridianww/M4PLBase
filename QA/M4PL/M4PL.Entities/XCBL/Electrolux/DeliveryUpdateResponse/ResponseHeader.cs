using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse
{
	[XmlRoot(ElementName = "ResponseHeader")]
	public class ResponseHeader
	{
		[XmlElement(ElementName = "StatusCode")]
		public string StatusCode { get; set; }
		[XmlElement(ElementName = "TransactionID")]
		public string TransactionID { get; set; }
	}
}
