using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class ProjectedCapacityData
    {
        public long CustomerId { get; set; }
        public int Year { get; set; }
        public List<ProjectedCapacityRawData> ProjectedCapacityRawData { get; set; }
    }
}
