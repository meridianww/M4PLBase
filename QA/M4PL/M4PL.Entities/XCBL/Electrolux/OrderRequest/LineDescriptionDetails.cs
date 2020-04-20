using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
	[XmlRoot(ElementName = "lineDescriptionDetails")]
	public class LineDescriptionDetails
	{
		[XmlElement(ElementName = "lineDescription")]
		public LineDescription LineDescription { get; set; }
	}
}
