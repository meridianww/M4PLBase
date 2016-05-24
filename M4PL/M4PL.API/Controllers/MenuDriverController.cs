//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              15/4/2016
//Program Name:                                 Menu Driver
//Purpose:                                      Returns serialized data for Menu Driver
//
//==================================================================================================================================================== 

using M4PL.API.App_Start;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    public class MenuDriverController : ApiController
    {
        /// <summary>
        /// Function to get the list of all menus
        /// </summary>
        /// <param name="Module"></param>
        /// <returns></returns>
        [Route("api/MenuDriver/GetAllMenus")]
        public Response<disMenus> GetAllMenus(int Module = 0)
        {
            try
            {
                return new Response<disMenus> { Status = true, DataList = BAL_MenuDriver.GetAllMenus(Module) ?? new List<disMenus>() };
            }
            catch (Exception ex)
            {
                return new Response<disMenus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to get the details of selected menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public Response<Menus> Get(int MenuID)
        {
            try
            {
                return new Response<Menus> { Status = true, Data = BAL_MenuDriver.GetMenuDetails(MenuID) ?? new Menus() };
            }
            catch (Exception ex)
            {
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Save menu details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        [ValidateModel]
        public Response<Menus> Post(Menus value)
        {
            try
            {
                var res = BAL_MenuDriver.SaveMenu(value);
                if (res > 0)
                    return new Response<Menus> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveMenus_Success };
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveMenus_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveMenus_Duplicate };
                        default:
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to Update menu details
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        [ValidateModel]
        public Response<Menus> Put(int id, Menus value)
        {
            try
            {
                var res = BAL_MenuDriver.SaveMenu(value);
                if (res > 0)
                    return new Response<Menus> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveMenus_Success };
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveMenus_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveMenus_Duplicate };
                        default:
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        /// <summary>
        /// Function to delete menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public Response<Menus> Delete(int MenuID)
        {
            try
            {
                var res = BAL_MenuDriver.RemoveMenu(MenuID);
                if (res > 0)
                    return new Response<Menus> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.RemoveMenus_Success };
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.RemoveMenus_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 547: // Foreign Key violation
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.ForeignKeyIssue, Message = DisplayMessages.RemoveMenus_ForeignKeyIssue };
                        default:
                            return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }
    }
}
