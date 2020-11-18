#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IMessageTypeCommands
// Purpose:                                      Set of rules for MessageTypeCommands
//==============================================================================================================

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
	public interface IMessageTypeCommands : IBaseCommands<MessageType>
	{
		/// <summary>
		/// Performs delete operation based on system messagetype
		/// Gets message type based on system message type
		/// </summary>
		/// <param name="sysMsgType"></param>
		/// <returns></returns>
		MessageType GetBySysMsgType(string sysMsgType);

		MessageType DeleteBySysMsgType(string sysMsgType);
	}
}