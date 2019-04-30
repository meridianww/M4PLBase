/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Program Reorts
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgReports")]
    public class PrgReportsController : BaseApiController<PrgReport>
    {
        private readonly IPrgReportCommands _PrgReportCommands;

        /// <summary>
        /// Fucntion to get Programs reports
        /// </summary>
        /// <param name="prgReportCommands"></param>
        public PrgReportsController(IPrgReportCommands prgReportCommands)
            : base(prgReportCommands)
        {
            _PrgReportCommands = prgReportCommands;
        }
    }
}