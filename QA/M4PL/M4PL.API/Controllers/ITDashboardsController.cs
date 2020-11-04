using M4PL.API.Filters;
using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// ITDashboardsController
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/ITDashboards")]
    public class ITDashboardsController : ApiController
    {
        private readonly IITDashboardCommands _iTDashboardCommands;
        /// <summary>
        /// ITDashboardsController
        /// </summary>
        /// <param name="iTDashboardCommands"></param>
        public ITDashboardsController(IITDashboardCommands iTDashboardCommands)
        {
            _iTDashboardCommands = iTDashboardCommands;
        }

        /// <summary>
        /// IT Dashboard GetCardTileData
        /// </summary>
        /// <param name="dashboardName"></param>
        /// <returns></returns>
        [CustomQueryable]
        [HttpGet]
        [Route("GetCardTileData")]
        public IQueryable<ITDashboard> GetCardTileData(string dashboardName)
        {
            _iTDashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _iTDashboardCommands.GetCardTileData(dashboardName).AsQueryable();
        }
    }
}
