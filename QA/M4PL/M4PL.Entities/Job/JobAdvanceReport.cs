using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobAdvanceReport : BaseModel
    {
        public long CustomerId { get; set; }
        public long ProgramId { get; set; }
        public string ProgramIdCode { get; set; }
        public long OrderTypeId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Scheduled { get; set; }
        public string Origin { get; set; }
        public string Destination { get; set; }
        public long JobStatusId { get; set; }
        public long GatewayStatusId { get; set; }
        public long ServiceMode { get; set; }
        public long Mode { get; set; }
        public string Search { get; set; }
    }
}
