using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
	[XmlRoot(ElementName = "DeliveryImages")]
	public class DeliveryImages
	{
		[XmlElement(ElementName = "ImageURL")]
		public string ImageURL { get; set; }
	}
}
