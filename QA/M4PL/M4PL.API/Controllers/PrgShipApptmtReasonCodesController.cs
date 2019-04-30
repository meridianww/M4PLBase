/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramShipApptmtReasonCodes
//Purpose:                                      End point to interact with Program ShipApptmtReasonCode module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgShipApptmtReasonCodes")]
    public class PrgShipApptmtReasonCodesController : BaseApiController<PrgShipApptmtReasonCode>
    {
        private readonly IPrgShipApptmtReasonCodeCommands _prgShipApptmtReasonCodeCommands;

        /// <summary>
        ///  Function to get program's ShipApptmtReasonCode details
        /// </summary>
        /// <param name="prgShipApptmtReasonCodeCommands"></param>
        public PrgShipApptmtReasonCodesController(IPrgShipApptmtReasonCodeCommands prgShipApptmtReasonCodeCommands)
            : base(prgShipApptmtReasonCodeCommands)
        {
            _prgShipApptmtReasonCodeCommands = prgShipApptmtReasonCodeCommands;
        }
    }
}