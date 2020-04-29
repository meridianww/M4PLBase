using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobHistoryController : BaseController<JobHistoryView>
    {
        private readonly IJobHistoryCommand _jobHistoryCommands;
        public JobHistoryController(IJobHistoryCommand jobHistoryCommand, ICommonCommands commonCommands)
            : base(jobHistoryCommand)
        {
            _commonCommands = commonCommands;
            _jobHistoryCommands = jobHistoryCommand;
        }
      
        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SetGridResult(route, gridName, false);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
    }
}