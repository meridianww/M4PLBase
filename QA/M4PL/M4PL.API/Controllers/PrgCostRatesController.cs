/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramCostRates
//Purpose:                                      End point to interact with Program Cost Rates module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ProgramCostRates")]
    public class PrgCostRatesController : BaseApiController<PrgCostRate>
    {
        private readonly IPrgCostRateCommands _programCostRateCommands;

        /// <summary>
        /// Function to get Program's cost rate details
        /// </summary>
        /// <param name="programCostRateCommands"></param>
        public PrgCostRatesController(IPrgCostRateCommands programCostRateCommands)
            : base(programCostRateCommands)
        {
            _programCostRateCommands = programCostRateCommands;
        }
    }
}