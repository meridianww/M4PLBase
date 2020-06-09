using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse
{
    [XmlRoot(ElementName = "UpdatedRecord")]
    public class UpdatedRecord
    {
        [XmlElement(ElementName = "ServiceProviderID")]
        public string ServiceProviderID { get; set; }
        [XmlElement(ElementName = "EDCCode")]
        public string EDCCode { get; set; }
        [XmlElement(ElementName = "OrderNumber")]
        public string OrderNumber { get; set; }
        [XmlElement(ElementName = "OrderDate")]
        public string OrderDate { get; set; }
    }
}
