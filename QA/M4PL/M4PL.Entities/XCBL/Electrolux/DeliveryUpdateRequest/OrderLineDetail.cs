﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Collections.Generic;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "OrderLineDetail")]
    public class OrderLineDetails
    {
        /// <summary>
        /// Gets or Sets List of Order lines
        /// </summary>
        [XmlElement(ElementName = "OrderLine")]
        public List<OrderLine> OrderLine { get; set; }
    }
}
