using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobAdvanceReportFilter : BaseReportModel
    {
        public JobAdvanceReportFilter()
        {
        }

        public JobAdvanceReportFilter(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }

        public long CustomerId { get; set; }
        public long ProgramId { get; set; }
        public long OrderTypeId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Scheduled { get; set; }
        public long Origin { get; set; }
        public long Destination { get; set; }
        public long JobStatusId { get; set; }
        public long GatewayStatusId { get; set; }
        public long ServiceMode { get; set; }
        public long Mode { get; set; }
        public string Search { get; set; }
    }
}
