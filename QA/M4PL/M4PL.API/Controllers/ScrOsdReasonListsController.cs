/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrOsdReasonListsController
//Purpose:                                      End point to interact with ScrOsdReasonList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrOsdReasonLists")]
    public class ScrOsdReasonListsController : BaseApiController<ScrOsdReasonList>
    {
        private readonly IScrOsdReasonListCommands _scrOsdReasonListCommands;

        /// <summary>
        /// Function to get the ScrOsdReasonList details
        /// </summary>
        /// <param name="scrOsdReasonListCommands"></param>
        public ScrOsdReasonListsController(IScrOsdReasonListCommands scrOsdReasonListCommands)
            : base(scrOsdReasonListCommands)
        {
            _scrOsdReasonListCommands = scrOsdReasonListCommands;
        }
    }
}