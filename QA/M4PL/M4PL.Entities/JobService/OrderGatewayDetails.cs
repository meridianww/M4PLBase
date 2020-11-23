using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Job Gateways
    /// </summary>
    public class OrderGatewayDetails
    {
        /// <summary>
        /// Gets or Sets Gateway Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Job ID
        /// </summary>
        public long JobID { get; set; }
        /// <summary>
        /// Gets or Sets Gateway COde
        /// </summary>
        public string GatewayCode { get; set; }
        /// <summary>
        /// Gets or Sets ACD
        /// </summary>
        public DateTime? ACD { get; set; }
        /// <summary>
        /// Gets or Sets Sets Current DDP
        /// </summary>
        public DateTime? GwyDDPCurrent { get; set; }
        /// <summary>
        /// Gets or Sets updated DDP
        /// </summary>
        public DateTime? GwyDDPNew { get; set; }
        /// <summary>
        /// Gets or Sets Type Id if the current Gateway is Action or Gateway Type
        /// </summary>
        public int? TypeId { get; set; }
        /// <summary>
        /// Gets or Sets Gateway Name
        /// </summary>
        public string GateWayName { get; set; }
    }
}
