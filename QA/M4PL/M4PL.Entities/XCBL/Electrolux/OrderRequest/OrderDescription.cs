using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "OrderDescription")]
    public class OrderDescription
    {
        [XmlElement(ElementName = "DescriptionText")]
        public string DescriptionText { get; set; }
        [XmlElement(ElementName = "pickTicketIndicator")]
        public string PickTicketIndicator { get; set; }
        [XmlElement(ElementName = "billOfLadingIndicator")]
        public string BillOfLadingIndicator { get; set; }
    }
}
