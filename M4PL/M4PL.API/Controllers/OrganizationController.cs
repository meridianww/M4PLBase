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
    public class OrganizationController : ApiController
    {
        // GET api/<controller>
        public Response<Organization> Get()
        {
            try
            {
                return new Response<Organization> { Status = true, DataList = BAL_Organization.GetAllOrganizations() ?? new List<Organization>() };
            }
            catch (Exception ex)
            {
                return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        //GET api/<controller>/5
        public Response<Organization> Get(int OrganizationID)
        {
            try
            {
                return new Response<Organization> { Status = true, Data = BAL_Organization.GetOrganizationDetails(OrganizationID) ?? new Organization() };
            }
            catch (Exception ex)
            {
                return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // POST api/<controller>
        public Response<Organization> Post(Organization value)
        {
            try
            {
                var res = BAL_Organization.SaveOrganization(value);
                if (res > 0)
                    return new Response<Organization> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveOrganization_Success };
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveOrganization_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveOrganization_Duplicate };
                        default:
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // PUT api/<controller>/5
        public Response<Organization> Put(int id, Organization value)
        {
            try
            {
                var res = BAL_Organization.SaveOrganization(value);
                if (res > 0)
                    return new Response<Organization> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveOrganization_Success };
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveOrganization_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveOrganization_Duplicate };
                        default:
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // DELETE api/<controller>/5
        public Response<Organization> Delete(int OrganizationID)
        {
            try
            {
                var res = BAL_Organization.RemoveOrganization(OrganizationID);
                if (res > 0)
                    return new Response<Organization> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.RemoveOrganization_Success };
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.RemoveOrganization_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 547: // Foreign Key violation
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.ForeignKeyIssue, Message = DisplayMessages.RemoveOrganization_ForeignKeyIssue };
                        default:
                            return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Organization> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        [Route("api/Organization/GetOrgSortOrder")]
        public List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return BAL_Organization.GetOrgSortOrder(OrganizationID);
        }
    }
}
