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
