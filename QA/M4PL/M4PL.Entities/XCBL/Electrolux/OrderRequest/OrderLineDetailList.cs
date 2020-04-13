﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.OrderRequest
{
    [XmlRoot(ElementName = "OrderLineDetailList")]
    public class OrderLineDetailList
    {
        [XmlElement(ElementName = "OrderLineDetail")]
        public List<OrderLineDetail> OrderLineDetail { get; set; }
    }
}