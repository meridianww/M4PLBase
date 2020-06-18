/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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