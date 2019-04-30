/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramBillableRates
//Purpose:                                      End point to interact with Program Billable Rate module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ProgramBillableRates")]
    public class PrgBillableRatesController : BaseApiController<PrgBillableRate>
    {
        private readonly IPrgBillableRateCommands _programBillableRateCommands;

        /// <summary>
        /// Function to get Program's Billable rate details
        /// </summary>
        /// <param name="programBillableRateCommands"></param>
        public PrgBillableRatesController(IPrgBillableRateCommands programBillableRateCommands)
            : base(programBillableRateCommands)
        {
            _programBillableRateCommands = programBillableRateCommands;
        }
    }
}