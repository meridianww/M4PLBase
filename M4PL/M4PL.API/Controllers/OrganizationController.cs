//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/5/2016
//Program Name:                                 Organisation
//Purpose:                                      Returns serialized data for Organisation
//
//==================================================================================================================================================== 

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
        /// <summary>
        /// Function to get the list of all Organizations
        /// </summary>
        /// <returns></returns>
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

        /// <summary>
        /// Function to get the details of selected Organization
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Function to Save Organization details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Function to Update Organization details
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Function to Delete Organization details
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Function to Get Sort Order for Organizations to select
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
        [Route("api/Organization/GetOrgSortOrder")]
        public List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return BAL_Organization.GetOrgSortOrder(OrganizationID);
        }
    }
}
