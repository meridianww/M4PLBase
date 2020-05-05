using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
	[XmlRoot(ElementName = "OrderLine")]
	public class OrderLine
	{
		[XmlElement(ElementName = "LineNumber")]
		public string LineNumber { get; set; }
		[XmlElement(ElementName = "ItemNumber")]
		public string ItemNumber { get; set; }
		[XmlElement(ElementName = "ItemInstallStatus")]
		public string ItemInstallStatus { get; set; }
		[XmlElement(ElementName = "UserNotes")]
		public string UserNotes { get; set; }
		[XmlElement(ElementName = "ItemInstallComments")]
		public string ItemInstallComments { get; set; }
		[XmlElement(ElementName = "Exceptions")]
		public Exceptions Exceptions { get; set; }
	}
}
