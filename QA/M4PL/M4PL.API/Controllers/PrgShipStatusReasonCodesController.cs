#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramShipStatusReasonCodes
//Purpose:                                      End point to interact with Program ShipStatusReasonCode module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgShipStatusReasonCodes")]
    public class PrgShipStatusReasonCodesController : BaseApiController<PrgShipStatusReasonCode>
    {
        private readonly IPrgShipStatusReasonCodeCommands _prgShipStatusReasonCodeCommands;

        /// <summary>
        /// Function to get Program's ShipStatusReasonCode details
        /// </summary>
        /// <param name="prgShipStatusReasonCodeCommands"></param>
        public PrgShipStatusReasonCodesController(IPrgShipStatusReasonCodeCommands prgShipStatusReasonCodeCommands)
            : base(prgShipStatusReasonCodeCommands)
        {
            _prgShipStatusReasonCodeCommands = prgShipStatusReasonCodeCommands;
        }
    }
}