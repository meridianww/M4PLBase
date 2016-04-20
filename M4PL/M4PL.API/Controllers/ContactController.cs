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
        public int Post(Contact value)
        {
            return BAL_Contact.InsertContactDetails(value);
        }
        
        public int Put(int Id, Contact value)
        {
            return BAL_Contact.UpdateContactDetails(value);
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

        //GET api/<controller>/5
        public Contact Get(int ContactID)
        {
            return BAL_Contact.GetContactDetails(ContactID);
        }

    }
}
