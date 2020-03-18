using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobCardCondition
    {
        public long CompanyId { get; set; }
        public string WhereCondition { get; set; }
    }
}
