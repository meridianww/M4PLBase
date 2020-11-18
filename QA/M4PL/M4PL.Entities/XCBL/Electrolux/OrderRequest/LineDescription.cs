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
    [XmlRoot(ElementName = "lineDescription")]
    public class LineDescription
    {
        /// <summary>
        /// Gets or Sets Line Number 
        /// </summary>
        [XmlElement(ElementName = "lineNumber")]
        public string LineNumber { get; set; }
        /// <summary>
        /// Gets or Sets LineText
        /// </summary>
        [XmlElement(ElementName = "lineText")]
        public string LineText { get; set; }
        /// <summary>
        /// Gets or Sets Pick Ticket Indicator
        /// </summary>
        [XmlElement(ElementName = "pickTicketIndicator")]
        public string PickTicketIndicator { get; set; }
        /// <summary>
        /// Gets or Sets Bill of Lading Indicator
        /// </summary>
        [XmlElement(ElementName = "billOfLadingIndicator")]
        public string BillOfLadingIndicator { get; set; }
    }
}
