/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Vendor Reorts
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendReports")]
    public class VendReportsController : BaseApiController<VendReport>
    {
        private readonly IVendReportCommands _VendReportCommands;

        /// <summary>
        /// Fucntion to get Vendors reports
        /// </summary>
        /// <param name="vendReportCommands"></param>
        public VendReportsController(IVendReportCommands vendReportCommands)
            : base(vendReportCommands)
        {
            _VendReportCommands = vendReportCommands;
        }
    }
}