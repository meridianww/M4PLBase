using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobVocReport : BaseModel
    {
        public long Id { get; set; }
        public string CustCode { get; set; }
        public string LocationCode { get; set; }
        public string ContractNumber { get; set; }
        public string DriverId { get; set; }
        public int DeliverySatisfaction { get; set; }
        public int CSRProfessionalism { get; set; }
        public int AdvanceDeliveryTime { get; set; }
        public int DriverProfessionalism { get; set; }
        public int DeliveryTeamHelpfulness { get; set; }
        public int OverallScore { get; set; }
        public string Feedback { get; set; }
    }
}
