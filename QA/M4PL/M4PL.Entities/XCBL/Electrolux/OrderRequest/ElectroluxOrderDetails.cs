using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "fxEnvelope")]
    public class ElectroluxOrderDetails
    {
        [XmlElement(ElementName = "header")]
        public Header Header { get; set; }
        [XmlElement(ElementName = "body")]
        public Body Body { get; set; }
    }
}
