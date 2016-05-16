using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;
using System.Web.Security;
using M4PL_API_CommonUtils;
using System.Data.SqlClient;

namespace M4PL.API.Controllers
{
    public class UserController : ApiController
    {
        /// <summary>
        /// Function to get the list of all users
        /// </summary>
        /// <returns></returns>
        public Response<disUser> Get()
        {
            try
            {
                return new Response<disUser> { Status = true, DataList = BAL_User.GetAllUserAccounts() ?? new List<disUser>() };
            }
            catch (Exception ex)
            {
                return new Response<disUser> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public Response<User> Get(int UserID)
        {
            try
            {
                return new Response<User> { Status = true, Data = BAL_User.GetUserAccount(UserID) ?? new User() };
            }
            catch (Exception ex)
            {
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Save user details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public Response<User> Post(User value)
        {
            try
            {
                var res = BAL_User.SaveUserAccount(value);
                if (res > 0)
                    return new Response<User> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveUser_Success };
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveUser_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<User> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveUser_Duplicate };
                        default:
                            return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Update user details
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public Response<User> Put(int id, User value)
        {
            try
            {
                var res = BAL_User.SaveUserAccount(value);
                if (res > 0)
                    return new Response<User> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveUser_Success };
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveUser_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<User> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveUser_Duplicate };
                        default:
                            return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Delete user details
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public Response<User> Delete(int UserID)
        {
            try
            {
                var res = BAL_User.RemoveUserAccount(UserID);
                if (res > 0)
                    return new Response<User> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.RemoveUser_Success };
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.RemoveUser_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 547: // Foreign Key violation
                            return new Response<User> { Status = false, MessageType = MessageTypes.ForeignKeyIssue, Message = DisplayMessages.RemoveUser_ForeignKeyIssue };
                        default:
                            return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }
    }
}
