using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class BizMoblGatewayRequest
    {
        public long JobId { get; set; }
        public string GatewayStatusCode { get; set; }
        public DateTime? DeliveredDate { get; set; }
    }
}
