using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class UnCancelJobResponse
    {
        public long JobId { get; set; }
        public long ProgramId { get; set; }
        public long CurrentGatewayId { get; set; }
        public string ErrorMessage { get; set; }
        public bool IsSuccess { get; set; }
        public DateTime? JobOriginDateTimePlanned { get; set; }
        public DateTime? JobDeliveryDateTimePlanned { get; set; }
    }
}
