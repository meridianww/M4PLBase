/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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