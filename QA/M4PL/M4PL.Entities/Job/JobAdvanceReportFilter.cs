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
        public string ProgramIdCode { get; set; }
        public int? OrderType { get; set; }
        public string OrderTypeName { get; set; }
        public int? Scheduled { get; set; }
        public string ScheduledName { get; set; }
        public string Origin { get; set; }
        public string Destination { get; set; }
        public long JobStatusId { get; set; }
        public string JobStatusIdName { get; set; }
        public string GatewayStatus { get; set; }
        public string ServiceMode { get; set; }
        public long Mode { get; set; }
        public string Search { get; set; }
        public string ProgramCode { get; set; }
        public string ProgramTitle { get; set; }
        public string Brand { get; set; }
        public string ProductType { get; set; }
        public string JobChannel { get; set; }
        public string DateTypeName { get; set; }
    }
}
