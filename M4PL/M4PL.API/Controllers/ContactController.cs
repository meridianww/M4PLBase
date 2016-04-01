using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;

namespace M4PL.API.Controllers
{
    public class ContactController : ApiController
    {
        public int SaveContact(Contact contact)
        {
            try
            {
                if (contact.ContactID == 0)
                    return BAL_Contact.InsertContactDetails(contact);
                else
                    return BAL_Contact.UpdateContactDetails(contact);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int Delete(int ContactID)
        {
            try
            {
                return BAL_Contact.RemoveContact(ContactID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<Contact> Get()
        {
            try
            {
                return BAL_Contact.GetAllContacts();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Contact Get(int ContactID)
        {
            try
            {
                return BAL_Contact.GetContactDetails(ContactID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
