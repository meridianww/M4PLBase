
//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Ramkumar 
//Date Programmed:                              2/6/2016
//Program Name:                                 System Message Template
//Purpose:                                      Returns serialized data for System Message Template
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
using M4PL.API.App_Start;
using System.Web;

namespace M4PL.API.Controllers
{
    public class SystemMessagesController : ApiController
    {
        static List<disMessages> lstMsgs { get; set; }

        public SystemMessagesController()
        {
            lstMsgs = this.GetMessages();
        }

        List<disMessages> GetMessages()
        {
            if (lstMsgs == null || lstMsgs.Count() == 0)
                return BAL_SysMessages.GetSysMessagesTemplates("SystemMessages");
            else
                return lstMsgs;
        }
        

        /// <summary>
        /// IF (screenName != null && screenName.Length > 0) Function to get the list of all SystemMessages ELSE Function to get the list of all SystemMessages
        /// </summary>
        /// <param name="screenName"></param>
        /// <returns></returns>
        public Response<disMessages> Get(string screenName = "")
        {
            try
            {
                if (screenName != null && screenName.Length > 0)
                    return new Response<disMessages> { Status = true, DataList = BAL_SysMessages.GetSysMessagesTemplates(screenName) ?? new List<disMessages>() };
                else
                    return new Response<disMessages> { Status = true, DataList = BAL_SysMessages.GetAllSystemMessages((HttpContext.Current.Session[SessionNames.UserID] != null && Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) > 0) ? Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) : 0) ?? new List<disMessages>() };
            }
            catch (Exception ex)
            {
                return new Response<disMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message, SystemMessages = lstMsgs[0] };
            }
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public Response<SystemMessages> Get(int SystemMessagesID, string ScreenName)
        {
            try
            {
                return new Response<SystemMessages> { Status = true, Data = BAL_SysMessages.GetSystemMessageDetails(SystemMessagesID) ?? new SystemMessages() };
            }
            catch (Exception ex)
            {
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Save SystemMessages details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        [ValidateModel]
        public Response<SystemMessages> Post(SystemMessages value)
        {
            try
            {
                BAL_SysMessages.GetSysMessagesTemplates("SystemMessages", "Save");
                var res = BAL_SysMessages.SaveSystemMessages(value);
                if (res > 0)
                    return new Response<SystemMessages> { Status = true, MessageType = MessageTypes.Success, SystemMessages = lstMsgs[1] };
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Failure, SystemMessages = lstMsgs[0] };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Duplicate };
                        default:
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Update SystemMessages details
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        [ValidateModel]
        public Response<SystemMessages> Put(int id, SystemMessages value)
        {
            try
            {
                var res = BAL_SysMessages.SaveSystemMessages(value);
                if (res > 0)
                    return new Response<SystemMessages> { Status = true, MessageType = MessageTypes.Success, SystemMessages = lstMsgs[1] };
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Failure, SystemMessages = lstMsgs[0] };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Duplicate };
                        default:
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Delete SystemMessages details
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public Response<SystemMessages> Delete(int SystemMessagesID)
        {
            try
            {
                var res = BAL_SysMessages.RemoveSystemMessage(SystemMessagesID);
                if (res > 0)
                    return new Response<SystemMessages> { Status = true, MessageType = MessageTypes.Success, SystemMessages = lstMsgs[1] };
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Failure, SystemMessages = lstMsgs[0] };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 547: // Foreign Key violation
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.ForeignKeyIssue };
                        default:
                            return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

    }
}
