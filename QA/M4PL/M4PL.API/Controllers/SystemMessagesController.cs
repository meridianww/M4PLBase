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
//Program Name:                                 SystemMessages
//Purpose:                                      End point to interact with System Message module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SystemMessages")]
    public class SystemMessagesController : BaseApiController<SystemMessage>
    {
        private readonly ISystemMessageCommands _systemMessagesCommands;

        /// <summary>
        /// Function to get Administration's System message details
        /// </summary>
        /// <param name="systemMessageCommands"></param>
        public SystemMessagesController(ISystemMessageCommands systemMessageCommands)
            : base(systemMessageCommands)
        {
            _systemMessagesCommands = systemMessageCommands;
        }
    }
}