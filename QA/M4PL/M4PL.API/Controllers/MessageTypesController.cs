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