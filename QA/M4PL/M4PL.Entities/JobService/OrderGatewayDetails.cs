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
        /// Gets or Sets Gateway Code
        /// </summary>
        public string Code { get; set; }
        /// <summary>
        /// Gets or Sets Gateway Title
        /// </summary>
        public string Title { get; set; }
        /// <summary>
        /// Gets or Sets ACD
        /// </summary>
        public DateTime? Date { get; set; }
        /// <summary>
        /// Gets or Sets Sets Current DDP
        /// </summary>
        public DateTime? ScheduleDate { get; set; }
        /// <summary>
        /// Gets or Sets updated DDP
        /// </summary>
        public DateTime? RescheduleDate { get; set; }
        /// <summary>
        /// Gets or Sets Type Id if the current Gateway is Action or Gateway Type
        /// </summary>
        public int? Type { get; set; }
        /// <summary>
        /// Gets or Sets Gateway Name
        /// </summary>
        public string GateWayName { get; set; }
        public bool Completed { get; set; }
        public string Comment { get; set; }
        public string StatusCode { get; set; }
        public string AppointmentCode { get; set; }
    }
}
