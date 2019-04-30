/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Reorts
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Reports")]
    public class ReportsController : BaseApiController<Report>
    {
        private readonly IReportCommands _reportCommands;

        /// <summary>
        /// Function to get Administration's menu driver details
        /// </summary>
        /// <param name="reportCommands"></param>
        public ReportsController(IReportCommands reportCommands)
            : base(reportCommands)
        {
            _reportCommands = reportCommands;
        }
    }
}