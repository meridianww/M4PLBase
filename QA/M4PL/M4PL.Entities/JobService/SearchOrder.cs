using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class SearchOrder
    {
        public long Id { get; set; }
        public string CustomerSalesOrder { get; set; }
        public string GatewayStatus { get; set; }
        public DateTime? DeliveryDatePlanned { get; set; }
        public DateTime? ArrivalDatePlanned { get; set; }
    }
}
