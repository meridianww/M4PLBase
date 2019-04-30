/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Organization Reorts
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgReports")]
    public class OrgReportsController : BaseApiController<OrgReport>
    {
        private readonly IOrgReportCommands _orgReportCommands;

        /// <summary>
        /// Fucntion to get Organizations reports
        /// </summary>
        /// <param name="orgReportCommands"></param>
        public OrgReportsController(IOrgReportCommands orgReportCommands)
            : base(orgReportCommands)
        {
            _orgReportCommands = orgReportCommands;
        }
    }
}