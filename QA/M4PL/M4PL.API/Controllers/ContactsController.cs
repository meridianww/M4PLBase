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
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Contacts
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/Contacts")]
	public class ContactsController : ApiController
	{
		private readonly IContactCommands _contactCommands;

		/// <summary>
		/// Function to get the Contact details
		/// </summary>
		/// <param name="contactCommands"></param>
		public ContactsController(IContactCommands contactCommands)
			
		{
			_contactCommands = contactCommands;
           
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<Contact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the contact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Contact Get(long id)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new contact object passed as parameter.
        /// </summary>
        /// <param name="contact">Refers to contact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Contact Post(Contact contact)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Post(contact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on contact object passed.
        /// </summary>
        /// <param name="contact">Refers to contact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Contact Put(Contact contact)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Put(contact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on contact object passed.
        /// </summary>
        /// <param name="contact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Contact Patch(Contact contact)
        {
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _contactCommands.Patch(contact);
        }
        /// <summary>
        /// Function to update the Contact card details
        /// </summary>
        /// <param name="contact"></param>
        [HttpPut]
		[Route("ContactCard")]
		public Contact PutContactCard(Contact contact)
		{
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser; ;
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
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser; ;
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
            _contactCommands.ActiveUser = Models.ApiContext.ActiveUser; ;
			return _contactCommands.CheckContactLoggedIn(contactId);
		}
	}
}