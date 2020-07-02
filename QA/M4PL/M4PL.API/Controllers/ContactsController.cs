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
//Program Name:                                 ActRoles
//Purpose:                                      End point to interact with Contact module
//====================================================================================================================================================*/

using M4PL.Business.Contact;
using M4PL.Entities.Contact;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/Contacts")]
	public class ContactsController : BaseApiController<Contact>
	{
		private readonly IContactCommands _contactCommands;

		/// <summary>
		/// Function to get the Contact details
		/// </summary>
		/// <param name="contactCommands"></param>
		public ContactsController(IContactCommands contactCommands)
			: base(contactCommands)
		{
			_contactCommands = contactCommands;
		}

		/// <summary>
		/// Function to update the Contact card details
		/// </summary>
		/// <param name="contact"></param>
		[HttpPut]
		[Route("ContactCard")]
		public Contact PutContactCard(Contact contact)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _contactCommands.PutContactCard(contact);
		}

		/// <summary>
		/// Function to update the Contact card details
		/// </summary>
		/// <param name="contact"></param>
		[HttpPut]
		[Route("AddContactCard")]
		public Contact PostContactCard(Contact contact)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _contactCommands.PostContactCard(contact);
		}

		/// <summary>
		/// Function to check contact is loggedIn or not
		/// </summary>
		/// <param name="contactId"></param>
		[HttpGet]
		[Route("CheckContactLoggedIn")]
		public bool CheckContactLoggedIn(long contactId)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _contactCommands.CheckContactLoggedIn(contactId);
		}
	}
}