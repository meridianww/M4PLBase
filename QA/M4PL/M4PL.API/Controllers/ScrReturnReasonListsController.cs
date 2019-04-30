/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrReturnReasonListsController
//Purpose:                                      End point to interact with ScrReturnReasonList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrReturnReasonLists")]
    public class ScrReturnReasonListsController : BaseApiController<ScrReturnReasonList>
    {
        private readonly IScrReturnReasonListCommands _scrReturnReasonListCommands;

        /// <summary>
        /// Function to get the ScrReturnReasonList details
        /// </summary>
        /// <param name="scrReturnReasonListCommands"></param>
        public ScrReturnReasonListsController(IScrReturnReasonListCommands scrReturnReasonListCommands)
            : base(scrReturnReasonListCommands)
        {
            _scrReturnReasonListCommands = scrReturnReasonListCommands;
        }
    }
}