/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Contact Reorts
//====================================================================================================================================================*/

using M4PL.Business.Contact;
using M4PL.Entities.Contact;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ConReports")]
    public class ConReportsController : BaseApiController<ConReport>
    {
        private readonly IConReportCommands _ConReportCommands;

        /// <summary>
        /// Fucntion to get Contacts reports
        /// </summary>
        /// <param name="conReportCommands"></param>
        public ConReportsController(IConReportCommands conReportCommands)
            : base(conReportCommands)
        {
            _ConReportCommands = conReportCommands;
        }
    }
}