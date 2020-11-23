using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Job reference Document
    /// </summary>
    public class JobDocument
    {
        /// <summary>
        /// Gets or Sets Doc Reference Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Job Id
        /// </summary>
        public long JobId { get; set; }
        /// <summary>
        /// Gets or Sets Document Type Id e.g. 205 for Document
        /// </summary>
        public int? DocTypeId { get; set; }
        /// <summary>
        /// Gets or Sets Status Id
        /// </summary>
        public int? StatusId { get; set; }
        /// <summary>
        /// Gets or Sets Job Document Reference Code e.g. Damaged Imaged
        /// </summary>
        public string JdrCode { get; set; }
        /// <summary>
        /// Gets or Sets  Document Reference Title/uploaded file Name e.g. fm_meridian_assets_ps_hp_homedelivery.jpg
        /// </summary>
        public string JdrTitle { get; set; }
        /// <summary>
        /// Gets or Sets List of attached document
        /// </summary>
        public List<DocumentAttachment> DocumentAttachment { get; set; }
    }
    /// <summary>
    /// Model class for Document Attachment
    /// </summary>
    public class DocumentAttachment
    {
        /// <summary>
        /// Gets or Sets document content in VarBinary format
        /// </summary>
        public byte[] Content { get; set; }
        /// <summary>
        /// Gets or Sers document name
        /// </summary>
        public string Name { get; set; }
    }
}
