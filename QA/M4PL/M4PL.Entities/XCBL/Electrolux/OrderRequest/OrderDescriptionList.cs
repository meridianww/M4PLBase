using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "OrderDescriptionList")]
    public class OrderDescriptionList
    {
        [XmlElement(ElementName = "OrderDescription")]
        public OrderDescription OrderDescription { get; set; }
    }
}
