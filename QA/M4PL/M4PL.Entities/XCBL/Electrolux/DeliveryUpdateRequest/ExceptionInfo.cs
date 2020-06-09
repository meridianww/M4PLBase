using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "Exceptions")]
    public class ExceptionInfo
    {
        [XmlElement(ElementName = "ExceptionCode")]
        public string ExceptionCode { get; set; }

        [XmlElement(ElementName = "ExceptionDetail")]
        public string ExceptionDetail { get; set; }
    }
}
