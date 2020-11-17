using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Model class for User Guide upload
    /// </summary>
    public class UserGuidUpload : BaseModel
    {
        /// <summary>
        /// Gets or Sets Document Name 
        /// </summary>
        public string DocumentName { get; set; }
        /// <summary>
        /// Gets or Sets URL of User Guide
        /// </summary>
        public string Url { get; set; }
        /// <summary>
        /// Gets or Sets PDF Document content
        /// </summary>
        public byte[] FileContent { get; set; }
    }
}
