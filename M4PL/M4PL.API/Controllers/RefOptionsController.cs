//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              
//Program Name:                                 RefOptions
//Purpose:                                      Returns serialized data for RefOptions
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
using System.Text;
using System.Web;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    public class RefOptionsController : ApiController
    {
        /// <summary>
        /// Function to dropdown options for forms
        /// </summary>
        /// <param name="TableName"></param>
        /// <param name="ColumnName"></param>
        /// <returns></returns>
        public List<disRefOptions> Get(string TableName, string ColumnName)
        {
            return BAL_RefOptions.GetRefOptions(TableName, ColumnName);
        }

        /// <summary>
        /// Funtion to save the Layout Grid
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public int Post(GridLayout obj)
        {
            obj.UserId = (HttpContext.Current.Session[SessionNames.UserID] != null && Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) > 0) ? Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) : 0;
            return BAL_RefOptions.SaveGridLayout(obj.PageName, obj.Layout, obj.UserId);
        }

        /// <summary>
        /// Funtion to get the saved Layout Grid
        /// </summary>
        /// <param name="pagename"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        public StringBuilder Get(int userid, string pagename)
        {
            userid = (HttpContext.Current.Session[SessionNames.UserID] != null && Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) > 0) ? Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) : 0;
            return new StringBuilder().Append(BAL_RefOptions.GetSavedGridLayout(pagename, userid));
        }

        /// <summary>
        /// Function to Save Alias Column
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        [Route("api/RefOptions/SaveAliasColumn")]
        [ValidateModel]
        public Response<SaveColumnsAlias> SaveAliasColumn(SaveColumnsAlias obj)
        {
            try
            {
                var res = BAL_RefOptions.SaveAliasColumn(obj);
                if (res > 0)
                    return new Response<SaveColumnsAlias> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveColumnsAlias_Success };
                else
                    return new Response<SaveColumnsAlias> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveColumnsAlias_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<SaveColumnsAlias> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveColumnsAlias_Duplicate };
                        default:
                            return new Response<SaveColumnsAlias> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<SaveColumnsAlias> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<SaveColumnsAlias> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        public Response<ColumnsAlias> Get(string pagename)
        {
            try
            {
                return new Response<ColumnsAlias> { Status = true, DataList = BAL_RefOptions.GetAllColumnAliases(pagename) ?? new List<ColumnsAlias>() };
            }
            catch (Exception ex)
            {
                return new Response<ColumnsAlias> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        public long Get(string pageName, long id, short options)
        {
            return BAL_RefOptions.GetNextPrevValue(pageName, id, options);
        }

    }
}
