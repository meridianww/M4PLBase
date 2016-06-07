//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/5/2016
//Program Name:                                 User
//Purpose:                                      Returns serialized data for Choose Columns
//
//==================================================================================================================================================== 

using M4PL.API.App_Start;
using M4PL.Entities;
using M4PL.Entities.DisplayModels;
using M4PL_API_CommonUtils;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    public class ChooseColumnsController : ApiController
    {
        // GET: api/ChooseColumns
        /// <summary>
        /// Function to get all columns to display to select & unselect for grid.
        /// </summary>
        /// <param name="PageName"></param>
        /// <returns></returns>
        public Response<disChooseColumns> Get(string PageName, bool IsRestoreDefault = false)
        {
            try
            {
                return new Response<disChooseColumns> { Status = true, Data = BAL_ChooseColumns.GetAllColumns(PageName, IsRestoreDefault) ?? new disChooseColumns() };
            }
            catch (Exception ex)
            {
                return new Response<disChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // POST: api/ChooseColumns
        /// <summary>
        /// Function to save all selected columns to display to grid.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        [ValidateModel]
        public Response<ChooseColumns> Post(ChooseColumns value)
        {
            try
            {
                value.ColUserId = (HttpContext.Current.Session[SessionNames.UserID] != null && Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) > 0) ? Convert.ToInt32(HttpContext.Current.Session[SessionNames.UserID]) : 0;
                var res = BAL_ChooseColumns.SaveChoosedColumns(value);
                List<disMessages> objmsg = BAL_SysMessages.GetSysMessagesTemplates(value.ColPageName,"Save");
                if (res > 0)
                    return new Response<ChooseColumns> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveChooseColumns_Success, SystemMessages = objmsg[1] };
                else
                    return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveChooseColumns_Failure, SystemMessages = objmsg[0] };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveChooseColumns_Duplicate };
                        default:
                            return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        
    }
}
