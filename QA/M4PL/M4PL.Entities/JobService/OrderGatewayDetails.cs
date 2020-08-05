using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class OrderGatewayDetails
    {
        public long Id { get; set; }
        public long JobID { get; set; }
        public string GatewayCode { get; set; }
        public DateTime? ACD { get; set; }
        public DateTime? GwyDDPCurrent { get; set; }
        public DateTime? GwyDDPNew { get; set; }
        public int? TypeId { get; set; }
        public string GateWayName { get; set; }
    }
}
