using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobCardRequest
    {
        public long Count { get; set; }
        public string CardName { get; set; }

        public string CardType { get; set; }
        public string BackGroundColor { get; set; }
        public long DashboardCategoryRelationId { get; set; }
        public long? CustomerId { get; set; }
    }
}
