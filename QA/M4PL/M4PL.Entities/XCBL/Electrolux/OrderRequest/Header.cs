using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "header")]
    public class Header
    {
        [XmlElement(ElementName = "message")]
        public Message Message { get; set; }
        [XmlElement(ElementName = "from")]
        public From From { get; set; }
        [XmlElement(ElementName = "to")]
        public To To { get; set; }
    }
}
