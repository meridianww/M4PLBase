/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrGatewayListsController
//Purpose:                                      End point to interact with ScrGatewayList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrGatewayLists")]
    public class ScrGatewayListsController : BaseApiController<ScrGatewayList>
    {
        private readonly IScrGatewayListCommands _ScrGatewayListCommands;

        /// <summary>
        /// Function to get the ScrGatewayList details
        /// </summary>
        /// <param name="scrGatewayListCommands"></param>
        public ScrGatewayListsController(IScrGatewayListCommands scrGatewayListCommands)
            : base(scrGatewayListCommands)
        {
            _ScrGatewayListCommands = scrGatewayListCommands;
        }
    }
}