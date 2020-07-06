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
//Program Name:                                 SecurityCommands
//Purpose:                                      Contains action related to user securities
//====================================================================================================================================================*/

using M4PL.API.Models;
using M4PL.Entities.Support;
using Orbit.WebApi.Security;

namespace M4PL.API.Controllers
{
	public class SecurityCommands : SecurityCommandBase
	{
		/// <summary>
		/// Encrypts the specified text.
		/// </summary>
		/// <param name="text">The text.</param>
		/// <returns>
		/// encrypted text
		/// </returns>
		public override string Encrypt(string text)
		{
			text = SecureString.Encrypt(text);
			return base.Encrypt(text);
		}

		/// <summary>
		/// Gets the decrypted password.
		/// </summary>
		/// <param name="password">The password.</param>
		/// <param name="clientId">The client identifier.</param>
		/// <returns>
		/// decrypted password
		/// </returns>
		public override string GetDecryptedPassword(string password, string clientId)
		{
			return base.GetDecryptedPassword(password, clientId);
		}

		/// <summary>
		/// Gets the decrypted username.
		/// </summary>
		/// <param name="username">The username.</param>
		/// <param name="clientId">The client identifier.</param>
		/// <returns>
		/// decrypted username
		/// </returns>
		public override string GetDecryptedUsername(string username, string clientId)
		{
			return base.GetDecryptedUsername(username, clientId);
		}

		/// <summary>
		/// Validates the username and password.
		/// </summary>
		/// <param name="username">The username.</param>
		/// <param name="password">The password.</param>
		/// <returns>
		/// validated result
		/// </returns>
		public override bool ValidateUsernameAndPassword(string username, string password)
		{
			return base.ValidateUsernameAndPassword(username, password);
		}

		internal ActiveUser GetCurrentUser()
		{
			return new ActiveUser { UserId = ApiContext.UserId };
		}
	}
}