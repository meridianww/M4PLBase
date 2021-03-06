﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobTrackingUpdateRequest
    {
        public long JobId { get; set; }
        public DateTime? ScheduleDate { get; set; }
        public string StatusCode { get; set; }
        public DateTime? GatewayACD { get; set; }
    }
}
