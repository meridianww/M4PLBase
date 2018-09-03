using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace xCBLSoapWebService
{
    public class ProcessData
    {
        public string WebUserName { get; set; }
        public string FtpUserName { get; set; }
        public string ScheduleID { get; set; }
        public string OrderNumber { get; set; }
        public string CsvFileName { get; set; }
        public string XmlFileName { get; set; }
        public ShippingSchedule ShippingSchedule { get; set; }
        public XmlDocument XmlDocument { get; set; }
    }
}