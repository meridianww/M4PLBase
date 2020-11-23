using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Job Gateway Comment
    /// </summary>
    public class JobGatewayComment
    {
        /// <summary>
        /// Gets or Sets Job Gateway Id
        /// </summary>
        public long JobGatewayId { get; set; }
        /// <summary>
        /// Gets or Sets Job Gateway Description text
        /// </summary>
        public string JobGatewayDescription { get; set; }
    }
}
