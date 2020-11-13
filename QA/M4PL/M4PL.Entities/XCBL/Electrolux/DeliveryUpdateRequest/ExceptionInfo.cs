#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "Exceptions")]
    public class ExceptionInfo
    {
        /// <summary>
        /// Gets or Sets Exception Code e.g. Exception-O
        /// </summary>
        [XmlElement(ElementName = "ExceptionCode")]
        public string ExceptionCode { get; set; }
        /// <summary>
        /// Gets or Sets Exception Detail e.g. Product Overage
        /// </summary>
        [XmlElement(ElementName = "ExceptionDetail")]
        public string ExceptionDetail { get; set; }
    }
}
