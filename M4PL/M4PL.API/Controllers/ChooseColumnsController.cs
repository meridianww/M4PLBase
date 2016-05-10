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
    public class ChooseColumnsController : ApiController
    {
        // GET: api/ChooseColumns
        public Response<ColumnsChild> Get(string PageName)
        {
            try
            {
                return new Response<ColumnsChild> { Status = true, Data = BAL_ChooseColumns.GetAllColumns(PageName) ?? new ColumnsChild() };
            }
            catch (Exception ex)
            {
                return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // GET: api/ChooseColumns/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/ChooseColumns
        public Response<ColumnsChild> Post(ColumnsChild value)
        {
            try
            {
                var res = BAL_ChooseColumns.SaveChoosedColumns(value);
                if (res > 0)
                    return new Response<ColumnsChild> { Status = true, MessageType = MessageTypes.Success, Message = DisplayMessages.SaveChoosedColumns_Success };
                else
                    return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Failure, Message = DisplayMessages.SaveChoosedColumns_Failure };
            }
            catch (SqlException ex)
            {
                if (ex.Errors.Count > 0)
                {
                    switch (ex.Errors[0].Number)
                    {
                        case 2601: // Primary key violation
                            return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Duplicate, Message = DisplayMessages.SaveChoosedColumns_Duplicate };
                        default:
                            return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
                    }
                }
                else
                    return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
            catch (Exception ex)
            {
                return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = ex.Message };
            }
        }

        // PUT: api/ChooseColumns/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/ChooseColumns/5
        public void Delete(int id)
        {
        }
    }
}
