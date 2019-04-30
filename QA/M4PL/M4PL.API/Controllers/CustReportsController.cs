/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Customer Reorts
//====================================================================================================================================================*/
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustReports")]
    public class CustReportsController : BaseApiController<CustReport>
    {
        private readonly ICustReportCommands _custReportCommands;

        /// <summary>
        /// Fucntion to get Customers reports
        /// </summary>
        /// <param name="custReportCommands"></param>
        public CustReportsController(ICustReportCommands custReportCommands)
            : base(custReportCommands)
        {
            _custReportCommands = custReportCommands;
        }
    }
}