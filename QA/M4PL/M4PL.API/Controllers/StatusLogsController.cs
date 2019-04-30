/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              06/06/2018
//Program Name:                                 DeliveryStatus
//Purpose:                                      End point to interact with Delivery Status module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/StatusLogs")]
    public class StatusLogsController : BaseApiController<StatusLog>
    {
        private readonly IStatusLogCommands _statusLogCommands;

        /// <summary>
        /// Function to get tables and reference name details
        /// </summary>
        /// <param name="statusLogCommands"></param>
        public StatusLogsController(IStatusLogCommands statusLogCommands)
            : base(statusLogCommands)
        {
            _statusLogCommands = statusLogCommands;
        }

    }
}