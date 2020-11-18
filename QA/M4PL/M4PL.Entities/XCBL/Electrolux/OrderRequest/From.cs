#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "from")]
    public class From
    {
        /// <summary>
        /// Gets Or Sets Organization ID e.g. 3pd001
        /// </summary>
        [XmlElement(ElementName = "orgID")]
        public string OrgID { get; set; }
        /// <summary>
        /// Gets or Sets Location ID e.g. 3pd001
        /// </summary>
        [XmlElement(ElementName = "locationID")]
        public string LocationID { get; set; }
        /// <summary>
        /// Gets or Sets Message ID e.g. 7803055830
        /// </summary>
        [XmlElement(ElementName = "messageID")]
        public string MessageID { get; set; }
    }
}
