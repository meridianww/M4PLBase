using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse
{
	[XmlRoot(ElementName = "DeliveryUpdateResponse")]
	public class DeliveryUpdateResponse
	{
		[XmlElement(ElementName = "ResponseHeader")]
		public ResponseHeader ResponseHeader { get; set; }
		[XmlElement(ElementName = "UpdatedRecord")]
		public UpdatedRecord UpdatedRecord { get; set; }
	}
}
