using M4PL.Entities;
using M4PL.Entities.Job;

namespace M4PL.APIClient.ViewModels.Job
{
    public class JobAdvanceReportFilterView : JobAdvanceReportFilter
    {
        public JobAdvanceReportFilterView()
        { }

        public JobAdvanceReportFilterView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}
