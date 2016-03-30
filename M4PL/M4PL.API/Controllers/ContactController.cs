using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;

namespace M4PL_API.Controllers
{
    public class ContactController : ApiController
    {
        public int SaveContact(Contact contact)
        {
            try
            {
                return BAL_Contact.InsertContact(contact);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string Post(string fn, string ln)
        {
            return fn + " " + ln;
        }
    }
}