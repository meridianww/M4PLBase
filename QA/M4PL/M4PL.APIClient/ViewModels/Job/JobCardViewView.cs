using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL.Entities.Job;

namespace M4PL.APIClient.ViewModels.Job
{
    public class JobCardViewView : JobCardTile
    {
        public JobCardViewView()
        {
        }

        public JobCardViewView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }

    }
}
