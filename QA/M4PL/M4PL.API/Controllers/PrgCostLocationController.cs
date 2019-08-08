/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              24/07/2019
//Program Name:                                 PrgCostLocations
//Purpose:                                      End point to interact with Program Cost Location module
//====================================================================================================================================================*/
using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Mvc;

namespace M4PL.API.Controllers
{


    [RoutePrefix("api/PrgCostLocation")]
    public class PrgCostLocationController : BaseApiController<PrgCostLocation>
    {
     
        private readonly IPrgCostLocationCommands _prgCostLocationCommands;
        /// <summary>
        /// Function to get Program's Role details
        /// </summary>
        /// <param name="prgCostLocationCommands"></param>
        public PrgCostLocationController(IPrgCostLocationCommands prgCostLocationCommands)
            : base(prgCostLocationCommands)
        {
            _prgCostLocationCommands = prgCostLocationCommands;
        }
    }
}