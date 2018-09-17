using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace xCBLSoapWebService
{
    public class ProcessData
    {
        /// <summary>
        /// The xCBL Web Service Username 
        /// </summary>
        public string WebUserName { get; set; }

        /// <summary>
        /// The FTP Username to upload CSV files
        /// </summary>
        public string FtpUserName { get; set; }
        public string ScheduleID { get; set; }
        public string OrderNumber { get; set; }
        public string CsvFileName { get; set; }
        public string XmlFileName { get; set; }
        public ShippingSchedule ShippingSchedule { get; set; }
        public XmlDocument XmlDocument { get; set; }
        public string FtpPassword { get; internal set; }
    }
}