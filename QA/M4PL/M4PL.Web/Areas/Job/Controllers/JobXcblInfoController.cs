using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobXcblInfoController : BaseController<JobXcblInfoView>
    {
        private readonly IJobXcblInfoCommands _jobXcblInfoCommands;
        public JobXcblInfoController(IJobXcblInfoCommands jobXcblInfoCommands, ICommonCommands commonCommands)
            : base(jobXcblInfoCommands)
        {
            _commonCommands = commonCommands;
            _jobXcblInfoCommands = jobXcblInfoCommands;
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);



            return PartialView(_formResult);
        }
    }
}