using M4PL.Entities;
using M4PL_API_CommonUtils;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
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
            return new StringBuilder().Append(BAL_RefOptions.GetSavedGridLayout(pagename, userid));
        }

    }
}
