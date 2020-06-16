using System.Collections.Generic;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "OrderLineDetailList")]
    public class OrderLineDetailList
    {
        [XmlElement(ElementName = "OrderLineDetail")]
        public List<OrderLineDetail> OrderLineDetail { get; set; }
    }
}
