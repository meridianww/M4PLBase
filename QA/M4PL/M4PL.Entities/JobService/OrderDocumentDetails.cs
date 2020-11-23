using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Order Document Reference
    /// </summary>
    public class OrderDocumentDetails
    {
        /// <summary>
        /// Gets or Sets document reference Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets JobID
        /// </summary>
        public long JobID { get; set; }
        /// <summary>
        /// Gets or Sets Job Document Reference Code e.g. Mail Delivery
        /// </summary>
        public string JdrCode { get; set; }
        /// <summary>
        /// Gets or Sets Job Document Reference Title e.g. Automation Tool_Selenium.pptx
        /// </summary>
        public string JdrTitle { get; set; }
        /// <summary>
        /// Gets or Sets Document Type Id e.g. 206 for POD
        /// </summary>
        public int? DocTypeId { get; set; }
        /// <summary>
        /// Gets or Sets Document Type Name e.g. POD
        /// </summary>
        public string DocTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets Description
        /// </summary>
        public byte[] JdrDescription { get; set; }
        /// <summary>
        /// Gets or Sets Document Name to display without file extension e.g. Automation Tool_Selenium
        /// </summary>
        public string DisplayDocName
        {
            get
            {
                return Path.GetFileNameWithoutExtension(JdrTitle);
            }
        }
    }
}
