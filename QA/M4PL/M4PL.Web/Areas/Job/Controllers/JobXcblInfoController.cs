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
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = _jobXcblInfoCommands.GetJobXcblInfo(67899, "XCBL", "sjdfgjhsdf"); /// need pass real data
            _formResult.SetupFormResult(_commonCommands, route);
            _formResult.CallBackRoute = new MvcRoute();
            return PartialView(_formResult);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            base.DataView(strRoute, gridName);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
    }
}