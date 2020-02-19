using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobCardTileDetail : BaseModel
    {
        public long DashboardCategoryRelationId { get; set; }

        public long RecordCount { get; set; }
        public string DashboardName { get; set; }
        public string DashboardCategoryDisplayName { get; set; }
        public string DashboardSubCategoryDisplayName { get; set; }

    }
}
