#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.Mvc;

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
            route.OwnerCbPanel = "AppCbPanel";
            route.IsPBSReport = true;
            SetGridResult(route, gridName, false);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
    }
}