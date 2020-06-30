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