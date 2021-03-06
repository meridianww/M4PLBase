﻿#region Copyright

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
// Program Name:                                 ICustomerCommands
// Purpose:                                      Set of rules for CustomerCommands
//==============================================================================================================

using M4PL.Entities;

namespace M4PL.Business.Email
{
	/// <summary>
	/// Performs basic CRUD operation on the Customer Entity
	/// </summary>
	public interface IEmailCommands : IBaseCommands<EmailDetail>
	{
		SMTPEmailDetail GetSMTPEmailDetail(int emailCount, int toHours, int fromHours);

		bool UpdateEmailStatus(int id, short emailStatus, short retryAttampts);
		bool xCBLEmailNotification(int scenarioTypeId);
		bool EDIEmailNotification(int scenarioTypeId);
	}
}