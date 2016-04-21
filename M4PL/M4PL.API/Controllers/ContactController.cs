using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;
using M4PL_API_CommonUtils;
using System.Data.SqlClient;

namespace M4PL.API.Controllers
{
    public class ContactController : ApiController
    {
        public Response<Contact> Post(Contact value)
        {
            try
            {
                var res = BAL_Contact.InsertContactDetails(value);
                if (res > 0)
                    return new Response<Contact> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveContact_Success };
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveContact_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveContact_Duplicate };
                        default:
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        public Response<Contact> Put(int Id, Contact value)
        {
            try
            {
                var res = BAL_Contact.UpdateContactDetails(value);
                if (res > 0)
                    return new Response<Contact> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveContact_Success };
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveContact_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveContact_Duplicate };
                        default:
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        public Response<Contact> Delete(int ContactID)
        {
            try
            {
                var res = BAL_Contact.RemoveContact(ContactID);
                if (res > 0)
                    return new Response<Contact> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.RemoveContact_Success };
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.RemoveContact_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 547: // Foreign Key violation
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.ForeignKeyIssue, Message = DisplayMessages.RemoveContact_ForeignKeyIssue };
                        default:
                            return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        public Response<Contact> Get()
        {
            try
            {
                return new Response<Contact> { Status = true, DataList = BAL_Contact.GetAllContacts() ?? new List<Contact>() };
            }
            catch (Exception ex)
            {
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        //GET api/<controller>/5
        public Response<Contact> Get(int ContactID)
        {
            try
            {
                return new Response<Contact> { Status = true, Data = BAL_Contact.GetContactDetails(ContactID) ?? new Contact() };
            }
            catch (Exception ex)
            {
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

    }
}
