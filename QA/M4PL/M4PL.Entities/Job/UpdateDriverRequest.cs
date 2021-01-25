using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Request model for Update Driver alert
    /// </summary>
    public class UpdateDriverRequest
    {
        public long jobId { get; set; }
        public string jobDriverAlert { get; set; }
    }
}
