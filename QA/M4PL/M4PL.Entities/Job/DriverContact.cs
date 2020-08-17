using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class DriverContact
    {
        private long? id { get; set; }
        public string locationCode { get; set; }
        public string firstName { get; set;     }
        public string lastName { get; set; }
        public string bizMoblContactID { get; set; }
        public long? jobId { get; set; }
    }
}
