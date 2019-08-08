using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    
    public class JobsSiteCode : BaseModel
    {

        /// <summary>
        /// Gets or sets the type of job.
        /// </summary>
        /// <value>
        /// The JobSiteCode.
        /// </value>
        public string PvlLocationCode { get; set; }

        /// <summary>
        /// Gets or sets the type of job.
        /// </summary>
        /// <value>
        /// The JobSiteId.
        /// </value>
        public long PvlVendorID { get; set; }


    }
}
