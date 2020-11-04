using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class ITDashboardController : BaseController<ITDashboardView>
    {
        protected CardViewResult<ITDashboardView> _cardResult = new CardViewResult<ITDashboardView>();
        private readonly IITDashboardCommands _itDashBoardCommands;
        public ITDashboardController(IITDashboardCommands iTDashboardCommands, ICommonCommands commonCommands) : base(iTDashboardCommands)
        {
            _commonCommands = commonCommands;
            _itDashBoardCommands = iTDashboardCommands;
            _commonCommands.ActiveUser = SessionProvider.ActiveUser;
        }

        // GET: Administration/ITDashboard
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CardView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
            _cardResult.SetupCardResult(_commonCommands, route, SessionProvider);
            var record = _itDashBoardCommands.GetCardTileData("IT");
            if (record != null) _cardResult.Records = record.GetCardViewViews();
            return PartialView(MvcConstants.ViewCardViewDashboard, _cardResult);
        }
    }
}