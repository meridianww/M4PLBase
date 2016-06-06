
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


using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M4PL_BAL;

namespace M4PL.API.Controllers
{
    public class SystemMessagesController : Controller
    {  

        /// <summary>
        /// Function to get the list of all SystemMessages
        /// </summary>
        /// <returns></returns>
        public Response<disMessages> Get(string screenName)
        {
            try
            {
                return new Response<disMessages> { Status = true, DataList = BAL_SysMessages.GetSysMessagesTemplates(screenName) ?? new List<disMessages>() };
            }
            catch (Exception ex)
            {
                return new Response<disMessages> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }
               
    }
}
