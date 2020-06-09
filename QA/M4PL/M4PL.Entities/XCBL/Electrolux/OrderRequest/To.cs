using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "to")]
    public class To
    {
        [XmlElement(ElementName = "orgID")]
        public string OrgID { get; set; }
        [XmlElement(ElementName = "locationID")]
        public string LocationID { get; set; }
    }
}
