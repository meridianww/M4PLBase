using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "DeliverySignature")]
    public class DeliverySignature
    {
        [XmlElement(ElementName = "ImageURL")]
        public string ImageURL { get; set; }
        [XmlElement(ElementName = "SignedBy")]
        public string SignedBy { get; set; }
    }
}
