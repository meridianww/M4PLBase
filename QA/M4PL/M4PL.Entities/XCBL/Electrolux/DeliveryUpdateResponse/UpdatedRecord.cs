#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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
