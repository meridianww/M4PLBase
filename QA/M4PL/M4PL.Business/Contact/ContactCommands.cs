/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ContactCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Contact.ContactCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Contact.ContactCommands;

namespace M4PL.Business.Contact
{
    public class ContactCommands : BaseCommands<Entities.Contact.Contact>, IContactCommands
    {
        /// <summary>
        /// Get list of contacts data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Contact.Contact> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific contact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Contact.Contact Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new contact record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Contact.Contact Post(Entities.Contact.Contact contact)
        {
            return _commands.Post(ActiveUser, contact);
        }

        /// <summary>
        /// Updates an existing contact record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Contact.Contact Put(Entities.Contact.Contact contact)
        {
            return _commands.Put(ActiveUser, contact);
        }

        /// <summary>
        /// Deletes a specific contact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of contacts records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Updates an existing contact card record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Contact.Contact PutContactCard(Entities.Contact.Contact contact)
        {
            return _commands.PutContactCard(ActiveUser, contact);
        }

        /// <summary>
        /// Updates an existing contact card record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact)
        {
            return _commands.Post(ActiveUser, contact);
        }

        /// <summary>
        /// Check contact is loggedIn or not
        /// </summary>
        /// <param name="contactId"></param>
        /// <returns></returns>

        public bool CheckContactLoggedIn(long contactId)
        {
            return _commands.CheckContactLoggedIn(contactId);
        }

        public Entities.Contact.Contact Patch(Entities.Contact.Contact entity)
        {
            throw new NotImplementedException();
        }
    }
}