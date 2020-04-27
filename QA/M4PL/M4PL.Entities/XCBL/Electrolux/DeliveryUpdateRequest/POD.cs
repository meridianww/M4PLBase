using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
	[XmlRoot(ElementName = "POD")]
	public class POD
	{
		[XmlElement(ElementName = "DeliveryImages")]
		public DeliveryImages DeliveryImages { get; set; }
		[XmlElement(ElementName = "DeliverySignature")]
		public DeliverySignature DeliverySignature { get; set; }
	}
}
