﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MessageTypes
//Purpose:                                      End point to interact with Message Types module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/MessageTypes")]
    public class MessageTypesController : BaseApiController<MessageType>
    {
        private readonly IMessageTypeCommands _messageTypeCommands;

        /// <summary>
        /// Function to get Administration's Message Type details
        /// </summary>
        /// <param name="messageTypeCommands"></param>
        public MessageTypesController(IMessageTypeCommands messageTypeCommands)
            : base(messageTypeCommands)
        {
            _messageTypeCommands = messageTypeCommands;
        }
    }
}