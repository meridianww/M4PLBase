using M4PL.Entities;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    public class RefOptionsController : ApiController
    {
        // GET api/<controller>
        public List<disRefOptions> Get(string TableName, string ColumnName)
        {
            return BAL_RefOptions.GetRefOptions(TableName, ColumnName);
        }
    }
}
