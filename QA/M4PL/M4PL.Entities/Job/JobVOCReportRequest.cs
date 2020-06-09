using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace M4PL.Entities.Job
{
    public class JobVOCReportRequest // : Support.MvcRoute
    {
        public List<string> Location { get; set; }
        [DisplayName("Start Date")]
        public DateTime? StartDate { get; set; }
        [DisplayName("End Date")]
        public DateTime? EndDate { get; set; }
        public long? CompanyId { get; set; }
        public bool IsPBSReport { get; set; }
    }
}
